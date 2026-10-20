# ghūl: .NET interop in depth

Read this when you are calling .NET libraries beyond the common cases. It continues sections of [GHUL.md](../GHUL.md), the language reference, under the same headings; GHUL.md is loaded with every session and this file is not.

## .NET interop

`a =~ b` on a bare, unconstrained type parameter compiles by going through `EqualityComparerBase[T].default.equals`, the same route .NET collections use for a generic instantiation. That reaches the `Equals(object)` bridge above, so the comparison follows whatever the actual type argument does: a type declaring `=~` and `get_hash_code` answers through its own operator, a class with neither declared nor synthesised compares by reference, and a struct, enum, or scalar gets the runtime's ordinary value equality for that type. A bound that itself declares `=~` (`[T: Named]` where `Named` declares the operator) resolves the bound's operator directly and never reaches the comparer.

A tuple takes the same route. `EqualityComparerBase[T].default` for a `ValueTuple` is the tuple's own element-wise equality, so each element is compared by the default comparer for *its* type — and so, by the same chain, through a user-written `=~` where the element type declares one.

A type implementing `Collections.Iterator[T]` that declares no `reset` gets a synthesised one that throws `Ghul.NotSupportedException`, which is what `IEnumerator.Reset` is documented to do and what .NET's own generated iterators answer with; a `reset` the type declares is left alone. `dispose` is not supplied, since what a type holds and must release is its author's to say.

An operator is an ordinary member and can be called as one, which is occasionally clearer than the operator spelling and is how a completion list offers it. The dot needs separating from the operator's name, because a run of operator characters is scanned as a single token and `.` is one of them — so `a.=~(b)` is read as an operator named `.=~` rather than as a member access. A space does it, and so does the backtick escape:

```ghul
a. =~(b)
a.`=~(b)
```

Both are the same call, and both are a plain method call rather than another spelling of the operator. Where the two differ, they differ quietly. The null handling around `a =~ b` is written around the *operator*, so the member call receives an absent operand instead of being answered before it is reached. And an operator that lowers to an IL instruction has no .NET method behind it: on the scalar types the arithmetic operators are instructions, declared as static members of the type, so `a. +(b)` on an `int` finds no overload taking one operand, and `int.`+(a, b)` is the call — while `=~` and `<>` on those types, and on `string`, do reach the .NET method the name maps to, which is not the same thing the operator does. Member syntax is fine to use on a type whose operators you wrote; it is not a general substitute for writing the operator. Naming one of those instruction-backed operators as a *value* rather than calling it - `int.`+`` passed where a function is expected - is rejected, since there is no method to take the address of; an operator you declared yourself is an ordinary static or global function and is named as a value like any other. An instance member named through its type, `BOX.plus` or `int.`<>``, is rejected too: a member reached through a receiver needs one.

A type's own **operators** are reached by writing the operator. A public static operator method a .NET type declares — `op_Addition` and the rest, on `bigint`, `System.DateTime`, `System.TimeSpan` and any other type that has them — is a candidate wherever a value of that type is either operand, and both operand types contribute, so `step * 2.0D` and `2.0D * step` find the same operator on `TimeSpan`. The same goes for a static operator declared on a ghūl class or struct: `+(a: VECTOR, b: VECTOR) -> VECTOR static` applies to `v + w` from anywhere `VECTOR` is visible, not only inside its own body. An operator none of whose operands is the declaring type is reached by importing it under its own name — ``use Lib.VECTOR_OPS.`*;`` — the same route the generic-math interface operators take. The arithmetic, bitwise, shift and unary operators are reached this way; comparison and equality come from `<>` and `=~` as elsewhere, so a reflected `op_LessThan` or `op_Equality` is not. The scalar types are the exception: their operators are the language's own, so `decimal`'s reflected `op_Addition` is not a second candidate beside the built-in `+`.

A .NET **user-defined conversion operator** (`op_Implicit` / `op_Explicit`) declared on either the source or the target type is reachable through `cast`, alongside the subtype and scalar conversions `cast` already performs:

```ghul
let h = cast System.Half(1.5);      // System.Half declares `explicit operator Half(double)`
let f = cast single(h);             // and `implicit operator float(Half)`
```

`cast T(v)` calls the operator and lets it throw on failure, same as calling it from C# would. `cast T?(v)` never throws: `InvalidCastException` or `OverflowException` from the operator becomes an absent value, and any other exception still propagates.

An auto-property's **backing field** is named `$` followed by the property name, and reflection sees it alongside the property. A reflection-based serializer told to include fields will therefore emit every property twice — with `System.Text.Json`, leave `include_fields` alone unless the type really does have fields to serialize.

Because ghūl has no default argument values, a .NET **optional parameter** has to be supplied explicitly — there is no overload with it omitted. `File.ReadAllTextAsync(path)` is written:

```ghul
let text = await IO.File.read_all_text_async(path, System.Threading.CancellationToken.none);
```

`@IL.name("Name")` sets the name a function, method or property has in the compiled assembly, for a .NET library that finds members by name - Entity Framework Core, for example, looks for an `Id` property and a `DbSet` property named after the table. On a property it also names the accessors `get_Name` and `set_Name`; `@IL.name.read("...")` or `@IL.name.assign("...")` names one accessor on its own. The argument is a single string literal and cannot contain a quote. A type keeps its ghūl name in the compiled assembly, and `@IL.name` written on a class, struct, trait, union or enum is an error. The ghūl name is unchanged, so ghūl code still calls the member by the name it declares:

```ghul
class PRODUCT is
    @IL.name("Id")
    id: int public

    init() is si
si
```

Five `@IL` pragmas are acted on: `IL.name`, `IL.name.read`, `IL.name.assign`, `IL.output` and `IL.entrypoint`. Any other `IL.` pragma draws an `unknown-pragma` warning, since a misspelled or removed pragma is otherwise acted on as a built-in and silently does nothing.

`@intrinsic("operation")` marks a declaration as providing a compiler intrinsic: a call to it lowers to an operation of the compiler rather than to the method emitted there. It exists for the runtime and core libraries, which provide the intrinsics every compilation reflects. The operation is named by the pragma alone, so a library for a target with no assemblies to carry attributes can still mark what it declares. Where the compilation's reference set holds the runtime's `Ghul.Internal.INTRINSIC_ATTRIBUTE` — .NET, where other compilations read the marker back by reflecting the emitted assembly — the pragma is emitted as that attribute; where nothing holds it, nothing is emitted. The attribute type itself stays unnameable from source, as `Ghul.Internal` always is.

`@trusted_store_free()` marks a function, method or property of a library as store-free for narrowing, on the terms the compiler trusts the .NET members it knows to store nothing: a call to it leaves a narrowed value alone. The trust covers the declaration's own body only. An override is held to nothing, and one in the program being compiled is judged as written, so an override that can store still ends a narrowing at a call that could reach it. That is what separates it from `pure`, which every override must keep. It exists for the core library and the runtime, so a build that declares library sources accepts it only in one of them and reports it anywhere else; a build that declares none is its own core. It is carried across assemblies as `Ghul.Internal.TRUSTED_STORE_FREE_ATTRIBUTE` where the runtime declares that type.

`@finalizer()` marks the method the collector calls once an instance of its class is unreachable, so an object holding a host resource, an open file for instance, releases it when the program forgets to dispose it, as the base class library's own finalizers do on .NET. It is the libraries' to write, accepted only in a core or runtime source as `@trusted_store_free()` is, and only on an instance method of a non-generic class taking no arguments, at most one to a class. A finalizer releases only its own object's resource and must not throw. Everything its object refers to is still there when it runs, and the finalizers of finalizable objects it refers to run after it; finalizable objects that refer to one another in a cycle are never finalized. An object still reachable when the process ends is not finalized, as on .NET. Only the llvm target runs finalizers; elsewhere the pragma has no effect.

A parameter attribute is recognised only where a formal parameter can appear: a named function or method's parameter list, or a lambda literal's — not on a `let` or a primary-constructor parameter. Written on an element of a parenthesised expression that turns out not to be a lambda (an ordinary value tuple), it's rejected with an error rather than silently ignored.

`System.Obsolete` marks a declaration as deprecated, whether it is written as a pragma in ghūl or carried by a .NET assembly. Every use of the declaration from elsewhere is then reported as `<name> is deprecated: <message>`, or `<name> is deprecated` where the attribute gives no message. The report is a `deprecated` warning, suppressible like any other, or an error when the attribute's second argument is `true`. Using a class's constructor counts as using the class. A use written inside a declaration that is itself deprecated is not reported, so an old member can go on using another. Hover shows the message under the signature, and completion marks the item as deprecated.

```ghul
@System.Obsolete("use scaled instead")
doubled(x: int) -> int => x * 2;

@System.Obsolete("removed", true)
tripled(x: int) -> int => x * 3;
```

`System.Runtime.CompilerServices.MethodImpl` says how the runtime is to treat the method it is written on. The options it names become the method's implementation flags rather than an attribute the method carries, which is where the runtime reads them from, so `NO_INLINING` keeps the method out of the inliner and `SYNCHRONIZED` takes the lock. Reflection reads the flags back through `get_method_implementation_flags`, and finds no `MethodImplAttribute` among the method's custom attributes:

```ghul
@System.Runtime.CompilerServices.MethodImpl(
    System.Runtime.CompilerServices.MethodImplOptions.NO_INLINING)
measured(x: int) -> int => x + 1;
```

`System.Runtime.InteropServices.DllImport` on a static method with no body declares a call into a shared library. The method is emitted as the call itself rather than as a method carrying an attribute, so it needs no body and cannot have one:

```ghul
class LIBC is
    @System.Runtime.InteropServices.DllImport("libc")
    abs(value: int) -> int static;

    @System.Runtime.InteropServices.DllImport("libc", entry_point = "getpid")
    process_id() -> int static;

    init() is si
si
```

The name looked up in the library is the method's own, spelled as written, unless `entry_point` gives another: a native symbol is matched exactly, so none of the case conversion that applies to a .NET name applies here. `char_set`, `set_last_error`, `exact_spelling` and `calling_convention` are carried through as written.

What can cross the boundary is what the machine lays out the same way on both sides: the scalar types, a pointer, a `ref` to a scalar, and a `string` argument, which is marshalled to a null-terminated buffer for the duration of the call. A returned `string` is not accepted, since freeing the buffer the library returned is the library's business rather than the runtime's. Anything else, such as a class, a tuple, an array or a function, is reported at the declaration rather than emitted.

`System.Runtime.InteropServices.StructLayout` on a class or struct sets how its fields are laid out, which is what a native structure the type stands for has to match. Its kind, `pack`, `size` and `char_set` become the type's own layout rather than an attribute it carries. A struct is laid out sequentially without it, in the order its members are declared; a class is laid out as the runtime chooses unless it asks for `SEQUENTIAL`. `EXPLICIT` places each field where a `System.Runtime.InteropServices.FieldOffset` on it says, so two fields can share bytes, and every instance field of such a type has to carry one, which rules out auto-properties there:

```ghul
@System.Runtime.InteropServices.StructLayout(System.Runtime.InteropServices.LayoutKind.EXPLICIT)
struct WORD_BYTES is
    @System.Runtime.InteropServices.FieldOffset(0)
    word: ushort field

    @System.Runtime.InteropServices.FieldOffset(0)
    low: ubyte field

    init() is si
si
```

# ghūl: generics

Read this when you are writing generic library code. It continues sections of [GHUL.md](../GHUL.md), the language reference, under the same headings; GHUL.md is loaded with every session and this file is not.

## generics

A bound's *static* members are reachable through the type parameter itself, written `T.member(...)` — the mechanism .NET's generic-math interfaces (`IParsable[T]`, `INumber[T]`, `IBinaryInteger[T]`, ...) are built on:

```ghul
use System.IParsable;

parse[T: IParsable[T]](s: string) -> T => T.parse(s, null);
```

Consuming such a member is all that is supported. A type cannot *implement* one: nothing binds a type's static to the interface's static slot, and the runtime refuses to load a type that leaves one unfilled, so naming an interface that declares a static member on a concrete type is an error at the declaration. That covers the generic-math interfaces above, which is why a bound on one of them is satisfied by the built-in numeric types and not by a type of your own.

Some of those interfaces declare an **operator** as a static member — `IAdditionOperators[TSelf, TOther, TResult]` declares addition, and `INumber[T]` extends it. Such an operator is written as an operator rather than reached through the type parameter, but only once it has been imported by name:

```ghul
use System.Numerics.INumber;
use System.Numerics.IAdditionOperators.`+;

total[T: INumber[T]](a: T, b: T) -> T => a + b;
```

Without that `use` the operator is not in scope and `a + b` does not resolve, so nothing changes for code that does not ask for it — importing one does not displace the built-in operators either, and `3 + 4` still adds two `int`s the way it always did.

A concrete type needs no import for its own operators. A public static operator a .NET type declares for itself is a candidate wherever a value of that type is either operand (see [.NET interop](../GHUL.md#net-interop)), so `Int128.one + Int128.one` resolves as it stands. The import is for a bounded type parameter, whose operators come from the interface rather than from any one type.

A static member imported by name reaches a concrete type as well as a bounded one, so `use System.Numerics.INumber.max;` makes `max(a, b)` available on a bounded `T` and on `Int128` alike.

The arithmetic operators `+`, `-`, `*`, `/` and `%` can be imported this way, and so can the bitwise and shift operators `&`, `|`, `^`, `\`, `<<`, `>>` and `>>>`. The comparison and equality operators cannot: a type says how it orders and compares by defining `<>` and `=~`, and those are what the operators are written in terms of. Each operator is imported from the interface that *declares* it, which for the shifts is `IShiftOperators` however the bound is spelled:

```ghul
use System.Numerics.IBinaryInteger;
use System.Numerics.IShiftOperators.`>>>;

halve[T: IBinaryInteger[T]](a: T) -> T => a >>> 1;
```

A trait's type parameter can also declare its **variance**, written after any other constraints: `out` makes it covariant and `in` contravariant. A covariant trait of a subtype is assignable to the same trait of its supertype, so a `Source[CAT]` is a `Source[Animal]`; a contravariant one goes the other way, so a `Sink[Animal]` is a `Sink[CAT]`:

```ghul
trait Source[T: out] is
    next() -> T
si

trait Sink[T: in] is
    take(value: T)
si
```

The compiler checks how the parameter is used: a covariant parameter in an input position, such as a method parameter, is an error, and so is a contravariant one in an output position, such as a return type. Only a trait can declare variance, because .NET allows it only on interfaces; `out` or `in` on a class or struct type parameter is an error. The variance of an imported type, a function type or an array comes from .NET.

A type parameter written with a trailing `..` is an **argument pack**. `[T..]` in the type parameter list says that where `T` appears in the signature it may, if it is marked with `..` there, be implicitly wrapped and unwrapped, so that the calling code does not have to wrap or unwrap it by hand. It still can: a caller is free to write the tuple out, and a single argument is the value itself rather than a one-element tuple. Writing `T..` within the signature then says that the wrap or unwrap is wanted for that specific argument, should it be needed at the call site.

So the two markers do different jobs. The one on the type parameter is the permission, and nothing is spread because of it alone; the one on a formal is the request. A formal over a pack that is left unmarked takes the pack as the tuple it is.

The pack stands for the arguments of a call, held as a positional tuple. The `..` on the type parameter is that parameter's bound — it says what `T` ranges over — so a type bound cannot be written alongside it.

A formal argument then writes `..` on its own type to say which of the pack's readings it wants. `f: T.. -> U` takes the arguments spread out, as a function of as many parameters as the call supplies; `v: T..` takes them as the call's own remaining arguments; a plain `T` is the tuple. So a function taking a function and the values to call it with declares one of each, and callers write the call out rather than assembling the tuple by hand:

```ghul
apply[T.., U](f: T.. -> U, v: T..) -> U => f(v);

concat(a: string, b: string) -> string => "{a}{b}";

apply((a, b) => "{a}{b}", "x", "y");     // T is (string, string)
apply(concat, "x", "y");                 // the same, by name
apply(concat, ("x", "y"));               // the tuple, written out
apply(double, 123);                      // T is int, as for any parameter
```

A spread formal has to be the last one, since it leaves nothing for the arguments after it. One argument is the value itself rather than a one-element tuple, which is what makes `apply(double, 123)` read the way it does; two or more are the tuple they are spread into. Writing the tuple out goes into the same formal, so both spellings are available and the written-out one is what a caller reaches for when it already holds the tuple.

The pack is the last parameter of the function the formal takes, and that function can take parameters of its own before it. `f: (A, T..) -> A` is the shape a fold's callback has: the running value comes first and is passed as it is, and the rest of the parameters are the pack's elements.

```ghul
fold[A, T..](source: Collections.Iterable[T], seed: A, f: (A, T..) -> A) -> A is
    let running mut = seed

    for element in source do
        running = f(running, element)
    od

    return running
si

let pairs = [(1, 2), (3, 4)]

fold(pairs, 0, (total, a, b) => total + a * b)      // 14
fold(pairs, 0, (total, pair) => total + pair.`0)    // the tuple, written out
```

Only the last parameter can be the pack, and a parameter list holds one pack: `(A.., B) -> C` and `(T.., T..) -> int` are both errors.

The pack binds to whatever the call supplies, and the function written at its own formal is one of the things that supplies it — its parameters are the tuple. So a call that passes nothing but the function still infers, as long as the function says what its parameters are:

```ghul
n_ary[A.., B](f: A.. -> B) -> (A -> B) => f;

add(a: int, b: int) -> int => a + b;

n_ary(add);                        // A is (int, int)
n_ary((a: int, b: int) => a + b);  // the same, written out
n_ary((a, b) => a + b);            // error - nothing says what a and b are
```

Nothing about the parameter itself changes: `T` binds to whatever the call supplies, `f(v)` passes one value, and a consumer in another language sees a method taking a tuple. What the marker on `f` licenses is a **function of two or more parameters written where that formal expects one**. A function literal there is read as destructuring the tuple, and a function named there is wrapped so that it is. A one-parameter function needs no adaptation and is passed as it stands.

`[T..]` is accepted on a class, struct, trait and union type parameter as well as a function or method one, and each formal opts in for itself — so a type declaring `EVENT[T..]` marks its handler formal and its value formal for the readings each wants:

```ghul
class EVENT[T..] is
    subscribe(handler: T.. -> void) is ... si
    raise(v: T..) is ... si
si

let e = EVENT[(int, string)]();

e.subscribe((n, s) => write_line("{n} {s}"));
e.raise(7, "seven");
```

Inside the type, a formal holding the handler has its tuple-in type, `T -> void`. That type is what the handler is stored as, since a type argument can't carry the marker:

```ghul
class EVENT[T..] is
    _handlers: Collections.LIST[T -> void]

    init() is _handlers = Collections.LIST[T -> void](); si

    subscribe(handler: T.. -> void) is _handlers.add(handler); si

    raise(v: T..) is
        for handler in _handlers do
            handler(v);
        od
    si
si
```

The marker can sit on the parameter of any function type along the formal's return spine, not only the outermost. `f: X -> T.. -> U` asks for a function the caller's own lambda returns, which is how a higher-order function takes an N-ary one:

```ghul
run[T.., U](make: (int) -> T.. -> U, v: T) -> U => make(10)(v);

run(n => (a, b) => a + b + n, (1, 2));   // 13
```

A literal written there can spell its types out. Its return is written as the N-ary function type the marker licenses, and the literal is presented in the tuple-in shape the formal takes, exactly as the inferred one is - at whatever depth the marker sits. The tuple-in shape itself is not a type an N-ary literal can be returned as, there or anywhere else:

```ghul
run((n: int) -> (int, int) -> int => (a: int, b: int) -> int => a + b + n, (1, 2));   // 13

run((n: int) -> ((int, int)) -> int => (a: int, b: int) -> int => a + b + n, (1, 2)); // error
```

The marker reads only as a formal's own type, as the last parameter of a function type on that type's return spine, or as the last parameter of a function type in a declared return type. Written anywhere else — inside a bigger type, reached through a parameter rather than a return, or on a type parameter that no `[T..]` declares — it is an error. The tuple limit is the pack's limit too: past seven arguments there is no tuple to bind to, and the call is reported as it stands. A pack is not `params`: a homogeneous variable-length list is a different thing.

What each formal asks for survives into the assembly, so a pack declared in one assembly reads the same way from another.

A return type marked that way hands the pack back out, which is how a combinator preserves the arity of a function it takes:

```ghul
retry[T.., U](f: T.. -> U, attempts: int) -> T.. -> U =>
    v => ( ... call f(v) with retries ... );
```

Inside `retry`, the declared return type still names the tuple-in shape the body's `v => ...` literal has. The presentation happens at each call that binds the pack to a concrete tuple: `retry(parse, 3)` evaluates once, where the call stands, and its value is the N-ary function `f`'s own arity suggests — `let safe = retry(parse, 3); safe("2a", 10)` calls it as a two-argument function. A call that binds the pack to a single argument needs no presentation and returns the function as it is. The same rule applies one level up: a generic whose own return type carries the marker returns the tuple-in value its declaration names, and the call of *that* function does the presenting.

A generic function or method named with no argument list is a *value*, the same way a non-generic name in value position is. Written with its type arguments it is the value at that instantiation; written bare, the type arguments are inferred from the function type of the slot it goes into — from the parameter positions, and from the return slot for a variable that appears only there. It converts wherever a function type or a named delegate is expected, and where the name is overloaded the expected type picks the member:

```ghul
identity[T](x: T) -> T => x;

zero_of[T](ignored: int) -> T => _[T];

let f = identity[int];                    // (int) -> int, explicit
let g: (string) -> string = identity;     // inferred from the slot
let h: (int) -> string = zero_of;         // T pinned by the return slot
```

With no slot type in scope there is nothing to infer from, and the bare name is an error (`cannot infer the type arguments`) — give the type arguments explicitly.

A name can be declared at more than one generic arity in the same namespace — `class BOX` and `class BOX[T]` are two types, as `Tasks.TASK` and `Tasks.TASK[T]` are. Written with type arguments the name picks the sibling of that arity, and written bare it picks the one taking none.

That leaves the generic sibling with no bare spelling, which matters in a `typeof`: an *open* generic — the type before any type argument is supplied — is a thing only reflection can hold, and a bare `BOX` in a `typeof` names the sibling taking no type arguments. `BOX[_]` names the open generic, with one `_` for each type argument it takes:

```ghul
let plain = typeof BOX;         // the sibling taking no type arguments
let open = typeof BOX[_];       // BOX[T], with no argument supplied
let closed = typeof BOX[int];   // BOX[int]

typeof PAIR[_, _];              // a two-argument open generic
```

`open` is the type `closed.get_generic_type_definition()` returns. Because nothing but reflection can hold such a type, `FOO[_]` is accepted only as the whole operand of a `typeof` — not as a declared type, not nested inside another type argument, and not with some arguments supplied and others left as `_`. Where a name has no sibling taking no type arguments, a bare name in a `typeof` yields the open generic too, so `typeof List` is ``IReadOnlyList`1[T]``; `X[_]` is the spelling that means it whatever siblings exist, and the only one accepted anywhere a sibling could be meant instead.

The main use for it is an attribute that names a generic type, where the type it names shares its name with a sibling — a task-like whose builder is generic, for instance (see [asynchronous code](../GHUL.md#asynchronous-code)):

```ghul
@System.Runtime.CompilerServices.AsyncMethodBuilder(typeof(COROUTINE_BUILDER[_]))
class COROUTINE[T] is ... si
```

Everywhere else a type is required, a generic named with none of its type arguments is an error saying how many it takes: what the name stands for is the open generic, and an assembly naming one is refused by the runtime at load rather than at compile time. That covers a declared type, a parameter, a cast target, an `isa` test and a type argument alike. Two positions are not affected, because each takes its arguments from somewhere else: a union's variant, whose arguments come from the union and so from the value the variant is tested against or assigned to (`isa Option.NONE(o)` over an `Option[int]`), and a call whose type arguments are inferred (`LIST()`).

`size_of[T]()` answers how many bytes a value of `T` takes where it is stored, as one element of a `T[]` holds it: a scalar's width, a reference's size for a class or trait, and a struct's laid-out size where the struct is stored in place. It is a constant for each type argument, so it costs nothing at run time, and inside a generic it answers for the type the parameter stands for. The answer is the target's: a reference is 8 bytes on .NET and llvm and 4 on wasm, where a struct is stored by reference, so it answers the reference's size.

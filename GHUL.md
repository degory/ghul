# ghūl language tutorial and reference

ghūl is a statically typed, general-purpose programming language that targets .NET 10. It is a hobby project, but expressive enough for general-purpose work — the ghūl compiler is itself written in ghūl. It produces ordinary .NET assemblies and NuGet packages, and ghūl code can consume any .NET library.

Apart from a slightly quirky syntax, ghūl is a fairly conventional language. The syntax is influenced by ALGOL 68 and Pascal: blocks are delimited by keywords rather than braces or indentation, and the keywords come in pairs whose closing half mirrors the opening one — a class or function body runs `is` ... `si`, a conditional runs `if` ... `fi`, a `try` ends with `yrt`.

This file is a condensed single-file reference. The full documentation, with a page per topic, is at <https://ghul.dev>; setup instructions are at <https://ghul.dev/getting-started.html>. Each section below links to the page that covers it in depth.

## naming conventions

ghūl keywords are lowercase. Identifiers follow a convention that the compiler partly enforces:

- `snake_case` — variables, functions, methods, properties
- `PascalCase` — namespaces, traits, abstract classes, unions, enums
- `UPPER_SNAKE_CASE` — concrete classes, structs, variants, enum members

A `static` field or property reads as a named constant, so it accepts either `snake_case` or `UPPER_SNAKE_CASE`.

A leading underscore (`_name`) marks a declaration as non-public — there are no `public`/`private` keywords, the naming convention carries that information. Whatever it is attached to, an underscore-prefixed name is **private to the assembly it is declared in**: another assembly cannot see it at all, and a reference to one from outside is a compile error.

Within the assembly the rule differs by kind. A **member** — method, field or property — is restricted further, by default to its own declaring class. A **type**, **global function** or **global variable** has no declaring class to be narrower than, so for those the underscore means exactly "private to this assembly" and nothing more.

How far the member restriction reaches is chosen with a compiler flag:

- `--underscore-access private` (the default) — an underscore member is visible only to its declaring class.
- `--underscore-access protected` — widens that to the declaring class and its subclasses within the same assembly.
- `--underscore-access legacy` — the historic behaviour: no compile-time enforcement at all, and underscore methods and types are emitted public, so they escape the assembly.

An out-of-policy reference from elsewhere *inside* the assembly is reported as an error, but the access is allowed through rather than being cut, so the diagnostic never cascades.

The compiler warns when a ghūl-source declaration doesn't match the convention for its kind. Each rule has its own slug, suppressible per declaration, per file, or project-wide:

- `non-snake-case-name` — variables (including `let`, `for` and `catch` locals, and function arguments), functions, methods, properties.
- `non-pascal-case-name` — abstract classes, traits, unions, enums.
- `non-upper-snake-case-name` — concrete classes, structs, variants, enum members.

A class with only `static` members (and no primary-constructor parameters) is a static-utility container — never constructed — and accepts either PascalCase or UPPER_SNAKE_CASE.

## namespaces and `use`

See <https://ghul.dev/definitions.html#namespaces>.

Code is organised into namespaces — `namespace`, a name, and an `is` ... `si` body:

```ghul
namespace MyApp.Utilities is
    class HELPER is
        ...
    si
si
```

Namespaces nest, and a dotted name (`namespace Outer.Inner is ... si`) is shorthand for nesting. A namespace definition is an *instance* of that namespace; instances are aggregated across every source file, so a definition made in one file's `namespace Example` is visible unqualified from every other `namespace Example` block in the project.

A source file with no namespace declarations has its definitions placed in a compiler-generated namespace private to that file — convenient for small programs and tests. Compiling with `--global-namespace` instead aggregates every such file's definitions into a single unnamed global namespace shared across the project, so a global defined in one file is visible from the others. Once a file declares any namespace, every definition in it must sit inside a namespace.

A namespace-less file may also carry bare statements at the file root. They run, in source order, as the program's entry point — so a short program needs no `entry` function — and may be interleaved with global definitions, which are visible regardless of where they appear. A file cannot both carry top-level statements and declare a namespace.

The `use` statement brings names into scope so they can be referred to without qualification. Applied to a namespace it imports every public symbol; applied to a single symbol it imports just that one:

```ghul
use IO.Std.write_line;            // a single static method
use IO;                           // every public symbol in the namespace
use Console = IO.Std;             // import under a different name
```

A `use` applies only within the current namespace block — if a namespace is split across blocks or files, each block needs its own `use` statements.

## variables

See <https://ghul.dev/definitions.html#variables>.

Local variables are declared with `let`, with an inferred or explicit type and an initializer:

```ghul
let i = 1234;          // type inferred as int
let k: int = 5678;     // explicit type
```

A bare `let` is immutable: the initializer is required, the value is fixed, and reassignment is rejected. To reassign, declare with a trailing `mut`; the initializer can then be omitted, giving a deferred-init local that takes the default value of its type (zero, `false`, or `null`):

```ghul
let counter mut = 0;     // initialised, will be reassigned
counter = counter + 1;

let result: int mut;     // deferred — default-initialised to 0
result = compute();
```

A deferred-init local is still covered by definite-assignment analysis: reading it on a path that has not assigned it draws a `definite-assignment` warning, so the default value is a backstop rather than something to lean on.

A `mut` variable still cannot change type. Either form can also take its value from `_`, the default-value expression — `let i = _` takes its type from the local's own annotation or from later use, with `_[T]` to pin it explicitly. A bare `_` in a call-argument position infers the parameter type from the callee, provided the call resolves to a single unambiguous overload; if the parameter has a declared .NET default value, `_` takes that value rather than the type's zero value, so writing it out positionally behaves exactly like omitting the same argument by name. A `_` argument is never itself used to infer a generic type variable — one pinned only by the `_` slot, or a call left ambiguous between overloads, is still an error (`cannot infer type of default here`). `_[T]` always means the literal zero value of `T`, in every position — it never picks up a callee's declared default.

`_` in a binding or pattern position — `let _ = expr`, a destructure leaf `(_, b)`, a `for _`, an `if let _`, a lambda discard formal `_ => ...` or `(_, y) => ...`, a typed discard `(_: T)` — is the discard placeholder, a different meaning from the default-value expression above; the positions are syntactically distinct so the two meanings never collide. `_[T]` has no reading as a lambda formal — a formal's type comes from `_: T`, not `_[T]` — so writing `_[T]` where a formal is expected is a compile error rather than a silently-dropped type argument.

A single `let` can declare several variables, mixing inferred and explicit types:

```ghul
let first = 1, second: int = 0, third = "three";
```

The name `_` is a discard placeholder: it stands in for a variable name, but the value that would be assigned to it is discarded. It is accepted in `let` definitions, tuple destructuring, lambda parameters, and `for` loop variables.

Variables are block-scoped — visible from their declaration to the end of the innermost enclosing block — and `let` can only be used inside function, method, or property bodies.

A variable declared at namespace scope is a **global variable**. It is written as a plain name and type, without `let`, and cannot carry an initializer:

```ghul
counter: int;            // a global variable
```

## types and literals

See <https://ghul.dev/language-basics.html>.

ghūl exposes the .NET primitive types under lowercase names:

- integers — `byte`, `ubyte`, `short`, `ushort`, `int`, `uint`, `long`, `ulong`, `word`, `uword`
- floating-point — `single`, `double`, and `decimal`
- `bool`, `char`, `void`

`string` and `object` are reference types from the .NET base class library.

Note that `byte` and `ubyte` are inverted relative to .NET: `byte` is `System.SByte` (signed) and `ubyte` is `System.Byte` (unsigned).

```ghul
let count = 12_345;            // int
let hex = 0x1234_ABCD;         // int, hexadecimal
let big = 1_000_000_000L;      // long
let b = 99b;                   // byte
let ratio = 123.456;           // single
let precise = 123.456D;        // double
let price = 19.99m;            // decimal
let letter = 'c';              // char
let greeting = "hello";        // string
```

Digits may be grouped with `_`. An integer literal can carry a radix prefix (`0x`) and a type suffix built from two optional parts, both case-insensitive: a sign selector — `s` signed or `u` unsigned — followed by a size selector — `b` byte, `c` char, `s` short, `i` int, `l` long, `w` word. So `123b` is a `byte`, `0ub` a `ubyte`, `4567s` a `short`, `7890us` a `ushort`, `222i` an `int`, `0ul` a `ulong`, `123w` a `word`. A numeric character literal (`65c`) cannot be unsigned.

A fractional literal is a `single` unless suffixed — `s` single, `d` double, `m` decimal, in either case. The `m` suffix is also accepted on a digit-only literal to write an integral decimal (`100m`). Exponent notation is accepted: `1.5e3`, `1.5E-3`.

ghūl does not convert between scalar types implicitly — a mixed-type arithmetic expression is a compile-time error, and a `cast` is required. Upcasting is implicit: a value is assignment-compatible with any ancestor type, so a `string` can be assigned to an `object` with no cast.

```ghul
let a = 1.0D + 1.0D;             // ok, both double
let b = 1.0D + cast double(1);   // ok, explicit cast
let o: object = "hello";         // ok, string is an object
```

A **string literal** may interpolate expressions: `{` opens an expression and `}` closes it, and the expression's value is converted to a string in place. There is no `+` operator on `string`, so interpolation is how strings are joined:

```ghul
let greeting = "hello {name}, you are {age} years old";
let combined = "{prefix}{suffix}";                  // concatenation
```

An interpolated expression can carry an alignment and a format specifier, as in .NET: `{expr, alignment : format}`.

```ghul
let padded = "[{value,12:F3}]";     // [    1500.000]
```

Adjacent string literals concatenate, so a long string can be split across lines — plain and interpolated literals mix freely.

Inside the braces you are in *expression* context, so a nested string literal is written normally — `"{format("hello")}"` needs no escaping of its inner quotes. To write a literal brace, double it: `"{{"` and `"}}"`. The escapes are `\t`, `\n`, `\r` and `\\`, plus a run of octal digits for an arbitrary character code — so an escape character is `"\33"`. Any other character after a `\` stands for itself, which is what makes `\"` a quote.

An **array** type is written `E[]`. Arrays are fixed-size and immutable — there is no assigning indexer. An array's length is its `count`. An array literal is a comma-separated list in square brackets, and its element type is inferred as the most specific type compatible with every element (`object` if there is no closer common ancestor):

```ghul
let primes = [2, 3, 5, 7, 11];          // int[]
let mixed = ["frog", 1234, 12.5];       // object[]
let p = primes[2];                      // indexing, 0-based
```

The empty array literal `[]` is accepted wherever the element type comes from context — an explicitly-typed `let`, a `return`, or a call argument's parameter type.

A **tuple** groups two or more values of possibly different types — a single-element tuple is rejected. Tuple types and literals both use parentheses; elements may be named, and an unnamed element is named with a backtick and its index. Tuples are immutable, compare by structural equality, nest, and can be destructured:

```ghul
let pair = (10, "hello");                  // (int, string)
let point = (x = 10, y = 20);              // (x: int, y: int)
let x = point.x;
let first = pair.`0;                       // positional access
let (name, age) = ("alice", 30);           // destructuring
```

When an unnamed tuple-literal element is a bare identifier, it takes its name from the identifier: `(a, b)` constructs the same tuple as `(a = a, b = b)`. When the identifier resolves to a field whose name carries the single-underscore private-member convention, the leading `_` is stripped from the inferred element name: `(_count, _total)` packed from private fields surfaces as `(count: ..., total: ...)` to consumers. Locals are not affected, and only a single leading underscore is ever stripped.

Destructuring comes in two forms: **positional** and **by-name**, distinguished syntactically.

A **positional** target list `(a, b, ...)` is matched against the source in this order: a value-tuple of matching arity; a `deconstruct(...)` instance method whose parameters are all `T ref`; the conventionally-named positional members `` `0 ``, `` `1 ``, .... The `deconstruct` route covers .NET types like `Collections.KeyValuePair[K, V]`, ghūl-defined classes that write through each `T ref` parameter with postfix `!`, and classes with a primary constructor that get an auto-synthesised `deconstruct` (see [primary constructors](#primary-constructors)). A type without one of those shapes is not destructurable positionally — use the by-name form below.

```ghul
for (key, value) in dict do          // KeyValuePair.Deconstruct
    write_line("{key}={value}");
od

class POINT is
    x: int; y: int;
    init(x: int, y: int) is self.x = x; self.y = y; si
    deconstruct(a: int ref, b: int ref) is
        a! = x;
        b! = y;
    si
si

let (px, py) = POINT(3, 7);
```

A **by-name** target list `(local = field, ...)` pulls each element from the named field of the source — `local` becomes the new local variable, `field` names the member on the right-hand side. The same `=` reads in both directions: `(x = x, y = y) = point` is no-rename ("local x gets field x"); `(new_x = x, new_y = y) = point` renames the bound locals. Each `(...)` group is either entirely positional or entirely by-name — mixing is a parse error. Nested groups choose independently:

```ghul
let (a, (bb = b, cc = d), d) = triple;   // outer positional, middle by-name
```

In refutable contexts (`if let`, `case`-when patterns), a literal on the left-hand side adds a value-equality test rather than declaring a variable — `("Alice" = name, a = age)` matches when `source.name == "Alice"` and binds `a` to `source.age`. The rule throughout: the LHS of `=` says what to do with the value (bind it, or match it against a literal), the RHS names the field to pull.

Postfix `!` on a `T ref` derefs the pointee: `p!` reads the value, `p! = v` writes through. On a `T?` it asserts presence and projects out the value (see [optional types](#optional-types)); the parser produces the same node in both cases and the meaning is settled by the operand type. Outside `deconstruct` bodies the deref form is rarely needed — ghūl code usually takes refs only to pass them to .NET methods that follow the try-pattern.

## functions

See <https://ghul.dev/definitions.html#functions>.

A function is a name, a parenthesized argument list, an optional return type after `->`, and then either a single-expression body after `=>` or a block body between `is` and `si`:

```ghul
add(a: int, b: int) -> int => a + b;

multiply(a: int, b: int) -> int is
    let result = a * b;
    return result;
si
```

A named function's signature is fully explicit: every argument has a written type, and so does the return — written after `->`, or the `->` left off to make the function `void`. The compiler infers no part of a named function's or method's signature. A block body uses `return` to produce a value; reaching the end of a non-void function without a `return` returns the default value of the return type, and draws a `definite-return` warning.

Functions are declared at namespace scope — there are no nested function definitions — and may be overloaded on their argument types. There are no default argument values. Execution of a program begins at a function named `entry`, or — in a file with no namespace — at the bare statements written at its file root, which are collected in source order into that entry point. An `entry` function takes either no parameters or a single `string[]` of the command-line arguments, and returns either nothing or an `int` exit status. It should not be asynchronous: an async `entry` returns a task rather than one of those, which draws a warning and leaves the program without an entry point — to run asynchronous work, read `.result` on the returned task. The name can be changed with `--entry <name>`, and an `@entry` pragma marks any function as the entry point regardless of name.

A formal parameter can be a tuple-destructure pattern instead of a plain name. It is still one physical parameter, at the written tuple type — the pattern is unpacked into its named elements on entry, the same way a `let (a, b) = pair;` local is:

```ghul
add_pair((a: int, b: int): (int, int)) -> int => a + b;

add_pair((3, 4));    // 7
```

Nesting and mixing with ordinary parameters both work: `f(x: int, (a: int, b: int): (int, int), y: int)`. Because a named function's signature is always fully explicit, the aggregate type ascription is required — there is no context to infer it from — and per-element types are optional, exactly as in a `let (a, b) = pair;` local. The aggregate type can be any positionally-destructurable type — a tuple, or a type with a matching `deconstruct(...)` method. The by-name group form (`(x = field, ...)`) is not supported in a formal argument list.

Functions are first-class values. A function literal has the same shape without a name, but its argument and return types are generally *inferred* — from the body and from the context the literal is used in — so they are usually written without annotations (though either can be given explicitly). With a single argument the parentheses are optional. `A -> B` is the type of a function from `A` to `B`. Function literals capture references from the enclosing scope, forming closures: an immutable `let` is captured by value (a snapshot at the point the literal is constructed); a `let mut` is captured by reference, so the closure and the outer scope share one live variable that either side can read or reassign. An anonymous function refers to itself through the `rec` keyword:

```ghul
let twice = x => x * 2;
let apply_twice = (f: int -> int, i) => f(f(i));
let factorial = n rec => if n == 0 then 1 else n * rec(n - 1) fi;
```

A function literal's parameter can be a destructure pattern too, written in its own parentheses inside the parameter list — the outer parentheses are the parameter list, the inner ones the pattern. It is one parameter, unpacked into the names the body uses, exactly as for a named function:

```ghul
let pairs = [(1, 2), (3, 4)];

pairs | .map(((a, b)) => a + b);           // element types inferred from the sequence
```

The bare single-parameter shorthand (`x => …`) can't carry a pattern any more than it can carry a type annotation — both need the parentheses. Unlike a named function the aggregate type is usually inferred, from the sequence or slot the literal is written into, or from how the parameter is used; write it explicitly when there is nothing to infer from. As with a named function, the aggregate can be any positionally-destructurable type, so per-element types and the aggregate ascription both take the full type syntax:

```ghul
let add = ((a, b): (int, int)) => a + b;

entries | .each(((key, value): Collections.KeyValuePair[string, int]) =>
    write_line("{key}={value}"));
```

Patterns nest and take discards, so `(((a, b), c)) => …` and `((_, b)) => …` both work. An asynchronous function literal cannot take one: its body compiles into a state machine whose locals are frame fields, which the pattern's names are not.

A bare name in call position (`foo(args)`) normally resolves to the nearest enclosing binding of that name, the same as any other reference. When that binding is not callable — a local variable, field, or property holding no function — and an enclosing scope has a function or a function-typed value of the same name, the call reaches that one instead, with a `shadowed-non-callable` warning at the call site:

```ghul
tally(xs: int[]) -> int => xs.count;

use_tally(xs: int[]) is
    let tally = tally(xs);   // warns, then calls the function above
    write_line("{tally}");
si
```

The fallback only applies when the nearest binding cannot be called at all — a function whose overloads reject the supplied arguments still reports the ordinary argument-mismatch error rather than reaching for something else. A name that refers to itself from inside its own initializer's function literal (rather than directly, as above) keeps reporting the reference as one to a value that does not exist yet:

```ghul
let f = (x: int) -> int => f(x);   // error: variable is not defined here
```

## type definitions

See <https://ghul.dev/definitions.html#types>. ghūl has five kinds of user-defined type, all declared at namespace scope, never nested inside another type.

### classes

A class defines a reference type. The header is the class name, optionally a superclass and any implemented traits after a colon, then an `is` ... `si` body of properties, methods, and constructors:

```ghul
class PERSON is
    name: string;
    age: int;

    init(name: string, age: int) is
        self.name = name;
        self.age = age;
    si

    describe() -> string => "{name} is {age} years old";
si
```

A class can extend at most one superclass and implement any number of traits. `self` refers to the current instance. An instance is created with a constructor expression — the type name applied like a function — which selects the matching `init` overload (`PERSON("alice", 30)`). A class with no declared superclass extends `object`. `==` on a class is always reference identity and stays that way; to give a type structural equality, define `=~`, which maps to .NET's `Equals`.

A **static constructor** — `init() static` — runs once, before the type is first used, to initialise its static state. It takes no parameters and no `self`, and is invoked by the runtime rather than called directly; a class or struct may declare one alongside its instance constructors:

```ghul
class COUNTER is
    next_id: int static;

    init() static is
        next_id = 1000;
    si

    id: int;

    init() is
        id = next_id;
        next_id = next_id + 1;
    si
si
```

Two postfix modifiers shape the hierarchy:

- **`open`** lifts the default closed-to-assembly rule. Without `open`, a class can only be subclassed from within the assembly it was declared in; consumers in another assembly that try to extend it are rejected at compile time. `open` opts in to cross-assembly subclassing — the right choice when a library class is genuinely a hook for downstream code, the wrong choice (and the harder one to take back) when it isn't. The closure also feeds type narrowing: the compiler can enumerate a closed root's subclasses on the else edge of an `isa` test.
- **`abstract`** says the class itself can't appear as a runtime instance — only its subclasses can. A direct constructor call (`Animal()`) on an abstract class is rejected at compile time; subclasses still call `super.init(...)` for shared initialisation. Closed-narrowing relies on this: when the root is `abstract`, the else edge of `isa CAT(a)` excludes the root from the in-set and can collapse to the singleton sibling.

```ghul
class Animal abstract is
    init() is si
si

class CAT: Animal is
    init() is super.init(); si
    purr() -> string => "purr";
si

class DOG: Animal is
    init() is super.init(); si
    bark() -> string => "bark";
si

describe(a: Animal) is
    if isa CAT(a) then
        write_line(a.purr());
    else
        // `Animal` is abstract and `CAT`/`DOG` are the only subclasses,
        // so the compiler knows `a` is `DOG` here.
        write_line(a.bark());
    fi
si
```

The two modifiers are independent: `open` controls who can extend, `abstract` controls who can be instantiated. They can be combined (`class Animal abstract open is ... si` is an extensible abstract base) or stand alone.

A class is **implicitly abstract** when it has any user-written body-less instance method — `foo();` or `foo() -> int;` with no `is … si` body. The user clearly wrote the method as a contract for subclasses to satisfy, and a bare instance of the class would have nothing useful to do on calling it, so the constructor is rejected the same way `abstract` rejects it. Property accessors, `init`, and static methods are excluded — a write-only property leaves its synthesised getter body-less without making the enclosing class abstract.

### structs

A struct defines a value type. The syntax mirrors a class, but a struct has no superclass (it may still implement traits). Copying a struct copies all of its fields:

```ghul
struct POINT is
    x: double;
    y: double;

    init(x: double, y: double) is
        self.x = x;
        self.y = y;
    si
si
```

A struct gets no equality operator of its own — define `=~` explicitly if the type needs one.

A bare member declaration like `x: double;` is an auto-**property**, not a field, and a struct's property getter hands back a *copy*. That matters when a struct is held in a heap object: mutating it through the property mutates the copy and the write is lost, so the compiler rejects a store through one. Declare a real field with the `field` modifier where a struct member is to be mutated in place:

```ghul
class HOLDER is
    origin: POINT field;     // a real field, mutable in place
si
```

### primary constructors

A class or struct may declare its constructor parameters directly in the header. Each parameter becomes a parameter of the synthesised `init`. A primary parameter without an explicit body declaration **auto-generates** a same-named body field/property mirroring its declared visibility:

```ghul
class POINT(x: int, y: int) is
    show() => write_line("({x}, {y})");
si
```

is equivalent to

```ghul
class POINT is
    x: int;
    y: int;

    init(x: int, y: int) is
        self.x = x;
        self.y = y;
    si

    show() => write_line("({x}, {y})");
si
```

A trailing **modifier suffix** on the parameter overrides the default visibility or storage, matching the same rules as a body field/property declaration:

- `x: int public` — public read and write.
- `x: int protected` — readable from the declaring class and its subclasses.
- `x: int private` — captured into the underscore-named member `_x`, non-public under the rules in [naming conventions](#naming-conventions). The parameter itself keeps the plain name `x`, so the member is read as `_x` and the constructor argument stays `x`. A private capture is left out of the synthesised `deconstruct`.
- `x: int field` — plain field rather than auto-property.
- `x: int static` — a static member rather than a per-instance one.
- `x: int init` — **no field generated**. The parameter is in scope only inside the synthesised `init` and any explicit `init(..)` body; useful when the constructor consumes its argument to compute something else (`init(.., other)` style).

Naming the parameter with a leading underscore (`_x: int`) is the equivalent convention-driven route, and follows the same rules; `_x: int private` is accepted and adds nothing, the name already carrying the visibility.

An explicit body declaration with the same name as a primary parameter (under the same `_foo` / `foo` matching rule) wins over auto-generation — the body decl receives the auto-init copy. This is the *capture* form: writing the field shorthand `_x;` (or a property declaration named `_x` / `x` that supplies neither a read nor an assign body) tells the rewriter "match primary parameter `x` to this declaration." A property that does supply an accessor body is a normal member, not a capture. With explicit body decls you also get to choose private renames (`_x;` on a primary parameter `x`) without using the modifier suffix.

```ghul
class POINT(x: int, y: int) is
    _x;
    _y;

    show() => write_line("({_x}, {_y})");
si
```

is also equivalent to the classic-form `POINT` above, with the fields named `_x` and `_y`.

The form also supports:

- **`super(expr, expr);`** as a class-body declaration — forwards the given expressions to the superclass `init`. Each argument can be any expression whose free identifiers are primary-ctor parameters (literals and module/type-level references are also in scope), so `super(null)`, `super(other.x)`, `super(LIST([elem]))`, and `super(Source.LOCATION.reflected, owner, name)` all work. Primary parameters consumed by `super(...)` are excluded from auto-generation (their value is forwarded to the base, no field needed locally).
- **`init(..)`** — an explicit body for the primary `init`; runs after the synthesised field assignments.
- **`init(.., extras)`** — a secondary `init` overload. The `..` splice expands to the primary parameters and an implicit chain to the primary `init` is prepended to the body, so every captured field is assigned before the secondary's body runs.
- **auto-`deconstruct`** — every public-readable capture surfaces, in primary-header order, as one `T ref` parameter of a synthesised `deconstruct` (exposed under .NET's `Deconstruct` name for cross-language interop), so `let (x, y) = POINT(3, 4)` works without writing the deconstruct out. Suppressed if the class body already declares a `deconstruct(...)` of any arity, or any backtick-numeric (`` `0 ``/`` `1 ``/...) property — both signal that the user is taking responsibility for positional access.

```ghul
class DOG(name: string, breed: string): ANIMAL is
    _breed;

    super(name);

    init(.., trick: string) is
        write_line("the {_breed} can {trick}");
    si
si
```

When the body would be empty, the `is si` may be replaced with a terminating `;`:

```ghul
class POINT(x: int, y: int);

struct VECTOR(dx: int, dy: int);
```

Classes, structs and unions all support primary constructors; the union form is covered under [unions](#unions).

### traits

A trait is ghūl's equivalent of an interface. A class or struct implements a trait by naming it in the header, and must provide every trait member that has no default. A trait member *can* carry a default body; an implementing type inherits the default and need only override it to change the behaviour, reaching the default with `super`:

```ghul
trait Logged is
    log() is
        write_line("(no log message)");
    si
si

class NOISY: Logged is
    init() is si

    log() is
        super.log();
        write_line("plus my own message");
    si
si
```

A class extends one superclass but may implement many traits. Structs and unions implement traits the same way, with the same `: Trait, Other` header syntax — a union's trait members must all be defaulted or satisfied by a property the union itself supplies, since variants have no syntactic place for a method body.

A trait declares properties and methods, but not fields — `field` is rejected in a trait body. A bare trait property is read-only; to make it assignable, give it an explicit assign accessor. An implementing type then satisfies it with a `public` property, which supplies both accessors:

```ghul
trait Counted is
    count: int, = v;      // readable and assignable
si

class TALLY: Counted is
    count: int public;
    init() is count = 0; si
si
```

Inheriting two *concrete* defaults for the same member from different traits is an error rather than a silent pick, so a diamond has to be resolved by overriding the member in the implementing type.

An override or trait implementation must keep the overridden member's optionality contract. It may strengthen it - a non-optional return or property where the base declares optional, an optional parameter where the base declares non-optional - but weakening it in either position is a compile error: returning `T?` where the base promises `T` would hand null to callers that use the base type, and requiring a non-optional parameter where the base accepts `T?` would receive null from them. A property with an assign accessor faces both directions at once, so its type must match the base's optionality exactly.

### unions

A union is a reference type that holds one of several variants. Each variant has a name and an optional list of fields:

```ghul
union Tree is
    NODE(left: Tree, right: Tree);
    LEAF(value: int);
si
```

A variant is constructed through the union name (`Tree.LEAF(123)`). A variant with no fields — a *unit variant* — is referenced by name without parentheses, and is interned to a single shared instance per generic instantiation:

```ghul
union Color is
    RED;
    GREEN;
si

union Option[T] is
    SOME(value: T);
    NONE;
si

let c: Color = Color.RED;
let n: Option[int] = Option.NONE;
let n2: Option[int] = Option.NONE[int];
```

Type arguments on a unit-variant reference are inferred from the surrounding context (declared LHS type, function-argument slot, return slot) the same way the parenthesised constructor form infers them; the explicit `[int]` is only needed when no context is available. The parenthesised form (`Color.RED()`, `Option.NONE()`) still works and yields the same interned value.

Discriminate a union value with `isa V(x)` or `if let v: V = x` — both test the runtime variant, and `if let` binds the value at the narrower variant type for use in the then-arm:

```ghul
if let node: Tree.NODE = tree then
    write_line("node: {node.left} and {node.right}");
elif let leaf: Tree.LEAF = tree then
    write_line("leaf: {leaf.value}");
fi
```

Both `isa V(x)` and `if let v: V = x` narrow `x` itself inside the then-arm and inside guard-then-return tails, and on a two-variant union narrow the `else` branch to the other variant — member access on the scrutinee in the else arm resolves against the complement variant. A `case` over a union scrutinee is checked for exhaustiveness: missing variants draw a `non-exhaustive-case` warning on the statement form, and are an error on the expression form, which has to produce a value. A `redundant-case-arm` arm fires when a later arm matches nothing the prior arms didn't already cover, and `dead-case-else` fires when the `else` arm is unreachable because the preceding arms cover the domain. The warnings also fire on `bool` and `bool?` scrutinees, on `T?` of a union, on closed class hierarchies (the in-assembly subclasses are the closed set — plus the root type itself when the root is concrete, since it is then constructible) and on enums. A `case` over an open-domain scrutinee (`int`, `string`, open class hierarchy, tuple) with no `else` arm fires `case-needs-else`: a warning on the statement form, where it just falls through; a warning on an expression form whose expected type has a default (value type or `T?`); and an error otherwise.

Unions compare by structural equality through the `=~` operator — two union values are `=~` when they hold the same variant with memberwise-equal fields.

A union with exactly one variant carrying fields of *its own* behaves as an option type: `u?` tests whether that variant is present and `u!` unwraps its value. Fields inherited from a union primary-constructor header don't count towards this, so a variant that carries only spliced shared fields is still a unit variant for the purpose of the rule. A union with several field-carrying variants can mark one with a trailing `default` to nominate it as the variant `?` and `!` act on:

```ghul
union Result[T, E] is
    OK(value: T) default;
    ERROR(error: E);
si
```

`r?` is then true when `r` holds `OK`, and `r!` unwraps the `OK` payload, throwing if `r` holds `ERROR`. A default variant with one field unwraps to that field positionally — the field name does not have to be `value` — and with several fields, it unwraps to the variant. Inside an `if r?` the variable narrows to the default variant — so its fields read directly, no `!` needed — and the `else` branch narrows to the remaining variant(s), the same narrowing `isa OK(r)` performs.

A union may declare a **primary-constructor header** for state shared across every variant. Each variant then splices the shared parameters into its field list with `..`:

```ghul
union TRIVIA(location: LOCATION) is
    LINE_COMMENT(text: string, ..);
    BLOCK_COMMENT(text: string, ..);
    BLANK_LINE;
si
```

The primary parameters become fields on the union base, so `t.location` reads through on any `TRIVIA` value regardless of variant; variant-declared fields like `text` stay variant-only. The `..` may appear at any position in the variant's field list; field order in the synthesised constructor and in positional destructure (`let (a, b) = trivia`) follows source order. A variant that carries no additional fields can be written without a field list at all (`BLANK_LINE;`) and is treated as if it had written `(..)`. A variant with additional fields must include exactly one `..`. The mechanism mirrors the class secondary-init splice ([primary constructors](#primary-constructors)).

A union may declare traits it implements after its header, with a leading `:` (and after any primary-constructor params):

```ghul
trait NAMED is
    name: string;
    label() -> string => "[{name}]";
si

union COLOUR(name: string): NAMED is
    RED(..);
    GREEN(..);
    BLUE(..);
si
```

`NAMED.name` is satisfied by the property auto-synthesised from the union's `name` primary parameter, and `NAMED.label` is inherited by every variant. A `NAMED` reference accepts any `COLOUR` value, with dispatch going through the union base class. The traits-only restriction is strict: a union may not declare a base class. Every trait member used through this header form must either be defaulted or be a property the union already supplies (typically through a primary parameter), since neither the union body nor its variants can carry method bodies; to give a union method implementations for a trait, use an [`impl` block](#partial-and-impl-blocks).

### enums

An enum is a set of named integer constants, counting from 0 unless given explicit values, reached as `Suit.HEARTS`. The enum type takes a PascalCase name and its members UPPER_SNAKE_CASE; a trailing comma after the last member is allowed:

```ghul
enum Suit is
    HEARTS,
    DIAMONDS,
    CLUBS,
    SPADES,
si

enum Status is
    OK = 200,
    NOT_FOUND = 404,
si
```

Enum values compare with the relational operators as well as for equality, so they order by their underlying integer. An individual member can be imported by name — `use Some.Namespace.Suit.HEARTS;` — as well as reached through the type.

### partial and impl blocks

Members can be added to an already-declared type from a separate block - even a separate file - as long as the type is declared in the same assembly. The added members are real members of the target: full private access and normal virtual dispatch, indistinguishable from members written in the type's own body.

A `partial` block adds members to the type it names:

```ghul
class VISITOR is
    _depth: int;
    init() is _depth = 0; si
si

partial VISITOR is
    visit_expression(e: EXPRESSION) is ... si
si
```

`partial` carries no interface clause - interfaces stay in the type's header. It applies to classes, structs, and unions; for a union, whose body holds only variants, it is the only way to give the type methods.

An `impl` block additionally makes the target implement an interface:

```ghul
trait Printer is print() -> string; si

union List[T] is
    NIL;
    CONS(head: T, tail: List[T]);
si

impl Printer for List[T] is
    print() -> string =>
        if let (head, tail): CONS = self then "{head} {tail.print()}" else "nil" fi;
si
```

The interface's type parameters are the target's own, written on the target after `for` (`impl Printer for List[T]`). Inside the body `self` has the concrete target type, so a union's variants can be matched on directly. The target then satisfies the interface exactly as a header-declared one would - a `List[T]` passes wherever a `Printer` is expected, dispatching through the type's base. A self-relational interface takes the target as its own argument: `impl Eq[List[T]] for List[T]`. The interface must be a trait, and the target must be a same-assembly type - an imported type cannot be reopened.

The target (and a `partial` block's target) can be a qualified name: a namespaced type (`impl Printer for Some.Namespace.TYPE`) or a specific union variant (`impl Printer for List.NIL`). Implementing an interface on a single variant attaches it to that variant alone - a value statically typed as the variant satisfies the interface, but the union as a whole does not unless it also implements it.

Inside the block, the target's own members, inherited members, and type parameters are in scope first, exactly as inside the target's declaration body. Every other name - the target name after `for`, the interface name, the types in member headers, anything the bodies reference - resolves where the block is written: its enclosing namespace and that namespace's `use` imports. Names that are only in scope at the target's declaration site (its namespace siblings, its own file's imports) are not visible unless they are also reachable from the block's site. Declaration order does not matter: the block can precede its target in the same file or live in a file compiled earlier.

### properties, methods, and visibility

A property is a name and a type, optionally with getter and setter bodies; a property with no bodies is backed by a hidden field. A property is public to read but only assignable within its defining type — prefixing the name with `_` makes it non-public for reading too, to whatever extent the `--underscore-access` policy in [naming conventions](#naming-conventions) sets.

The storage and visibility modifiers available on a primary-constructor parameter apply to a body declaration too: `x: int public` for public read and write, `x: int field` for a plain field rather than an auto-property, and `x: int static` for a static member. The `field` distinction matters most on value types — see [structs](#structs). `private` is the exception: it renames the member it captures, which only makes sense on a primary-constructor parameter. A plain body declaration has no separate name to rename from, so writing `private` on one without an accessor body is rejected; name the member `_x` directly instead.

```ghul
class COUNTER is
    _count: int;

    count: int => _count,
        = new_value is
            assert new_value >= 0 else "count must be non-negative";
            _count = new_value;
        si
si
```

Methods are functions declared inside a class, struct, or trait; they have an implicit `self`. A constructor is a method named `init`. Methods are public unless their name starts with `_`, which makes them non-public under the `--underscore-access` policy — by default visible only to the declaring class. The compiler enforces that gate.

## optional types

See <https://ghul.dev/language-basics.html#optional-types>.

A type followed by `?` is an *optional* type — a value of `T?` may be present or absent; the same type without the `?` is non-optional. The postfix `?` tests whether an optional holds a value and `!` reads it out, though `!` is rarely needed directly — a plain `if x?` narrows `x` to its non-optional form, and `if let` tests an optional and reads its value into a variable in one step.

```ghul
let name: string? = lookup();

if name? then
    write_line("hello, {name}");   // name is non-optional string here
fi
```

Optionals cover reference and value types alike. There are three lowerings — a plain nullable reference, `Nullable[T]` for a value type, and `MAYBE[T]` for an unconstrained type parameter, so `T?` is spellable even where `T` could be either kind. Which one is in play is an implementation detail: all three behave the same way and interconvert. A non-optional `T` is assignable to a `T?` without ceremony; the other direction is a hard rejection. To use a `T?` where a non-optional `T` is expected, the caller must narrow first — `if x?` / `if let` flow-narrow inside the guarded region, `x!` asserts present (throws if absent), and `x ?? _` falls back to a non-optional value. Reading a member, iterating (`for x in xs`), or indexing (`xs[i]`) through an optional receiver the flow analysis has not proven present — an un-narrowed local or member path, a call result — draws a `null-deref` warning; narrowing first (`if xs?` / `if let`), `x?.y`, `x.has_value`, and `x!` are the warning-free ways through (`--suppress null-deref` opts out project-wide). Applying `!` to a value that was never optional is an error (`cannot unwrap this`) — there is nothing to unwrap. Where flow analysis has already proven a value present — inside an `if x?` / `if let` region — a further `!`, `?`, or `?.` on it draws a redundancy warning (`redundant-unwrap`, `redundant-presence-test`, or `redundant-coalesce`); the fix is to drop the operator. Suppress via `@suppress("<code>")` per declaration or per file, or with `--suppress <code>` project-wide. `--warn-as-error`, `--warn-as-info` and `--warn-as-hint` reclassify a slug's severity the same way. A `?` or `?.` applied to a never-optional *value type* is an error too — a struct can never be null, so the test has nothing to check. On a never-optional *reference* a `?` presence test is redundant by its static type and draws a `presence-test-non-optional` warning, since the type already guarantees presence — though not inside an `assert` condition, where the test is taken as deliberate; a `?.` stays legal, reading as a defensive null test for the case where null can still arrive despite the static type, for example from reflected .NET APIs. Types that provide `has_value` and `value` properties are treated as optional-shaped, and `?` / `!` on them consult those properties and are never flagged.

The `?.` operator is *coalescing* member access: `a?.b` reads `b` from `a` when `a` is present, otherwise yields the optional null. The result is always optional — a non-optional member type `U` is widened to `U?`, an already-optional `U?` stays `U?`. Receivers may be reference- or value-type optional (`T?` backed by `Nullable[T]`). A flow-narrowed non-optional receiver always takes the present branch and draws a `redundant-coalesce` warning — a plain `.` does the same job. A receiver that was never optional is an error for a value type (`receiver is not optional`); a never-optional reference receiver stays legal as a defensive null test.

```ghul
let p: PERSON? = find(id);
let name = p?.name;              // string?
let length = p?.name?.length;     // int? — chained coalesce
let title = p?.describe();       // string? — method call short-circuits too
```

Method calls compose with `?.` the same way: `a?.foo(args)` calls `foo` on a present receiver — argument expressions included in the short-circuit, so they are not evaluated when `a` is absent — and yields the optional null otherwise. A void method is simply skipped on an absent receiver. Function-typed fields and properties invoked through `?.` (`a?.callback()`) short-circuit the invocation the same way.

The `??` operator is *null-coalescing*: `a ?? b` returns `a` when it is present, otherwise evaluates and returns `b`. The right operand is evaluated only when needed. `??` is right-associative, so `a ?? b ?? c ?? d` parses as `a ?? (b ?? (c ?? d))`; each intermediate result stays optional until the chain is closed by a non-optional fallback. The result type is the LUB of the left's underlying type and the right's type, kept optional iff the right is itself optional — so a chain that ends in a plain `T` returns `T`, and a chain that stays all-optional returns `T?`. `??` works across all three optional lowerings — reference `T?`, value-type `T?` (`Nullable[T]`), and the unconstrained-`T?` carrier `MAYBE[T]` — including mixed-kind operands: the result's optional kind is derived from the LUB of the inner types, and each side coerces to it. A `bool?` plugged with `?? false` reads as absent-means-false in condition position.

```ghul
let name: string? = lookup();
let greeting = "hello, {name ?? "stranger"}";   // string

let primary: string?   = first();
let secondary: string? = second();
let chosen = primary ?? secondary ?? "fallback"; // string
```

`=~` can compare values that may be null, with no narrowing first. The compiler writes the null checks around the call: two absent values are equal, and an absent value and a present one are not. `!~` negates that whole answer, so two absent values are not unequal:

```ghul
let present: THING? = THING(3);
let absent: THING? = null;
let also_absent: THING? = null;

present =~ absent;          // false
absent =~ also_absent;      // true
absent !~ also_absent;      // false
```

An absent value on the left is always answered this way, whatever the operator declares: there is no receiver to call a method on. What the operator's declaration decides is the *right* operand. Declared non-optional, an absent one is answered here too and the body is only ever handed present values. Declared optional — as `Ghul.Equatable[T]`'s example below writes it — the body is handed the absent value and answers for it itself.

A `T?` over a value type or over an unconstrained type parameter compares the same way, with one difference: an absent one of those is always answered by the null checks, never handed to the operator, because a value operand has no absent form to pass.

## control flow

See <https://ghul.dev/control-flow.html>. Most control-flow statements delimit one or more blocks, and each block is a scope.

`if` runs `if` ... `then` ... `fi`, with optional `elif` and `else` clauses, and is also an expression — every branch must then yield a compatible type:

```ghul
if x > 0 then
    write_line("positive");
elif x < 0 then
    write_line("negative");
else
    write_line("zero");
fi

let sign = if x >= 0 then "non-negative" else "negative" fi;
```

### type narrowing

When an `if` or `while` condition proves a stronger fact about a local variable's type, the branch (or loop body) sees it at the narrower type. The common cases are `isa` class or variant tests and a `?` presence test on an optional:

```ghul
if isa CAT(a) then
    // a is narrowed to CAT
    write_line(a.purr());
fi
```

For a two-variant union the `else` branch is narrowed to the other variant. The same applies to a class hierarchy declared in this assembly without `open` — eliminating one direct subclass on the else edge narrows to the others. If the root is `abstract` (only its subclasses can exist at runtime) the chain can collapse to a singleton and reach subtype-only members; a concrete root stays in the in-set, so the narrow is sound but reaches only members the root itself defines.

Narrowing is flow-sensitive: if a guard rejects a type and then leaves the block — by `return`, `throw`, `break`, or `continue` — the code after the guard is narrowed too.

Assignment narrows as well: when the assigned value's static type is strictly more specific than the local's declared type, the local reads at that type from the assignment on:

```ghul
let pet: Animal mut = CAT();

pet = DOG();
write_line(pet.bark());   // pet is DOG here
```

A null right-hand side contributes only the presence fact, a value-type right-hand side does not narrow (a wider slot holds the boxed value, not the bare struct), and a tuple-typed value keeps the declared spelling so named elements stay reachable. When branches assign different types, the views join back to the common ancestor after the `fi`.

Narrowing applies to local variables (including a function's own parameters), to `self` - an `isa`, `if let`, or destructure on `self` narrows it in place, so a method (typically in an [`impl` block](#partial-and-impl-blocks)) can match its own concrete type or a union's variants without first copying `self` into a local; because `self` is never reassigned its narrow is never dropped by reassignment - to fields, to properties whose getter the compiler can prove stores nothing - hover shows such members with `pure` in the trailing comment - and to member-access paths built from those pieces. Both the presence and type domains lift: after `if x.y? then`, a repeated `x.y` reads at its non-optional type; after `if isa CAT(x.y) then`, a repeated `x.y` reads at `CAT`, so `x.y.purr()` type-checks. `if let p: CAT = x.y` narrows the same way. The else edge narrows to the complement when the receiver is a closed hierarchy (a two-variant union collapses to the sibling variant; a closed class hierarchy eliminates the tested subclass from the in-set), so `if isa CAT(x.y) then x.y.purr() else x.y.bark() fi` type-checks on both arms when `x.y` is a closed `Animal`. Sibling / class-and-trait narrows on a path compose via intersection: after `if isa Purring(x.y)`, `x.y` exposes both `Animal` members and `Purring` members. Every hop must be a field or a store-free property. The facts differ in how long they last. A local's narrow holds until the local is reassigned; the assignment then re-narrows to the new value's static type when that is strictly more specific, and otherwise leaves the local at its declared type. A field's narrow also drops at any call that might store to the heap, and at an assignment to that same field through any receiver - the written receiver may alias the one the fact was proven on. A property's narrow additionally drops at any assignment to a field, property or element, because its getter may read anything the assignment changed. A path fact drops whenever any of its pieces would: at any possibly-storing call, at any heap store when some hop is a property, at a store to a field it reads through, and when its root is reassigned. Calls the compiler proves store-free drop nothing, wherever they appear - and a call that might store drops heap facts even from inside the condition that just proved them, so `if _f? /\ mutate() then` enters its branch with `_f` un-narrowed. A path through a getter the compiler cannot prove store-free never narrows - copy the value into a local variable first, or use `if let`, which introduces one.

Where proof falls short, declare it: a postfix `pure` modifier on a function or method (`describe() -> int pure is … si`) trusts it as effectively store-free, so callers keep their facts across the call without the body being provable. The declaration is a contract — every override or trait implementation must itself be pure, declared or proven, and violating that is a compile error, enforced even when the pure base was imported from another assembly. A postfix `pure` on a function type (`filter(p: (T) -> bool pure)`) extends the contract to a slot holding a function: only a store-free value is accepted — a literal whose body performs no possibly-storing call, heap store, or local reassignment, a store-free named function, or a value already of pure function type. The slot can be a parameter, a variable, a field, or a return type, and putting anything else in one — passing it, assigning it, initializing with it, returning it — draws an `impure-function-value` warning. For an argument the call conservatively drops heap facts anyway, so narrowing there does not depend on the warning being heeded. For a store into any other kind of slot it does: the value is in the slot from then on, and invoking a value through a pure function type drops nothing, so a narrowing can be kept across a call that invalidates it. Heed the warning, or don't declare the slot pure.

Being store-free is a property of the function rather than of the slot it is going into, so a function value's own type reports it: a literal whose body proved store-free, and a reference to a function that is declared `pure` or proved store-free, both have a pure function type, and it shows wherever that type does.

```ghul
double(x: int) -> int pure => x * 2;

let f = double;                      // (int) -> int pure
let g = (n: int) -> int => n * 2;    // (int) -> int pure — proved store-free
```

A variable whose type is a pure function type is trusted to hold a store-free value wherever it is read, which is why it is the store into one that carries the warning, and why the trust is only worth as much as the values put in. It is a declaration in the same sense `pure` on a function is: neither is verified, and both mislead the compiler if they are not true. Reassigning such a variable is unremarkable as long as the new value is store-free too. Purity declarations and pure function types survive compilation into an assembly and are honoured when it is imported.

### if let

`cast T(x)` views `x` as a `T`, yielding `null` rather than throwing when `x` is not a `T`. `if let` folds a cast and a presence test into the `if` itself — a `let` in the condition, with the then-branch running only when the value is present and the variable narrowed and in scope just there. A type on the variable makes it a type test; `elif let` chains them:

```ghul
if let c: CAT = a then
    write_line(c.purr());
elif let d: DOG = a then
    write_line(d.bark());
else
    write_line("some other animal");
fi
```

With no type, `if let` simply tests that the value is present — the natural way to consume an optional, since the variable has the non-optional type within the branch. The `let` can also destructure:

```ghul
if let line = reader.read_line() then
    write_line("read: {line}");
fi

if let (name, _) = lookup(id) then
    write_line("found {name}");
fi
```

A destructure leaf can also be a literal — an integer, float, string, character or boolean literal, `null`, or a qualified enum-member name. The leaf is then an equality test against the source position rather than a declaration; the arm only runs when every literal leaf matches and every named leaf binds. The test is value-equality for the value-type kinds (int / float / char / bool / enum); strings and `null` test by reference, so string-literal leaves rely on interning to work for inline literals — for arbitrary runtime strings, use a `/\`-guard with `=~`:

```ghul
if let (1, name) = pair then
    write_line("first is one: {name}");
fi

if let (Color.RED, label) = entry then
    write_line("red: {label}");
fi
```

Literal leaves are only allowed in refutable contexts (`if let` and `case`-when patterns); a plain `let` with a literal leaf is rejected, because the value test would be silently skipped at runtime.

Trailing `/\`-separated *guards* gate entry on additional conditions evaluated after the test, with the new variable in scope:

```ghul
if let c: CAT = animal /\ c.is_friendly then
    write_line("friendly cat: {c.name}");
fi
```

The clause's presence test runs first; if it succeeds, each guard runs in source order under the narrowed environment. Failure at any clause falls through to the next `elif`/`else` arm. The clause's initializer is whatever precedes the first `/\`; anything after is a guard, so a top-level `/\` in `if let` position always reads as a chain — its result would otherwise be `bool`, which is never refutable.

A single `if let` can chain several comma-separated clauses; every clause's presence test and optional `/\` guard must succeed for the then-arm to fire. Later clauses' scrutinees see earlier clauses' variables, so the value flows left to right:

```ghul
if let outer = holder, inner = outer.value then
    write_line("inner: {inner.label}");
fi

if let c: CAT = a, d: DOG = b then
    write_line("a cat and a dog: {c.name} and {d.name}");
fi
```

A failure at any clause's test or guard short-circuits straight to the next `elif`/`else` arm — earlier clauses' variables then aren't in scope.

When the tested value is a member path and the variable should simply take the path's last name, the `name =` can be omitted: `if let x.y.z` declares `z`, holding the value, refutable on the path's own optionality exactly as the full form `if let z = x.y.z` would be. `if let path: T` does the same with a type test. The shorthand composes with guards, comma-chained clauses, and `while let` exactly like the full form:

```ghul
if let order.customer then
    write_line("customer: {customer.name}");     // customer = order.customer
fi

if let zoo.pet: CAT /\ pet.is_friendly then
    write_line("{pet.name} says meow");
fi

while let queue.head do
    process(head);
od
```

The shorthand needs a path — for a bare optional local, `if x?` already narrows the variable itself, with no new name to introduce.

ghūl has no construct spelled `match`; variant tags, narrowing, `if let`, and `case` patterns cover that ground.

### loops

`while` tests its condition before each iteration; `do` ... `od` is an unconditional loop, left through `break`. `for` steps over anything iterable — a range, an array, a list, a map — and the loop variable's type is the element type, which can be destructured:

```ghul
while counter < 5 do
    counter = counter + 1;
od

for i in 1::5 do
    write_line("number {i}");
od

for (key, value) in dictionary do
    write_line("{key} = {value}");
od
```

Every loop supports `break` to exit and `continue` to skip to the next iteration. The range operators work in any expression: `..` is inclusive of its start and exclusive of its end (`0..3` is 0, 1, 2), and `::` is inclusive of both (`1::5` is 1 through 5).

Any loop (`for`, `while`, `do`) can be labelled by prefixing it with an identifier and a colon, and `break` and `continue` can then name the loop they act on, letting an inner loop exit or advance an outer one:

```ghul
outer: for i in 0..3 do
    for j in 0..3 do
        if j > i then
            continue outer;    // next i
        fi

        if i == 2 then
            break outer;       // exits both loops
        fi

        write_line("i {i} j {j}");
    od
od
```

A `break` or `continue` that names no enclosing labelled loop is a compile error.

A `while` condition narrows the loop body the same way an `if` condition narrows its then-arm. `while xs? /\ i < xs.count do xs[i] …` reads `xs` at its non-optional type inside the body, and `while isa CAT(a) do a.purr() od` calls a `CAT`-only member without an inner cast.

`while let` is the loop counterpart of `if let`: the loop runs while the refutable clause matches, with the declared names freshly in scope on each iteration. The same shapes work — bare presence (`while let line = reader.read_line() do …`), type ascription (`while let c: CAT = a do …`), destructure, `/\` guards (`while let c: CAT = a /\ c.has_whiskers do …`), and comma-separated multi-clause bindings (`while let x = a, y = b do …`) where every clause must succeed each iteration. Loop exit is whenever any clause's test or guard fails.

### case

`case` branches on a scrutinee value. Each `when` carries either a value-equality expression list (literals, enum members, named constants) or a binding pattern; `else` catches the rest; the construct ends with `esac`. There is no fall-through. The body of each arm is introduced by `then`:

```ghul
case status
when 200 then
    write_line("ok");
when 500, 501, 502 then
    write_line("server error");
else
    write_line("other");
esac
```

`case` is also an expression: the last expression of each arm body becomes the arm's value, and the `case` evaluates to whichever arm matched. An expression-position `case` needs either an `else` arm, arms that cover the scrutinee's closed domain (a union's full variant set, both bool branches, etc.), or — over an open-domain scrutinee with an expected type that has a default value (value type or `T?`) — none of the above, in which case the `case` produces `default(T)` on the no-match path and `case-needs-else` warns:

```ghul
let label = case status
when 200 then "ok"
when 500, 501, 502 then "server error"
else "other"
esac;
```

A `when` arm can also carry a binding pattern instead of an equality list. The patterns mirror those accepted by `if let`:

- `when v: T then` — type-test against `T`; on match, bind `v` to the narrowed value.
- `when (a, b) then` — destructure a tuple scrutinee into bound names. Per-element ascription works (`when (c: CAT, d: DOG) then`); discards are `_`; literal leaves like `when (1, label) then` or `when (Color.RED, label) then` add a value-equality test at that position.
- `when _: T then` — type-test only, no binding.

Pattern arms share `if let`'s contract on refutability — an option-shaped scrutinee binds to the unwrapped value, and an impossible value-type narrow is rejected with one error and ERROR-typed recovery on the bound names:

```ghul
case animal
when null then
    write_line("nothing");
when c: CAT then
    c.meow();
when d: DOG then
    d.bark();
else
    write_line("just an animal: {animal!.name}");
esac
```

A bare identifier without `:` or `(...)` is still an expression — `when v then` tests equality against the value of `v` in scope, it does not bind a new local. Bindings carry shape information.

A pattern arm can carry a trailing `/\`-guard, evaluated after the pattern binds — the bound names are in scope in the guard and in the arm body:

```ghul
case s
when c: CIRCLE /\ c.radius > 3 then
    write_line("big circle {c.radius}");
when c: CIRCLE then
    write_line("small circle {c.radius}");
when q: SQUARE then
    write_line("square {q.side}");
esac
```

A failing guard falls through to the next arm, exactly as if the pattern itself hadn't matched. A guarded arm never counts towards exhaustiveness — it can decline to run even when its pattern matches, so `non-exhaustive-case` still fires for a variant only ever matched by a guarded arm.

### val ... lav

`val ... lav` is a block expression: a sequence of statements whose value is the value of the last statement. Use it in any position that accepts an expression — a `let` initializer, function argument, `=>` body, etc.

```ghul
let x = val let y = 5; y * 2 lav;          // x = 10
let z = val let a = 3; let b = 4; a + b lav;  // z = 7
let n = val write_line("setup"); 42 lav;   // n = 42
```

A common use is loop-as-expression — fold an iterable into a value with the loop body updating a `mut` accumulator and the tail expression handing back the result:

```ghul
let sum_1_to_5 = val
    let acc mut = 0;
    for i in 1..6 do
        acc = acc + i;
    od;
    acc
lav;
```

If the last statement does not provide a value (a `let`, `for`, `while`, `assert`, ...), the block is void. Void blocks are accepted in any context that tolerates void — an expression-statement, the `=>` body of a void-returning function. A value-required position (typed `let` initializer, function argument, `=>` body of a value-returning function) requires the last statement to be value-producing, *unless* every reachable path through the body diverges (via `return`, `throw`, or a divergent inner `if`/`case`/`try`) — then the trailing statement is unreachable and the block's value comes from the divergence sites instead.

`return E` inside a `val ... lav` block in expression position exits the **block**, not the enclosing function. The block's value is the least-upper-bound of every `return E` inside it and the tail expression (if any), so an early return can short-circuit out of the block with a value while a different path falls through to the tail. Nesting follows the innermost rule — a `return` inside an inner `val` exits only that inner block, leaving the outer block's walk to continue.

A `val ... lav` is fine as the *entire* body of an expression-bodied function/method/lambda (the `=> body`). The innermost-block rule still applies — `return` inside targets the val-block — but the val-block's value flows back out as the function's expression-body value, so observable behaviour matches `is ... si`. `try` / `catch` / `finally` composes the same way as in any function body, including `return` from inside a `try` (the finally fires before the value is delivered), and a body whose every reachable path returns needs no separate value-providing tail:

```ghul
sign_label(n: int) -> string =>
    val
        if n < 0 then
            return "neg";
        fi
        if n == 0 then
            return "zero";
        fi
        "pos"
    lav;

divide_or_default(n: int, d: int) -> int =>
    val
        try
            return n / d;
        catch e: System.DivideByZeroException
            return 0;
        finally
            log("done");
        yrt
    lav;
```

Bare `return;` (no value) is accepted in a void val-block — same rule as `return;` in a void function — and acts as an early exit. In a value-required val-block it is an error.

### exceptions

`throw` raises an exception, which must derive from `System.Exception`. Exception handling runs `try` ... `yrt`, with `catch` clauses and an optional `finally`. A `catch` names an exception variable and a type, and handles that type or any subtype; `finally` always runs, including before a `return` leaves the `try`:

```ghul
try
    risky_operation();
catch e: FileNotFoundException
    write_line("not found: {e.message}");
catch e: IOException
    write_line("io error: {e.message}");
finally
    cleanup();
yrt
```

`throw` can also stand alone as the body of an expression-bodied function, property, or indexer, which is handy for stubbing out code that is not written yet:

```ghul
not_done() -> int => throw System.Exception("not implemented");
```

The body always diverges, so it satisfies any declared return type — explicit, generic, or void — and an inferred return type settles as void.

### assert and return

`assert` checks a condition and throws if it fails. The `else` clause is optional: without one, the thrown message is built from the source location and the condition text.

```ghul
assert index >= 0;
assert index < array.count else "index out of range";
```

A string after `else` is prefixed with the source location and wrapped in a `Ghul.AssertFailedException`; a `System.Exception` value is thrown as it stands. Anything else is a compile error.

In expression position, `assert cond else "msg" in expr` guards a value and chains like `let X in expr`: a failing assert throws, a passing assert yields the inner expression. The narrowing applied by the condition flows into the inner expression, so the guarded value can be used there directly:

```ghul
lookup(key: string?) -> int =>
    assert key? else "key is null" in
    table[key];
```

`return value;` returns from a block-body function, `return;` from a void one.

### asynchronous code

A function is asynchronous when its declared return type is `Tasks.TASK[T]` (the .NET `Task<T>`) or `Tasks.TASK` (the non-generic `Task`). Inside such a function, `await e` is an expression that waits for the task `e` to complete and evaluates to its result, so `let x = await e;` initializes `x` to that result and the rest of the function continues:

```ghul
compute() -> Tasks.TASK[int] is
    let a = await double_async(10);
    let b = await add_async(a, 1);
    return b;
si
```

The source reads top-to-bottom even though execution suspends at each `await`. `await e;` on its own is the value-less form — it waits for the task to complete and discards any result. A function declared `-> Tasks.TASK[T]` may `return` a bare `T` and the compiler wraps it as `Tasks.TASK.from_result(...)` automatically.

`await` may appear inside the body of a `for` or `while` loop, and `return` from inside such a body propagates back through the loop. A `try`/`catch`/`finally` around awaiting code works as expected, including a `return` from inside the `try`; what is not yet supported is an `await` inside a `catch` or `finally` *handler*. Reading `.result` on a returned task surfaces a faulted task as a `System.AggregateException`.

### generators

A function that returns `Ghul.Pipes.Pipe[T]` and contains `yield` is a *generator*: each `yield` hands the next element to the consumer and suspends, resuming where it left off when another element is asked for. The elements are produced lazily, so a generator can be unbounded.

```ghul
counting(limit: int) -> Ghul.Pipes.Pipe[int] is
    let i mut = 0;
    while i < limit do
        yield i;
        i = i + 1;
    od
si

for n in counting(4) do
    write_line("{n}");
od

let evens = counting(6) | .filter(x => x % 2 == 0);
```

The result is an ordinary `Pipe[T]`, so the pipe combinators chain straight onto it.

A generator's return type has to be `Pipe[T]` — `yield` in a function declared otherwise is an error. A function cannot be both a generator and asynchronous. And as with `await`, `yield` is not yet supported inside a `catch` or `finally` handler.

## collections and pipes

See <https://ghul.dev/functional-programming.html>.

`Collections.List[T]` is the read-only list trait (the .NET `IReadOnlyList<T>`); `Collections.LIST[T]` is the mutable list. `MAP`/`Map` pair the same way for dictionaries, and `SET` is the mutable hash set. `MutableList`, `MutableMap`, `Bag`, `MutableBag` and `STACK` round out the mapping. There is no map literal — construct a `MAP`:

```ghul
let scores = MAP[string, int]();
scores.add("alice", 1);
let total = scores["alice"];
```

The pipe operator `|` chains sequence operations: an expression, then `| .method(...)`. ghūl provides the usual combinators, in the manner of LINQ, and none of them mutate the source. They split into lazy stages that return a new sequence — `map`, `filter`, `flat_map`, `skip`, `take`, `cat`, `index`, `zip`, `sort` — and terminals that consume it and produce a value: `reduce`, `collect` / `collect_list` / `collect_array`, `count`, `find`, `find_map`, `first`, `only`, `has`, `any`, `all`, `each`, `join`, `append_to`.

```ghul
let numbers = [1, 2, 3, 4, 5];
let evens = numbers | .filter(x => x % 2 == 0);
let doubled = numbers | .map(x => x * 2);
let sum = numbers | .reduce(0, (acc, x) => acc + x);
```

Lazy and infinite sequences are built with `Ghul.Pipes.stream(initial, advance)`, where `advance` steps from the current state to the next element and state. Nothing forces `advance` to be free of side effects, but it is called lazily and on demand, so it is much easier to reason about when it is. The `||` infix is the step expression — `value || next_state`. A `stream(...)` is an ordinary `Pipe[T]`, so the pipe combinators chain straight onto it. See <https://ghul.dev/functional-programming.html#lazy-sequences>.

The thread-first operator `|>` calls a function with the left value threaded in as its first argument: `x |> f(a)` is `f(x, a)`, and `x |> f()` is `f(x)`. The right-hand side is resolved exactly as an ordinary call, so it can be a free function, a method on an explicit receiver (`x |> box.combine(a)` is `box.combine(x, a)`), or a generic whose type argument is inferred from the left value. Chains associate left to right, so `x |> f(a) |> g(b)` is `g(f(x, a), b)`. Unlike `|`, which wraps its operand in a `Pipe[T]` and calls pipe combinators on it, `|>` is a plain call, and its right-hand side must be a function call:

```ghul
double(x: int) -> int => x * 2;
add(x: int, y: int) -> int => x + y;

let a = 5 |> double();           // double(5) is 10
let b = 5 |> add(3);             // add(5, 3) is 8
let c = 5 |> double() |> add(1); // add(double(5), 1) is 11
```

## generics

See <https://ghul.dev/generics.html>.

Classes, structs, traits, unions, methods, and global functions can take type parameters, written in brackets after the name:

```ghul
print_something[T](value: T) => write_line("something is {value}");

struct BOX[T] is
    item: T;
    init(item: T) is self.item = item; si
si
```

A value of an unbounded generic argument type is largely opaque — it can be stored, passed, returned, and have the methods of `object` called on it, but little else. Giving the parameter a **bound** — `[T: Bound]` — makes the value behave as its bound, so the bound's members are reachable:

```ghul
trait Named is name: string; si

greet[T: Named](x: T) => write_line("hello {x.name}");
```

A bound's *static* members are reachable through the type parameter itself, written `T.member(...)` — the mechanism .NET's generic-math interfaces (`IParsable[T]`, `INumber[T]`, `IBinaryInteger[T]`, ...) are built on:

```ghul
use System.IParsable;

parse[T: IParsable[T]](s: string) -> T => T.parse(s, null);
```

The CLR kind constraints on an imported generic (`where T : class`, `struct`, `new()`) are enforced too, at the point a type argument is resolved. Type arguments can be given explicitly (`print_something[int](1234)`) but are usually inferred — from the call arguments of a function or method, from the constructor arguments of a generic class, struct, or variant, and from the enclosing context (return type, let-init type, assignment LHS) when the constructor arguments alone don't pin every owner-generic slot:

```ghul
print_something(1234);                       // T inferred as int
let b = BOX("hello");                        // BOX[string]
let r: RESULT[int, string] = RESULT.OK(42);  // OK's arg pins T = int;
                                             // the LHS pins S = string
```

When neither the arguments nor any later use pins a type argument, the construction is an error (`cannot infer type here`) — give the type argument explicitly (`BOX[int]()`).

## type inference

See <https://ghul.dev/type-inference.html>.

ghūl infers types pervasively, but inference is **function-local**: a function's signature — its parameter and return types — is always written out, and inference works only within the body. Within a body, types are inferred for local variables, loop variables, destructured variables, anonymous function parameters and return types, and generic type arguments on calls.

Inference also works from later use: a variable with no immediate clue takes its type from how it is used further down the same body — including from operations the body performs on it, and from its own recursive calls if it is a function. The compiler narrows local variables, fields and store-free properties (see Type narrowing above for how long each kind of fact lasts), and a `let` variable's inferred type does not escape the function it is declared in.

## .NET interop

See <https://ghul.dev/dotnet-integration.html>.

ghūl compiles to .NET IL and can consume most types in any .NET assembly. .NET names are mapped to ghūl conventions: method, property, and field names become `snake_case`; enum names and members become `MACRO_CASE`; class, struct, and trait names are left as they are, with .NET's generic arity suffix removed — `KeyValuePair<K, V>` is `Collections.KeyValuePair[K, V]`. The namespace `System.Collections.Generic` maps to `Collections` and `System.IO` to `IO`, and some common types are remapped — `System.Console` is `IO.Std`, `IReadOnlyList<T>` is `Collections.List[T]`, `IEnumerable<T>` is `Collections.Iterable[T]`, and `IComparable<T>`/`IEquatable<T>` are `Ghul.Comparable[T]`/`Ghul.Equatable[T]`. The dotnet-integration page has the full mapping table.

Those two interfaces are declared in terms of the operators rather than named methods: `Ghul.Equatable[T]` requires `=~` and `Ghul.Comparable[T]` requires `<>`, so a type implements them by defining the operator. Every .NET type implementing them gains the operator in turn, which is why `=~` compares a `System.DateTime` and the relational operators order a `System.Version`.

```ghul
class BOX: Ghul.Comparable[BOX], Ghul.Equatable[BOX] is
    _v: int;

    init(v: int) is _v = v; si

    <>(other: BOX?) -> int => if other? then _v - other._v else 1 fi;
    =~(other: BOX?) -> bool => other? /\ _v == other._v;
si
```

`<>` answers how its operands are ordered: negative when the left is the lesser, zero when neither is, positive otherwise. The relational operators are written in terms of it — `a < b` is `a <> b` reduced against zero — so defining `<>` is what gives a type all four.

An identifier that collides with a ghūl keyword is escaped with a backtick — `` `class `` is the identifier `class`.

A static property or field takes `snake_case` however constant-like it reads, since only enum members become `MACRO_CASE` — `CancellationToken.None` is `System.Threading.CancellationToken.none`.

A **nested** .NET type is not addressed through its enclosing type. It lives in the enclosing type's namespace under a name joining the segments with `_`, so `System.Environment.SpecialFolder` is written:

```ghul
let home = System.Environment.get_folder_path(System.Environment_SpecialFolder.USER_PROFILE);
```

A .NET **delegate** type is a slot a function literal can be written into directly, and the literal is compiled as that delegate:

```ghul
let xs = Collections.LIST[int]();

xs.sort((a: int, b: int) -> int => b - a);          // System.Comparison[int]

let is_even: System.Predicate[int] = n => n % 2 == 0;
```

Parameter types are taken from the delegate the slot expects, so they need no annotation. `Func` and `Action` are different: they are how ghūl's own function types are represented, so a `(int) -> bool` value is already a `System.Func<int, bool>` at the IL level and passes into such a slot with no conversion in either direction. Write the ghūl spelling — `(int) -> bool` — rather than naming `Func` directly.

Any other delegate type is a distinct .NET type rather than another spelling of `(int) -> bool`, so an existing function **value** held in a variable is not accepted where one is expected:

```ghul
let compare = (a: int, b: int) -> int => b - a;     // a function value
xs.sort(compare);                                   // error: not assignable to System.Comparison[int]
```

Declare the variable at the delegate type instead, and it is that delegate from the start:

```ghul
let compare: System.Comparison[int] = (a: int, b: int) -> int => b - a;
xs.sort(compare);
```

Or construct the delegate explicitly from the existing value, calling the delegate type as if it were a constructor:

```ghul
let compare = (a: int, b: int) -> int => b - a;     // a function value
xs.sort(System.Comparison[int](compare));
```

A global function, or a static or instance method, referred to **by name** is different from a stored function value: the name converts directly wherever a function type *or* a named delegate is expected, since the compiler reaches for the method itself rather than needing an existing value to wrap.

```ghul
compare_descending(a: int, b: int) -> int => b - a;

apply(f: (int, int) -> int) -> int => f(3, 5);

apply(compare_descending);                          // ok - no lambda wrapper needed

xs.sort(compare_descending);                        // ok - System.Comparison[int]

let f = compare_descending;                         // f: (int, int) -> int
```

An overloaded name is resolved against whichever function or delegate type the reference needs to match, the same way a call's argument types pick an overload; with no such type in scope, an ambiguous name is left as an error rather than guessed at.

A .NET **user-defined conversion operator** (`op_Implicit` / `op_Explicit`) declared on either the source or the target type is reachable through `cast`, alongside the subtype and scalar conversions `cast` already performs:

```ghul
let h = cast System.Half(1.5);      // System.Half declares `explicit operator Half(float)`
let f = cast single(h);             // and `implicit operator float(Half)`
```

`cast T(v)` calls the operator and lets it throw on failure, same as calling it from C# would. `cast T?(v)` never throws: `InvalidCastException` or `OverflowException` from the operator becomes an absent value, and any other exception still propagates.

An auto-property's **backing field** is named `$` followed by the property name, and reflection sees it alongside the property. A reflection-based serializer told to include fields will therefore emit every property twice — with `System.Text.Json`, leave `include_fields` alone unless the type really does have fields to serialize.

Because ghūl has no default argument values, a .NET **optional parameter** has to be supplied explicitly — there is no overload with it omitted. `File.ReadAllTextAsync(path)` is written:

```ghul
let text = await IO.File.read_all_text_async(path, System.Threading.CancellationToken.none);
```

A pragma whose name doesn't match a compiler built-in is taken to name a .NET **attribute**, and emits the attribute on whatever it's written against: a class, trait, struct, union, variant, or enum; a function or method; or a single parameter in a function or method's parameter list, including a lambda literal's. The `Foo` short form resolves to `FooAttribute` when no plain `Foo` exists. Arguments are positional, named (`name = value`), array-valued, or `typeof`:

```ghul
@System.Obsolete("use PRODUCT instead")
class LEGACY_PRODUCT is
    init() is si
si

get_product(
    @Microsoft.AspNetCore.Mvc.FromServices() store: ProductStore,
    @Microsoft.AspNetCore.Mvc.FromRoute() index: int
) -> Tasks.TASK[IResult] is
    ...
si

app.map_get(
    "/products/{index}",
    (@Microsoft.AspNetCore.Mvc.FromRoute() index: int, store: ProductStore) -> Tasks.TASK[IResult] is
        ...
    si
);
```

A parameter attribute is recognised only where a formal parameter can appear: a named function or method's parameter list, or a lambda literal's — not on a `let` or a primary-constructor parameter. Written on an element of a parenthesised expression that turns out not to be a lambda (an ordinary value tuple), it's rejected with an error rather than silently ignored.

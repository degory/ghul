# ghūl language tutorial and reference

ghūl is a statically typed, general-purpose programming language that targets .NET 8. It is a hobby project, but expressive enough for general-purpose work — the ghūl compiler is itself written in ghūl. It produces ordinary .NET assemblies and NuGet packages, and ghūl code can consume any .NET library.

Apart from a slightly quirky syntax, ghūl is a fairly conventional language. The syntax is influenced by ALGOL 68 and Pascal: blocks are delimited by keywords rather than braces or indentation, and the keywords come in pairs whose closing half mirrors the opening one — a class or function body runs `is` ... `si`, a conditional runs `if` ... `fi`, a `try` ends with `yrt`.

This file is a condensed single-file reference. The full documentation, with a page per topic, is at <https://ghul.dev>; setup instructions are at <https://ghul.dev/getting-started.html>. Each section below links to the page that covers it in depth.

## naming conventions

ghūl keywords are lowercase. Identifiers follow a convention that the compiler partly enforces:

- `snake_case` — variables, functions, methods, properties
- `PascalCase` — namespaces, traits, abstract classes
- `MACRO_CASE` — concrete classes, structs, enums, unions, and union variants

A leading underscore (`_name`) marks a name as non-public. For methods and properties this is enforced. There are no `public`/`private` keywords; the naming convention carries that information.

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

A source file with no namespace declarations has its definitions placed in a compiler-generated namespace private to that file — convenient for small programs and tests. Once a file declares any namespace, every definition in it must sit inside a namespace.

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

A `mut` variable still cannot change type. Either form can also take its value from a `default` expression — `let i = default` initializes to the default value of the type that the surrounding context expects, with `default[T]` to pin the type explicitly.

A single `let` can declare several variables, mixing inferred and explicit types:

```ghul
let first = 1, second: int = 0, third = "three";
```

The name `_` is a discard placeholder: it stands in for a variable name, but the value that would be assigned to it is discarded. It is accepted in `let` definitions, tuple destructuring, lambda parameters, and `for` loop variables.

Variables are block-scoped — visible from their declaration to the end of the innermost enclosing block — and can only be declared inside function, method, or property bodies.

## types and literals

See <https://ghul.dev/language-basics.html>.

ghūl exposes the .NET primitive types under lowercase names:

- integers — `byte`, `ubyte`, `short`, `ushort`, `int`, `uint`, `long`, `ulong`, `word`, `uword`
- floating-point — `single`, `double`
- `bool`, `char`, `void`

`string` and `object` are reference types from the .NET base class library.

```ghul
let count = 12_345;            // int
let hex = 0x1234_ABCD;         // int, hexadecimal
let big = 1_000_000_000L;      // long
let b = 99b;                   // byte
let ratio = 123.456;           // single
let precise = 123.456D;        // double
let letter = 'c';              // char
let greeting = "hello";        // string
```

Digits may be grouped with `_`. An integer literal can carry a radix prefix (`0x`) and a type suffix (`L`, `UL`, `b`); a fractional literal is a `single` unless suffixed `D` for `double`.

ghūl does not convert between scalar types implicitly — a mixed-type arithmetic expression is a compile-time error, and a `cast` is required. Upcasting is implicit: a value is assignment-compatible with any ancestor type, so a `string` can be assigned to an `object` with no cast.

```ghul
let a = 1.0D + 1.0D;             // ok, both double
let b = 1.0D + cast double(1);   // ok, explicit cast
let o: object = "hello";         // ok, string is an object
```

An **array** type is written `E[]`. Arrays are fixed-size and immutable — there is no assigning indexer. An array literal is a comma-separated list in square brackets, and its element type is inferred as the most specific type compatible with every element (`object` if there is no closer common ancestor):

```ghul
let primes = [2, 3, 5, 7, 11];          // int[]
let mixed = ["frog", 1234, 12.5];       // object[]
let p = primes[2];                      // indexing, 0-based
```

A **tuple** groups a fixed number of values of possibly different types. Tuple types and literals both use parentheses; elements may be named, and an unnamed element is named with a backtick and its index. Tuples are immutable, compare by structural equality, nest, and can be destructured:

```ghul
let pair = (10, "hello");                  // (int, string)
let point = (x = 10, y = 20);              // (x: int, y: int)
let x = point.x;
let first = pair.`0;                       // positional access
let (name, age) = ("alice", 30);           // destructuring
```

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

A named function's signature is fully explicit: every argument has a written type, and so does the return — written after `->`, or the `->` left off to make the function `void`. The compiler infers no part of a named function's or method's signature. A block body uses `return` to produce a value; reaching the end of a non-void function without a `return` returns the default value of the return type.

Functions are declared at namespace scope — there are no nested function definitions — and may be overloaded on their argument types. There are no default argument values. Execution of a program begins at a parameterless function named `entry`.

Functions are first-class values. A function literal has the same shape without a name, but its argument and return types are generally *inferred* — from the body and from the context the literal is used in — so they are usually written without annotations (though either can be given explicitly). With a single argument the parentheses are optional. `A -> B` is the type of a function from `A` to `B`. Function literals capture references from the enclosing scope, forming closures: an immutable `let` is captured by value (a snapshot at the point the literal is constructed); a `let mut` is captured by reference, so the closure and the outer scope share one live variable that either side can read or reassign. An anonymous function refers to itself through the `rec` keyword:

```ghul
let twice = x => x * 2;
let apply_twice = (f: int -> int, i) => f(f(i));
let factorial = n rec => if n == 0 then 1 else n * rec(n - 1) fi;
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

A class can extend at most one superclass and implement any number of traits. `self` refers to the current instance. An instance is created with a constructor expression — the type name applied like a function — which selects the matching `init` overload (`PERSON("alice", 30)`). A class with no declared superclass extends `object`, and classes compare by reference identity unless equality is overridden.

### structs

A struct defines a value type. The syntax mirrors a class, but a struct has no superclass (it may still implement traits). Copying a struct copies all of its fields, and `==` on a struct is a memberwise equality check:

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

A class extends one superclass but may implement many traits.

### unions

A union is a reference type that holds one of several variants. Each variant has a name and an optional list of fields:

```ghul
union Tree is
    NODE(left: Tree, right: Tree);
    LEAF(value: int);
si
```

A variant is constructed through the union name (`Tree.LEAF(123)`). Discriminate a union value with `isa V(x)` or `if let v: V = x` — both test the runtime variant, and `if let` binds the value at the narrower variant type for use in the then-arm:

```ghul
if let node: Tree.NODE = tree then
    write_line("node: {node.left} and {node.right}");
elif let leaf: Tree.LEAF = tree then
    write_line("leaf: {leaf.value}");
fi
```

`isa V(x)` also narrows `x` itself inside the then-arm and inside guard-then-return tails, and on a two-variant union narrows the `else` branch to the other variant. Variant-name dispatch is not checked for exhaustiveness yet — the compiler knows the full variant set but won't error on a missing arm.

Unions compare by structural equality through the `=~` operator — two union values are `=~` when they hold the same variant with memberwise-equal fields.

A union with exactly one field-carrying variant behaves as an option type: `u?` tests whether that variant is present and `u!` unwraps its value. A union with several field-carrying variants can mark one with a trailing `default` to nominate it as the variant `?` and `!` act on:

```ghul
union Result[T, E] is
    OK(value: T) default;
    ERROR(error: E);
si
```

`r?` is then true when `r` holds `OK`, and `r!` unwraps the `OK` payload, throwing if `r` holds `ERROR`. A default variant with one field unwraps to that field positionally — the field name does not have to be `value` — and with several fields, it unwraps to the variant.

### enums

An enum is a set of named integer constants, counting from 0 unless given explicit values, reached as `SUIT.HEARTS`:

```ghul
enum SUIT is
    HEARTS,
    DIAMONDS,
    CLUBS,
    SPADES
si
```

### properties, methods, and visibility

A property is a name and a type, optionally with getter and setter bodies; a property with no bodies is backed by a hidden field. A property is public to read but only assignable within its defining type — prefixing the name with `_` makes it protected for reading as well.

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

Methods are functions declared inside a class, struct, or trait; they have an implicit `self`. A constructor is a method named `init`. Methods are public unless their name starts with `_`, which makes them protected; protected access is enforced by the compiler.

## optional types

See <https://ghul.dev/language-basics.html#optional-types>.

A type followed by `?` is an *optional* type — a value of `T?` may be present or absent; the same type without the `?` is non-optional. The postfix `?` tests whether an optional holds a value and `!` reads it out, though `!` is rarely needed directly — a plain `if x?` narrows `x` to its non-optional form, and `if let` tests an optional and reads its value into a variable in one step.

```ghul
let name: string? = lookup();

if name? then
    write_line("hello, {name}");   // name is non-optional string here
fi
```

Optionals cover reference and value types alike — an optional value type is backed by the .NET `Nullable[T]`. A non-optional `T` is assignable to a `T?` without ceremony; the other direction needs the value to be known present. Assigning a possibly-absent value where a non-optional type is expected produces a warning, which clears once the value is known to be present.

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

When an `if` condition proves a stronger fact about a local variable's type, the branch sees it at the narrower type. The common cases are `isa` class or variant tests and a `?` presence test on an optional:

```ghul
if isa Cat(a) then
    // a is narrowed to Cat
    write_line(a.purr());
fi
```

For a two-variant union the `else` branch is narrowed to the other variant. Narrowing is flow-sensitive: if a guard rejects a type and then leaves the block — by `return`, `throw`, `break`, or `continue` — the code after the guard is narrowed too.

Narrowing applies to local variables, including a function's own parameters — never to a field or property. To narrow a field, copy it into a local variable first, or use `if let`, which introduces one.

### if let

`cast T(x)` views `x` as a `T`, yielding `null` rather than throwing when `x` is not a `T`. `if let` folds a cast and a presence test into the `if` itself — a `let` in the condition, with the then-branch running only when the value is present and the variable narrowed and in scope just there. A type on the variable makes it a type test; `elif let` chains them:

```ghul
if let c: Cat = a then
    write_line(c.purr());
elif let d: Dog = a then
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

ghūl has no dedicated `match` construct; variant tags, narrowing, and `if let` cover that ground.

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

### case

`case` branches on a constant value — numbers or enum members. Each `when` lists one or more literals; `default` catches the rest; the construct ends with `esac`. There is no fall-through:

```ghul
case status
when 200:
    write_line("ok");
when 500, 501, 502:
    write_line("server error");
default
    write_line("other");
esac
```

`case` cannot deconstruct a union — use variant tags or `if let` for that.

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

### assert and return

`assert` checks a condition and throws if it fails — the value after `else` is thrown, with a string wrapped in an `AssertionFailedException`:

```ghul
assert index < array.count else "index out of range";
```

`return value;` returns from a block-body function, `return;` from a void one.

### asynchronous code

A function is asynchronous when its declared return type is `Tasks.TASK[T]` (the .NET `Task<T>`) or `Tasks.TASK` (the non-generic `Task`). Inside such a function, `let await x = e;` waits for the task `e` to complete; `x` is then initialized to its result and the rest of the function continues:

```ghul
compute() -> Tasks.TASK[int] is
    let await a = double_async(10);
    let await b = add_async(a, 1);
    return b;
si
```

The source reads top-to-bottom even though execution suspends at each `let await`. `await e;` is the value-less form — it waits for the task to complete and discards any result. A function declared `-> Tasks.TASK[T]` may `return` a bare `T` and the compiler wraps it as `Tasks.TASK.from_result(...)` automatically.

`let await` and `await` may appear inside the body of a `for` or `while` loop, and `return` from inside such a body propagates back through the loop. A `try`/`catch` surrounding code that awaits is not yet supported; wrap the call at the call site — reading `.result` on a returned task surfaces a faulted task as a `System.AggregateException`.

## collections and pipes

See <https://ghul.dev/functional-programming.html>.

`Collections.List[T]` is the read-only list trait (the .NET `IReadOnlyList<T>`); `Collections.LIST[T]` is the mutable list. `MAP`/`Map` pair the same way for dictionaries, and `SET` is the mutable hash set. There is no map literal — construct a `MAP`:

```ghul
let scores = MAP[string, int]();
scores.add("alice", 1);
let total = scores["alice"];
```

The pipe operator `|` chains sequence operations: an expression, then `| .method(...)`. ghūl provides `map`, `filter`, `reduce`, and the rest, in the manner of LINQ; these return new sequences and never mutate the source:

```ghul
let numbers = [1, 2, 3, 4, 5];
let evens = numbers | .filter(x => x % 2 == 0);
let doubled = numbers | .map(x => x * 2);
let sum = numbers | .reduce(0, (acc, x) => acc + x);
```

Lazy and infinite sequences are built with `Ghul.Pipes.stream(initial, advance)`, where `advance` is a pure step function from the current state to the next element and state. The `||` infix is the step expression — `value || next_state`. A `stream(...)` is an ordinary `Pipe[T]`, so the pipe combinators chain straight onto it. See <https://ghul.dev/functional-programming.html#lazy-sequences>.

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

A value of a generic argument type is largely opaque — it can be stored, passed, returned, and have the methods of `object` called on it, but little else. Type arguments can be given explicitly (`print_something[int](1234)`) but are usually inferred — from the call arguments of a function or method, and from the constructor arguments of a generic class, struct, or variant:

```ghul
print_something(1234);     // T inferred as int
let b = BOX("hello");      // BOX[string]
```

## type inference

See <https://ghul.dev/type-inference.html>.

ghūl infers types pervasively, but inference is **function-local**: a function's signature — its parameter and return types — is always written out, and inference works only within the body. Within a body, types are inferred for local variables, loop variables, destructured variables, anonymous function parameters and return types, and generic type arguments on calls.

Inference also works from later use: a variable with no immediate clue takes its type from how it is used further down the same body — including from operations the body performs on it, and from its own recursive calls if it is a function. The compiler narrows local variables but never fields or properties, and a `let` variable's inferred type does not escape the function it is declared in.

## .NET interop

See <https://ghul.dev/dotnet-integration.html>.

ghūl compiles to .NET IL and can consume most types in any .NET assembly. .NET names are mapped to ghūl conventions: method, property, and field names become `snake_case`; enum names and members become `MACRO_CASE`; class, struct, and trait names are left as they are, keeping any generic arity suffix (`` KeyValuePair`2 ``). The namespace `System.Collections.Generic` maps to `Collections` and `System.IO` to `IO`, and some common types are remapped — `System.Console` is `IO.Std`, `IReadOnlyList<T>` is `Collections.List[T]`, `IEnumerable<T>` is `Collections.Iterable[T]`. The dotnet-integration page has the full mapping table.

An identifier that collides with a ghūl keyword is escaped with a backtick — `` `class `` is the identifier `class`.

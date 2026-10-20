# ghūl language tutorial and reference

ghūl is a statically typed, general-purpose programming language that targets .NET 10, WebAssembly and native executables. It is a hobby project, but expressive enough for general-purpose work — the ghūl compiler is itself written in ghūl. On .NET it produces ordinary assemblies and NuGet packages, and ghūl code can consume any .NET library; the other two targets use ghūl's own libraries, and the [compilation targets](#compilation-targets) section says what each supports.

Apart from a slightly quirky syntax, ghūl is a fairly conventional language. The syntax is influenced by ALGOL 68 and Pascal: blocks are delimited by keywords rather than braces or indentation, and the keywords come in pairs whose closing half mirrors the opening one — a class or function body runs `is` ... `si`, a conditional runs `if` ... `fi`, a `try` ends with `yrt`.

This file is a condensed single-file reference. The full documentation, with a page per topic, is at <https://ghul.dev>; setup instructions are at <https://ghul.dev/getting-started.html>. Each section below links to the page that covers it in depth.

## the mistakes most often made

These cost the most rework. Each is explained in its own section below.

- **.NET members are `snake_case`.** `Math.sqrt(x)`, `Math.pi`, `s.length` and `list.count`, not `Math.Sqrt`, `Math.PI` or `list.Count`. The .NET names are converted, and `System.Math` is `Ghul.Math`.
- **`write_line` has to be imported.** Write `use IO.Std.write_line` before the code that calls it, or start the file with `use default` for `write_line`, the pipes and the collections.
- **There is no `+` on strings.** Join with interpolation: `"{a}{b}"`.
- **`==` on a `string` is reference identity.** Compare text with `=~`. `==` is for scalars, enums and references.
- **Numbers do not convert implicitly.** `1.0 + 1` is an error: write `1.0 + double(1)` or `cast double(n)`. A big integer is `bigint`, with `n` literals, not `System.Numerics.BigInteger`.
- **There is no `new`.** Construct by calling the type: `Box(42)`, `LIST[int]()`.
- **Blocks close with the mirror of their opener**: `is` ... `si`, `if` ... `fi`, `do` ... `od`, `case` ... `esac`, `try` ... `yrt`. There are no braces.
- **A bare `let` is immutable.** `let count mut = 0` can be reassigned.
- **An optional `T?` has to be narrowed before it is used as a `T`**: `if x?`, `if let v = x`, or `x!` to assert it is present.
- **A semicolon ends nothing at the end of a line**; it separates two statements on one line.
- **On WebAssembly and native, a .NET API the core library does not declare does not exist**, and `decimal` is not supported.

## the rest of the reference

GHUL.md covers the language as ordinary programs use it. These files hold the detail that specialised work needs. They are not loaded with this file: read the one that matches what you are doing.

| file | covers | read it when |
| --- | --- | --- |
| [docs/narrowing.md](docs/narrowing.md) | how narrowing works in depth: heap facts and crossings, `pure` and `stable`, getters, closure-assigned locals, nested optionals and `Result` coalescing | reasoning about why a value is or is not narrowed, or changing the compiler's flow analysis |
| [docs/generics.md](docs/generics.md) | argument packs, variance, generic-math operator imports, open generics in `typeof`, `size_of` | writing generic library code |
| [docs/async.md](docs/async.md) | the awaiter pattern, task-like return types and their builders, asynchronous function literals | writing a coroutine library or a custom task type |
| [docs/sessions.md](docs/sessions.md) | `--submission`, `--cells`, `--session` and `--cell-link`, and what they guard | working on the REPL, a notebook kernel or the playground |
| [docs/dotnet.md](docs/dotnet.md) | the core-type names, attributes and pragmas (`@intrinsic`, `@trusted_store_free()`, `@finalizer()`), `DllImport`, `StructLayout`, `IL.name`, operators reached from .NET types | calling .NET libraries beyond the common cases |
| [docs/targets.md](docs/targets.md) | what each target supports, conditional compilation, what differs on wasm, `@extern` on each target, the llvm options | building for WebAssembly or native executables |
| [docs/details.md](docs/details.md) | access policy flags, file-level pragmas, doc comment rules, `cast` target inference, synthesised equality and `@equality()`, `@Flags()` operators, `partial` and `impl` blocks, `@precedence`, `Displayable` | looking up a specific rule |

## naming conventions

ghūl keywords are lowercase. Identifiers follow a convention that the compiler partly enforces:

- `snake_case` — variables, functions, methods, properties
- `PascalCase` — namespaces, traits, abstract classes, exception classes, unions, enums
- `UPPER_SNAKE_CASE` — concrete classes, structs, variants, enum members

An exception class, `Exception` itself or one that derives from it directly or through other classes, is `PascalCase` whether or not it is abstract: it is named where it is thrown and where it is caught, which is where naming the concrete type is right, and every exception imported from .NET is spelled that way already.

A `static` field or property reads as a named constant, so it accepts either `snake_case` or `UPPER_SNAKE_CASE`. So does a property declared as an expression-bodied getter with no setter (`NAME: string => "x"`); one with a block getter or a setter keeps the `snake_case` rule.

A leading underscore (`_name`) marks a declaration as non-public — there are no `public`/`private` keywords, the naming convention carries that information. Whatever it is attached to, an underscore-prefixed name is **private to the assembly it is declared in**: another assembly cannot see it at all, and a reference to one from outside is a compile error.

The compiler warns when a ghūl-source declaration doesn't match the convention for its kind. Each rule has its own slug, suppressible per declaration, per file, or project-wide:

- `non-snake-case-name` — variables (including `let`, `for` and `catch` locals, and function arguments), functions, methods, properties.
- `non-pascal-case-name` — abstract classes, exception classes, traits, unions, enums.
- `non-upper-snake-case-name` — concrete classes, structs, variants, enum members.

A class with only `static` members (and no primary-constructor parameters) is a static-utility container — never constructed — and accepts either PascalCase or UPPER_SNAKE_CASE.

*More detail on this section: [language details](docs/details.md#naming-conventions).*

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

A namespace-less file may also carry bare statements at the file root. They run, in source order, as the program's entry point — so a short program needs no `entry` function — and may be interleaved with global definitions, which are visible regardless of where they appear. A file cannot both carry top-level statements and declare a namespace.

The `use` statement brings names into scope so they can be referred to without qualification. Applied to a namespace it imports every public symbol; applied to a single symbol it imports just that one:

```ghul
use IO.Std.write_line;            // a single static method
use IO;                           // every public symbol in the namespace
use Console = IO.Std;             // import under a different name
```

A `use` applies only within the current namespace block — if a namespace is split across blocks or files, each block needs its own `use` statements.

One namespace needs no `use` anywhere: `Ghul.Intrinsics` holds the names the language itself supplies — the built-in types such as `int` and `string`, the function and tuple shapes, and the operators on them — and every namespace block sees it as if it had written `use Ghul.Intrinsics;` first. Everything else the runtime provides is declared in `Ghul` and its nested namespaces and is imported like any other library: `use Ghul;` for the functional combinators such as `apply`, `use Ghul.Pipes;` for the pipe combinators. A definition of your own can share a name with one of those — an `apply` of your own, say — and a file that does not import that name sees only its own. A file that imports it as well sees both: a function of your own and an imported function of the same name form one overload group, and each call is resolved between them.

A `use` with a type expression on the right names a type rather than importing a symbol — a *type alias*:

```ghul
use IndexedString = (index: int, value: string);
use Handler = (int) -> void;
use Names = string[];
use MaybeName = string?;
use Numbers = Collections.LIST[int];
```

`use default` stands for a set of imports rather than naming one: the clause expands to the imports most files want before they want anything specific, which by default are `IO.Std.write_line`, `Ghul.Pipes` and `Collections`. It is an ordinary `use` in every other respect, so it applies to the namespace block it is written in and imports nothing implicitly: a file that does not write it gets none of them.

```ghul
use default

entry() is
    let totals = LIST[int]([1, 2, 3, 4])

    write_line("{totals |> filter(x => x % 2 == 0) |> reduce(0, (a, b) => a + b)}")
si
```

*More detail on this section: [language details](docs/details.md#namespaces-and-use), [sessions and submissions](docs/sessions.md#namespaces-and-use).*

## comments

`//` starts a comment that runs to the end of the line, and `/*` ... `*/` encloses one that can span lines. Either counts as the whitespace it sits in.

A line comment starting with exactly three slashes, `///`, and with nothing before it on its line, is a **doc comment**. A block of them written directly above a declaration documents it, and an editor shows the text in hover and completion wherever the declaration is used, including from another assembly:

```ghul
/// Joins `parts` with `separator` between each pair.
///
/// - parts: the strings to join, in order
/// - separator: placed between adjacent parts, not at either end
join(parts: string[], separator: string) -> string => string.join(separator, parts)
```

*More detail on this section: [language details](docs/details.md#comments).*

## statement terminators

Code written in the conventional style, one statement to a line, doesn't need a `;` anywhere except to put two statements on one line.

A `;` separates two statements or simple declarations written on one line. At the end of a line it is not needed: wherever the grammar could accept a `;` and the next token opens a new line, the boundary is inferred. End of file ends a line too, so the last construct in a file needs no terminator either. A construct left incomplete at the end of a line — `a +`, an argument list waiting for its `)` — continues on the next.

The rules that decide where a line break ends a statement, most often met first:

- A line that opens with `.`, `?`, `|>` or `ref` continues the construct above it, so member chains, optional chains and thread-first chains wrap.
- A line that opens with `(`, `[`, `` `[ ``, or an operator starts something new — a destructure assignment `(a, b) = …`, an array literal, a prefix `!` — and never glues to the line above as a call, an index, or an infix operand. A wrapped operator expression puts the operator at the end of the line (`a +` then the newline, not the newline then `+ a`).
- Two string literals chain into one across a line break. Where a statement ends on a string literal and the next begins with one, a `;` between them is the one boundary only a written `;` can make (see the string-literal section below).
- A bare `return` at the end of a line is a void return when the next line opens with a closing keyword (`fi`, `si`, `od`, …), and otherwise takes the next line's expression as its value. A statement after a `return` in the same block would be unreachable, so the two readings never compete.
- In a parenthesised group, a top-level `,` commits the tuple reading and an inferred boundary commits the block reading, exactly as a written `;` does. A compound statement that ends a line is complete, so the boundary falls after it whatever opens the next line, and an operator there begins a new statement. The expression reading needs the operator on the same line: `(if c then 2 else 5 fi - 1)` is 1 when `c` is true, where the same tail written on its own line is a second statement and the group's value.
- A postfix marker attaches on the same line as what it marks: a line-start modifier (`pure`, `static`, …) belongs to the next definition rather than the header above, and a line-start `rec` is the recursive self-reference call, never a rec-lambda marker.
- An `else` opening the line after a bare `assert` is the assert's message clause when its line is indented at least as far as the assert's, and otherwise the `else` of the enclosing `if` or `case` arm. Only the indentation decides: an assert sharing its line with the `if` (`if c then assert x` / `else y fi`) takes an `else` written level with the `if` as its own; a `;` after the assert gives the `else` to the `if`.

*More detail on this section: [language details](docs/details.md#statement-terminators).*

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

`null` says a local can be absent without saying what it holds when present, so an initializer or an assignment of `null` does not settle the local's type. The type comes from the other values assigned to it, or from the fallback a later `??` supplies, and is the optional of that type:

```ghul
let root mut = null;       // NODE?, from the assignment below
root = NODE("first");

let unknown = null;        // bool?, from the fallback
if unknown ?? false then
    ...
fi
```

A local whose initializer, assignments and uses give it no type at all is reported as `cannot infer type here` where it is declared, and needs an annotation.

A `mut` local with an initializer and no written type holds everything assigned to it, so its type is the join of the initializer and every value assigned later: a union variant or a subclass as the initializer does not stop a sibling being assigned.

```ghul
let tree mut = Tree.EMPTY;     // Tree, from the assignment below
tree = Tree.NODE(tree, 1, Tree.EMPTY);

let pet mut = CAT();           // Animal
pet = DOG();
```

The join is only taken where the author wrote a type for the values to share. Where it would be `object`, `System.ValueType`, or a trait neither the initializer nor any assigned value is typed as, or where any of them is a value type, the local keeps its initializer's type and the assignment is reported: `let i mut = 0; i = 1L` is an error, as is assigning an unrelated class. Writing the type out (`let pet: Animal mut = CAT()`) always fixes it.

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

*More detail on this section: [language details](docs/details.md#variables).*

## types and literals

See <https://ghul.dev/language-basics.html>.

ghūl exposes the .NET primitive types under lowercase names:

- integers — `byte`, `ubyte`, `short`, `ushort`, `int`, `uint`, `long`, `ulong`, `word`, `uword`
- floating-point — `single`, `double`, and `decimal`
- `bigint`, an integer of no fixed width
- `bool`, `char`, `void`

`string` and `object` are reference types from the .NET base class library.

Note that `byte` and `ubyte` are inverted relative to .NET: `byte` is `System.SByte` (signed) and `ubyte` is `System.Byte` (unsigned).

```ghul
let count = 12_345;            // int
let hex = 0x1234_ABCD;         // int, hexadecimal
let big = 1_000_000_000L;      // long
let b = 99b;                   // byte
let ratio = 123.456;           // double
let coarse = 123.456s;         // single
let price = 19.99m;            // decimal
let huge = 900719925474099n;   // bigint
let letter = 'c';              // char
let greeting = "hello";        // string
```

Digits may be grouped with `_`. An integer literal can carry a radix prefix (`0x`) and a type suffix built from two optional parts, both case-insensitive: a sign selector — `s` signed or `u` unsigned — followed by a size selector — `b` byte, `c` char, `s` short, `i` int, `l` long, `w` word. So `123b` is a `byte`, `0ub` a `ubyte`, `4567s` a `short`, `7890us` a `ushort`, `222i` an `int`, `0ul` a `ulong`, `123w` a `word`, `123n` a `bigint`. A numeric character literal (`65c`) cannot be unsigned, and neither can a `bigint` one (`123un`) — .NET has no unsigned counterpart to `System.Numerics.BigInteger`.

The digits are read first and as far as they go, so a letter that is a digit of the literal's radix is one. In hex that covers `b` and `c`, which are size selectors as well as hex digits: `0x20AC` is the `int` 8364 and `0xAB` is the `int` 171, with no suffix in either. A suffix that would be read as a digit is attached with a backtick, which marks the boundary and is not part of the value:

```ghul
let euro = 0x20AC`c;       // char, 8364
let byte_max = 0xFF`ub;    // ubyte, 255
let wide = 0x20ACl;        // long — `l` is not a hex digit, so no backtick
```

Backtick is the same escape it is elsewhere: it says to read what follows as itself rather than as its default meaning. Decimal needs it nowhere, since no size selector is a decimal digit.

`bigint` is `System.Numerics.BigInteger` under a built-in name, and only under that name — as `decimal` is `System.Decimal`. It is a name rather than a built-in type: its arithmetic and its ordering are its own static operators and its `IComparable` rather than anything the language supplies, so it has no width to overflow and no literal that is out of range.

```ghul
let factorial mut = 1n;

for i in 1::30 do
    factorial = factorial * bigint(i);
od

write_line("{factorial}");     // 265252859812191058636308480000000
```

Mixed operands stay an error, exactly as `1.0D + 1` is: `total * 2` is rejected where `total` is a `bigint`, and `total * 2n` is what to write. `==` is rejected on it as on every other struct; compare with `=~`.

A fractional literal is a `double` unless suffixed — `s` single, `d` double, `m` decimal, in either case. The `m` suffix is also accepted on a digit-only literal to write an integral decimal (`100m`). Exponent notation is accepted: `1.5e3`, `1.5E-3`.

ghūl does not convert between scalar types implicitly — a mixed-type arithmetic expression is a compile-time error, and a `cast` is required. Upcasting is implicit: a value is assignment-compatible with any ancestor type, so a `string` can be assigned to an `object` with no cast.

```ghul
let a = 1.0 + 1.0;               // ok, both double
let b = 1.0 + cast double(1);    // ok, explicit cast
let o: object = "hello";         // ok, string is an object
```

A scalar type is also a constructor from any other scalar, converting exactly as a cast to it does: `double(n)` is `cast double(n)`, `int(x)` truncates as `cast int(x)` does, and a value out of range wraps the same way. `_(n)` converts to the scalar type the context expects. The source has to be a scalar: `int("42")` is not a parse, and a value held as `object` or a type parameter is converted with `cast`, which unboxes it.

```ghul
let n = 7;
let half = double(n) / 2.0;      // 3.5
let code = int('A');             // 65
let total: long = _(n);          // 7
```

The target type can be left out when the surrounding expression already determines it. `cast(v)` converts `v` to whatever type the position it sits in calls for — a typed `let` initializer, an assignment, a `return` or `=>` body, an argument, an operator's other formal, an index, or the callee of a call:

```ghul
let total = cast(count) + average;   // count converts to double
let d: double = cast(i);             // to double
takes_a_double(cast(i));             // to double
values[cast(index)];                 // to whatever the indexer takes
```

A **string literal** may interpolate expressions: `{` opens an expression and `}` closes it, and the expression's value is converted to a string in place. There is no `+` operator on `string`, so interpolation is how strings are joined:

```ghul
let greeting = "hello {name}, you are {age} years old";
let combined = "{prefix}{suffix}";                  // concatenation
```

An interpolated expression can carry an alignment and a format specifier, as in .NET: `{expr, alignment : format}`.

A format reaches a number, and a value whose type implements `System.IFormattable`, which is written through its `to_string(format, format_provider)` with no provider. A format given to any other value is ignored, as on .NET. A type of your own takes a format by implementing `System.IFormattable`.

```ghul
let padded = "[{value,12:F3}]";     // [    1500.000]
```

How a value reads depends on its static type. A string, a number, an enum, and any type that declares its own `to_string` read as they always have, through that `to_string`, and so does any value given an alignment. A `bool` reads `true` or `false`, as ghūl spells it. An optional reads as the value it holds, by these same rules, or as `null` when it holds nothing. Anything else - an array, a list, a tuple, a struct or class that declares no `to_string`, a value held as `object`, a trait or a type parameter - would otherwise read as its .NET type name, so the runtime's `$` writes it instead: a sequence as its elements in brackets, a tuple as its parts, and a record as its type and members.

```ghul
struct POINT(x: int public, y: int public);

let xs = [1, 2, 3];
let found: string? = null;

"{xs} {(1, "one")} {POINT(3, 4)} {true} {found}"
                                     // [1, 2, 3] (1, one) POINT(x = 3, y = 4) true null
```

Adjacent string literals concatenate, so a long string can be split across lines — plain and interpolated literals mix freely. Comments count as the whitespace they sit in, so a commented fragment chains like an uncommented one; only a `;` separates two otherwise-adjacent literals. That `;` is the one statement terminator that carries meaning — where a statement ends on a string literal and the next begins with one, it keeps them from chaining into a single literal, so `redundant-semicolon` never reports it:

```ghul
let band = "top";
"{band} band"        // a new statement — without the `;` the two
                     // literals chain, and band is not defined yet
```

Inside the braces you are in *expression* context, so a nested string literal is written normally — `"{format("hello")}"` needs no escaping of its inner quotes. To write a literal brace, double it: `"{{"` and `"}}"`. The escapes are `\t`, `\n`, `\r`, `\\`, and `\u` followed by exactly four hex digits for an arbitrary character code — so the euro sign is `"\u20AC"` and an escape character is `"\u001B"`. Four digits is one UTF-16 code unit, which is one `char`; a code point above `U+FFFF` is written as its surrogate pair, so `"\uD83D\uDE00"` is one grinning face and two `char` values. The width is fixed so that the escape never reaches into the text after it — `"\u0041cat"` is `Acat`. Any other character after a `\` stands for itself, which is what makes `\"` a quote.

An **array** type is written `E[]`. Arrays are fixed-size and read-only — there is no assigning indexer. An array's length is its `count`. An array literal is a comma-separated list in square brackets, and its element type is inferred as the most specific type compatible with every element (`object` if there is no closer common ancestor):

```ghul
let primes = [2, 3, 5, 7, 11];          // int[]
let mixed = ["frog", 1234, 12.5];       // object[]
let p = primes[2];                      // indexing, 0-based
```

The empty array literal `[]` is accepted wherever the element type comes from context — an explicitly-typed `let`, a `return`, a call argument's parameter type, a sibling element of an enclosing array literal, or the other arms of an `if` or `case` expression it is an arm of. An untyped immutable local initialized with `[]` takes its element type from its later uses in the same body, such as being passed where an array is expected or placed in an array literal that is; when nothing uses it that way, its element type is `object`.

A non-empty array literal passed as an argument is built at the type of the parameter it fills when its elements each convert to that parameter's element type but the literal built from its elements alone would not convert to the parameter. That is the case for tuples, which are value types and so do not vary: passed to a parameter of `(name: string, operation: Operation[string]){}`, `[("+", APPEND())]` is built as a sequence of those pairs, each tuple converted as a tuple value is anywhere else, rather than as a `(string, APPEND)[]`. A generic parameter is matched once the call has bound its type arguments.

A sequence of `E`, anything a `for` loop can walk, is written `E{}`: it is `Collections.Iterable[E]`, the .NET `IEnumerable<E>`, spelled the way `E[]` spells an array. The two spellings are the same type, so either is accepted wherever the other is, and diagnostics, hover and inlays show `E{}`. The braces follow the element type in every position a type can appear, and combine with the other suffixes: `int{}?` is an optional sequence, `int[]{}` a sequence of arrays and `int{}{}` a sequence of sequences. A tuple or function type is parenthesised first, as it is for `[]`:

```ghul
total(values: int{}) -> int => values |> sum()

let words: string{} = ["alpha", "beta"]
let pairs: (int, string){} = [(1, "one")]
```

Indexing with a **range** takes a slice of the source rather than a single element. `..` and `::` count both endpoints from the start, as they do everywhere else; `..<` and `::<` count the end back from the end of the source, and `..<<` and `::<<` count both endpoints back. The number of `<` says how many endpoints are counted back, filling from the right. `<0` is the length, so `a..<0` runs from `a` to the end:

```ghul
let xs = [10, 20, 30, 40, 50];

xs[1..3];        // 20, 30
xs[1..<1];       // 20, 30, 40   — up to one back from the end
xs[1..<0];       // 20, 30, 40, 50 — to the end
xs[3..<<0];      // 30, 40, 50   — the last three
```

The slice is a `Collections.List[E]` over the source, so nothing is copied and a later change to a mutable source shows through. Arrays, strings and anything that satisfies `Collections.List[E]` can be indexed this way; a string gives back a string, since there is no non-copying substring to hand out. A range index is a read: there is no slice to assign through. A type may also declare its own `[r: System.Range]` indexer, which is used in preference.

The from-the-end operators build a `System.Range`, whose endpoints are only resolvable against a length, so unlike `..` and `::` they are not iterable — `for i in 1..<1 do` is rejected.

A **tuple** groups two or more values of possibly different types — a single-element tuple is rejected, and a tuple has at most 7 elements. Tuple types and literals both use parentheses; elements may be named, and an unnamed element is named with a backtick and its index. Tuples are immutable, nest, and can be destructured. They compare element by element through `=~`; `==` is rejected on one, as it is on any other struct (see [equality](#equality)):

```ghul
let pair = (10, "hello");                  // (int, string)
let point = (x = 10, y = 20);              // (x: int, y: int)
let x = point.x;
let first = pair.`0;                       // positional access
let (name, age) = ("alice", 30);           // destructuring
```

A tuple is assignable to a tuple type whose elements each accept its own, so a `(CAT, Shape.DOT)` value goes wherever a `(Animal, Shape)` is expected, and an `(int, string)` wherever an `(int, object)` is. The .NET tuple type is invariant, so the value is rebuilt at the wider type where it crosses into it, converting each element as it would be converted on its own, boxing and optional widening included. The rule is for tuple values: a function type returning a tuple is not made assignable by it, so a `(int) -> (int, int)` value is not a `(int) -> (object, object)`.

When an unnamed tuple-literal element is a bare identifier, it takes its name from the identifier: `(a, b)` constructs the same tuple as `(a = a, b = b)`. When the identifier resolves to a field whose name carries the single-underscore private-member convention, the leading `_` is stripped from the inferred element name: `(_count, _total)` packed from private fields surfaces as `(count: ..., total: ...)` to consumers. Locals are not affected, and only a single leading underscore is ever stripped.

Destructuring comes in two forms: **positional** and **by-name**, distinguished syntactically.

A **positional** target list `(a, b, ...)` is matched against the source in this order: a value-tuple of matching arity; a `deconstruct(...)` instance method whose parameters are all `T ref`; the conventionally-named positional members `` `0 ``, `` `1 ``, .... The `deconstruct` route covers .NET types like `Collections.KEY_VALUE_PAIR[K, V]`, ghūl-defined classes that write through each `T ref` parameter with postfix `!`, and classes with a primary constructor that get a synthesised `deconstruct` (see [primary constructors](#primary-constructors)). A type without one of those shapes is not destructurable positionally — use the by-name form below.

```ghul
for (key, value) in dict do          // KEY_VALUE_PAIR.deconstruct
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

*More detail on this section: [language details](docs/details.md#types-and-literals).*

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

A named function's signature is fully explicit: every argument has a written type, and so does the return — written after `->`, or the `->` left off to make the function `void`. The compiler infers no part of a named function's or method's signature.

A block body produces its value with an explicit `return`, or by ending on an expression: the final statement of a non-void body is the function's return value on the fall-through path whenever its type is assignable to the declared return type, with or without a `;` after it. An expression qualifies, and so do an `if`/`case` expression and a parenthesised block. A tail of an incompatible non-void type is an error at the tail; to genuinely discard such a value, write `let _ = expr`. A void tail — an effect-only call, or an `if`/`case` whose arms diverge or do only effects — is the statement it is: the body falls off the end, returns the default value of the return type, and draws a `definite-return` warning. An asynchronous function accepts a bare-`T` value as its tail exactly where it accepts `return T`. Loops, `let`, assignments and `assert` never provide a tail value, and neither do labelled statements or `try` blocks (until `try` has an expression form). Void bodies tolerate any tail: whatever is left standing at the end of a void method is discarded, and an expression body follows the same rule, so `f(x: int) -> void => g(x);` discards `g`'s result rather than returning it. Generators are exempt from all of this: their fall-through signals end of stream.

A function whose result depends on the values of its arguments can have a `case` over them as its body, one arm per case: the form a function defined by equations takes in Haskell or Elixir. Over more than one argument the scrutinee is a tuple of them, and the arms get the same exhaustiveness checking, narrowing and guards as any `case`:

```ghul
gcd(a: int, b: int) -> int =>
    case (a, b)
    when (_, 0) then a
    else gcd(b, a % b)
    esac
```

A function declared at namespace scope may be overloaded on its argument types. Where a generic and a non-generic overload fit a call equally well, the non-generic one is chosen when each of its parameters is at least as specific as the generic's once the generic's type arguments are bound: `f(items: List[string])` wins over `f[T](items: Iterable[T])` for a `string[]`, and `f(items: List[object])` or `f(items: object)` loses to it. There are no default argument values. Execution of a program begins at a function named `entry`, or — in a file with no namespace — at the bare statements written at its file root, which are collected in source order into that entry point. An `entry` function takes any subset of two recognised parameters, matched by declared type rather than by name: a `string[]` for the command-line arguments, and a `Ghul.Environment` — a ghul-runtime trait giving read/write access to the process's environment variables — for the process environment. So `entry()`, `entry(args: string[])`, `entry(env: Ghul.Environment)` and `entry(args: string[], env: Ghul.Environment)` are all accepted, in either parameter order — and the environment parameter is recognised equally when reached through a `use`: `use Ghul;` then `entry(env: Environment)`, `use Ghul.Environment;` then `entry(env: Environment)`, or an aliasing `use X = Ghul.Environment;` then `entry(env: X)`. It returns either nothing or an `int` exit status. Only declaring the environment parameter changes anything about how the program starts: the compiler then synthesises a private wrapper carrying the real entry-point shape — no parameters, or a lone `string[]` when `args` is also declared — which resolves `Ghul.Environment` and calls through to `entry`; without it, `entry` compiles straight to the program's real entry point exactly as before. This recognition only applies to a global function reached by name — the default `entry`, or the name `--entry` gives — not to a class's static method serving as the entry point, which keeps its plain `string[]`-or-nothing shape. A function of the name the build starts at whose shape is none of those is an error at the function, saying which part of it rules the function out: a return type that is neither `int` nor `void` - which is what an asynchronous `entry` has, since it returns a task, so to run asynchronous work read `.result` on the returned task - more than one parameter, or a parameter of any other type. The file's top-level statements are not run in its place: a program that declares where it starts has said so, and starting somewhere else would be as surprising as not starting at all. The name can be changed with `--entry <name>`, and an `@entry` pragma marks any function as the entry point regardless of name.

A formal parameter can be a tuple-destructure pattern instead of a plain name. It is still one physical parameter, at the written tuple type — the pattern is unpacked into its named elements on entry, the same way a `let (a, b) = pair;` local is:

```ghul
add_pair((a: int, b: int): (int, int)) -> int => a + b;

add_pair((3, 4));    // 7
```

Nesting and mixing with ordinary parameters both work: `f(x: int, (a: int, b: int): (int, int), y: int)`. Because a namespace-scope function's signature is always fully explicit, the aggregate type ascription is required — there is no context to infer it from — and per-element types are optional, exactly as in a `let (a, b) = pair;` local. The aggregate type can be any positionally-destructurable type — a tuple, or a type with a matching `deconstruct(...)` method. The by-name group form (`(x = field, ...)`) is not supported in a formal argument list.

Functions are first-class values. A function literal has the same shape without a name, but its argument and return types are generally *inferred* — from the body and from the context the literal is used in — so they are usually written without annotations (though either can be given explicitly). With a single argument the parentheses are optional. `A -> B` is the type of a function from `A` to `B`. A function *type* — and so a function literal, or a named function referred to as a value — has at most 16 parameters; a named function itself has no such limit, since it need never be represented as a function-type value. Function literals capture references from the enclosing scope, forming closures: an immutable `let` is captured by value (a snapshot at the point the literal is constructed); a `let mut` is captured by reference, so the closure and the outer scope share one live variable that either side can read or reassign. An anonymous function refers to itself through the `rec` keyword:

```ghul
let twice = x => x * 2;
let apply_twice = (f: int -> int, i) => f(f(i));
let factorial = n rec => if n == 0 then 1 else n * rec(n - 1) fi;
```

A block-bodied function literal ends on a tail exactly as a named function does: a final statement whose type is assignable to the return type is the value the literal returns on fall-through. Where the return type is written out, or comes from the slot the literal goes into, the tail is judged against it. Where it is left to be inferred and the body has no `return`, the tail is what settles it - a void tail settles nothing, so such a body is void and may end on a guard `if` like any other.

A slot returning `void` settles the literal's return type as much as any other does, so a literal written into one discards whatever its body produces - by either body form. That is how a call whose result is not wanted is written where a function is expected:

```ghul
names |> each(name => seen.add(name));    // `add` returns a bool, discarded here
```

Where several overloads take a function at the same arity, a body that produces a value goes to the formal that asks for one, and a `void` formal is reached only when no candidate does. So a literal returning a `bool` still picks a `(T) -> bool` formal over a `(T) -> void` one, and writing the return type out (`name -> void => seen.add(name)`) picks the void formal outright. Among formals that each ask for a value, the type the body produces picks the one it fits: a literal returning an `int` goes to a `(T) -> int` formal over `(T) -> double` and `(T) -> long` ones, however many there are.

A function literal's parameter can be a destructure pattern too, written in its own parentheses inside the parameter list — the outer parentheses are the parameter list, the inner ones the pattern. It is one parameter, unpacked into the names the body uses, exactly as for a named function:

```ghul
let pairs = [(1, 2), (3, 4)];

pairs |> map(((a, b)) => a + b);          // element types inferred from the sequence
```

The bare single-parameter shorthand (`x => …`) can't carry a pattern any more than it can carry a type annotation — both need the parentheses. Unlike a named function the aggregate type is usually inferred, from the sequence or slot the literal is written into, or from how the parameter is used; write it explicitly when there is nothing to infer from. As with a named function, the aggregate can be any positionally-destructurable type, so per-element types and the aggregate ascription both take the full type syntax:

```ghul
let add = ((a, b): (int, int)) => a + b;

entries |> each(((key, value): Collections.KEY_VALUE_PAIR[string, int]) =>
    write_line("{key}={value}"));
```

Patterns nest and take discards, so `(((a, b), c)) => …` and `((_, b)) => …` both work, on plain and asynchronous function literals alike.

A function can also be written among the statements of a body, with a name. It is a function literal that the name is a local variable for, so it captures, compiles and is called exactly as the equivalent `let` would be, and the two spellings are interchangeable:

```ghul
process(xs: Collections.List[int]) -> int is
    score(x: int) -> int is
        if x < 0 then
            return 0;
        fi

        x * 2
    si

    xs |> map(score) |> reduce(0, (a, b) => a + b)
si
```

Argument and return types are optional, as they are on any other literal and unlike a namespace-scope function, whose uses are not all in view. Either body form works, and the name may be written wherever a value of its function type is expected, not only in a call:

```ghul
    halve(x) => x / 2;

    let apply_to_ten = (f: (int) -> int) => f(10);

    apply_to_ten(halve);
```

The function refers to itself by its own name, so it needs no `rec`, and a literal written inside its body reaches it the same way:

```ghul
    fact(n: int) -> int => if n <= 1 then 1 else n * fact(n - 1) fi;
```

Being a local, it is defined from its own definition onward: a reference above it, and mutual recursion between two of them, are both reported. Write one of the pair as a `let mut` literal and assign it afterwards where that is what is wanted. A file's bare top-level statements are not a body, so a named function written among those is a namespace-scope function and its argument types are required.

*More detail on this section: [language details](docs/details.md#functions).*

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

A class can extend at most one superclass and implement any number of traits. `self` refers to the current instance. An instance is created with a constructor expression — the type name applied like a function — which selects the matching `init` overload (`PERSON("alice", 30)`). A class with no declared superclass extends `object`. `==` on a class is always reference identity and stays that way; to give a type structural equality, define `=~`, or ask for one with `@equality()`. See [equality](#equality).

A class without the pragma is unaffected: it has no `=~` at all, and comparing two of its values by `==` asks about identity as it always did. Structs and unions need no pragma, and are given equality wherever they declare none — a struct is a value, so two structs holding equal members already are the same value, and a union is compared by which variant it holds and what that variant carries.

A member whose type says it always holds a value has to be given one. A constructor that leaves one or more such members unassigned on some path out draws a single `field-definite-assignment` warning on the constructor's own name, naming every member it misses, since the object it produces holds null in a slot that cannot be written null anywhere else. Each missed member also carries a related location pointing at its declaration — on the property, not the hidden backing field, when the member is an auto-property — which a capable editor renders as a jump-to link. A constructor is credited with what it assigns itself, and with what the methods it cannot avoid calling on `self` assign in turn — a call reached on only one branch of an `if`, a call on another object, and a call to a method a subclass could override all credit nothing, because none of them is bound to happen. Members of optional type and of value type are not checked: neither has a null to be caught holding. Suppress via `@suppress("field-definite-assignment")` per file, with `--suppress field-definite-assignment` project-wide, or on the constructor itself.

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

A method written with no body at all — `foo();` or `foo() -> int;` with no `is … si` — is **abstract**: a contract for a subclass to satisfy rather than a method that does nothing. The class that declares one is abstract too, so constructing it is rejected exactly as `abstract` on the header rejects it, and a concrete subclass that does not implement the method is an error naming the method and the class it came from. Property accessors, `init`, and static methods are excluded — a write-only property leaves its synthesised getter body-less, and its accessors read and write the backing field rather than declaring anything.

The rule holds whether or not a trait behind the class supplies a default for the member. A class writing the member again with no body withdraws that default: the class is abstract, its subclasses owe an implementation, and `super` cannot reach the member, since there is nothing in the class chain to reach. A class that wants the default does not mention the member.

`super.foo()` cannot reach an abstract method: a super call names the base implementation directly, and there is none.

*More detail on this section: [language details](docs/details.md#classes).*

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

`==` and `!=` are rejected on every struct operand — a tuple, an imported `System.DateTime`, one of your own — because the single comparison they lower to reads the value's bytes rather than its fields. `=~` is what compares a struct by value.

For a struct that declares no equality of its own, the compiler synthesises `=~` and a matching `get_hash_code`, comparing the members that hold its state: each auto-property and `field`, in turn, through its own type's equality. A property with a body is derived from that state rather than part of it, and a static member belongs to the type, so neither takes part.

```ghul
struct PAIR is
    a: int;
    b: string;

    init(a: int, b: string) is
        self.a = a;
        self.b = b;
    si
si

PAIR(1, "x") =~ PAIR(1, "x")      // true
```

A bare member declaration like `x: double;` is an auto-**property**, not a field, and a struct's property getter hands back a *copy*. That matters when a struct is held in a heap object: mutating it through the property mutates the copy and the write is lost, so the compiler rejects a store through one. Declare a real field with the `field` modifier where a struct member is to be mutated in place:

```ghul
class HOLDER is
    origin: POINT field;     // a real field, mutable in place
si
```

*More detail on this section: [language details](docs/details.md#structs).*

### primary constructors

A class or struct may declare its constructor parameters directly in the header. Each parameter becomes a parameter of the synthesised `init`. A primary parameter without an explicit body declaration gets a **synthesised** same-named body field/property mirroring its declared visibility:

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
- `x: int init` — **no field synthesised**. The parameter is in scope only inside the synthesised `init` and any explicit `init(..)` body; useful when the constructor consumes its argument to compute something else (`init(.., other)` style).

Naming the parameter with a leading underscore (`_x: int`) is the equivalent convention-driven route, and follows the same rules; `_x: int private` is accepted and adds nothing, the name already carrying the visibility.

An explicit body declaration with the same name as a primary parameter (under the same `_foo` / `foo` matching rule) wins over synthesis — the body decl receives the value the synthesised `init` assigns. This is the *capture* form: writing the field shorthand `_x;` (or a property declaration named `_x` / `x` that supplies neither a read nor an assign body) tells the rewriter "match primary parameter `x` to this declaration." A property that does supply an accessor body is a normal member, not a capture. With explicit body decls you also get to choose private renames (`_x;` on a primary parameter `x`) without using the modifier suffix.

```ghul
class POINT(x: int, y: int) is
    _x;
    _y;

    show() => write_line("({_x}, {_y})");
si
```

is also equivalent to the classic-form `POINT` above, with the fields named `_x` and `_y`.

The form also supports:

- **`super(expr, expr);`** as a class-body declaration — forwards the given expressions to the superclass `init`. Each argument can be any expression whose free identifiers are primary-ctor parameters (literals and module/type-level references are also in scope), so `super(null)`, `super(other.x)`, `super(LIST([elem]))`, and `super(Source.LOCATION.reflected, owner, name)` all work. Primary parameters consumed by `super(...)` get no synthesised member (their value is forwarded to the base, no field needed locally).
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

*More detail on this section: [language details](docs/details.md#traits).*

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

Both `isa V(x)` and `if let v: V = x` narrow `x` itself inside the then-arm and inside guard-then-return tails, and on a two-variant union narrow the `else` branch to the other variant — member access on the scrutinee in the else arm resolves against the complement variant. A `case` over a union scrutinee is checked for exhaustiveness: missing variants draw a `non-exhaustive-case` warning on the statement form, and are an error on the expression form, which has to produce a value. A `redundant-case-arm` arm fires when a later arm matches nothing the prior arms didn't already cover, and `dead-case-else` fires when the `else` arm is unreachable because the preceding arms cover the domain. The warnings also fire on `bool` and `bool?` scrutinees, on `T?` of a union, on closed class hierarchies (the in-assembly subclasses are the closed set — plus the root type itself when the root is concrete, since it is then constructible) and on enums. An arm that names a unit variant by value (`when Color.RED then`) covers that variant exactly as `when _: Color.RED then` does, since a unit variant has a single shared instance; and a label in a `case` takes its type from the scrutinee, so a generic union's unit variant needs no type arguments there (`when Option.NONE then` over an `Option[int]`).

A `case` whose scrutinee cannot be covered this way, and which has no `else` arm, fires `case-needs-else`: a warning on the statement form, where it just falls through; a warning on an expression form whose expected type has a default (value type or `T?`); and an error otherwise. A destructurable scrutinee left short of its combinations reports the same way, naming the combinations that are still open.

Unions compare by structural equality through the `=~` operator — two union values are `=~` when they hold the same variant with memberwise-equal fields. Each field compares the way `=~` compares two values of its type anywhere else: through the field type's own `=~` where it defines one, through its `<>` read against zero where it defines only that, element by element for an array or a list, and through the runtime's default equality comparer otherwise — a class that overrides `equals` compares through it, one that neither declares nor has a synthesised operator compares by reference, and a struct or tuple field-by-field. A field of bare type-parameter type compares through the runtime's comparer for that type, which reaches whatever equality the type argument provides.

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

*More detail on this section: [language details](docs/details.md#unions).*

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

Enum values compare with the relational operators as well as for equality (`=~` and `==`), so they order by their underlying integer. `=~` works over an optional enum too, as it does over any other optional. An individual member can be imported by name — `use Some.Namespace.Suit.HEARTS;` — as well as reached through the type.

*More detail on this section: [language details](docs/details.md#enums).*

### partial and impl blocks

Members can be added to an already-declared type from a separate block - even a separate file - as long as the type is declared in the same assembly. The added members are real members of the target: full private access and normal virtual dispatch, indistinguishable from members written in the type's own body.

*More detail on this section: [language details](docs/details.md#partial-and-impl-blocks).*

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

## operators

See <https://ghul.dev/definitions.html#functions>.

An operator is a run of operator characters, scanned as a single token. The ASCII operator characters are `! $ % ^ & * - + = | : @ ~ # \ < > . ? /`, and so is any non-ASCII character Unicode classifies as a symbol, which puts `×`, `÷`, `∪`, `⊕` and `≠` on exactly the same footing as `*` and `+`. An operator can therefore be spelled with the notation it stands for rather than with an ASCII approximation of it.

A function whose name is an operator is used as one. Declared as a member it takes its left operand as `self` and the right as its argument; declared at namespace scope it takes both as arguments, which is how an operator is given to a type you did not write:

```ghul
struct N(v: int) is
    ⊕(other: N) -> N => N(v + other.v);
si

⊗(a: N, b: N) -> N => N(a.v * b.v);
```

An operator is resolved among those taking as many operands as it is written with. A prefix `-` is the operator of one operand, so a member `-` of two operands, which takes the left operand as `self`, never answers it, and inside the type declaring that member a prefix `-` still reaches the unary operator declared as a static member or at namespace scope.

Precedence comes from the operator's first character rather than from anything written on the declaration, so an operator that reads as arithmetic binds as arithmetic. From tightest to loosest:

| level | characters |
|-------|------------|
| multiplication | `*` `/` `%` `×` `÷` `✕` `⊗` `⊘` `⊙` `⋅` `∗` |
| addition | `+` `-` `⊕` `⊖` `±` `∓` |
| bitwise | `&` `\|` `¦` `^` `∩` `∪` `⊻` `⊼` `⊽` |
| shift | `<` or `>` doubled |
| range | `..` `::` |
| thread-first | `\|>` `~>` |
| relational | `=` `!` `~` `<` `>` `≠` `≤` `≥` `≈` `≉` `≡` `≢` `∈` `∉` `∋` `⊂` `⊃` `⊆` `⊇` |
| boolean | `∧` `∨`, and `/\` and `\/` |

The unary `\` is the bitwise complement of an integer, and its result has the operand's own type: `\5` is `-6` for an `int`, `\0` is `-1`, and `\x` for a `ubyte` 5 is `250`. It is the unary counterpart of the binary `&`, `|` and `^`, and `!` is the logical not of a `bool`. The boolean operators `/\` and `\/` are single tokens.

The built-in operators on the scalar types are the exception. They are
instructions rather than methods, so there is no function to take the value of,
and naming one is an error: `cannot take the value of built-in operator '+'`.
An instance member is not a value either, operator or not, since it needs a
receiver. What that rules out is ``int.`+`` and ``string.`=~``; a function literal
says the same thing and is what to write instead.

*More detail on this section: [language details](docs/details.md#operators).*

## equality

ghūl has two equality operators, and they ask different questions.

`==` and `!=` ask whether two values are *the same thing*: identical bits for a scalar, the same object for a reference. They lower to a single machine comparison, and every other property of them follows from that. No type can overload or override `==`, so what it does never depends on which type reaches it. It never recurses into a value's contents, so it never depends on how deeply one nests. It never calls anything, so it never throws — comparing two absent optionals compares two nulls rather than dereferencing them. And it never walks a structure, so it costs the same on a megabyte-long string as on an `int`. `a == b` carries exactly one instruction's worth of meaning, and it can be read without knowing anything about the types involved.

The price of that is a narrow domain. `==` and `!=` accept only:

- primitive scalars — the integer types, `single`, `double`, `decimal`, `bool`, `char`
- enum members
- references — `string`, `object`, any class, any trait, and `null` against one of those
- a bare type parameter, where the instantiation decides which of the above it is

Every other operand is a compile error pointing at `=~`. On a struct — a tuple, an imported `System.DateTime`, one of your own — the single comparison would read the value's bytes rather than its fields, which is silently wrong rather than merely limited: a reference field would compare by identity, and padding would compare at all.

**`==` on a `string` is reference identity, and stays that way.** Two strings with the same characters are `==` only when they are the same object, which for two literals they generally are and for anything computed they generally are not. That surprises people, and it is still the right definition, because it is the only one that keeps the four properties above. Compare characters with `=~`.

How two strings order follows .NET's globalization. On .NET, `<>` and the relational operators compare strings by the current culture, as `String.CompareTo` does, and so do `sort()`, `min` and `max`. The wasm and llvm targets behave as a .NET program configured for invariant globalization, which compares strings by UTF-16 code unit: upper case sorts before lower case and punctuation by its code. A .NET program gets the same order by setting `<InvariantGlobalization>true</InvariantGlobalization>` in its project. `string.compare_ordinal(a, b)` compares by code unit in any program; the sign of its answer agrees on every target, and the magnitude is the target's.

`=~` and `!~` ask whether two values *mean the same*, and that is a question each type answers for itself:

```ghul
"hello" =~ "{"hel"}{"lo"}"      // true - same characters
"hello" == "{"hel"}{"lo"}"      // false - different objects
```

`=~` resolves on:

- primitive scalars, `char`, `bool`, `decimal` and enum members, comparing by value
- `string`, comparing by characters
- any type that declares `=~` as a member — a class, struct or trait of your own, and any imported .NET type implementing `IEquatable[T]`, which is how `System.DateTime` and `System.Version` get one
- any type a global `=~` is declared for: `=~(a: T, b: T) -> bool` at namespace scope gives `T` the operator without reopening the type, which is the way to give one to a type you did not write, or to a tuple
- a union, through the operator synthesised for it — see [unions](#unions)
- a struct whose state is entirely public and that declares no equality of its own, through the one synthesised for it: member by member, each member through its own type's equality — see [structs](#structs)
- a class carrying an `@equality()` pragma, through the one synthesised for it: member by member and then its base's, each member through its own type's equality — see [classes](#classes)
- a tuple, element by element, each element through its own type's equality, however deep it nests
- an array, a `List[T]` or a `LIST[T]`, by count and then element by element, each element through its own type's equality - so `[[1, 2], [3]] =~ [[1, 2], [3]]` holds, and two lists of a type declaring `=~` compare through it. An element of a class that declares neither `=~` nor `<>` compares by reference here, although the same comparison written directly on two such values is an error: a list of them still has a sensible equality, where the two values alone have none to offer
- a type that declares `<>` and no `=~`: an ordering defines equality with it, so `a =~ b` is `a <> b == 0`
- a bare type parameter, through the runtime's comparer for whatever it is instantiated at

Where more than one of those could answer, the nearest declaration wins: a member operator first, then a global one, and the element-wise or comparer-based comparison only where nothing is declared.

It is not defined everywhere. A class that neither declares equality nor asks for one with `@equality()` does not get one — the operator does not resolve, rather than falling back to identity — and neither does `object`. Nor does a struct that holds any non-public state, or that declares `get_hash_code` or an `equals` over `object` without an operator to go with it: either leaves the struct as it was, with no `=~` until one is written for it. Writing `=~` where nothing defines it is a compile error naming the operand types. A `SET` is not compared element by element, since its equality is order-insensitive: `set_equals` answers that. A pipe is not compared at all, since reading one consumes it.

Defining `=~` on a type means defining `get_hash_code` alongside it: the two are a pair, and .NET's collections consult the hash first. [.NET interop](#net-interop) covers the `Ghul.Equatable[T]` contract, the `Equals` bridge, and why the hash cannot be synthesised.

`=~` is also null-safe, in a way `==` has no need to be: two absent values are equal, an absent and a present one are not, and neither case reaches an operator body. See [optional types](#optional-types).

That holds wherever `=~` is defined at all: `a =~ b` resolves over `T?` exactly when it resolves over `T`, and answers the same for two present values. So an optional enum, an optional tuple and an optional `T` compare like any other optional, with no narrowing first — and declaring `=~(a: T, b: T) -> bool` is enough to make `T? =~ T?` work, whether that declaration is a member or a global.

So on scalars and enums the two agree, and everywhere else they either differ or only one of them is defined. `=~` is the one that means what "equal" usually means; `==` is worth reaching for when identity is the actual question, or when the cost of the comparison is.

## optional types

See <https://ghul.dev/language-basics.html#optional-types>.

A type followed by `?` is an *optional* type — a value of `T?` may be present or absent; the same type without the `?` is non-optional. The postfix `?` tests whether an optional holds a value and `!` reads it out, though `!` is rarely needed directly — a plain `if x?` narrows `x` to its non-optional form, and `if let` tests an optional and reads its value into a variable in one step.

```ghul
let name: string? = lookup();

if name? then
    write_line("hello, {name}");   // name is non-optional string here
fi
```

Optionals cover reference and value types alike. There are three lowerings — a plain nullable reference, `Nullable[T]` for a value type, and `MAYBE[T]` for an unconstrained type parameter, so `T?` is spellable even where `T` could be either kind. Which one backs a given `T?` is an implementation detail: all three behave the same way, and a value of any of them is accepted wherever another is expected — assigned, passed, returned — with the conversion made at that boundary. The carrier is the compiler's own rather than a type a program names: a program that writes `Ghul.MAYBE[T]` itself gets the plain struct of that name, which is not an optional and is not assignable to a `T?`. The one place the three are distinct is as a type argument of another type: `LIST[T?]` over an unconstrained `T` is `LIST[MAYBE[T]]` and not `LIST[string?]` for any `T`, and a function type is a generic type too, so a `(int) -> string?` value is not a `(T) -> U?` for any `U`. There is no boundary inside a type argument to convert at, so a call that pins `U` from a *stored* function value of fixed type that way does not resolve; a function whose own return is `U?` over a type parameter has the same carrier and is accepted. A function referred to *by name* is accepted whichever carrier its own signature uses: it has no value yet, so where the two shapes describe the same call and differ only in an optional position's carrier, the reference is wrapped in a literal that presents the slot's own shape, and the coercion happens at that literal's boundary. `bind(unit(8), halve)` resolves for a `halve` returning `int?`, and so does the same reference passed the other way, into a slot whose carrier is the reference one. A shape differing anywhere but the carrier is still rejected. A function literal that leaves its return type to be inferred is not fixed: written into a `(T) -> U?` slot, its return settles as the slot's carrier over whatever the body produces, so `bind(4, n => n + 1)` and `xs |> find_map(x => lookup(x))` both resolve, with a `string?` or a bare `int` from the body converted at the literal's own return. A non-optional `T` is assignable to a `T?` without ceremony; the other direction is a hard rejection. To use a `T?` where a non-optional `T` is expected, the caller must narrow first — `if x?` / `if let` flow-narrow inside the guarded region, `x!` asserts present (throws if absent), and `x ?? _` falls back to a non-optional value. Reading a member, iterating (`for x in xs`), or indexing (`xs[i]`) through an optional receiver the flow analysis has not proven present — an un-narrowed local or member path, a call result — is an error, with the same standing as passing a `T?` where a `T` is required: it is the same fact about the same static type, so there is no slug to suppress and no severity to lower. Narrowing first (`if xs?` / `if let`), `x?.y`, `x.has_value`, and `x!` are the ways through. Applying `!` to a value that was never optional is an error (`cannot unwrap this`) — there is nothing to unwrap. Where flow analysis has already proven a value present — inside an `if x?` / `if let` region — a further `!`, `?`, or `?.` on it draws a redundancy warning (`redundant-unwrap`, `redundant-presence-test`, or `redundant-coalesce`); the fix is to drop the operator. Suppress via `@suppress("<code>")` per declaration or per file, or with `--suppress <code>` project-wide. `--warn-as-error`, `--warn-as-info` and `--warn-as-hint` reclassify a slug's severity the same way. A `?` or `?.` applied to a never-optional *value type* is an error too — a struct can never be null, so the test has nothing to check. On a never-optional *reference* a `?` presence test is redundant by its static type and draws a `presence-test-non-optional` warning, since the type already guarantees presence — though not inside an `assert` condition, where the test is taken as deliberate; a `?.` stays legal, reading as a defensive null test for the case where null can still arrive despite the static type, for example from reflected .NET APIs. Comparing one against `null` is not another spelling of that test: `null` is a value of optional types alone, so `x == null` and `x != null` on a never-optional operand are errors rather than warnings, and the way to write the defensive test is `x?` or `x?.y`. Types that provide `has_value` and `value` properties are treated as optional-shaped: `?` consults those properties on any such type, while `!` does so only on a struct.

An operator declared on a type takes its left operand as `self`, which always holds a value, so no such operator accepts a left operand that may be absent: `a - b` over an un-narrowed `a: T?` does not resolve, exactly as passing that `a` to a non-optional parameter does not. Narrow the operand first, or reach the operator through `a!`. `=~` and `!~` are the exception, and not by declaration: their null checks are written around the call, so an absent left operand is answered rather than dereferenced, whatever the operator itself declares. Any other operator that means to answer for an absent left operand is declared globally with an optional first parameter, where the operand really is an argument rather than a receiver.

The `?.` operator is *coalescing* member access: `a?.b` reads `b` from `a` when `a` is present, otherwise yields the optional null. The result is always optional — a non-optional member type `U` is widened to `U?`, an already-optional `U?` stays `U?`. Receivers may be reference- or value-type optional (`T?` backed by `Nullable[T]`). A flow-narrowed non-optional receiver always takes the present branch and draws a `redundant-coalesce` warning — a plain `.` does the same job. A receiver that was never optional is an error for a value type (`receiver is not optional`); a never-optional reference receiver stays legal as a defensive null test.

```ghul
let p: PERSON? = find(id);
let name = p?.name;              // string?
let length = p?.name?.length;     // int? — chained coalesce
let title = p?.describe();       // string? — method call short-circuits too
```

Method calls compose with `?.` the same way: `a?.foo(args)` calls `foo` on a present receiver — argument expressions included in the short-circuit, so they are not evaluated when `a` is absent — and yields the optional null otherwise. A void method is simply skipped on an absent receiver. Function-typed fields and properties invoked through `?.` (`a?.callback()`) short-circuit the invocation the same way.

The `??` operator is *null-coalescing*: `a ?? b` returns `a` when it is present, otherwise evaluates and returns `b`. The right operand is evaluated only when needed. `??` is right-associative, so `a ?? b ?? c ?? d` parses as `a ?? (b ?? (c ?? d))`; each intermediate result stays optional until the chain is closed by a non-optional fallback. The result type is the LUB of the left's underlying type and the right's type, kept optional iff the right is itself optional — so a chain that ends in a plain `T` returns `T`, and a chain that stays all-optional returns `T?`. `??` works across all three optional lowerings — reference `T?`, value-type `T?` (`Nullable[T]`), and the unconstrained-`T?` carrier `MAYBE[T]` — including mixed-kind operands: the result's optional kind is derived from the LUB of the inner types, and each side coerces to it. A `bool?` plugged with `?? false` reads as absent-means-false in condition position.

`=~` can compare values that may be null, with no narrowing first. The compiler writes the null checks around the call: two absent values are equal, and an absent value and a present one are not. `!~` negates that whole answer, so two absent values are not unequal:

```ghul
let present: THING? = THING(3);
let absent: THING? = null;
let also_absent: THING? = null;

present =~ absent;          // false
absent =~ also_absent;      // true
absent !~ also_absent;      // false
```

*More detail on this section: [narrowing](docs/narrowing.md#optional-types).*

## control flow

See <https://ghul.dev/control-flow.html>. Most control-flow statements delimit one or more blocks, and each block is a scope.

`if` runs `if` ... `then` ... `fi`, with optional `elif` and `else` clauses; an `else` is the last arm, so an `elif` or a second `else` after it is an error. It is also an expression — every branch must then yield a compatible type. Written without an `else`, the expression yields an optional of its branches' type instead: present when a branch runs, absent when control falls through, the same answer a loop expression gives exhaustion. A context expecting the non-optional type still requires the `else`, as does an `if` whose every branch diverges:

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

Assignment narrows as well: when the assigned value's static type is strictly more specific than the declared type, the variable reads at that type from the assignment on. This covers a local variable, a global variable, and a top-level `let`; a field or property of a type is not narrowed by a write to it:

```ghul
let pet: Animal mut = CAT();

pet = DOG();
write_line(pet.bark());   // pet is DOG here
```

*More detail on this section: [narrowing](docs/narrowing.md#type-narrowing).*

### if let

`cast T?(x)` views `x` as a `T`, yielding the absent value rather than throwing when `x` is not a `T` - so the result is one a presence test can ask about. Written without the `?` the cast is checked: a value that is not a `T` raises `Ghul.InvalidCastException` there rather than becoming a null in a slot whose type says it is never absent, and the `cast-may-throw` warning says so at the site. Two targets are unaffected and still yield rather than throwing: a value type, which gives that type's default, and a type parameter, which can stand for either kind and so cannot be checked at the cast - inside a generic, `cast T(x)` can still produce an absent value in a non-optional slot. `if let` folds a cast and a presence test into the `if` itself — a `let` in the condition, with the then-branch running only when the value is present and the variable narrowed and in scope just there. A type on the variable makes it a type test; `elif let` chains them:

```ghul
if let c: CAT = a then
    write_line(c.purr());
elif let d: DOG = a then
    write_line(d.bark());
else
    write_line("some other animal");
fi
```

A value type can be the type tested for. Over an `object`, `if let i: int = o` matches a boxed `int`, and over an `int?` it matches a present value. Over a plain `int` or `long` there is nothing to test, and the ascription is an error.

With no type, `if let` simply tests that the value is present — the natural way to consume an optional, since the variable has the non-optional type within the branch. The `let` can also destructure:

```ghul
if let line = reader.read_line() then
    write_line("read: {line}");
fi

if let (name, _) = lookup(id) then
    write_line("found {name}");
fi
```

A destructure leaf can also be a literal — an integer, float, string, character or boolean literal, `null`, or a qualified enum-member name. The leaf is then an equality test against the source position rather than a declaration; the arm only runs when every literal leaf matches and every named leaf binds. The test compares the way `=~` would, so a string leaf matches by content rather than by identity, and a leaf against an optional source position never matches an absent value. A `null` leaf is a presence test rather than a comparison, and matches absence across all three optional representations. This is the same comparison a `case` `when` label makes:

```ghul
if let (1, name) = pair then
    write_line("first is one: {name}");
fi

if let (Color.RED, label) = entry then
    write_line("red: {label}");
fi
```

A bare name in leaf position declares a variable, so it always matches and never tests. A leading `~` says the opposite — match the source position against the value that name already holds:

```ghul
use Colour.RED;

if let (~RED, label) = entry then
    write_line("red: {label}");
fi

if let (~expected, name) = pair then
    write_line("expected: {name}");
fi
```

The marked value is read where the pattern is, so it need not be a constant — a local variable, a parameter, or a field all work, which is what the dotted spelling cannot express. `~` is accepted on any leaf that is a legal value to match, so it can be written on a literal or a dotted name too, where it changes nothing (`(~1, s)` and `(~Colour.RED, s)` match exactly as `(1, s)` and `(Colour.RED, s)` do). A marked leaf counts towards exhaustiveness exactly as the unmarked spelling would: marked enum members and booleans complete their closed domain, while a value from a domain too large to enumerate leaves the `case` needing an `else`.

Matching leaves — literal, dotted, or marked — are only allowed in refutable contexts (`if let`, `while let` and `case`-when patterns); a plain `let` with one is rejected, because the value test would be silently skipped at runtime. For the same reason `~` is rejected on a formal argument or a lambda parameter, where a leaf can only bind, and on a whole destructure group rather than a leaf.

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

A value that is a sequence and its own iterator as well, as a generator is, is read through the iterator it hands out, so each loop over it starts from its beginning; a struct iterator such as a range is read directly. Every loop supports `break` to exit and `continue` to skip to the next iteration. A loop disposes nothing it iterated: for a sequence holding a resource, see [collections and pipes](#collections-and-pipes). The range operators work in any expression: `..` is inclusive of its start and exclusive of its end (`0..3` is 0, 1, 2), and `::` is inclusive of both (`1::5` is 1 through 5). The from-the-end forms (`..<`, `::<`, `..<<`, `::<<`) are for indexing rather than iteration — see [arrays](#types-and-literals).

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

### loops as expressions

Every loop form is also an expression of optional type `T?`. A `break E` exits the loop producing a value; falling off the end — a false condition, an exhausted iterator — produces the absent value:

```ghul
let found: int? = for x in xs do
    if pred(x) then break x fi;
od;

if let hit: int = found then
    write_line("found {hit}");
fi
```

The loop's type is the least upper bound of every valued break, wrapped in `?`. Exhaustion and `break null` are indistinguishable, and a bare `break` exits without a value — all three yield absence:

```ghul
let name: string? = while remaining do
    let line = read_line();

    if !line? then break null fi;      // same as falling off the end
    if is_interesting(line) then break line fi;
od;
```

When the context already expects an optional — a typed `let`, a call argument, a return — the loop's element type comes from it, and break expressions infer against the unwrapped type like any other expression in that position.

A valued `break` delivers to the innermost enclosing loop *that consumes a value*. Loops that are not expressions are exited through on the way, so one break can carry a value out of several nested loops to the loop whose value it feeds:

```ghul
let hit: (int, int)? =
    for x in rows do
        for y in cols do
            if good(x, y) then break (x, y) fi;
        od;
    od;
```

A valued break with no consuming loop anywhere around it is a compile error, the same as returning a value from a void function.

Labels belong to the statement forms: a loop carrying a `label:` prefix cannot also sit in expression position. For long-range exits out of deeply nested control flow, a parenthesised block with its targeted returns remains available.

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

An expression-list `when` matches its labels by value: `case` compares the scrutinee to each label the way `=~` would (falling back to `<>`), so a `string` scrutinee and a user type that declares `=~` both compare their labels by content rather than by identity. An optional scrutinee compares the same way — `=~` is null-safe, so a `T?` scrutinee matches a non-null label only when it holds a value-equal value, and never throws on an absent one. A `when null` label matches absence — a null reference for a reference-type `T`, an absent `Nullable[T]`/`MAYBE[T]` for a value-type or generic `T` — across all three optional representations.

`case` is also an expression: the last expression of each arm body becomes the arm's value, and the `case` evaluates to whichever arm matched. An expression-position `case` needs either an `else` arm, arms that cover the scrutinee's closed domain (a union's full variant set, both bool branches, every combination of a destructured tuple, etc.), or — over a scrutinee that cannot be covered, with an expected type that has a default value (value type or `T?`) — none of the above, in which case the `case` produces `default(T)` on the no-match path and `case-needs-else` warns:

```ghul
let label = case status
when 200 then "ok"
when 500, 501, 502 then "server error"
else "other"
esac;
```

A `when` arm can also carry a binding pattern instead of an equality list. The patterns mirror those accepted by `if let`:

- `when v: T then` — type-test against `T`; on match, bind `v` to the narrowed value.
- `when (a, b) then` — destructure a tuple scrutinee into bound names. Per-element ascription works (`when (c: CAT, d: DOG) then`); discards are `_`; literal leaves like `when (1, label) then` or `when (Color.RED, label) then` add a value-equality test at that position, and a `~`-marked leaf like `when (~expected, label) then` tests against the value that name holds rather than binding it.
- `when _: T then` — type-test only, no binding.

Pattern arms share `if let`'s contract on refutability — an option-shaped scrutinee binds to the unwrapped value, and a value-type ascription over a plain value-type scrutinee, which has nothing to test, is rejected with one error and ERROR-typed recovery on the bound names:

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

An arm's narrowing works like `if let`'s: an ascribed `when v: T` narrows the scrutinee to `T` inside the arm body, and a guard's own test — a `?` presence test or an `isa` — narrows within the body too. Arm narrowing is local; nothing an arm proves reaches a sibling arm or the code after the `case`.

### block expressions

A parenthesised block `(statement; ...; value)` runs a sequence of statements and evaluates to the value of the last one. Use it in any position that accepts an expression — a `let` initializer, function argument, `=>` body, etc.

```ghul
let x = (let y = 5; y * 2);                 // x = 10
let z = (let a = 3; let b = 4; a + b);      // z = 7
let n = (write_line("setup"); 42);          // n = 42

let box = BOX();
let m = (box.v = 7; box.v * 2);             // assignment statement, then the value
```

A parenthesised group commits to the block reading at the first top-level `;` — or immediately, on a token that can only open a statement (`let`, `try`, `return`, ...) — and stays a tuple, a parenthesised expression, or a lambda's formal parameters otherwise. A compound statement (`if`, `case`, `for`, `while`, `do`) opening the group commits the block reading the same way when what follows cannot continue its expression: `(for x in xs do f(x) od 0)` is a block whose tail is `0`, no `;` needed. An operator-headed tail on the same line is the one exception: any operator can also continue the expression, so the group keeps the expression reading there and the compound statement is the operator's left operand (`(if c then 2 else 5 fi - 1)` is 1 when `c` is true). Only the same line does that — the compound statement ends the line it is written on, so an operator opening the next line begins a new statement like any other, and `(if c then 2 else 5 fi` / `-1)` is a block whose tail is `-1` with no `;` needed. So `(a = f(x), b = g(y))` constructs a named tuple while `(a = f(x); b = g(y); a + b)` runs two assignments and yields the sum; the `,`/`;` is the whole difference, and the elements themselves can be any expression in both. A statement whose expression form already exists keeps it: `(let x = 5 in x * 2)` is the `let ... in` expression, unchanged, while `(let x = 5; x * 2)` is a block with a `let` statement and a tail.

A block is a block for disposal too: a `use` or `let use` in one disposes when the block ends, before the block's value is used (see [variables](#variables)).

A common use is loop-as-expression — fold an iterable into a value with the loop body updating a `mut` accumulator and the tail expression handing back the result:

```ghul
let sum_1_to_5 = (
    let acc mut = 0;
    for i in 1..6 do
        acc = acc + i;
    od;
    acc
);
```

If the last statement does not provide a value (a `let`, `for`, `while`, `assert`, ...), the block is void. Void blocks are accepted in any context that tolerates void — an expression-statement, the `=>` body of a void-returning function. A value-required position (typed `let` initializer, function argument, `=>` body of a value-returning function) requires the last statement to be value-producing, *unless* every reachable path through the body diverges (via `return`, `throw`, or a divergent inner `if`/`case`/`try`) — then the trailing statement is unreachable and the block's value comes from the divergence sites instead.

`return E` inside a block in expression position exits the **block**, not the enclosing function. The block's value is the least-upper-bound of every `return E` inside it and the tail expression (if any), so an early return can short-circuit out of the block with a value while a different path falls through to the tail. A `null` among those contributions joins as optionality rather than as a type of its own: the other contributors' LUB widens to its optional carrier (`(let s = f(); return s; null)` over a `string` return is `string?`), an all-null block settles at the type the surrounding context expects when there is one, and draws an error (`all val-block contributions are null`) when there is not. Nesting follows the innermost rule — a `return` inside an inner block exits only that inner block, leaving the outer block's walk to continue.

A block is fine as the *entire* body of an expression-bodied function/method/lambda (the `=> body`). The innermost-block rule still applies — `return` inside targets the block — but the block's value flows back out as the function's expression-body value, so observable behaviour matches `is ... si`. `try` / `catch` / `finally` composes the same way as in any function body, including `return` from inside a `try` (the finally fires before the value is delivered), and a body whose every reachable path returns needs no separate value-providing tail:

```ghul
sign_label(n: int) -> string => (
    if n < 0 then
        return "neg";
    fi;
    if n == 0 then
        return "zero";
    fi;
    "pos"
);

divide_or_default(n: int, d: int) -> int => (
    try
        return n / d;
    catch e: Ghul.DivideByZeroException
        return 0;
    finally
        log("done");
    yrt
);
```

Bare `return;` (no value) is accepted in a void block — same rule as `return;` in a void function — and acts as an early exit. In a value-required block it is an error.

`val ... lav` is the historical spelling of the same construct — `val statement; ...; value lav` and `(statement; ...; value)` are interchangeable everywhere — and is headed for removal; write the parenthesised form.

### exceptions

`throw` raises an exception, which must derive from `Ghul.Exception`. Exception handling runs `try` ... `yrt`, with `catch` clauses and an optional `finally`. A `catch` names an exception variable and a type, and handles that type or any subtype; `finally` always runs, including before a `return` leaves the `try`:

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
not_done() -> int => throw Ghul.Exception("not implemented");
```

The body always diverges, so it satisfies any declared return type — explicit, generic, or void — and an inferred return type settles as void.

### assert and return

`assert` checks a condition and throws if it fails. The `else` clause is optional: without one, the thrown message is built from the source location and the condition text.

```ghul
assert index >= 0;
assert index < array.count else "index out of range";
```

A string after `else` is prefixed with the source location and wrapped in a `Ghul.AssertFailedException`; a `Ghul.Exception` value is thrown as it stands. Anything else is a compile error.

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

The source reads top-to-bottom even though execution suspends at each `await`. `await e;` on its own is the value-less form — it waits for the task to complete and discards any result. A function declared `-> Tasks.TASK[T]` may `return` a bare `T`; the compiler delivers the value to the completed task, wrapping it as `Tasks.TASK.from_result(...)` where the body lowers without a suspension. It may also `return` a task, or anything else awaitable, whose result is a `T`. Where the body does not await, that task is what the caller receives. Where it does, the caller already holds the function's own task and a returned one can only complete it, so the return is taken as the task's awaited result - `return t` and `return await t` are the same program there. A void body accepts a task that awaits to nothing the same way.

*More detail on this section: [asynchronous code](docs/async.md#asynchronous-code).*

### generators

A function that returns `T{}` — an `Iterable[T]` — and contains `yield` is a *generator*: each `yield` hands the next element to the consumer and suspends, resuming where it left off when another element is asked for. The elements are produced lazily, so a generator can be unbounded.

```ghul
counting(limit: int) -> int{} is
    let i mut = 0;
    while i < limit do
        yield i;
        i = i + 1;
    od
si

for n in counting(4) do
    write_line("{n}");
od

let evens = counting(6) |> filter(x => x % 2 == 0);
```

The pipe combinators chain onto the result with `|>`. Each read of it starts the body from the beginning, with the arguments the generator was called with, and two reads in progress at once are independent: the first read from the thread that called the generator runs it in place, and any other read runs a fresh copy.

`yield in E` yields every element of `E` in turn, where `E` is anything a `for` loop can iterate — a pipe, an array, a list, an iterator. The elements are pulled one at a time as the consumer asks for them, exactly as writing the loop out by hand would, which is what makes it the natural shape for a recursive generator:

```ghul
preorder[T](tree: Tree[T]) -> T{} is
    if let (value, left, right): Tree.NODE = tree then
        yield value;
        yield in preorder(left);
        yield in preorder(right);
    fi
si
```

`E`'s element type has to be assignable to the generator's, and a value that cannot be iterated is rejected the same way a `for` over it would be.

A bare `return` ends the stream early, exactly as falling off the end of the body does. It carries no value: the declared `Pipe[T]` describes the stream the generator produces, not something a `return` inside it hands back.

A function literal whose body contains `yield` is a generator too. It captures the variables around it as any literal does, so a `let` is read as it stood when the literal was constructed and a `let mut` is shared, and each read of what it returns runs the body again, reading them again. Its element type comes from its declared return type, or from the slot it is written into when that expects a `Pipe[T]`, `Iterable[T]` or `Iterator[T]`, or otherwise from its first `yield`; one that no `yield` settles is an error. A nested named function that yields is a generator literal as well, and reaches itself by name for `yield in`:

```ghul
let evens = (limit: int) is
    let n mut = 0

    while n < limit do
        yield n
        n = n + 2
    od
si

walk(t: Tree) -> Pipe[int] is
    if let (left, value, right): Tree.NODE = t then
        yield in walk(left)
        yield value
        yield in walk(right)
    fi
si
```

A generator's return type has to be `T{}`, `Iterator[T]` or `Ghul.Pipes.Pipe[T]` — `yield` in a function declared otherwise is an error. One returning an `Iterator[T]` is read once: the iterator it returns is the one read. A function cannot be both a generator and asynchronous. And as with `await`, `yield` is not yet supported inside a `catch` or `finally` handler.

## collections and pipes

See <https://ghul.dev/functional-programming.html>.

`Collections.Iterable[T]`, written `T{}`, is any sequence (the .NET `IEnumerable<T>`). `Collections.List[T]` is the read-only list trait (the .NET `IReadOnlyList<T>`); `Collections.LIST[T]` is the mutable list. `MAP`/`Map` pair the same way for dictionaries, and `SET` is the mutable hash set, with `Set` (the .NET `IReadOnlySet<T>`) as its read-only trait and `MutableSet` (`ISet<T>`) as its mutable one. `MutableList`, `MutableMap`, `Bag`, `MutableBag` and `STACK` round out the mapping. There is no map literal syntax. A map with fixed contents is written as a list literal of key and value pairs, collected with `collect_map()`, which throws if a key is given twice:

```ghul
let scores = [("alice", 1), ("bob", 2)] |> collect_map();
let total = scores["alice"];
```

A map computed from a sequence takes a key and a value function instead, `words |> collect_map(w => w, w => w.length)`, and one that starts empty and is filled later is constructed with no arguments, `MAP()`, its types taken from how it is used.

A sequence is closed off into a collection by constructing the collection from it: `ARRAY(p)`, `LIST(p)` and `SET(p)` take any sequence, and `MAP(p)` a sequence of key and value pairs, throwing on a repeated key as `collect_map` does. The element types come from the sequence, so a constructor can end a `|>` chain, and `_(p)` constructs whichever of them the context expects:

```ghul
let names = people |> map(p => p.name) |> ARRAY();
let by_name = MAP(people |> map(p => (p.name, p)));
let seen: SET[string] = _(names);
```

A sequence closes off into text the same way. `string(p)` renders each element as `join` does and puts nothing between them, and `string(p, separator)` puts `separator` between each pair, so `word |> reverse() |> string()` is the word reversed, `[1, 2, 3] |> string()` is `123`, and `names |> string(", ")` is the names joined with commas. A sequence's own text, with its brackets, is still what `$` and interpolation give.

The sequence combinators are global functions in `Ghul.Pipes`, each taking the sequence as its first argument, so the thread-first operator `|>` chains them. ghūl provides the usual set, in the manner of LINQ, and none of them mutate the source. They split into lazy stages that return a new sequence — `map`, `filter`, `flat_map`, `skip`, `take`, `cat`, `index`, `zip`, `sort` — and terminals that consume it and produce a value: `reduce`, `sum`, `product`, `collect` / `collect_mutable` / `collect_set` / `collect_map` / `collect_mutable_map`, `count`, `find`, `find_map`, `first`, `only`, `any`, `all`, `each`, `join`, `append_to`. `collect` produces an array, and `collect_mutable` a `LIST` that can be changed. The collecting ones are the constructors above written as functions, and close a sequence off the same way: `collect` and `ARRAY(p)`, `collect_mutable` and `LIST(p)`, `collect_set` and `SET(p)`, `collect_mutable_map` and `MAP(p)`, `join` and `string(p, separator)`. `collect_map` is the exception: it gives back the read-only `Map`.

```ghul
let numbers = [1, 2, 3, 4, 5];
let evens = numbers |> filter(x => x % 2 == 0);
let doubled = numbers |> map(x => x * 2);
let total = numbers |> sum();                       // 15
let folded = numbers |> reduce(1, (acc, x) => acc * x);
let odd = numbers |> count(x => x % 2 == 1);        // 3, the elements the predicate accepts
```

`sum` and `product` total a sequence of any of the numeric types, taking the
element type from the sequence, so neither needs a seed. Addition and
multiplication each have an identity, so the total of an empty sequence is `0`
or `1` rather than an absent value, which is where the two differ from `min` and
`max`: those answer with a `MAYBE[T]`, since there is no least element of
nothing.

Every read of a pipe starts from the beginning, and two reads in progress at once are independent. That holds however it is read — through `for`, a combinator, a terminal or interpolation — so `for x in p` twice sees every element twice, a read that stops part way leaves nothing behind for the next, and `p |> count()` followed by `p |> only()` walks the whole sequence both times. `p |> take(2)` yields the first two elements every time it is read, and `skip` is how to page. The combinators return `T{}`, and each read of what they return reads its source afresh in turn. Neither a terminal nor a `for` loop disposes the iterator it reads, whether or not it reads to the end (below). A generator's `dispose()` releases nothing - it does not run the body's `finally` clauses or dispose an iterator the body is walking with `yield in`. `memo` reads its source once, and every read of it replays what it cached, asking the source for more only past the end of the cache.

A `for` loop does not dispose what it iterated, so a sequence that holds a resource is disposed by taking its iterator with `use`. That covers the few that hold one: file and directory enumeration, a database reader, a PLINQ query, and a .NET iterator written with a `using`. It matters where the loop can be left early, since the iterator is then still open.

```ghul
for line in use IO.File.read_lines(path).iterator do
    if line.starts_with(wanted) then
        return line
    fi
od
```

An iterator can also be read one element at a time with `next`, which advances it and returns the element it reaches, or absent at its end. An element that is itself absent comes back present, so only the end reads as absent, which makes `next` the condition of a `while let` loop: `while let cat: CAT = animals |> next() do ... od` runs until the iterator ends or yields something that is not a `CAT`.

A pipe can also be started from nothing. `repeat(value)` yields `value` without end and `repeat(value, count)` yields it `count` times; `from(start)` counts upwards from `start` without end, and `from(start, step)` counts in steps of `step`. Collected, a bounded `repeat` is how a list of a given size is made:

```ghul
let seen = repeat(false, 100) |> collect_mutable();      // LIST[bool], a hundred of them
let squares = from(1) |> map(n => n * n) |> take(5);  // 1, 4, 9, 16, 25
```

Lazy and infinite sequences are built with `Ghul.Pipes.stream(initial, advance)`, where `advance` steps from the current state to the next element and state. Nothing forces `advance` to be free of side effects, but it is called lazily and on demand, so it is much easier to reason about when it is. The `||` infix is the step expression — `value || next_state`. A `stream(...)` is an ordinary `Pipe[T]`, so the pipe combinators chain onto it with `|>`. See <https://ghul.dev/functional-programming.html#lazy-sequences>.

The thread-first operator `|>` calls a function with the left value threaded in as its first argument: `x |> f(a)` is `f(x, a)`, and `x |> f()` is `f(x)`. The right-hand side is resolved exactly as an ordinary call, so it can be a free function, a method on an explicit receiver (`x |> box.combine(a)` is `box.combine(x, a)`), or a generic whose type argument is inferred from the left value. Chains associate left to right, so `x |> f(a) |> g(b)` is `g(f(x, a), b)`. It is a plain call, and its right-hand side must be a function call or the name of a function spelled as an operator:

```ghul
double(x: int) -> int => x * 2;
add(x: int, y: int) -> int => x + y;

let a = 5 |> double();           // double(5) is 10
let b = 5 |> add(3);             // add(5, 3) is 8
let c = 5 |> double() |> add(1); // add(double(5), 1) is 11
```

`|>` and `~>` are a precedence level of their own, below range and above relational (see [operators](#operators)), so the subject is everything to the left that binds tighter: `1 + 2 |> double()` is `double(1 + 2)`, and `0..n |> map(f)` maps the whole range. A comparison or a boolean operator stays outside the chain, so `xs |> count() > 3` compares the count and `ready /\ xs |> any(p)` tests `ready` first.

A prefix operator applies to its operand before the chain does, so `!xs |> any(p)` negates `xs` rather than the answer, and `await t |> f()` is `f(await t)`. `use` binds the same way: `use open(p) |> first()` disposes what `open(p)` returns, while `use open(p).iterator` disposes the iterator, since a member access binds tighter than any prefix operator. Parenthesise the chain for the other reading: `!(xs |> any(p))`.

The subject goes into the last call written on the right-hand side, so `x |> box.combine(a)` is `box.combine(x, a)` and `x |> BOX(1).combine(a)` is `BOX(1).combine(x, a)`. Member access, indexing, `!` and `?` written after that call apply to its result, as they would after any call: `xs |> collect_mutable()[0]` is the first element and `xs |> collect_mutable().count` the count. An operator written after the call applies to the result of the whole chain, so `xs |> count() % 2` is `count(xs) % 2`.

A function named with an operator is the one right-hand side that can be written without an argument list, since there is nothing else the bare name could mean. The threaded value is then the only argument, and an argument list is still accepted alongside it:

```ghul
$(o: object?) -> string => "<{o}>";

let d = 5 |> $;                  // $(5)
let e = 5 |> $();                // the same call, written out
```

The operator and the `|>` have to be separated by a space. A run of operator characters scans as a single token, so `5 |>$` is one operator named `|>$` rather than two.

The propagating thread-first operator `~>` is `|>` combined with absence propagation, the way `?.` is member access combined with it. The left value has to be optional; an absent one skips the call — argument expressions included, as `?.` skips them — and yields the absent value, while a present one is threaded in unwrapped, exactly as `|>` threads a value. The result is always optional: a callee returning a non-optional `U` is widened to `U?` as `?.` widens a member's type, and a void callee is simply skipped:

```ghul
parse_port(s: string) -> int?;
clamp_port(n: int) -> int?;
label(n: int) -> string;

let port = text |> trim() |> parse_port() ~> clamp_port() ~> label() ?? "closed";
```

The two operators chain together — a `|>` stage runs unconditionally, a `~>` stage propagates — and `~>` works over every optional kind, including an unconstrained `T?` in a generic. The diagnostics are `?.`'s: a `~>` whose subject was never optional is an error on a value type (`receiver is not optional`) and stays legal as a defensive null test on a reference, and where flow analysis has proven the subject present the operator draws a `redundant-coalesce` warning. Inside a generic the callee sees the unwrapped `T` and its result widens back to the optional of whatever it returns.

A `|>` or `~>` at the end of a line carries the chain onto the next one, which is how a long chain is wrapped. Only a name continues it that way, so a line beginning with anything else leaves the operator without a right side and is reported as one — the next statement is never read as the call.

*More detail on this section: [language details](docs/details.md#collections-and-pipes).*

### list comprehensions

A list comprehension builds an array from one or more sources, in square brackets: the element first, then one or more `for` clauses, each optionally followed by `if` clauses:

```ghul
let squares = [x * x for x in 1::5]                  // [1, 4, 9, 16, 25]
let pairs = [(a, b) for a in 1::3 for b in a::3 if a != b]
let lengths = [name.length for name in names if name?]
```

A `for` clause reads a source the way a `for` loop does, so anything a loop can iterate works, and its variable can destructure (`for (key, value) in map`). Each clause sees the variables of the clauses before it, and the element sees them all. An `if` clause keeps only the elements for which its condition holds, and narrows what it tests, so `name.length` above reads `name` as a `string`. Clauses need no separator, so a long comprehension can be written across several lines.

The result is an array of the element's type, or of the type the context expects: `let objects: object[] = [x for x in ints]`. The `: T[]` annotation a list literal takes works here too. The closing bracket ends the comprehension, so it composes with pipes on either side: `[x for x in xs |> filter(odd)] |> sum()`. A comprehension builds its whole array before anything reads it, so it needs a source that ends: `[n * n for n in from(1)]` never finishes, and draws an `unbounded-comprehension-source` warning. An unbounded or lazily read sequence takes the lazy form below.

The same clauses written in braces make a lazy comprehension, a `Pipe[T]` of the element's type rather than an array:

```ghul
let primes = {n for n in from(2) if is_prime(n)}

primes |> take(10)                                   // the first ten primes
```

A lazy comprehension produces its elements one at a time as the pipe is read, so its source can be one that never ends, and nothing is computed for elements that are never read. It is a generator literal (see [generators](#generators)), so it captures what it reads as any function literal does, and reading it again re-runs its clauses. It composes with `|>` in the same way the array form does. Inside an interpolated string, `{{` is an escaped brace, so an interpolation that starts with a lazy comprehension needs a space: `"{ {x * 2 for x in xs} }"`.

A comprehension's loops belong to it. A `break` or `continue` inside one cannot leave it, and it cannot contain a `yield`, an `await` or a `try`. A function literal written inside it is a body of its own and is not restricted.

## displaying values

The runtime formats any value as text in two ways. `$(value)` gives the text a program shows its user, and is what string interpolation uses for a value its type gives no text of its own (see [types and literals](#types-and-literals)). `inspect(value)` gives the detailed form a REPL or a debugging session wants: the same structure, with strings and characters quoted wherever they appear inside a value. Both take anything, including an absent value, which reads `null`. `$` needs no `use`; `inspect` is in `Ghul`.

```ghul
use Ghul.inspect

struct POINT(x: int public, y: int public)

$(["one", "two"])                 // [one, two]
inspect(["one", "two"])           // ["one", "two"]
inspect("top")                    // top
$(POINT(3, 4))                    // POINT(x = 3, y = 4)
inspect((1, "one", 'c', true))    // (1, "one", 'c', true)
```

A string or character is quoted only inside a value, and only by `inspect`: at the top it is the whole answer, and reads as itself. `$` and `inspect` write a value by these rules, in order:

- `null` for an absent value, and `true` or `false` for a `bool`
- a type that implements `Ghul.Displayable` writes itself, as below
- a tuple as its parts in parentheses, and a map entry as `(key, value)`
- a type that declares its own `to_string` reads as that `to_string`, even when it is also a sequence. The runtime's own pipes, and generators, are the exception: their `to_string` writes their elements, and they are written as sequences
- a sequence, such as an array, a list or a pipe, as its elements in brackets
- a class, struct or union variant ghūl compiled, with no `to_string` of its own, as its type and members: `POINT(x = 3, y = 4)`, `Shape.DOT(size = 2)`
- a value of a type from another language, with no `to_string` of its own, as its .NET type name. Its members are not read, since a property getter can do anything - a task's result waits for the task

A sequence stops after 100 elements with `, ...]`, so an unbounded pipe is written too; stopping there leaves nothing behind for the next read of the value. A value that contains itself reads `<cycle>` where it recurs, and the same value in two places is written in full both times.

*More detail on this section: [language details](docs/details.md#displaying-values).*

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

A value of an unbounded generic argument type is largely opaque — it can be stored, passed, returned, compared with `=~`, and have the methods of `object` called on it, but little else. Giving the parameter a **bound** — `[T: Bound]` — makes the value behave as its bound, so the bound's members are reachable:

```ghul
trait Named is name: string; si

greet[T: Named](x: T) => write_line("hello {x.name}");
```

A parameter can carry several bounds, joined with `/\` — `[T: Named /\ Sized]`. The value then behaves as every one of them: a member of any bound is reachable, and the actual type argument has to satisfy each bound. The comma spelling declares separate type parameters and is not a way to write two bounds.

A bound can also be a **kind**: `class` for a reference type, `struct` for a value type, `optional` for one that can be absent, and `init` for a type exposing an accessible parameterless constructor. Kinds combine with each other and with a type bound, space-separated, and take no parentheses:

```ghul
make[T: init]() -> T;
find[T: class init](key: string) -> T;
build[T: Named class init](name: string) -> T;
build[T: Named /\ Sized class init](name: string) -> T;   // two bounds plus kinds
```

The CLR kind constraints on an imported generic (`where T : class`, `struct`, `new()`) are enforced too, at the point a type argument is resolved. Type arguments can be given explicitly (`print_something[int](1234)`) but are usually inferred — from the call arguments of a function or method, from the constructor arguments of a generic class, struct, or variant, from the enclosing context (return type, let-init type, assignment LHS, or the argument slot the call itself fills) when the arguments alone don't pin every slot, from how an untyped immutable local initialized with the call is used later in the body, and — for a generic function referred to as a value — from the function type of the slot it goes into:

```ghul
print_something(1234);                       // T inferred as int
let b = BOX("hello");                        // BOX[string]
let r: RESULT[int, string] = RESULT.OK(42);  // OK's arg pins T = int;
                                             // the LHS pins S = string
takes_int(zero_of(1));                       // zero_of[T](n: int) -> T:
                                             // the slot pins T = int
```

When neither the arguments nor any later use pins a type argument, the construction or call is an error (`cannot infer type here`, or `cannot infer the type of` the local it initializes) — give the type argument explicitly (`BOX[int]()`).

*More detail on this section: [generics](docs/generics.md#generics).*

## type inference

See <https://ghul.dev/type-inference.html>.

ghūl infers types pervasively, but inference is **function-local**: a namespace-scope function's signature — its parameter and return types — is always written out, and inference works only within the body. Within a body, types are inferred for local variables, loop variables, destructured variables, the parameters and return types of function literals and of nested named functions, and generic type arguments on calls.

Inference also works from later use: a variable with no immediate clue takes its type from how it is used further down the same body — including from operations the body performs on it, and from its own recursive calls if it is a function. The compiler narrows local variables, fields and store-free properties (see Type narrowing above for how long each kind of fact lasts), and a `let` variable's inferred type does not escape the function it is declared in.

## .NET interop

See <https://ghul.dev/dotnet-integration.html>.

ghūl compiles to .NET IL and can consume most types in any .NET assembly. .NET names are mapped to ghūl conventions: method, property, and field names become `snake_case`; enum names and members become `MACRO_CASE`; class, struct, and trait names are left as they are, with .NET's generic arity suffix removed — `Queue<T>` is `Collections.Queue[T]`. The namespace `System.Collections.Generic` maps to `Collections` and `System.IO` to `IO`, and some common types are remapped — `System.Console` is `IO.Std`, `IReadOnlyList<T>` is `Collections.List[T]`, `IReadOnlySet<T>` is `Collections.Set[T]`, `IEnumerable<T>` is `Collections.Iterable[T]`, `IComparable<T>`/`IEquatable<T>` are `Ghul.Comparable[T]`/`Ghul.Equatable[T]`, and `IComparer<T>`/`IEqualityComparer<T>` are `Collections.Comparer[T]`/`Collections.EqualityComparer[T]`, which moves the .NET classes `Comparer<T>`/`EqualityComparer<T>` to `Collections.ComparerBase[T]`/`Collections.EqualityComparerBase[T]`. The dotnet-integration page has the full mapping table.

The core types have ghūl names in ghūl namespaces. `System.Exception` is `Ghul.Exception`, and so are the common exceptions: `Ghul.InvalidOperationException`, `Ghul.NotImplementedException`, `Ghul.ArgumentException` and the rest of those in `System`. `System.Text.StringBuilder` is `Text.STRING_BUILDER`, `System.Math` is `Ghul.Math`, `System.Random` is `Ghul.RANDOM`, `System.StringSplitOptions` and `System.StringComparison` are `Ghul.StringSplitOptions` and `Ghul.StringComparison`, `System.Lazy<T>` is `Ghul.LAZY[T]`, `System.FlagsAttribute` is `Ghul.FlagsAttribute`, and `KeyValuePair<K, V>` is `Collections.KEY_VALUE_PAIR[K, V]`. `IComparer<T>` and `IEqualityComparer<T>` are `Collections.Comparer[T]` and `Collections.EqualityComparer[T]`, as above. The old name of each still reaches the same type wherever a type can be named, and a `use` that names one by its old name brings it in under that name. Diagnostics, hover and completion give only the new name.

Those two interfaces are declared in terms of the operators rather than named methods: `Ghul.Equatable[T]` requires `=~` and `Ghul.Comparable[T]` requires `<>`, so a type implements them by defining the operator. Every .NET type implementing them gains the operator in turn, which is why `=~` compares a `System.DateTime` and the relational operators order a `System.Version`.

```ghul
class BOX: Ghul.Comparable[BOX], Ghul.Equatable[BOX] is
    _v: int;

    init(v: int) is _v = v; si

    <>(other: BOX) -> int => _v - other._v;
    =~(other: BOX) -> bool => _v == other._v;
si
```

The parameter is written non-optional: presence is settled where the operator is used, so the body is only handed present values. On a reference type the optional spelling is accepted too, for a body that wants to defend against a null arriving from a caller in another language without the compiler reporting the test as redundant. A value type has no such choice, since its `T?` is a different type rather than the same one annotated.

`<>` answers how its operands are ordered: negative when the left is the lesser, zero when neither is, positive otherwise. The relational operators are written in terms of it — `a < b` is `a <> b` reduced against zero — so defining `<>` is what gives a type all four.

Defining `=~` also settles how .NET itself compares the type, provided `get_hash_code` is defined alongside it. For a type declaring both, the compiler synthesises a matching `Equals(object)`, so the operator is what runs when the runtime reaches for equality — using the value as a dictionary key, or searching for it in a collection. Without it a class compares by reference there and a struct field-by-field, either way ignoring the operator. Writing an `equals(other: object?)` member explicitly replaces the synthesised one.

Both halves are needed because .NET requires values that compare equal to hash equal, and a hash-based collection consults the hash first. A type that defines neither is consistent as it stands, comparing and hashing by identity, so defining only `=~` is reported as `equality-without-hash` and leaves the type alone rather than breaking that pair. The hash is not synthesised: an operator is free to ignore some of the fields it reads, and a memberwise hash would then disagree with it.

A member `=~` or `<>` must be `pure` — declared or provably store-free — a compile error otherwise. Both operators are trusted on an operand whose type isn't known until later — a lambda parameter, for instance — and `=~` is trusted again through the `EqualityComparerBase[T].default` route above. Nothing at either of those call sites can check what the implementation actually does, so an implementation that could store would make that trust unsound rather than merely unproven. Most bodies — field and property comparisons, delegating to another type's `=~`/`<>` — are provably store-free without any annotation; add `pure` when the body itself is more than the analysis can trace (a loop, a call the analysis doesn't otherwise bound). Overriding a pure `=~`/`<>` requires the override to be pure too, the same rule that governs overriding any other [pure function](#type-narrowing).

An identifier that collides with a ghūl keyword is escaped with a backtick — `` `class `` is the identifier `class`.

A static property or field takes `snake_case` however constant-like it reads, since only enum members become `MACRO_CASE` — `CancellationToken.None` is `System.Threading.CancellationToken.none`.

An **indexer** is the one member reached only through its own syntax. .NET does not fix its name — the property carries whatever its declaring language chose, and the type nominates the real one, so `System.String` and `Text.STRING_BUILDER` both call theirs `Chars` — but the name never has to be written: `[` and `]` find it whatever it is.

```ghul
let initial = name[0];
```

The accessors behind it are not members in their own right, so naming one directly is an error rather than another way in.

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

A pragma whose name doesn't match a compiler built-in is taken to name a .NET **attribute**, and emits the attribute on whatever it's written against: a class, trait, struct, union, variant, or enum; a function or method; a field or property; or a single parameter in a function or method's parameter list, including a lambda literal's. The `Foo` short form resolves to `FooAttribute` when no plain `Foo` exists, in a `use` clause as well as in the pragma — so `use System.Obsolete` brings `System.ObsoleteAttribute` into scope, and `use Marker = System.Obsolete` brings it in as `Marker`. Arguments are positional, named (`name = value`), array-valued, or `typeof`:

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

*More detail on this section: [.NET interop in depth](docs/dotnet.md#net-interop).*

## compilation targets

See <https://ghul.dev/webassembly.html>.

The compiler builds for a target chosen with `--target`: `dotnet`, the default, writes a .NET assembly, and `wasm` writes a WebAssembly module using the GC proposal, with a JavaScript loader beside it that runs the module under Node.js 22.19 or later on the 22 line, 24.15 or later on the 24 line, or 25 or later; Node 23 cannot run it. The same source builds for either target, and it means the same thing on both: where the `wasm` target cannot compile something yet, it reports an error rather than compiling it differently.

Both the wasm and llvm targets behave as a .NET program configured for invariant globalization (`System.Globalization.Invariant`): strings compare and sort by code unit, and numbers and dates format the same way whatever the machine. A .NET program that wants the same behaviour sets `<InvariantGlobalization>true</InvariantGlobalization>` in its project.

*More detail on this section: [compilation targets](docs/targets.md#compilation-targets).*

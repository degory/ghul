# ghūl: language details

Read this when you are looking up a specific rule. It continues sections of [GHUL.md](../GHUL.md), the language reference, under the same headings; GHUL.md is loaded with every session and this file is not.

## naming conventions

Within the assembly the rule differs by kind. A **member** — method, field or property — is restricted further, by default to its own declaring class. A **type**, **global function** or **global variable** has no declaring class to be narrower than, so for those the underscore means exactly "private to this assembly" and nothing more.

How far the member restriction reaches is chosen with a compiler flag:

- `--underscore-access private` (the default) — an underscore member is visible only to its declaring class.
- `--underscore-access protected` — widens that to the declaring class and its subclasses within the same assembly.
- `--underscore-access legacy` — the historic behaviour: no compile-time enforcement at all, and underscore methods and types are emitted public, so they escape the assembly.

An out-of-policy reference from elsewhere *inside* the assembly is reported as an error, but the access is allowed through rather than being cut, so the diagnostic never cascades.

An identifier is written in whatever script its author writes in. A letter of any script starts one, and a letter, a digit, a combining mark or a connecting punctuation mark continues one, which is the set C# admits less the format characters: a zero-width joiner or a bidirectional control renders as nothing, so a name carrying one reads as a name it is not, and one inside an identifier is an error naming the character. Only the basic plane is covered, since a character above it is written as a surrogate pair and the scanner reads that as two characters. A symbol is an operator character and a letter is an identifier character, so no character is ever both, and an operator spelled `×` and an identifier spelled `naïve` are each what they look like.

The conventions above are read with Unicode case. A character that has an upper and a lower form is checked whatever script it is in, so `ТИП` is a concrete class and `μέγεθος` a property. A character with neither form says nothing about case, so a name written entirely in a script that has none — Chinese, Japanese, Arabic, Hebrew — is correct as any kind and draws no warning.

## namespaces and `use`

A source file with no namespace declarations has its definitions placed in a namespace the compiler synthesises, private to that file — convenient for small programs and tests. Compiling with `--global-namespace` instead aggregates every such file's definitions into a single unnamed global namespace shared across the project, so a global defined in one file is visible from the others. Once a file declares any namespace, every definition in it must sit inside a namespace.

The top-level statements are collected into a synthesised entry-point function, and a `let` among them declares a global variable: readable by the top-level statements after it, and inside the functions and types the file defines below it. The entry takes the two shapes the runtime can hand an entry point (see [functions](../GHUL.md#functions)): the statements can read the command-line arguments as `args` and the process environment as `env`, and a private `_entry(args: string[])` wrapper is what actually carries them in. Those two names are the entry's own parameters, so a `let` declaring a global variable named `args` or `env` is rejected — use another name. A `let` of either name inside a nested block among the statements is an ordinary local and shadows the parameter as anywhere else. Its type is inferred exactly as a local variable's is. A bare `let` stays unassignable everywhere; a `let ... mut` can be reassigned from later top-level statements and from functions alike, so it is genuinely shared state. A `let` among the top-level statements is a statement, so it is in scope from where it is written and no earlier: reading or assigning one anywhere above its `let` is an error, whether from another top-level statement, from a function literal one of them writes, from inside the `let`'s own initializer, or from the body of a function or type the file defines above it. The statements run in order, so above the `let` the value would not exist yet. Writing the reader below the `let` is what says it is meant to see one. This is a rule about where the name is written rather than a guarantee about when the code runs — a function written below the `let` can still be called from above it — but it is the same rule for every reader, and it says what the `let` was for. State the whole file is meant to see regardless of order is a namespace-scope declaration (`count: int;`), which is a definition rather than a statement and so has no position to be read above. A `let` inside a nested block among the top-level statements stays an ordinary local of that block. It shares the file's namespace with the file's other definitions, so a top-level `let` and a global function, global variable or type of the same name are a redefinition error.

The synthesised entry point is a file-private definition like any other, so more than one file in a project may carry top-level statements — an umbrella project globbing a directory of one-file examples, say. Only one of them can be the program's entry point, and what picks it is the same thing that picks any other: an `@entry` pragma first, then a function the `--entry` name matches (`entry` when the flag is not given), then a file's top-level statements. Naming an entry point with `--entry` takes top-level statements out of the running altogether, since a build that asks for one by name does not want statements from some other file instead.

The guards say what went wrong rather than making the earlier step right: its compiled code still assumes the hierarchy it was compiled against, and what makes it correct again is running that step again against the hierarchy as it now stands.

Every file whose top-level statements are left unselected is told so, as a `top-level-statements-not-run` warning at its first statement — the statements do not run, so a `let` among them never initializes. Suppress it project-wide with `--suppress top-level-statements-not-run`, or take it as a hint with `--warn-as-hint`, in a project where several script files under one build is the intended shape. Where several files carry top-level statements and nothing names an entry point, none is chosen, every one of them warns, and an executable build reports that it has no entry point.

An ordinary pragma wraps the one definition or statement written after it, which gives it nowhere to reach a warning reported at a top-level statement — there is no wrapping definition to attach to. `@@pragma(...)`, doubled at, is a **file-level** pragma: written before everything else in the file, one or more of them cover the whole file rather than one definition. `@@suppress("slug")` reaches every diagnostic in the file, top-level statements included; `@@precedence(...)` sets an operator's precedence for the rest of the file's parse, with no restore at the end the way the per-definition `@precedence` has; `@@IF.<name>()` leaves the whole file out of the build when `<name>` is off, definitions and top-level statements alike, which is how a source shared between targets keeps a file to one of them (`@@IF.dotnet()`, `@@IF.wasm()`, `@@IF.source_core()`). A `@@` pragma anywhere but the very start of the file — after a `use`, a definition, or a top-level statement — is an error:

```ghul
@@suppress("top-level-statements-not-run")

use IO.Std.write_line;

write_line("hello");
```

A file's first two bytes may be a `#!...` line, in the style of a Linux shebang naming an interpreter. The compiler recognises the line only there, as the very first thing in the file, and skips it, so a file carrying one still compiles; it is otherwise invisible to parsing, including to the rule above that a file-level `@@` pragma must be the first thing in the file, so a `@@` pragma is written immediately after the shebang line rather than instead of it.

`use X.*` imports every usable member of `X` at once, where `X` names a namespace, a class, a struct, a union or an enum. On a namespace this is the same import a bare `use X;` already gives, since a namespace's members are reachable unqualified either way. On a class, struct or union it imports every static field, property, method and operator, and — for a union — every variant; instance members and constructors are never imported, since neither means anything without a receiver. On an enum it imports every member. Each name comes into scope exactly as if it had been `use`d on its own, so a name a wildcard import happens to collide with is the ordinary duplicate-use error:

```ghul
use Collections.*;               // every public symbol in the namespace - same as `use Collections;`
use MATH_CONSTANTS.*;            // every static member of a class
use Suit.*;                      // every member of an enum
use Result.*;                    // every variant (and static member) of a union
```

An alias cannot name a wildcard import — `use name = X.*;` is rejected, since a wildcard stands for several imports rather than one value a name could be given.

One namespace cannot be named at all. `Ghul.Internal` holds the attributes that carry language facts, such as whether a class is closed or which variant of a union a type is, from the assembly that was compiled to the one that reads it. They state what the compiler established rather than something a program chooses, so naming one from source reports that the symbol is not found, and none of them is offered in completion. The assembly that declares them sees its own declarations as ordinary symbols.

An alias is a spelling for the type it names, not a type of its own, so the two are interchangeable in both directions: a `(index: int, value: string)` value is an `IndexedString` and an `IndexedString` is accepted wherever the tuple type is. That holds for every kind of target, so nothing that already accepts the underlying type has to learn about the alias. Constructing through an alias constructs what it names, so `Numbers()` builds a `Collections.LIST[int]`. A generic alias is constructed with its type arguments written, `StringMap[int]()`, and with them left off only when it passes its own type parameters straight through to a class, as `use Box[T] = BOX[T]` does, where `Box(42)` infers them as `BOX(42)` would. A tuple has no constructor, so neither does an alias of one.

An alias can take type parameters, which its target uses like any other type parameter:

```ghul
use Pair[A, B] = (first: A, second: B);
use StringMap[V] = Collections.MAP[string, V];

swap[A, B](p: Pair[A, B]) -> Pair[B, A] => (first = p.second, second = p.first);
```

`StringMap` names `MAP` with its first type argument already supplied, which nothing else in the language can express. Aliases can be written in terms of each other (`use IntPair = Pair[int, int];`) in any order, since an alias is resolved wherever it is first named rather than where it is written.

Because an alias is transparent, it cannot be defined in terms of itself — directly or through other aliases — since the type it stands for would have no end. Such a definition is reported as an error; a type that refers to itself is a `class` or a `union`, both of which are types in their own right.

An alias is scoped like any other `use`: it belongs to the namespace block it is written in, and a block elsewhere that wants the same shorthand declares it again. Consumers are unaffected either way, since a signature written with an alias is a signature written in the type it names.

Importing something the set already carries is how a file adds to the set rather than a duplicate, so `use default` and `use Ghul.Pipes` together are accepted. A function of your own named like one the set brings in joins it in one overload group, and each call is resolved between the two. Where yours fits the arguments as well as an imported generic function and each of its parameters is at least as specific, yours is chosen; the imported one is chosen where it fits better, or where your parameter is a catch-all such as `object`. To keep every call on your own function, leave that name out of the imports, by replacing `use default` with the narrower `use` statements the file needs, or give your function a different name. A project replaces the set with its own with `--default-use`, which takes a comma-separated list and can be written more than once; naming any name at all leaves the curated set out entirely, so a project that wants the collections and nothing else asks for exactly that. A project built by MSBuild names them in one property: `<GhulDefaultUses>Collections;IO.Std.write_line</GhulDefaultUses>`.

Compiling with `--implicit-default-use` gives every file that declares no namespace an implicit `use default`, placed after the file's pragmas and before everything else, which is how a one-file script run directly gets `write_line`, the pipes and the collections without asking for them. A file that declares a namespace gets nothing implicit, since its namespace blocks choose their own imports. A `use default` the file writes as well is harmless. A function the file defines merges with one of the same name the set brings in, as it does under an explicit `use default`.

## comments

The block is the run of `///` lines ending on the line directly above the declaration, or, where the declaration has pragmas, directly above its first pragma. A blank line or any other comment or code in between means the block documents nothing. Classes, structs, traits, unions and their variants, enums and their members, functions, methods, properties and global variables take a doc comment; members added in a `partial` or `impl` block take one like any other.

The text is Markdown. Each line loses its `///` and one following space, and is otherwise shown as written, so a `///` line with nothing else on it is a paragraph break. Arguments are described in a bullet list, one `- name: description` line each. Four or more slashes make an ordinary comment, which leaves a row of slashes free to use as a divider.

## statement terminators

`--warn redundant-semicolon` reports a `;` written at the end of a line, for a project moving its terminators out. It is off by default; once enabled it responds to `--warn-as-error` and the other severity flags like any other slug. `--inlay terminator` shows the inferred boundaries as editor inlay hints, a `∘︎` wherever a statement ends without a written `;`: exactly the places `redundant-semicolon` would report one. Also off by default.

## variables

A `mut` variable still cannot change type once it has one. Either form can also take its value from `_`, the default-value expression — `let i = _` takes its type from the local's own annotation or from later use, with `_[T]` to pin it explicitly. A bare `_` in a call-argument position infers the parameter type from the callee, provided the call resolves to a single unambiguous overload; if the parameter has a declared .NET default value, `_` takes that value rather than the type's zero value, so writing it out positionally behaves exactly like omitting the same argument by name. For a `T ref` parameter, `_` discards what the callee writes: the callee is handed the address of a fresh local holding the default of `T`, so `System.Version.try_parse("1.2", _)` tests the text without keeping the result. A `_` argument is never itself used to infer a generic type variable — one pinned only by the `_` slot, or a call left ambiguous between overloads, is still an error (`cannot infer type of default here`). `_[T]` always means the literal zero value of `T`, in every position — it never picks up a callee's declared default.

Applied to an argument list, `_(...)` *constructs* the type the context expects instead of taking its zero value, so a value can be built without naming its type a second time:

```ghul
let xs: LIST[int] = _();
let b: BOX[int] = _(42);
```

The type comes from the same places the bare `_` takes it from: the annotation on a `let`, the left-hand side of an assignment, or the formal type of a call argument. An untyped immutable `let` initialized with `_()` takes it from how the local is used later in the body, as a local initialized with `[]` does: `let result = _()` followed by `return result` builds the declared return type. An optional context is unwrapped first — `let b: BOX? = _(1)` constructs a `BOX`, which then widens to the optional — and with nothing to infer from, it is an error (`cannot infer the type to construct here`). `_[T](...)` is not accepted: with the type written out, `T(...)` already says it.

`use E` evaluates `E` and disposes the value when the innermost enclosing block ends, on every path out of the block, an exception included. The expression's value is `E`'s, so it can be written wherever `E` could: as an initializer, an argument, an operand. The value's type has to be `Ghul.Disposable`, and a value that is absent is skipped. Values are disposed in the reverse of the order their `use` ran:

```ghul
let file = use IO.File.open_read(path)
let reader = use IO.StreamReader(file)

return reader.read_line()
```

What is disposed is the value `use` saw, so reassigning a `mut` local initialized from one does not change it. Inside a body a statement can start with it, `use R()` on its own holding a value for the rest of the block. At file or namespace level a `use` is an import, so a top-level statement that starts with the operator is written in parentheses, `(use E)`. Disposal belongs to the block, not to the expression: `for x in use f().iterator do ... od` disposes the iterator when the block holding the loop ends, not when the loop does, and `return use E` hands back a value that has already been disposed.

`let use x = E` is the older spelling of `let x = use E`. It cannot be combined with `mut`.

`let use ... in` is the expression form. The local is disposed once the statement holding the expression has run, or, in an expression-bodied function, once the body has been evaluated, so it fits where a block does not:

```ghul
first_line(path: string) -> string? =>
    (let use lines = IO.File.read_lines(path).iterator in cursor(lines) |> first())
```

An asynchronous function's expression body that awaits has nowhere to dispose the local, and there the form is rejected.

## types and literals

The type comes from the declaration the expression resolves against rather than from any other operand, so a `cast(v)` in an argument or operand position takes the type of the formal it lands on. That means resolution has to reach exactly one candidate: `cast(v)` is refused where the position supplies no type at all, and where more than one overload or operator would accept it. `cast(a) + cast(b)` is an error rather than a guess, as is a call whose overloads differ only in the parameter the `cast(v)` fills. Hover over the `cast` keyword shows the type it resolved to.

A cast that is called supplies its own: the arguments give the parameter types and the surrounding context gives the return, so the target is the function type the call describes.

```ghul
let handler: object = read_handler();

let result: int = cast(handler)(4);    // handler converts to int -> int
```

A parenthesised target reads two ways, and which is meant depends on what the name in it turns out to be. `cast (T)(v)` converts `v` to `T` where `T` names a type, and casts the value `T` and calls the result where it does not. A target that can only be a type — a tuple, a function type — is never read the second way, since a value of it could not be called.

```ghul
let widened = cast (double)(count);    // a type: count converts to double
let called = cast (handler)(count);    // a value: handler is cast, then called
```

A pipe declares a `to_string` of its own that reads as its elements in brackets, the same text `$` gives it. A type's own `to_string` always wins, so the way to change how a value interpolates is to give its type one.

A run of octal digits after a `\` is the older spelling of a character code (`"\33"` for an escape character). It still works and still means the same thing, but it is deprecated — it is greedy and unbounded, so it also swallows the digits after it — and writing one draws a `deprecated-octal-escape` warning. Write `\u` instead.

## functions

A bare name in call position (`foo(args)`) normally resolves to the nearest enclosing declaration of that name, the same as any other reference. When that declaration is not callable — a local variable, field, or property holding no function — and an enclosing scope has a function or a function-typed value of the same name, the call reaches that one instead, with a `shadowed-non-callable` warning at the call site:

```ghul
tally(xs: int[]) -> int => xs.count;

use_tally(xs: int[]) is
    let tally = tally(xs);   // warns, then calls the function above
    write_line("{tally}");
si
```

A bare name written with type arguments (`foo[int]`, whether or not it is then called) follows the same rule, since a name applied to type arguments can only mean a type or a function.

The fallback only applies when the nearest declaration cannot be called at all — a function whose overloads reject the supplied arguments still reports the ordinary argument-mismatch error rather than reaching for something else. A name that refers to itself from inside its own initializer's function literal (rather than directly, as above) keeps reporting the reference as one to a value that does not exist yet:

```ghul
let f = (x: int) -> int => f(x);   // error: variable is not defined here
```

## classes

An `@equality()` pragma before a class asks the compiler to synthesise its `=~` and matching `get_hash_code`, comparing the members that hold the class's state — each auto-property and `field`, in turn, through its own type's equality. A property with a body is derived from that state rather than part of it, and a static member belongs to the type, so neither takes part. Members that are not public take part like any other: the pragma is the author asking for the comparison, so what the members are visible to says nothing about whether they distinguish two values.

Two values compare equal only when they have the same runtime type, so a base and a subclass are never equal in either direction, and the relation stays symmetric however it is written.

```ghul
@equality()
class Shape abstract is
    area() -> int;
si

@equality()
class CIRCLE: Shape is
    radius: int;

    init(radius: int) is
        self.radius = radius;
    si

    area() -> int => radius * radius * 3;
si
```

The pragma applies to the class it is written on and to no other, so each class in a hierarchy asks for its own. An abstract class with no state of its own can ask too, which is what lets a comparison written against the base type resolve — `a =~ b` over two `Shape` variables dispatches to whichever subclass the values actually are, and each subclass compares what it adds on top of its base's.

A synthesised operator serves only the class it was written for: it admits operands of exactly that runtime type and reads only that class's members. So a subclass of a class that has one must supply its own, either by asking with `@equality()` or by declaring `=~` and `get_hash_code`, and a subclass that does neither is an error. That holds however little the subclass adds: the rule is uniform, so that every class in a hierarchy states its own position rather than its obligation depending on whether it happens to declare a field. A subclass whose base declares equality by hand is unaffected — what the author wrote is the author's to answer for.

The synthesised pair settles how .NET itself compares the value, through the `Equals` bridge, so a class that asks becomes a dictionary key that finds an equal value rather than only the same object. A class relied on to compare by identity in a `MAP` or a `SET` simply does not ask.

Asking for equality on a class that already declares `=~`, `<>`, `get_hash_code` or an `equals` over `object` is an error, since the request contradicts what is written. So is asking on an `open` class: enforcing the rule above needs every subclass in view, and an `open` class can be extended from another assembly.

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

A body-less method that overrides a **class** method with a body is the one case that cannot become an abstract slot, because a caller holding the base type would still reach it. Such a method gets a synthesised body that throws `Ghul.NotImplementedException` naming it, so the call says what the declaration says. It is not a contract, so subclasses owe it nothing. A trait's default is not this case: a class redeclaring one withdraws it, as above, and the redeclaration is a contract like any other.

## structs

Two conditions. Declaring any half of the pair opts the type out of both: `=~`, `<>`, `get_hash_code`, or an `equals` over `object`. The decision reads the type's own members and nothing else, so a global `=~` declared for the struct does not opt it out: the struct is synthesised all the same, and the member operator is what answers where both exist. Equality that differs from the memberwise answer is declared on the type itself, which opts out of synthesis. A hand-written `=~` is the author's own answer, and a hand-written hash beside a synthesised operator could disagree with it, which is the pair the two are held to. And every member holding state must be public: private state is an implementation detail whose part in equality only its author knows, and comparing the public members alone would answer equal for two values a private member distinguishes. A struct with any non-public state is left as it was, with no `=~` at all until one is written for it. `protected` counts as non-public here.

A synthesised `=~` also settles how .NET itself compares the value, through the same `Equals` bridge a declared operator gets, so a struct is a working dictionary key. The hash reads what the comparison reads: a member compared element by element contributes its count, since two equal sequences are different objects, and a member whose comparison is finer than the hash it answers contributes nothing, so that equal values never hash differently. See [equality](../GHUL.md#equality).

A function literal written inside a struct's instance member cannot read `self`
or any of the struct's instance members, and doing so is an error at the read.
A literal becomes a delegate, whose target is an object, and a struct's
instance member holds `self` as a pointer to the value rather than as a
reference to an object, so there is nothing for the literal to bind to. Copy
what the literal needs into a local first, and the literal captures the local
as it captures any other:

```ghul
struct SCALER(factor: int) is
    scale(xs: List[int]) -> Pipe[int] is
        let by = factor

        return xs |> map(x => x * by)
    si
si
```

Static members are unaffected, since they have no `self`, and so is a struct
reached through anything other than `self` - a local, a parameter, a field of
some other object - which is an ordinary value the literal captures.

## traits

Inheriting two *concrete* defaults for the same member from different traits is an error rather than a silent pick, so a diamond has to be resolved by overriding the member in the implementing type.

Like a class, a trait is closed to other assemblies unless it carries the postfix `open` modifier. A closed trait can be implemented, and derived from, only within the assembly it is declared in; an attempt from anywhere else is a compile error. `open` opts in to cross-assembly extension, and is the right choice when a trait exists to be implemented by downstream code:

```ghul
trait Displayable open is
    display(state: DISPLAY_STATE);
si
```

Nothing changes inside the declaring assembly, where a closed trait is implemented and derived from exactly as an open one is. A trait imported from an assembly built before the closure existed is treated as open.

An override or trait implementation can narrow its return type to a subtype of the overridden member's, as `make() -> CIRCLE` narrows `make() -> SHAPE`: it is still the override, so a caller holding the base class or the trait reaches it and a caller holding the narrower type gets the narrower return. Only a reference type narrows this way - a value type in place of a reference is a different representation rather than a narrower one - and a trait member's implementation with any other return type is an error at the member.

A class member with the same name and arguments as one it inherits from another class, but a return type that is neither the same nor narrower, does not override it: it hides it. It takes a slot of its own, a caller holding the subclass reaches the subclass's member, and a caller holding the base reaches the base's, even for an instance of the subclass. That reads like an override and is not one, so it draws a `hides-inherited` warning, suppressible on the member. A task with a result is the case it is for, as .NET's `Task<TResult>` hides `Task`'s awaiter:

```ghul
class TASK is
    get_awaiter() -> TASK_AWAITER => TASK_AWAITER(self)
si

class TASK[T]: TASK is
    @suppress("hides-inherited")
    get_awaiter() -> TASK_AWAITER[T] => TASK_AWAITER[T](self)
si
```

Awaiting a `TASK[int]` gives its `int`. Awaiting the same task through a `TASK` reaches the base's awaiter, which waits for it and drops the result, as it does on .NET. `super.get_awaiter()` reaches the hidden member.

An override or trait implementation must keep the overridden member's optionality contract. It may strengthen it - a non-optional return or property where the base declares optional, an optional parameter where the base declares non-optional - but weakening it in either position is a compile error: returning `T?` where the base promises `T` would hand null to callers that use the base type, and requiring a non-optional parameter where the base accepts `T?` would receive null from them. A property with an assign accessor faces both directions at once, so its type must match the base's optionality exactly. The equality and order operators `=~` and `<>` are the one exception on the parameter side: presence is settled where the operator is used and the body is only handed present values, so an implementation may declare its parameter non-optional even where the overridden member spells it optional.

## unions

Exhaustiveness also reaches through a destructure. A scrutinee that destructures — a tuple, or any type with a `deconstruct` — is covered when the arms cover the *combinations* its elements can take, for as long as every element sits in a closed domain of its own; the same rule applies again to a nested destructure. So four arms cover a `(bool, bool)` with no `else`, and two arms cover it when each leaves one element unmatched. Coverage is over the combinations rather than each element separately, so `when (true, _)` and `when (_, true)` together leave `(false, false)` open. An element drawn from a domain that cannot be enumerated (`int`, `string`, an open class hierarchy) leaves the whole scrutinee open, and so does a field the arms only test rather than bind — `when (0): WHOLE` reaches part of `WHOLE`, not all of it.

A field whose type is declared in ghūl source, could declare `=~` and does not, draws a `synthesized-equality-fallback` warning on the field's declaration: the union's structural equality compares that field with the default equality comparer rather than an operator. Types that cannot declare an operator — imported types, tuples, sets, maps, function types — fall back without a warning; an array or a list does not fall back at all, since it compares element by element. Suppress via `@suppress("synthesized-equality-fallback")` per declaration or per file, or with `--suppress synthesized-equality-fallback` project-wide.

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

`NAMED.name` is satisfied by the property synthesised from the union's `name` primary parameter, and `NAMED.label` is inherited by every variant. A `NAMED` reference accepts any `COLOUR` value, with dispatch going through the union base class. The traits-only restriction is strict: a union may not declare a base class. Every trait member used through this header form must either be defaulted or be a property the union already supplies (typically through a primary parameter), since neither the union body nor its variants can carry method bodies; to give a union method implementations for a trait, use an [`impl` block](../GHUL.md#partial-and-impl-blocks).

A method or property accessor supplied to a union, or to one of its variants, through a [`partial` or `impl`](../GHUL.md#partial-and-impl-blocks) block must be pure: declared `pure`, or provably store-free. One that stores draws an `impure-union-method` warning.

## enums

An enum marked `@Ghul.Flags()` additionally gets the bitwise operators `&`, `|`, `^`, and the unary `\`, for combining and testing flag-shaped values. The attribute is `Ghul.FlagsAttribute`, which is .NET's `System.FlagsAttribute` under its ghūl name, so `@System.Flags()` is accepted too. Each takes and returns the enum's own type — there is no coercion to or from the underlying integer, and combining two different enum types is a compile error, the ordinary overload-resolution failure. An enum without the attribute has none of the four: an ordinal enum's members were never meant to combine, so `Suit.SPADES & Suit.HEARTS` is rejected the same way as any other undefined operator.

```ghul
@Ghul.Flags()
enum Access is
    READ = 1,
    WRITE = 2,
    EXECUTE = 4,
si

let read_write = Access.READ | Access.WRITE;

if read_write & Access.READ == Access.READ then
    write_line("can read");
fi
```

Unlike C#, where `[Flags]` changes nothing about which operators an enum has — `&`/`|`/`^`/`~` there work on any enum, built into the language — `Ghul.Flags` in ghūl gates the four operators as well as its usual effect on `to_string()`: it makes the default rendering of a combined value list its constituent names (`READ, WRITE`) instead of the raw number, exactly as it does in C#. ghūl has no attribute for naming a combined value as a member (`ALL = A | B | C`): an enum member's initializer is restricted to a plain integer literal.

## partial and impl blocks

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

The interface's type parameters are the target's own, written on the target after `for` (`impl Printer for List[T]`). Inside the body `self` has the concrete target type, so a union's variants can be matched on directly. The target then satisfies the interface exactly as a header-declared one would - a `List[T]` passes wherever a `Printer` is expected, dispatching through the type's base. A self-relational interface takes the target as its own argument: `impl Eq[List[T]] for List[T]`. The interface must be a trait, and the target must be a same-assembly type - an imported type cannot be reopened. When the target is a union or a single variant, every method and property accessor the block supplies must be pure: see [unions](../GHUL.md#unions).

The target (and a `partial` block's target) can be a qualified name: a namespaced type (`impl Printer for Some.Namespace.TYPE`) or a specific union variant (`impl Printer for List.NIL`). Implementing an interface on a single variant attaches it to that variant alone - a value statically typed as the variant satisfies the interface, but the union as a whole does not unless it also implements it.

Inside the block, the target's own members, inherited members, and type parameters are in scope first, exactly as inside the target's declaration body. Every other name - the target name after `for`, the interface name, the types in member headers, anything the bodies reference - resolves where the block is written: its enclosing namespace and that namespace's `use` imports. Names that are only in scope at the target's declaration site (its namespace siblings, its own file's imports) are not visible unless they are also reachable from the block's site. Declaration order does not matter: the block can precede its target in the same file or live in a file compiled earlier.

## operators

The thread-first row is the two operators themselves rather than a first character: see [collections and pipes](../GHUL.md#collections-and-pipes). An operator opening with `?` sits looser than all of those, and everything the table does not name sits between shift and bitwise. Associativity is left, except for an operator opening with `?`, which is right so that a chain of them stays open to the one after it.

Where the first character does not say what is meant, a `@precedence` pragma places the operator explicitly. It takes the operator and a level: one of the eight `user-1` to `user-8`, which interleave with the levels above, or one of those levels by name. The pragma written before a definition covers that definition; the file-level `@@precedence` covers the rest of the file.

```ghul
@@precedence("∘", "user-8")

∘(f: (int) -> int, g: (int) -> int) -> (int) -> int => x => f(g(x));
```

An operator is an ordinary function, so its name is a value wherever a function
of its shape is expected. The name is written with the backtick escape, since
an operator is not an identifier:

```ghul
struct N(v: int public);

⊕(a: N, b: N) -> N => N(a.v + b.v);

let totals = values |> reduce(N(0), `⊕);
```

A static member operator is named through its type, and reads the same way:

```ghul
struct V(x: int public) is
    +(a: V, b: V) -> V static pure => V(a.x + b.x)
si

let total = vectors |> reduce(V(0), V.`+);
```

## collections and pipes

A pipe is built over the held iterator with `cursor`, which reads the iterator it is given rather than asking the source for a new one, so an early-exit terminal on it leaves the resource to `use`:

```ghul
return cursor(use IO.File.read_lines(path).iterator) |> skip(wanted - 1) |> first()
```

The `undisposed-source` warning reports a read that can stop before the end of one of these sources with nothing holding it: an early-exit terminal or stage such as `first`, `find`, `any`, `all`, `only` or `take`, or a `for` loop whose body can `break` out of it or `return`. The call to the source has to be the read's source, or be reached from it through other pipe stages. A read to the end lets the source close itself and draws nothing, and so does a stage that reads all of its source before passing anything on, such as `sort` or `reverse`. A sequence held in a local variable, a field or anywhere else first is not followed.

## displaying values

A type chooses how it is displayed by implementing `Ghul.Displayable`, whose one method writes the value through a `Ghul.DISPLAY_STATE`. Write a child value with `state.render(child)` rather than with `$(child)`: the state carries the element limit and the values already being written, which a fresh call to `$` starts without. `state.mode` says whether the text is for `$`, `DisplayMode.CLEAN`, or for `inspect`, `DisplayMode.DETAILED`:

```ghul
use Ghul

class SCORE(points: int): Displayable is
    display(state: DISPLAY_STATE) is
        state.append("[")
        state.render(points)
        state.append(if state.mode == DisplayMode.DETAILED then " points]" else "]" fi)
    si
si

$(SCORE(3))                       // [3]
inspect(SCORE(3))                 // [3 points]
```

A `DISPLAY_STATE` can also be made directly, with a mode and a different element limit, and written into: `DISPLAY_STATE(DisplayMode.CLEAN, 3)` writes `[1, 2, 3, 4, 5]` as `[1, 2, 3, ...]`, read back with `to_string()`.

`Displayable` customises the text `$` and `inspect` produce for a value. `Ghul.Renderable` offers other media for the same value, such as an image, which a host like a notebook can show in place of that text: its `representations()` gives each as a MIME type and its content, best first. The host chooses which MIME types it shows, and the text `$` writes is the fallback. A host showing output in a web page does not insert `text/html` or `image/svg+xml` from a value into its own document.

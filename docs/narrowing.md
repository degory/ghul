# ghūl: narrowing

Read this when you are reasoning about why a value is or is not narrowed, or changing the compiler's flow analysis. It continues sections of [GHUL.md](../GHUL.md), the language reference, under the same headings; GHUL.md is loaded with every session and this file is not.

## optional types

A generic function returning `T?` can be called at a `T` that is itself optional, and its result then has two layers: whether a value came back, and the value, which can itself be absent. `next[T](iter: Iterator[T]) -> T?` called on the iterator of a `string?[]` returns a `string??`. `if let`, `while let` and `!` remove only the outer layer, so the value they give is the `string?`, still to be tested. `??` and a `case` over the result test the outer layer. `?.` tests only the outer layer too, so reading a member through the inner value is an error; write `(x!)?.length` to test both.

A `??` whose left operand holds the runtime's `Result[T, E]` union unwraps the result instead of coalescing: a present OK contributes its payload, and an absent one — an ERROR — is replaced by the right operand. The right operand's type is the answer's exactly, so `Result[T, E] ?? Result[T, F]` gives a `Result[T, F]`, with the OK payload rebuilt at the right's instantiation and the left's error type discarded, and `Result[T, E] ?? T` gives a `T`. The left's error never survives: it is discarded with its payload when the right operand replaces it, and an error the answer ends up holding is the right operand's, there because the fallback failed too — `failed_a() ?? failed_b()` is `failed_b()`'s error value. A chain folds right-associatively to the rightmost fallback's type. The right operand has to fit: itself a Result, or assignable to the OK payload. The operator reads a value as a Result only when the build's runtime declares the union.

```ghul
let port: int = parse(text) ?? 80
let later: Result[int, string] = first() ?? second()
```

```ghul
let name: string? = lookup();
let greeting = "hello, {name ?? "stranger"}";   // string

let primary: string?   = first();
let secondary: string? = second();
let chosen = primary ?? secondary ?? "fallback"; // string
```

An absent value on the left is always answered this way, whatever the operator declares: there is no receiver to call a method on. What the operator's declaration decides is the *right* operand. Declared non-optional, an absent one is answered here too and the body is only ever handed present values. Declared optional — as `Ghul.Equatable[T]`'s example below writes it — the body is handed the absent value and answers for it itself.

A `T?` over a value type or over an unconstrained type parameter compares the same way, with one difference: an absent one of those is always answered by the null checks, never handed to the operator, because a value operand has no absent form to pass.

The same applies to a global `=~`. One declaring non-optional parameters gets the null checks written around it, so its body is only handed present values; one declaring optional parameters is answering for absence itself and is called as written.

Not every type reaches its equality through an operator at all — an enum's is an opcode, and a tuple and a bare type parameter have none (see [equality](../GHUL.md#equality)). Those get the same null checks around whatever compares them, so an optional one behaves exactly like an optional of a type that does declare an operator. The rule is that `a =~ b` over `T?` resolves whenever it resolves over `T`.

## type narrowing

A null right-hand side contributes only the presence fact, a value-type right-hand side does not narrow (a wider slot holds the boxed value, not the bare struct), and a tuple-typed value keeps the declared spelling so named elements stay reachable. When branches assign different types, the views join back to the common ancestor after the `fi`.

Narrowing applies to local variables (including a function's own parameters), to `self` - an `isa`, `if let`, or destructure on `self` narrows it in place, so a method (typically in an [`impl` block](../GHUL.md#partial-and-impl-blocks)) can match its own concrete type or a union's variants without first copying `self` into a local; because `self` is never reassigned its narrow is never dropped by reassignment - to fields, to properties, and to member-access paths built from those pieces. Both the presence and type domains lift: after `if x.y? then`, a repeated `x.y` reads at its non-optional type; after `if isa CAT(x.y) then`, a repeated `x.y` reads at `CAT`, so `x.y.purr()` type-checks. `if let p: CAT = x.y` narrows the same way. The else edge narrows to the complement when the receiver is a closed hierarchy (a two-variant union collapses to the sibling variant; a closed class hierarchy eliminates the tested subclass from the in-set), so `if isa CAT(x.y) then x.y.purr() else x.y.bark() fi` type-checks on both arms when `x.y` is a closed `Animal`. Sibling / class-and-trait narrows on a path compose via intersection: after `if isa Purring(x.y)`, `x.y` exposes both `Animal` members and `Purring` members. Every hop must be a field or a property. The facts differ in how long they last. A local's narrow holds until the local is reassigned; the assignment then re-narrows to the new value's static type when that is strictly more specific, and otherwise leaves the local at its declared type. A global variable re-narrows the same way, but its narrow is a heap fact rather than a local one: a callee can name and write it, so the narrow drops at a call the compiler cannot show left it alone. Direct stores are tracked precisely: a field's fact drops at an assignment to that same field through any receiver - the written receiver may alias the one the fact was proven on - a property's fact drops at any assignment to a field, property or element, because its getter may read anything the assignment changed, and a path fact drops at a store to anything it reads through, or when its root is reassigned.

One kind of local is treated as heap state: a local that a function
literal assigns. Such a local does not live on the stack - the
closure body and the enclosing scope share one cell - so a call can
rewrite it where the enclosing scope cannot see. Its facts form
exactly as any local's do and survive calls the way a field's do: a
call that provably leaves the local alone - a store-free callee, or
one whose solved write set does not name it - keeps them, and one
that invokes the assigning closure, directly or through anything that
can reach it, drops them. The remedy is the usual one: test the value
again, or copy it into a local variable first.

```ghul
let s: string? mut = get();

let clear = () -> void is
    s = null;
si;

if s? then
    write_line("{s.length}");    // fine: nothing ran between test and use

    clear();

    write_line("{s.length}");    // error: the call can change s, so s is string? again
fi
```

A fresh local declared by `if let` is out of every closure's reach,
so its facts survive any call:

```ghul
if let present = s then
    clear();

    write_line("{present.length}");
fi
```

A heap fact lives from the test that establishes it to the first call the compiler cannot show left it alone, or the first store that could change it; at that point the value reads at its declared type again. That question is settled once the whole program has compiled, so the narrowed view a call leaves behind is the one the effect relations justify, and every use after the call is typed against it: passing the value where only the non-optional or narrower type is accepted is the ordinary type error, and reading a member through it is the ordinary error for a dereference through an optional. The fix is to test the value again, or to copy it into a local variable before the call - a local no closure assigns is unreachable to any callee, so its facts survive every call. Re-observing the value re-establishes the fact whatever calls came before: a presence test, an unwrap `!`, a coalescing `?.`, an `isa` test and an `if let` all check the value at run time. So `if _f? /\ mutate() then` enters its branch with `_f` at its declared `string?` when `mutate` cannot be shown to leave `_f` alone: passing `_f` where a `string` is required there is an error, `_f.length` is an error, and `_f!.length` is fine. The editor marks the call that dropped the fact with a `◄` hint naming what it can change.

Whether a call left a fact alone is judged member by member, once the whole program has compiled: a call is harmless to a fact when nothing it can reach - overrides and invoked function values included - writes the member the fact describes (for a presence fact, writes it a possibly-absent value), and harmless to a fact read through a getter when nothing it can reach writes anything that getter reads. A store-free callee is harmless to every fact. A small curated set of imported .NET members sits between store-free and unproven: the collection mutators `LIST.add`, `LIST.insert`, `LIST.remove_at`, `LIST.clear`, `STACK.push`, `STACK.pop`, `STACK.clear` and the `STRING_BUILDER` writers store only their own receiver's internal state and call nothing while doing it, so they are harmless to any fact that does not read through a getter of that state. So `if _name? then _items.add(x); _name.length` type-checks, and the same `_items.add(x)` before a leaning use of a property whose getter reads `_items` draws the report. Trust also follows from shape rather than from enumeration: an imported .NET static whose parameters are all scalars, strings or enums has no receiver and nothing overridable to name, and counts as store-free; an imported instance member the CLR binds statically (non-virtual, final, on a struct, or on a sealed owner) with such parameters can only write its own receiver's interior, so field facts survive it while property facts still die. Generic methods, static-virtual interface slots, and members of a generic owner are excluded, since their bodies can dispatch through a type parameter — `LIST[T].sort()` is generic-owned this way even though it takes no arguments to name one. A global function imported from another ghūl assembly is a CLR static too but is not one of these: its body is arbitrary ghūl source rather than a .NET surface, so it earns this trust only by being declared `pure`, the same as code of your own. A static can still route through mutable ambient state its parameters don't name - `Console.write_line(s)` dispatches through whatever writer `Console.set_out` last installed - and this is accepted rather than guarded against: redirecting a stream that pervasive into something that mutates narrowed state is not a realistic hazard, and declining every string-taking static to cover it would cost the tier its point. The set lives in the compiler and cannot be extended from source; `pure` is the declaration to write for code of your own, and it claims something stronger - that the function stores nothing at all. The getter a fact reads through is held to the same standard: the fact is only presented as a narrowing when the getter's own call, treated as any other crossing over the fact, is discharged. Store-free is sufficient but not necessary - a write-only getter, whose writes are disjoint from everything it reads, is self-stable and backs the fact. When the getter cannot back it, the test presents no narrowing at all: no narrowing inlay at the test site, hover reports the declared type, and the editor leaves a hint at the test naming the getter, since such a getter can answer differently on every read; the fix is `if let`, a local variable, or — when adjacent reads genuinely agree — declaring the property `stable` (below). One getter shape is proven rather than refused: a **monotone memoiser**, whose body writes only one field of the receiver, writes it only values that are always present, returns absent only under a guard that proved that field absent, and returns that field on every other path, cannot change its answer from present to absent - so a presence fact through it survives even the getter's own call, and leaning on the presence is sound. A type fact through the same getter is still declined: a rewrite while the field is absent can change the runtime type a wider-typed member holds.

Where proof falls short, declare it: a postfix `pure` modifier on a function or method (`describe() -> int pure is … si`) trusts it as effectively store-free, so a fact survives a call to it, without the body being provable. The declaration is a contract — every override or trait implementation must itself be pure, declared or proven, and violating that is a compile error, enforced even when the pure base was imported from another assembly. A postfix `pure` on a function type (`filter(p: (T) -> bool pure)`) extends the contract to a slot holding a function: only a store-free value is accepted — a literal whose body performs no possibly-storing call, heap store, or local reassignment, a store-free named function, or a value already of pure function type. The slot can be a parameter, a variable, a field, or a return type, and putting anything else in one — passing it, assigning it, initializing with it, returning it — is reported. The two positions carry different slugs, because they are worth different things. Passing one as an argument draws `impure-function-argument`: the enclosing call is judged on its own callee anyway, so narrowing there does not depend on the warning being heeded, and it is advice. Storing one into any other kind of slot draws `impure-function-value`, and that one does carry weight: the value is in the slot from then on, and invoking a value through a pure function type is trusted to leave every fact alone, so a stale fact can be relied on across a call that really does invalidate it. Heed that warning, or don't declare the slot pure.

A property can make a parallel declaration about its getter with a postfix `stable` modifier (`value: string? stable => …`): two adjacent reads with nothing between them agree on presence and runtime type. It is the escape for a getter the crossing question cannot prove — a general memoiser, a cache — the case where `pure` would be false, because the getter stores. Facts narrowed through a declared-stable property are presented although the body is unprovable, and the getter's own re-read discharges for presence and type alike; other calls cross the fact as usual, judged against what they can write and the getter reads. On a member-access path the declaration covers only the property it is on — a stable hop deeper in the path re-reads to the same object, but the getter may write through that object, so a fact about a further member still owes the hop's call; copy the prefix into a local instead. `stable` is orthogonal to `pure` — a memoiser is impure and stable — and it is a contract in the same sense: every override must itself be stable, declared or proven self-stable by the same crossing question, and violating that is a compile error, enforced even when the stable base was imported from another assembly.

Being store-free is a property of the function rather than of the slot it is going into, so a function value's own type reports it: a literal whose body proved store-free, and a reference to a function that is declared `pure` or proved store-free, both have a pure function type, and it shows wherever that type does.

```ghul
double(x: int) -> int pure => x * 2;

let f = double;                      // (int) -> int pure
let g = (n: int) -> int => n * 2;    // (int) -> int pure — proved store-free
```

A variable whose type is a pure function type is trusted to hold a store-free value wherever it is read, which is why it is the store into one that carries the warning, and why the trust is only worth as much as the values put in. It is a declaration in the same sense `pure` on a function is: neither is verified, and both mislead the compiler if they are not true. Reassigning such a variable is unremarkable as long as the new value is store-free too. Purity declarations and pure function types survive compilation into an assembly and are honoured when it is imported.

The same declaration can be made once for a whole type: a postfix `pure` on a class, struct or trait header (`class PARSER pure is ... si`). Every instance member must then be pure - proven store-free, or declared - and a member that stores draws an error naming it. Declaring the member `pure` is the escape: trusted, not verified, exactly as anywhere else. The exemptions are the writes that have to exist: constructors assign fields by definition; static members keep their own state and can be marked individually; and the sanctioned write paths are assign accessors and the ref-parameter writes of the synthesised `deconstruct` - though a getter that stores through an assign accessor still draws the error, because from the outside it reads as a read, and a hand-written `deconstruct` is an ordinary member with no such allowance. What a pure type does not allow is publishing a write: declaring a property `public` makes its assign accessor publicly reachable, and that is rejected on the class, the struct, and the primary-constructor parameter alike. `pure` on a union is an error, since union members are already held to purity through partial and impl blocks.

A member declared with no body in a pure type carries an implicit `pure` declaration: it is a contract rather than an implementation, so implementors inherit the obligation through the ordinary override rules. A class implementing a pure trait cannot supply a storing method any more than it could override a declared-pure member.

The type-level marker is a discipline for the declaring assembly and its readers rather than a cross-assembly contract of its own: members that are declared or proven pure cross assemblies individually and keep their guarantees there, and the override contract binds implementors in exactly the same way.

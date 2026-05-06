# Type system and inference

Depth notes on how ghūl's type system and type inference are structured today, the conceptual framing the maintainer uses for it, and where the open work is. This expands on the brief summary in `CLAUDE.md`.

## The mental model: bidirectional type checking

The compiler does bidirectional type checking in the standard sense:

- **Inferences** flow up / right-to-left / leaf-to-root: each expression computes its own type from its sub-expressions.
- **Constraints** flow down / left-to-right / root-to-leaf: each expression's parent context can supply a type the expression must conform to.

At any point where a type is uncertain, the intersection of the bottom-up inference and the top-down constraint is the best guess. Where they conflict, we have a type error.

The maintainer sometimes calls the down-flowing concept "implications" and sometimes "constraints" — they are the same thing. The historical reason both terms exist is that the compiler currently has *two parallel implementations* of the down-flowing concept that don't talk to each other, and they grew up under different names. **Issue #1174 ("Consistently apply type implications")** plans to unify them.

### Producers and consumers (per #1174)

Producers of constraints (top-down):
- Local variable definitions with explicit types and initializers — the explicit type flows into the initializer.
- Return statements in functions of non-void return type — the function's declared return type flows into the return expression.
- Expression body of functions of non-void return type — same.
- *Aspirational:* Left side of assignment statements (would require speculatively loading the LHS to determine its type, then pushing into the RHS).
- *Aspirational:* Overload resolution — should produce constraints rather than the current "implications".

Consumers of constraints (top-down):
- `let ... in ...` expressions propagate any incoming constraint into the body expression.
- `if` expressions propagate constraints to both branches and prefer the constraint over inferring a common type.
- List literals use any incoming constraint as their element type, in preference to inferring a common type. (They do *not* currently propagate the constraint into each element expression — arguably they should.)
- *Aspirational:* Function literal arguments without explicit types should be assigned the type implied by the matching overload, derived from the constraint.

The two parallel mechanisms are why some scenarios "work in `let` initialization" but "don't work in argument position", as we discovered with `let xs: List[Base] = [d, d]` (works) vs `m.takes_iterable_of_base([d, d])` (doesn't).

## Type variance

Generic type variance is hard-wired per type-class via `Type.get_argument_type_variance(index: int) -> TYPE_VARIANCE`. There is no source-level syntax for declaring variance; the compiler special-cases a few built-in shapes.

Per `src/semantic/types/`:

| Type             | File              | Variance per parameter                                         |
| ---------------- | ----------------- | -------------------------------------------------------------- |
| `Type` (base)    | `type.ghul`       | n/a (no params)                                                |
| `GENERIC` default | `generic.ghul:128` | INVARIANT for all params                                      |
| `ARRAY`          | `array.ghul`      | COVARIANT for non-value-types, INVARIANT for value types      |
| `FUNCTION`       | `function.ghul`   | last parameter (return) COVARIANT; others CONTRAVARIANT       |
| `ACTION`         | `action.ghul`     | all CONTRAVARIANT (no return — void)                          |

Consequences:

- `[Cat()]` is a `LIST[Cat]`. `LIST[T]` extends `Iterable[T]`, but `Iterable` is invariant in `T`. So `LIST[Cat]` is **not** assignable to `Iterable[Animal]`, even though `Cat <: Animal`.
- `Cat[]` is **assignable** to `Animal[]` (array covariance for reference types).
- `(Cat) -> int` is **not** assignable to `(Animal) -> int` (function arg contravariance — wider input wanted), but `(Animal) -> int` **is** assignable to `(Cat) -> int`.
- `() -> Cat` **is** assignable to `() -> Animal` (return covariance).

The variance handling itself is implemented in `Types.GENERIC.compare` (line 235ff in `src/semantic/types/generic.ghul`):

```ghul
for i in 0..generic_symbol.arguments.count do
    let variance = generic_other.get_argument_type_variance(i);
    if variance == TYPE_VARIANCE.COVARIANT then
        argument_score = generic_symbol.arguments[i].compare(generic_other_symbol.arguments[i]);
    elif variance == TYPE_VARIANCE.CONTRAVARIANT then
        argument_score = generic_other_symbol.arguments[i].compare(generic_symbol.arguments[i]);
    elif generic_symbol.arguments[i] =~ generic_other_symbol.arguments[i] then
        argument_score = Types.MATCH.SAME;
    else
        return Types.MATCH.DIFFERENT;
    fi
    ...
od
```

### Variance from .NET reflection (open follow-up)

For types loaded from .NET assemblies, the compiler does **not** currently extract variance from metadata. So even though `System.Collections.Generic.IEnumerable<out T>` is declared covariant in C#, the ghūl type system treats it as invariant because that's the GENERIC default and the loader doesn't override it.

The fix is small in principle: in `src/semantic/dotnet/symbol_factory.ghul` where each generic parameter is loaded, read `GenericParameterAttributes.Covariant` (0x0001) / `Contravariant` (0x0002) from the reflection metadata, store it on the resulting `Symbols.GENERIC`, and have `Types.GENERIC.get_argument_type_variance` consult it.

The risk is not in the loader change but in *the consequences*: the existing variance machinery in `compare` and `bind_type_variables` has only been tested via ARRAY and FUNCTION (the only types that currently override the default). Generalising it could surface edge cases nobody has hit. Worth doing as its own PR with a strong test pass.

## Least Upper Bound (LUB)

`Semantic.LEAST_UPPER_BOUND_MAP` (in `src/semantic/least_upper_bound_map.ghul`) computes the LUB of a set of types, used to infer a single type that satisfies multiple candidates. It backs:

- List literal element type inference.
- `if` expression branch type inference.
- Generic function-arg type-variable binding (added in PR #1205).
- *Aspirational:* generic class/struct/union type-arg inference in constructor expressions, function-literal multi-return-type, recursive tuple-element inference (all unticked boxes in #1173).

### Algorithm

`get_result()` runs strategies in order, returning the first that succeeds:

1. **`_try_get_best_assignable`** — pick the type from the input set that is assignable from all the others. Returns null if no input type satisfies. (This is the "original heuristic" — handles the common case where one input is itself an ancestor of all the others.)
2. **`_try_get_best_element_type`** — full LUB walk over the input element types only. Marked TODO in source as "actually worse than the original heuristic in some cases because it doesn't handle type variance". Returns null if the result is `object` (i.e. the only common element-type is too generic to be useful).
3. **`_try_get_best_concrete`** — full LUB walk over each input's concrete ancestor chain, intersect, pick the most-derived survivor. Always returns *something* — worst case `object`.
4. **`_try_get_best_trait`** — full LUB walk over implemented traits. Often picks unhelpful interfaces and "needs tuning somehow to prioritize traits that are relevant based on context" (per source comment).

When both 3 and 4 yield results, the chooser uses a depth-difference heuristic:

```ghul
let total_concrete_depth_difference =
    types | .reduce(0, (d, t) => d + (t.depth - best_concrete_type.depth));
let total_trait_depth_difference =
    types | .reduce(0, (d, t) => d + (t.depth - best_trait_type.depth));

if total_trait_depth_difference < total_concrete_depth_difference then
    return best_trait_type
else
    return best_concrete_type
fi
```

i.e. it picks the option that's closer (sum-of-depth-differences) to the inputs.

### Recently-fixed bugs in LUB

- **PR #1204** — `_try_get_best_assignable` had `type = best;` where `best = type;` was meant. The buggy form silently assigned to the loop variable instead of the accumulator, so `best` never widened when the *first* input was narrower than a later one. End-to-end symptom: `[Derived(), Base()]` was typed `Derived[]` and crashed at runtime with `ArrayTypeMismatchException`. `[Base(), Derived()]` always worked because `best` already held the wider type.

- **PR #1205** — extended `GENERIC_ARGUMENT_BIND_RESULTS.bind` to fall back to LUB on the siblings case. Includes a post-bind structural conformance re-check in `Function.try_bind_generic_arguments`, gated on whether LUB widening actually fired, to catch cases like `structured[T](T, Iterable[T])` with `(int, "hello")` where the LUB-widened binding satisfies per-arg bind calls but breaks structural conformance (Iterable is invariant; `string` is `Iterable[char]` not `Iterable[ValueType]`).

### LUB performance considerations

The maintainer flagged that the language server / analysis mode calls LUB-shaped operations frequently, and the current implementation allocates `LIST` and `MAP` collections per call. There is no measurement infrastructure today, so this is a "wait and see" concern — but be conscious of LUB being on a hot path before tightening the conformance check or extending it to additional call sites.

## Generic-argument inference (binding)

`Semantic.Types.GENERIC_ARGUMENT_BIND_RESULTS` (in `src/semantic/types/generic_argument_bind_results.ghul`) is the per-call accumulator that maps each type-variable to a single concrete type during overload resolution. Driven by `Function.try_bind_generic_arguments` in `src/semantic/symbols/function.ghul`.

Flow:

1. For each (parameter, actual-arg) pair, recursively descend the parameter type's structure looking for type-variable references. When one is found, call `results.bind(T, corresponding-actual-type)`.
2. After all args processed, call `check_complete` to verify every required type-variable was bound.
3. *(Added in #1205)* If LUB widening was used, re-verify each actual-arg type still conforms to its parameter type with the bindings substituted in.
4. If everything succeeds, the caller specializes the function with `results.map`.

`bind`'s pairwise-merge logic:

- New binding: just insert.
- Existing actual is `NONE` (sentinel for prior conflict): keep failing.
- New is `null` or `any`: no information, accept without changing existing.
- New is assignable from existing: widen to new.
- Existing is assignable from new: keep existing.
- Otherwise (siblings or unrelated): **(post-#1205)** compute LUB of existing and new; if LUB returns a non-null result, widen to that and set `used_lub = true`. **(pre-#1205)** set `actual_type` to `NONE` and return false, killing the overload match.

### The `unspecialized_*` interplay

After binding succeeds and the function is specialized via `Function.specialize_function`:

- `arguments` becomes the substituted parameter type list.
- `unspecialized_arguments` retains the *original* parameter type list (preserved across specialization in the function-symbol clone).
- `return_type` becomes substituted; `unspecialized_return_type` retains the original.

The IL emitter prefers `unspecialized_*` over `arguments`/`return_type` so that methodref signatures use `!N` indexed references rather than the substituted concrete types. See `docs/claude/il-emission.md` for why this matters.

## What's working today

- Generic constructor type-arg inference (`Box(42)` → `Box[int]`).
- Generic function-arg type-arg inference for matching, ancestor-related, and (post-#1205) sibling argument types.
- LUB for list literal element types and `if` expression branch types.
- Variance handling for arrays and function types (when the variance is hard-wired on the type).
- Bidirectional propagation in `let`-initialization and `if`-expression positions.

## What's not working / open

- Bidirectional propagation in argument positions (e.g. `m.takes_iterable_of_base([d, d])` won't push the parameter type into the literal — #1174).
- Variance from .NET reflection metadata (open follow-up; tractable next-PR).
- LUB for generic constructor/function type-arg inference at *constructor* expression sites (still open in #1173).
- LUB for function-literal multi-return-type.
- Tie-breaking for trait LUB candidates.
- The unification of "implications" and "constraints" (#1174).

Don't pick up `iterative-type-inference-1`/`-2` — May 2024 WIP at "25 integration tests failing → WIP borken", abandoned mid-flight, the speculative-rewrite trap.

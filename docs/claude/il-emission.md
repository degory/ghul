# IL emission

Depth notes on how ghūl emits .NET IL for generic types and members, the contract that matters most when fixing real bugs in this area, and the bug classes that breaking it produces.

## The methodref/fieldref contract

A methodref token in IL has roughly this shape:

```
callvirt instance <return-type> <constructed-type>::<method-name>(<param-types>)
```

For a non-generic call, all three of those pieces are unambiguously concrete types. For a call into a generic type — even a fully-instantiated one — there's a subtle CLR rule:

**The signature parts (`<return-type>` and `<param-types>`) inside the methodref must use `!N` indexed references for any type parameters of the constructed type, not the substituted concrete types.**

Concretely, for `Lib.FooBase<TSubject, TAssertions>::DoSomething(TSubject) -> string` invoked with `TSubject=object, TAssertions=Foo`:

```
// Wrong:
callvirt instance class System.String
         class [Lib]Lib.FooBase`2<class System.Object, class Lib.Foo>
         ::DoSomething(class System.Object)

// Right:
callvirt instance class System.String
         class [Lib]Lib.FooBase`2<class System.Object, class Lib.Foo>
         ::DoSomething(!0)
```

The constructed-type spec at the start (`<class System.Object, class Lib.Foo>`) names the concrete instantiation. But the parameter signature must still be `(!0)` — the open-generic parameter index — because that's how the CLR matches the methodref against the candidate method definitions.

Use the wrong form and you get **`MissingMethodException`** at the call site (the IL is well-formed; the CLR just can't find a matching method). This was the bug class behind issue #987 / PR #1201.

The same rule applies to fieldref tokens (with a single type slot for the field's type) and was the second half of #1201's fix.

For method-level generic parameters (a generic method on a generic class), the indexing form is `!!N` instead of `!N`.

## How ghūl supports the contract: `unspecialized_*`

The IL emitter doesn't compute the open-generic form on the fly. Instead, the symbol layer carries it explicitly:

- `Semantic.Symbols.Function` has `arguments` (substituted) and `unspecialized_arguments` (open-generic), plus `return_type` and `unspecialized_return_type`.
- `Semantic.Symbols.Field` has `type` and `unspecialized_type`.

The `gen_*` emitters check `unspecialized_*` first and fall through to the substituted versions only if the open form was never set:

```ghul
gen_actual_arguments_list(buffer: StringBuilder) is
    let args = unspecialized_arguments;
    if !args? then args = arguments; fi
    for argument in args do
        ...
        argument.gen_type(buffer);
        ...
    od
si

gen_reference(buffer: StringBuilder) is        // Field
    let t = unspecialized_type;
    if !t? then t = type; fi
    t.gen_type(buffer);
    owner.gen_reference(buffer);
    gen_dot(buffer);
    gen_name(buffer);
si
```

The contract for setting these up:

- **Source-defined functions/fields:** ghūl populates `unspecialized_*` during `specialize_function` (function.ghul) and `Field.specialize` (variable.ghul) — the un-substituted parameter list/type is preserved when a generic instantiation produces a specialized clone.
- **Reflection-loaded functions/fields:** the `Semantic.DotNet.SYMBOL_FACTORY.add_method` and `add_field` paths populate `unspecialized_*` *only* when the member is inherited from a constructed-generic base in another assembly (`method.declaring_type.is_generic_type && !method.declaring_type.is_generic_type_definition`). The recovery uses metadata-token match against the open base type to find the corresponding open-form member. This is the fix that landed in PR #1201.

The IL `gen_*` methods themselves (in the symbol classes) write `!N` / `!!N` correctly given properly-set-up `unspecialized_*`. The bugs in this area have all been about the *inputs* to the emitter, not the emitter logic.

## The `gen_*` call graph

Several places write a `<…>` block of generic arguments into IL, each with subtly different semantics. PR #988's diagnostic instrumentation tagged each with a unique marker (`/*CCC1*/`, `/*CCC2*/`, `/*FFF1*/`, `/*FFF2*/`, `/*GGG*/`) to figure out which call site was producing bad output — the markers are gone now, but the call structure is the same:

| Method | File:line | Emits | Semantic |
|---|---|---|---|
| `Classy.gen_formal_type_arguments` | `classy.ghul:301` | `'T','U'` (single-quoted names) | The *only* place names belong — used in `.class` directive declaring a generic type. |
| `Classy.gen_actual_type_arguments` | `classy.ghul:318` | `!0,!1,...` | Self-reference to the class's own open-generic form. Uses iteration index. |
| `Function.gen_generic_arguments_list` | `function.ghul:719` | `!!0,!!1,...` (or substituted) | Methodref's function-level generic args (for generic methods). |
| `Function.gen_generic_arguments_names` | `function.ghul:733` | quoted names | The `.method` directive's own type-parameter list. |
| `Function.gen_actual_arguments_list` | `function.ghul:700` | `!0,!1,...` (or substituted) | Methodref signature's parameter list — uses `unspecialized_arguments` first. |
| `GENERIC.gen_actual_type_arguments` | `generic.ghul:347` | comma-separated list, each via `argument.gen_type` | Constructed-type spec — recursive. The "outer" `<class object, class Foo>` part of a methodref. |
| `Field.gen_reference` | `variable.ghul:237` | `<type> <owner>::<name>` | Fieldref — uses `unspecialized_type` first. |

When debugging a malformed methodref/fieldref, the workflow is:

1. Compile with `--keep-out-il` (set via `<GhulOptions>--keep-out-il</GhulOptions>` in the project file or `--keep-out-il` on the command line).
2. Find the bad token in `out.il`.
3. Trace which `gen_*` produced each piece by reading the IL from left to right and matching against the call structure above.
4. Look at how the input symbol was constructed — usually the bug is in the loader (`symbol_factory.ghul`) or in `specialize_function`/`Field.specialize`, not in the emitter.

## Bug-class catalogue

### `MissingMethodException` / `MissingFieldException`

The methodref/fieldref token is well-formed IL but doesn't resolve to a real method/field at runtime. Typical cause: the *signature* slot has substituted concrete types where `!N` was needed.

Past instance: PR #1201 / issue #987 — inherited methods on a constructed-generic base in another assembly were loaded via `Type.GetMembers(BindingFlags.FlattenHierarchy)`, which surfaces the substituted form. Without recovering the open form, every fieldref/methodref into FluentAssertions-style F-bounded base classes failed.

### `InvalidProgramException` at JIT time

The IL is genuinely malformed — the verifier rejects it before the method runs. Typical cause: a literal type-parameter name (the string `T`) appears where the grammar requires an indexed reference (`!0`).

This was the speculative diagnosis in the original #987 issue but turned out *not* to be the actual bug shape. ghūl's emitter doesn't currently produce literal type-parameter names anywhere — `CLASSY_GENERIC_ARGUMENT.gen_type` and `FUNCTION_GENERIC_ARGUMENT.gen_type` always emit `!N`/`!!N` from their `index` field. If you ever do see this exception, look at:

- `_gen_type_override` on a `GenericArgument` symbol — the closure-frame mechanism uses this to remap captured type parameters; a stale override could write a name.
- The `// FIXME the resulting argument could have the wrong index` cases in `generic_argument.ghul:111` and `:161` — `specialize` of a `CLASSY_GENERIC_ARGUMENT` / `FUNCTION_GENERIC_ARGUMENT` constructs the result via the type-taking init overload that doesn't set `index`. Latent but not hit by current tests.

### `ArrayTypeMismatchException` at access time

The array's declared element type is narrower than what was actually stored in it. Typical cause: an array literal whose LUB element type was computed wrong.

Past instance: PR #1204 — `LEAST_UPPER_BOUND_MAP._try_get_best_assignable` had a `type = best;` typo that should have been `best = type;`. With input order `[Derived, Base]` the LUB returned `Derived`, so the array was typed `Derived[]` but actually held a `Base` element.

## Where the IL inputs come from

Two main sources:

### Reflection load path (`src/semantic/dotnet/`)

`SYMBOL_FACTORY.add_members(result, type)` on line 232 enumerates members via:

```ghul
type.get_members(cast BindingFlags(64 + 4 + 32 + 16 + 8))
                                  // FlattenHierarchy | Instance | NonPublic | Public | Static
```

Note: **no `DeclaredOnly`**. So inherited members come back with `DeclaringType = <constructed base>` and parameter/field types in their substituted form. `add_method` and `add_field` detect this case (`method.declaring_type != type && method.declaring_type.is_generic_type && !method.declaring_type.is_generic_type_definition`) and recover the open form from `type.declaring_type.get_generic_type_definition()` via metadata-token match. The recovered open-form types are stored in `unspecialized_*` so the emitter picks them up.

There's a candidate alternative architecture (use `BindingFlags.DeclaredOnly` and let ghūl's own `pull_down_super_symbols` handle inheritance) that would eliminate the special-casing, but the maintainer doesn't trust the pull-down machinery in untested combinations — see the relevant memory entry.

### Source-defined path (`src/syntax/process/declare_symbols.ghul`, `src/semantic/symbols/function.ghul`)

When a generic class `class GenericThing[T,U]` is declared in source, the parser creates `CLASSY_GENERIC_ARGUMENT` symbols for `T` and `U` with the correct `index` values. When a method on `GenericThing` is later specialized via `Function.specialize_function`, the original `arguments` becomes `unspecialized_arguments` on the specialized clone, and `arguments` itself is updated with the substituted types. Same for `return_type`/`unspecialized_return_type`.

There's a subtle inconsistency in `declare_symbols.ghul:215`: every generic argument symbol (whether class-level or method-level) is wrapped in a `Semantic.Types.FUNCTION_GENERIC_ARGUMENT` Type wrapper unconditionally. The wrapper's `is_function_generic_argument` flag is therefore wrong for class-level arguments. The IL emission still works because `gen_type` delegates to the symbol (which is correctly `CLASSY_GENERIC_ARGUMENT` and writes `!N`), but `overload_resolver.ghul:214–218` keys behaviour off the wrapper's flag for "should we try to bind a function- or owner-generic-arg?" decisions. The maintainer is aware; it's noted as a `// TODO can get is classy vs is function from underlying symbol` in `types/generic_argument.ghul`.

## Useful tools

- **`--keep-out-il`** — keep the emitted IL (`out.il`) alongside the binary. Pass on the command line or set `<GhulOptions>--keep-out-il</GhulOptions>` in a `.ghulproj`. Essential for debugging IL-level bugs.
- **Bootstrap diff** — `./build/bootstrap.sh` runs four self-hosting passes and diffs IL between passes 3 and 4. Catches "this change made the compiler produce different IL when compiling itself" regressions.
- **`integration-tests/il/<test>/il.expected`** — snapshot tests for IL output of small ghūl programs. Use for IL-shape regression coverage when a runtime test isn't enough or feels too coarse.

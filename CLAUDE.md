# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Read these first

- [AGENTS.md](./AGENTS.md) — workflow, test requirements, and documentation hygiene rules. Treat it as authoritative; this file does not duplicate its contents.
- [GHUL.md](./GHUL.md) — quick tutorial and reference for the ghūl language. The compiler source itself is the largest available ghūl codebase and a useful secondary reference.
- Per-folder `README.md` files under `src/`, `integration-tests/`, `build/`, `tasks/`. They are short and current.
- [docs/claude/type-system-and-inference.md](./docs/claude/type-system-and-inference.md) — depth on LUB, variance, bidirectional type-checking, current state of inference and where the open work is.
- [docs/claude/il-emission.md](./docs/claude/il-emission.md) — depth on the methodref/fieldref shape, the `unspecialized_*` preference contract that several recent fixes turned on, and the bug classes it guards against.

## What this repo is

A self-hosting compiler for the [ghūl programming language](https://ghul.dev), written in ghūl, targeting .NET 8. The compiler is packaged and consumed as a local .NET tool (`ghul.compiler` → `dotnet ghul-compiler`), driven by MSBuild via `.ghulproj` project files. Build/runtime require .NET 8 SDK.

The compiler is *bootstrapped*: any change you make is compiled by the previously-published version of the compiler. The locally pinned version of the tool lives in `.config/dotnet-tools.json`. CI's `bootstrap` job builds the new compiler with the pinned one, then `project_tests` and `integration_tests` run against the freshly-built (not the pinned) compiler. This matters — see "Working with project tests" below.

## Common commands

```sh
dotnet tool restore                                  # required once after clone
dotnet build                                         # build the compiler (uses the pinned ghul.compiler tool)
dotnet test unit-tests                               # unit tests; minimal but growing
dotnet publish --output publish/                     # required before integration tests; produces ./publish/ghul.dll
dotnet ghul-test integration-tests                   # full integration suite (snapshot-based)
dotnet ghul-test integration-tests/<test-folder>     # single integration test
dotnet ghul-test --use-dotnet-build project-tests    # cross-assembly project tests (full MSBuild)
./integration-tests/run-failed.sh                    # rerun anything left with a `failed` marker
./integration-tests/create.sh                        # scaffold a new integration test from the template
./tasks/capture.sh integration-tests/<test-folder>   # promote produced output to `*.expected` snapshot files
./build/bootstrap.sh                                 # 4-pass self-hosting check; diffs IL of passes 3 and 4
```

Integration tests reference the freshly published compiler via each test's `ghul.json` pointing at `../../../publish/ghul.dll`, so always re-`publish` after compiler changes before running them. Test directories use `ghulflags`, `fail.expected`, `err.expected`, `warn.expected`, `run.expected`, `il.expected` — see `integration-tests/README.md` for the full file/format reference and capture workflow.

## Source layout (`src/`)

The compiler follows traditional phase boundaries; each `src/<phase>/` has its own README with a short orientation. High-level flow:

- `lexical/` → tokenizer producing `TOKEN` stream (`tokenizer.ghul`, with lookahead helpers).
- `syntax/` → split into `trees/` (AST node definitions), `parsers/` (recursive-descent, wired through the tiny `ioc/` container to break cyclic deps), and `process/` (visitors and per-source-file passes over the AST). When introducing a new AST node type, base visitors in `process/` (`Visitor`, `StrictVisitor`, `ScopeVisitorBase`, `ScopedVisitor`) must each get a method or compilation breaks even if the pass ignores the node.
- `semantic/` → symbol table, scopes, type system (`types/`), `stable_symbols.ghul` registry, `least_upper_bound_map.ghul` (LUB primitive), and `dotnet/` helpers for emitting .NET metadata.
- `ir/` → lower-level intermediate representation used by code generation.
- `compiler/` → `COMPILER` orchestrator that registers and runs the ordered passes (see `compiler.ghul` `init()` for the canonical pass list: conditional-compilation → rewrite-syntax-trees → declare-symbols → resolve-uses → resolve-type-expressions → resolve-ancestors → resolve-explicit-types → resolve-overrides → record-type-argument-uses → compile-expressions → generate-il).
- `driver/` → thin CLI front-end (`main.ghul`); also serves the VS Code language extension when invoked with `--analyse`.
- `analysis/` → analyse-mode code paths that respond to language-service requests.
- `ioc/`, `logging/`, `source/` → small support modules.

If you add a syntax feature, expect to touch `lexical/`, `syntax/trees/`, `syntax/parsers/`, the visitor base classes in `syntax/process/`, and likely one or more semantic passes — and add an integration test in the appropriate `integration-tests/{execution,il,parse,semantic}/` subfolder.

## ghūl language quick reference

A few things about ghūl that are non-obvious if you've come from C# or other ML/Algol-family languages, ordered roughly by how often they bite while editing:

- **`new` is deprecated.** Construct instances by calling the type as a function: `Box(42)`, `LIST[int]()`, `Pair(123, "hello")`. Don't write `new Box(42)` — it still parses, but the deprecated path has its own bugs (e.g. constructor-inference triggers a misleading "cannot call superclass constructor" error). Use plain `TypeName(args)` everywhere.
- **Generic constructor type inference works:** `Box(42)` infers `T = int`, `Pair(123, "hello")` infers `T = int, U = string`, and nesting flows correctly (`Wrap(Box(7))`).
- **No generic constraint enforcement.** ghūl accepts `Mock[SomeStruct]()` even when Moq's `Mock<T>` declares `where T : class`. This makes Moq awkward to use from ghūl tests; prefer NSubstitute (already in `Directory.Packages.props`), real collaborators, or hand-written ghūl fakes.
- **Type variance is hard-wired per-type, not declarable.** Function types are contravariant in inputs and covariant in return; arrays are covariant for non-value-types; everything else (including `Iterable[T]`, `List[T]`, `MAP[K,V]`) defaults to invariant. So `[Cat()]` (a `LIST[Cat]`) does **not** satisfy `Iterable[Animal]` — even though `Cat <: Animal` and conceptually it should. See `docs/claude/type-system-and-inference.md` for the full picture.
- **Array literals.** `[a, b]` produces a `List[T]` whose `T` is the LUB of element types. Empty array literal `[]` doesn't parse as a primary expression — use `LIST[T]()` for the empty case. List literals satisfy `Iterable[T]` for the *same* `T`, but not for a wider supertype (no element-type widening — see variance note above).
- **Operator overloading on generic functions.** ghūl supports defining custom binary operators as generic functions: `##[T,U](a: T, b: U) -> T;` declares `##` as a binary operator. Precedence is set via `@precedence("##", "10")`. Useful when reading the test suite — `expect_int([10 ## "hello"])` is a normal generic function call.
- **Keyword reserved words that surprise.** `field`, `and`, and similar can't be used as identifiers (local variable names). The parser error is "expected ( or identifier but found field" — not particularly obvious. Use a different name (`f`, `c`, ...) or escape with backtick (`` `field ``) when referring to a member that's been auto-named that way.
- **`@test()` annotation form.** Goes inside the `is` body of a method (immediately after `is`, before any code). For class-level annotations, immediately after `class X is`. See `unit-tests/src/lexical/token_queue_tests.ghul` for many examples.
- **Naming conventions in the compiler source:** `UPPER_CASE` for types (especially generated/concrete classes — `CLASS`, `INSTANCE_METHOD`, `LEAST_UPPER_BOUND_MAP`), `PascalCase` for abstract base types (`Function`, `Classy`, `Type`), `snake_case` for members. .NET-imported names are auto-converted to snake_case (so `DoSomething` becomes `do_something` when called from ghūl).

## Type system & inference at a glance

The compiler's type system is bidirectional in the standard sense: information flows up from leaf expressions ("inference") and down from contexts that constrain expression types ("constraints" or "implications" — same concept, used interchangeably here). The compiler currently has *two* parallel implementations of the down-flowing concept; #1174 plans to unify them.

Two recent improvements (PRs #1204 and #1205) tightened the inference half:
- `LEAST_UPPER_BOUND_MAP._try_get_best_assignable` now correctly widens the candidate when a later input is an ancestor of the current best (was a one-character bug — `type = best` rather than `best = type`).
- `GENERIC_ARGUMENT_BIND_RESULTS.bind` now falls back to LUB on sibling-conflict cases — `merge[T](Cat, Dog)` infers `T = Animal` instead of giving up.

Open items in this area, roughly in size-of-work order:
- **Per-PR-merge of #1173 checkboxes.** LUB for generic class/struct/union type args in constructor expressions; LUB for function-literal multi-return-type; trait-tie resolution.
- **#1174:** unify the two left→right propagation mechanisms (overload resolution should produce constraints, not implications; function-literal arg inference should consume constraints, not implications).
- **Variance from reflection.** Read `GenericParameterAttributes.Covariant`/`Contravariant` from .NET metadata in `symbol_factory.ghul` and surface it on `Symbols.GENERIC` — would let `Iterable[Cat]` correctly satisfy `Iterable[Animal]`. Small work, main risk is the existing variance machinery (in `compare`/`bind_type_variables`) has only been exercised via ARRAY/FUNCTION so generalising could surface edge cases.

Don't pick up the `iterative-type-inference-1`/`-2` branches — abandoned WIP from 2024 with dozens of failing tests at last touch.

See [docs/claude/type-system-and-inference.md](./docs/claude/type-system-and-inference.md) for full detail.

## IL emission architecture

The IL emitter has a key contract that's worth knowing because several real bugs have come from violating it: **methodref and fieldref signatures must use open-generic indexed references (`!N` for class-level type params, `!!N` for method-level), even when the constructed-type spec at the start of the methodref already pins the concrete instantiation.** ghūl supports this contract by maintaining `unspecialized_arguments`/`unspecialized_return_type` (on `Function`) and `unspecialized_type` (on `Field`) that hold the *open-generic* form of the signature, and the `gen_*` emitters prefer those when present.

PR #1201 (issue #987) discovered that the .NET reflection load path lost this open form for inherited members on a constructed-generic base, producing methodrefs with substituted concrete types where `!N` was needed → `MissingMethodException` at the call site. The fix recovers the open form via metadata-token match against the open base type.

Bug-pattern cheat sheet:
- `MissingMethodException`/`MissingFieldException` at call/access time → malformed methodref/fieldref signature where the *signature* part has substituted types instead of `!N`.
- `InvalidProgramException` at JIT time → genuinely malformed IL that the verifier rejects (e.g. literal type-parameter names like `T` in a position that requires an indexed reference).
- `ArrayTypeMismatchException` at access time → array literal typed too narrowly (the LUB ordering bug fixed in #1204).

See [docs/claude/il-emission.md](./docs/claude/il-emission.md) for full detail.

## Bootstrap workflow specifics

`build/bootstrap.sh` runs four `dotnet pack` + `dotnet tool install --local` cycles, then diffs the IL of pass 3 vs pass 4 (ignoring `AssemblyInformationalVersionAttribute`) to verify the compiler reproduces itself bit-for-bit. Locally it traps `EXIT` to reinstate the previously pinned `ghul.compiler` tool — if the script is interrupted, your local tool may be left at a `*-bootstrap.*` version; rerun `dotnet tool uninstall --local ghul.compiler && dotnet tool install --local ghul.compiler --version <pinned>` to recover (without `--version`, you'll get the latest published, not the pinned one).

To test compiler changes against integration/project tests *locally*, you need to rebuild and reinstall the local tool because the test runner calls `dotnet ghul-compiler` which resolves through `.config/dotnet-tools.json`:

```sh
dotnet pack -nologo -p:CI=true -p:Version=0.0.0-local.1
dotnet tool uninstall --local ghul.compiler
dotnet tool install --local ghul.compiler --add-source nupkg --version 0.0.0-local.1
# ... run tests ...
# When done: restore the pinned version
dotnet tool uninstall --local ghul.compiler
git checkout .config/dotnet-tools.json
dotnet tool restore
```

Never commit a manifest pinned to a non-NuGet (`0.0.0-*` local) version — that breaks every other developer.

## Working with project tests

Project tests (`project-tests/`) run via `dotnet ghul-test --use-dotnet-build project-tests` and are how cross-assembly behaviour gets exercised. Each test is a real `.ghulproj` with `<ProjectReference>`s to other csproj or ghulproj. CI runs them in parallel.

Two recurring traps:

- **Don't share a `.csproj` reference across multiple project tests.** Parallel `dotnet build` invocations of the same csproj race on `bin/Debug/net8.0/<project>.deps.json` — MSBuild's `GenerateDepsFile` task takes an exclusive write lock and the loser fails with "process cannot access the file...because it is being used by another process". Each project test should have its own private C# library if it needs one (see `project-tests/inherited-generic-members/lib/` for the pattern). The race is *stochastic* — it might pass on a PR run and fail on the post-merge main build, blocking the publish step.

- **Catch-22 with the pinned compiler.** A new project test that depends on a recent compiler fix will only pass when run against a compiler containing that fix. CI works because it bootstraps a fresh compiler before running project_tests; locally, with the pinned NuGet version, the test will fail until either (a) the fix ships to NuGet and the manifest gets bumped, or (b) you locally pack-and-install the patched compiler. This is transient and resolves with the next publish, but if you run `dotnet ghul-test --use-dotnet-build project-tests` on main and a single test fails, suspect this before anything else.

## Writing unit tests for compiler internals

Tests live under `unit-tests/src/` (anywhere — picked up by `<GhulSources Include="src/**/*.ghul" />`). Conventions worth matching:

- One file per class under test, named `<class>_tests.ghul`. Test class named `<CLASS>_TESTS`.
- `@test()` annotation on the class itself (immediately after `class X is`) and on each test method (immediately inside its body, before any code).
- Assertions: `Microsoft.VisualStudio.TestTools.UnitTesting.Assert.are_equal/are_same/is_true/is_false/is_null`.
- Methods are `snake_case`; long descriptive names like `Calling__gen_type__should_emit_indexed_class_reference` are the norm.

A few non-obvious gotchas when constructing symbol/type fixtures:

- `LOCATION.internal`/`unknown`/`reflected` are static singletons populated by `Source.LOCATION.init_static()`, which is *only* called from `IoC.CONTAINER.init_static`. In a unit test that doesn't bring up the container, those statics are null and `Classy.init`'s `assert span?` will fire. Construct LOCATIONs directly: `LOCATION("test.ghul", 1, 1, 1, 1)`.
- For most `gen_*` tests, the symbol's `owner` parameter can be passed `null` — only emitter paths that delegate to `owner.gen_reference` actually touch it. That keeps fixtures tiny.
- Element-type widening is a real pitfall when defining test helpers (see "ghūl language quick reference" above). If a helper takes `Iterable[GenericArgument]` but you pass a `LIST[CLASSY_GENERIC_ARGUMENT]`, ghūl rejects the call. Either type the helper for the most-specific element type the test uses, or build the list as `LIST[GenericArgument]()` explicitly.
- Generic-argument symbols vs. type wrappers: `CLASSY_GENERIC_ARGUMENT` (a `Symbols.GenericArgument`) has a `.type` field that returns the `Types.CLASSY_GENERIC_ARGUMENT` (a `Types.GenericArgument`). The `bind` method on `GENERIC_ARGUMENT_BIND_RESULTS` expects the *type-side* `GenericArgument`, not the symbol. Use `cast Semantic.Types.GenericArgument(symbol.type)` when calling it.
- ghūl keywords blocked as identifiers: `field`, `and`, others. Substitute or escape with backtick.

Per `AGENTS.md`, unit-test coverage is intentionally minimal and the instruction "don't waste time trying to add new unit tests if you run into issues" still applies — the heavy lifting is done by integration and project tests. That said, the unit-tests project has been growing for the IL-emission and inference paths because they're pure-function-shaped (no reflection, no IoC, fast fixtures) and act as regression guards under the more architectural fixes — see `unit-tests/src/semantic/symbols/` and `unit-tests/src/semantic/`.

## Repo conventions worth knowing

- Versioning is centralized in `Directory.Build.props` (`<Version>`); package versions in `Directory.Packages.props` (central package management is enabled).
- Source files are matched via `<GhulSources Include="src/**/*.ghul" />`; there is no per-file `<Compile>` listing.
- Optional git hooks live in `.git-hooks/`. The provided `pre-commit` hook reinstalls the latest *published* `ghul.compiler` and stages the updated `.config/dotnet-tools.json` — if you have uncommitted compiler work depending on the locally-built tool version, install the hooks deliberately (`./.git-hooks/install`) rather than by default.
- AGENTS.md's "Documentation hygiene" rule applies: when working on a change, fix or clarify any `README.md`, `AGENTS.md`, `GHUL.md`, or top-of-file explanatory comments you find to be wrong or unclear, but do not remove explicit instructions without confirmation.
- Unix line endings only. If git warns about CRLF in working-tree files, normalize them — even in unrelated files. (One intentional exception: `integration-tests/parse/carriage-returns/test.ghul` deliberately contains CRLF as test data for the parser.)
- Branch naming for AI agents: `claude/<descriptive>` for Claude-driven work, `codex/<descriptive>` for Codex. PR style: short imperative title, body with `## Summary` (1–3 bullets) and `## Testing` (commands run). PRs are squash-merged; the PR description becomes the final commit message.

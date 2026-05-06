# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Read these first

- [AGENTS.md](./AGENTS.md) — workflow, test requirements, and documentation hygiene rules. Treat it as authoritative; this file does not duplicate its contents.
- [GHUL.md](./GHUL.md) — quick tutorial and reference for the ghūl language. The compiler source itself is the largest available ghūl codebase and a useful secondary reference.
- Per-folder `README.md` files under `src/`, `integration-tests/`, `build/`, `tasks/`. They are short and current.

## What this repo is

A self-hosting compiler for the [ghūl programming language](https://ghul.dev), written in ghūl, targeting .NET 8. The compiler is packaged and consumed as a local .NET tool (`ghul.compiler` → `dotnet ghul-compiler`), driven by MSBuild via `.ghulproj` project files. Build/runtime require .NET 8 SDK.

The compiler is *bootstrapped*: any change you make is compiled by the previously-published version of the compiler. The locally pinned version of the tool lives in `.config/dotnet-tools.json`.

## Common commands

```sh
dotnet tool restore                                  # required once after clone
dotnet build                                         # build the compiler (uses the pinned ghul.compiler tool)
dotnet test unit-tests                               # unit tests (minimal coverage; see AGENTS.md before adding new ones)
dotnet publish --output publish/                     # required before integration tests; produces ./publish/ghul.dll
dotnet ghul-test integration-tests                   # full integration suite (snapshot-based)
dotnet ghul-test integration-tests/<test-folder>     # single integration test
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
- `semantic/` → symbol table, scopes, type system (`types/`), `stable_symbols.ghul` registry, and `dotnet/` helpers for emitting .NET metadata.
- `ir/` → lower-level intermediate representation used by code generation.
- `compiler/` → `COMPILER` orchestrator that registers and runs the ordered passes (see `compiler.ghul` `init()` for the canonical pass list: conditional-compilation → rewrite-syntax-trees → declare-symbols → resolve-uses → resolve-type-expressions → resolve-ancestors → resolve-explicit-types → resolve-overrides → record-type-argument-uses → compile-expressions → generate-il).
- `driver/` → thin CLI front-end (`main.ghul`); also serves the VS Code language extension when invoked with `--analyse`.
- `analysis/` → analyse-mode code paths that respond to language-service requests.
- `ioc/`, `logging/`, `source/` → small support modules.

If you add a syntax feature, expect to touch `lexical/`, `syntax/trees/`, `syntax/parsers/`, the visitor base classes in `syntax/process/`, and likely one or more semantic passes — and add an integration test in the appropriate `integration-tests/{execution,il,parse,semantic}/` subfolder.

## Bootstrap workflow specifics

`build/bootstrap.sh` runs four `dotnet pack` + `dotnet tool install --local` cycles, then diffs the IL of pass 3 vs pass 4 (ignoring `AssemblyInformationalVersionAttribute`) to verify the compiler reproduces itself bit-for-bit. Locally it traps `EXIT` to reinstate the previously pinned `ghul.compiler` tool — if the script is interrupted, your local tool may be left at a `*-bootstrap.*` version; rerun `dotnet tool uninstall --local ghul.compiler && dotnet tool install --local ghul.compiler` to recover.

## Writing unit tests for compiler internals

Tests live under `unit-tests/src/` (anywhere — picked up by `<GhulSources Include="src/**/*.ghul" />`). Conventions worth matching:

- One file per class under test, named `<class>_tests.ghul`. Test class named `<CLASS>_TESTS`.
- `@test()` annotation on the class itself (immediately after `class X is`) and on each test method (immediately inside its body, before any code).
- Assertions: `Microsoft.VisualStudio.TestTools.UnitTesting.Assert.are_equal/are_same/is_true/is_false`.
- Methods are `snake_case`; long descriptive names like `Calling__gen_type__should_emit_indexed_class_reference` are the norm.

A few non-obvious gotchas when constructing symbol/type fixtures:

- `LOCATION.internal`/`unknown`/`reflected` are static singletons populated by `Source.LOCATION.init_static()`, which is *only* called from `IoC.CONTAINER.init_static`. In a unit test that doesn't bring up the container, those statics are null and `Classy.init`'s `assert span?` will fire. Construct LOCATIONs directly: `LOCATION("test.ghul", 1, 1, 1, 1)`.
- `field` and `and` are ghūl keywords. You can't use them as local variable names — pick something else (`f`, `c`, etc.). The parser error is "expected ( or identifier but found field" rather than something more obvious.
- Empty array literal `[]` doesn't parse in a primary expression. For an empty list use `LIST[T]()`.
- Array literals like `[a, b]` produce a `List[T]` whose `T` is the *exact* element type. They satisfy `Iterable[T]` for the same `T`, but ghūl does not widen the element type at the call site — so `[derived, derived]` will not satisfy `Iterable[Base]` even though `Derived <: Base`. If the parameter is generic in a supertype, build a `LIST[Base]()` explicitly and `.add(...)` to it (or write a helper that takes named parameters of the supertype).
- For most `gen_*` tests, the symbol's `owner` parameter can be passed `null` — only emitter paths that delegate to `owner.gen_reference` actually touch it. That keeps fixtures tiny.

Per `AGENTS.md`, unit-test coverage is intentionally minimal and the instruction "don't waste time trying to add new unit tests if you run into issues" still applies — the heavy lifting is done by integration and project tests.

## Repo conventions worth knowing

- Versioning is centralized in `Directory.Build.props` (`<Version>`); package versions in `Directory.Packages.props` (central package management is enabled).
- Source files are matched via `<GhulSources Include="src/**/*.ghul" />`; there is no per-file `<Compile>` listing.
- Optional git hooks live in `.git-hooks/`. The provided `pre-commit` hook reinstalls the latest *published* `ghul.compiler` and stages the updated `.config/dotnet-tools.json` — if you have uncommitted compiler work depending on the locally-built tool version, install the hooks deliberately (`./.git-hooks/install`) rather than by default.
- AGENTS.md's "Documentation hygiene" rule applies: when working on a change, fix or clarify any `README.md`, `AGENTS.md`, `GHUL.md`, or top-of-file explanatory comments you find to be wrong or unclear, but do not remove explicit instructions without confirmation.

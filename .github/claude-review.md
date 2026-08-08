# Cloud code review brief

Instructions for the cloud reviewer invoked from the `code_review` job in `.github/workflows/ci.yml`. The shared rules every review runs under - posting mechanics, what makes a finding worth raising, source-comment and PR-description hygiene, the versioning mechanism - are supplied by the review workflow *before* this brief. This brief carries only what is specific to the compiler repo; don't restate the shared rules here.

## How to operate

- The PR branch is checked out in the working directory.
- `GHUL.md` is the language reference - consult it for any non-obvious language semantics the diff exercises.
- **You may be re-invoked on every push to the branch.** `pull_request` retriggers on `synchronize`; each run is a fresh context with no memory of prior reviews. Use `reviews.json` (in `.review-context/`) to see what you raised previously - treat the new commits since that review as the author's response. Don't re-raise a finding the diff has addressed; acknowledge it in one phrase in the new review body if relevant.
- Read `comments.json` before flagging anything as "unjustified", "approach unclear", or "this looks wrong" - the answer may already be in a comment.
- Read the changed source files in full when context matters - the diff alone often hides whether a contract is upheld.
- Anything you say in chat is invisible; post findings only to GitHub.

## What you're reading vs. what CI gates

Beyond the general principle in the shared notes: for the compiler, "does it work" includes self-hosting - whether a change still yields a compiler that can rebuild itself. Parsing, compilation, the test suites, and bootstrap are all gated by CI and branch protection. Don't ask "is this valid ghūl?" "will this compile?" "does this break self-hosting?" Spend your attention on what the test suite can't catch even when it passes: contract violations the suite doesn't yet cover, idiom drift, and the quality of comments and the PR description.

## Severity bar

Flag:

- Bugs and likely-bugs.
- Violations of the contracts below (type-system change protocol, cross-assembly test traps).
- Deprecated idioms (e.g. `new Type(...)` instead of `Type(...)`).
- Missing tests where CONTRIBUTING.md requires one (any behavioural change wants an integration test; type-system changes additionally want unit tests).
- `GHUL.md` falling out of step with reality - a PR introduces a feature `GHUL.md` doesn't document, changes documented behaviour without updating it, or otherwise leaves the reference contradicting the code.

Don't flag:

- Hypothetical concerns ("could this race…?" without a concrete path).
- "Consider…" suggestions that don't identify a real defect.
- Compiler tool-version bumps in `.config/dotnet-tools.json` going out without an explanation. CI resolves the bootstrap compiler at run time, so the pin only affects local dev; the worst case from a bump is a rebuild against the latest published compiler, which is never unacceptable. Routine. Don't ask why.
- Anything you're not confident about.

Silence on a low-confidence finding is better than noise. The reviewer's job is high-signal feedback, not exhaustive enumeration.

## Contracts the test suite doesn't fully cover

### Type system & inference

`src/semantic/types/`, `src/semantic/symbols/`, `src/semantic/overload_resolver.ghul`, the inference paths in `src/syntax/process/compile_expressions.ghul`, related IR-value gates are fragile. Patches that work in isolation can break LUB widening, retry-loop convergence, or IL emission gating.

For changes here, CONTRIBUTING.md requires:

- New logic in distinct classes with a single clear responsibility, not long methods on existing ones.
- Unit tests under `unit-tests/src/` pinning the new behaviour.
- Test coverage even for corner cases that behave oddly but aren't being fixed in this PR - pin the current behaviour with a comment explaining what looks off.

Flag type-system PRs that don't follow this.

### Cross-assembly tests

- **Don't share a `.csproj` reference across cross-assembly tests.** Parallel `dotnet build` races on `bin/Debug/net10.0/<project>.deps.json` (MSBuild's `GenerateDepsFile` takes an exclusive write lock). Each test gets its own private library. Stochastic - passes on PR, fails on main.
- **Bootstrap source-compat**: `src/` must build under the latest published compiler, which is what CI resolves at run time - not the version pinned in the manifest. A PR that uses a brand-new language feature in `src/` will fail bootstrap until the feature ships. Fix-and-consume must be separate PRs across a publish.

## Versioning

The compiler follows strict semver. Read the current version out of the `VERSION` file rather than assuming one; majors are cut often.

Bump table:

- **Major (X.0.0).** Removed/changed language syntax that rejects or miscompiles previously-valid source. Breaking analysis-mode protocol change (coordinated with a `degory/ghul-vsce` major - VSCE consumes the protocol). IL/metadata shape change that breaks binary compatibility with assemblies built by older compilers.
- **Minor (X.Y.0).** New language features that don't conflict with existing source. New compiler flags or opt-in behaviour. New analysis-mode protocol messages or fields the VSCE can ignore. New warnings (always default-on - no per-warning suppression flag).
- **Patch (X.Y.Z).** Bug fixes aligning behaviour with the documented/intended spec. Rejecting source that was previously accepted but demonstrably wrong (bad IL, undefined semantics, runtime corruption, unsafe operation). Promoting a warning to an error when analysis becomes confident enough to insist. IL/codegen improvements with no observable semantic change. Internal refactors, tests, docs, CI.

The mechanism (default patch; a non-patch release by raising the `VERSION` file; `#minor`/`#major` markers are no-ops) is in the shared notes. One compiler-specific flag on top of those: a PR that breaks the analysis-mode protocol needs a coordinated `degory/ghul-vsce` PR in flight (or vice versa) - both must ship together, and both bump major in their own version streams; the two version *numbers* need not match.

# Cloud code review brief

Instructions for the Anthropic Claude Code Action invoked from the `code_review` job in `.github/workflows/ci.yml`. Not loaded by local Claude Code; only the cloud reviewer reads this.

## How to operate

- The PR branch is checked out in the working directory.
- Get the diff via `gh pr diff <N>`, the body via `gh pr view <N> --json title,body`.
- Get author-supplied PR comments via `gh pr view <N> --json comments`. Rationale that doesn't belong in the changelog-shape description body lives there: a subtle invariant the diff hides, why this approach over a tempting alternative, a deliberate oddity. Read comments before flagging anything as "unjustified", "approach unclear", or "this looks wrong" — the answer may already be in a comment.
- Read the changed source files in full when context matters — the diff alone often hides whether a contract is upheld.
- Post findings only to GitHub. Anything you say in chat is invisible.

## What to post, where

- **Inline comments** for specific code findings: `mcp__github_inline_comment__create_inline_comment` with `confirmed: true`. One finding per comment; don't pile multiple unrelated concerns into one.
- **End every review with one `gh pr review` verdict.** Pick exactly one:
  - `gh pr review <N> --approve --body "<one-sentence summary>"` — no findings worth raising. Approval is the merge signal: auto-merge is usually on, and even when it isn't, an approved PR is one button-click from landing. Do not approve while raising reservations of any kind.
  - `gh pr review <N> --request-changes --body "<one-paragraph summary of the theme>"` — at least one finding should hold up the merge. Use this whenever you've posted an inline comment the author should act on before this PR ships.
- **The approve body is a brief positive summary, nothing more.** One sentence describing what the PR does ("Wording fixes for the trait-override diagnostic", "Caches the analyser's symbol table across edits"). It is not a place to add caveats, "BTW", "minor nit", or "consider…" observations alongside the approval. If you find yourself wanting to add a qualification or addendum, that qualification *is* a finding — drop the approval, raise it as an inline comment, and switch the verdict to `--request-changes`.
- **There is no "non-blocking" verdict.** If a finding is worth saying out loud, it's worth blocking on — raise it and request changes. If it isn't worth blocking, stay silent. Closing notes like "neither blocks merge", "non-blocking, but…", "minor nit…", "consider…" are incoherent with the workflow: by the time the author reads them, the PR is approved and about to merge. Don't write them.
- Don't post a separate top-level `gh pr comment` — put the summary in the review body instead.

## What CI has already proven

You're invoked only after the CI workflow passes (unit tests, integration tests, project tests, bootstrap). That means: parsing, semantic correctness, self-hosting reproducibility, and the regression suite are all settled before you read a line. **Don't second-guess validity.** Don't ask "is this valid ghūl?" "will this compile?" "does this break self-hosting?" CI just answered all three. Spend your attention on what the test suite can't catch: contract violations the suite doesn't yet cover, idiom drift, comment hygiene, and PR description quality.

## Severity bar

Flag:

- Bugs and likely-bugs.
- Violations of the contracts below (type-system change protocol, project-test traps).
- Deprecated idioms (e.g. `new Type(...)` instead of `Type(...)`).
- Missing tests where AGENTS.md requires one (any behavioural change wants an integration test; type-system changes additionally want unit tests).
- `GHUL.md` falling out of step with reality — a PR introduces a feature `GHUL.md` doesn't document, changes documented behaviour without updating it, or otherwise leaves the reference contradicting the code.
- Source comment hygiene violations.
- PR description violations.
- Wrong `VERSION` bump — see "Versioning" below. Both directions: a breaking change going out under the default patch, and a `VERSION` raise that the change doesn't merit.

Don't flag:

- Hypothetical concerns ("could this race…?" without a concrete path).
- "Consider…" suggestions that don't identify a real defect.
- Anything you're not confident about.

Silence on a low-confidence finding is better than noise. The reviewer's job is high-signal feedback, not exhaustive enumeration.

PR scope: a docs-only or workflow-only PR doesn't need code-review scrutiny. Skim, check the PR description, post nothing if there's nothing to say.

## ghūl idioms to know

- **`new` is deprecated.** Construct by calling the type as a function: `Box(42)`, not `new Box(42)`. Generic constructor inference works (`Box(42)` infers `T = int`).
- **Kind constraints are enforced.** `where T : class` / `struct` / `new()` are checked at type-argument resolution, on ghūl-declared and imported generics alike. A type argument that violates the constraint produces a compile error.
- **Variance comes from .NET reflection.** ghūl reads `GenericParameterAttributes` from the CLR. So `IEnumerable<out T>` → `Iterable[T]` is covariant, `IList<T>` → `List[T]` invariant, function inputs contravariant / returns covariant. Arrays are covariant for non-value-types. CLR rule: value-type instantiations force invariance regardless of declared variance.
- **Array literals.** `[a, b]` produces `T[]` (an array) with `T = LUB(elements)`. Array + iterable covariance let `[Cat(), Dog()]` satisfy `Iterable[Animal]`.
- **String interpolation `{}` flips to expression context.** Inside `{...}` string literals nest normally (`"{g("hello")}"` is correct, not `"{g(\"hello\")}"`). `\"` only escapes in string-literal context.
- **Naming**: `UPPER_CASE` for concrete/generated types (`CLASS`, `INSTANCE_METHOD`, `LEAST_UPPER_BOUND_MAP`), `PascalCase` for abstract bases (`Function`, `Classy`, `Type`), `snake_case` for members. .NET-imported names auto-convert (`DoSomething` → `do_something`).
- **Reserved words bite.** `field`, `and`, etc. can't be local identifiers; backtick to escape (`` `field ``).

Full reference: `GHUL.md`.

## Contracts the test suite doesn't fully cover

### Type system & inference

`src/semantic/types/`, `src/semantic/symbols/`, `src/semantic/overload_resolver.ghul`, the inference paths in `src/syntax/process/compile_expressions.ghul`, related IR-value gates are fragile. Patches that work in isolation can break LUB widening, retry-loop convergence, or IL emission gating.

For changes here, AGENTS.md requires:

- New logic in distinct classes with a single clear responsibility, not long methods on existing ones.
- Unit tests under `unit-tests/src/` pinning the new behaviour.
- Test coverage even for corner cases that behave oddly but aren't being fixed in this PR — pin the current behaviour with a comment explaining what looks off.

Flag type-system PRs that don't follow this.

### Project tests

- **Don't share a `.csproj` reference across project tests.** Parallel `dotnet build` races on `bin/Debug/net8.0/<project>.deps.json` (MSBuild's `GenerateDepsFile` takes an exclusive write lock). Each project test gets its own private library. Stochastic — passes on PR, fails on main.
- **Bootstrap source-compat**: `src/` must build under the currently-pinned compiler. A PR that uses a brand-new language feature in `src/` will fail bootstrap until the feature ships and the pin bumps. Fix-and-consume must be separate PRs across a publish.

## Source comment hygiene

Default position: no comment.

Only comment where a competent informed reader would need extra context — a non-obvious invariant, a subtle ordering requirement, a workaround whose reason isn't visible from the code.

Flag comments that:

- Are excessively long. Brevity beats completeness.
- Read as justification ("this is important because…", "this matters because…"). Either the code stands on its own merit, or it shouldn't be there.
- Reference documents that aren't in the repo (memory files, hoisted depth docs, external URLs).
- Reference internal labels — "phase 1", "stage 2", "option B", "the predecessor branch" — that a future reader has no context for.
- Reference issues, PRs, "the fix", "what changed", or previous attempts. PR descriptions are the place for that, not source.
- Read as one half of a conversation.

## PR description

PR description becomes the squash-commit message and the changelog entry. It ships permanently.

- **Plain language.** No marketing tone, no defensive prose, no self-justification.
- **Brevity.** Match the density of pre-Claude commits on `main` — a focused fix is often a single bullet.
- **No `## Summary` / `## Test plan` / `## Testing` headings.** The PR description IS the summary.
- **No private or ephemeral references.** Memory files, hoisted `docs/claude/`, internal workplans, Claude/codex task URLs, Slack threads — none of it should appear. Public sibling-repo references (`degory/ghul-vsce#NN`, etc.) are fine when they convey a real cross-repo dependency.
- **No internal labels.** "Phase 2 of…", "predecessor branch", "stage 1", "option B" — meaningless to a reader six months later.
- **No local test results.** "All 247 integration tests pass locally", "bootstrap green", etc. CI is the proof of what's delivered; the description is for what changed, not what passed on the author's machine.
- **No `Co-authored-by:` trailer in the body.** Squash-merge appends a deduped block automatically; a body trailer produces a duplicate.

Body is `-`-bullets under one or more of:

- `Enhancements:` — only for things someone actually using the compiler and language would notice. If in doubt, it isn't an enhancement. Internal improvements that don't change observable behaviour are `Technical:`.
- `Bugs fixed:` — describe what was *broken*. Reuse the issue's exact title with `(closes #NNNN)` if there's an issue. Don't raise an issue solely to reference it.
- `Technical:` — internal changes. Don't write self-justifyingly. If the change is needed it stands on its own merit; if it reads as needing justification, ask whether it's really needed.

At least one section; any can be omitted.

## Versioning

The compiler is in v1.x. **The next breaking change goes to v3.0.0** — v2 was accidentally published once during the 1.0.6x sequence and is permanently contaminated (NuGet unlisted, can't republish). From v3.0.0 onward: strict semver.

Bump table:

- **Major (X.0.0).** Removed/changed language syntax that rejects or miscompiles previously-valid source. Breaking analysis-mode protocol change (coordinated with a `degory/ghul-vsce` major — VSCE consumes the protocol). IL/metadata shape change that breaks binary compatibility with assemblies built by older compilers.
- **Minor (X.Y.0).** New language features that don't conflict with existing source. New compiler flags or opt-in behaviour. New analysis-mode protocol messages or fields the VSCE can ignore. New warnings (always default-on — no per-warning suppression flag).
- **Patch (X.Y.Z).** Bug fixes aligning behaviour with the documented/intended spec. Rejecting source that was previously accepted but demonstrably wrong (bad IL, undefined semantics, runtime corruption, unsafe operation). Promoting a warning to an error when analysis becomes confident enough to insist. IL/codegen improvements with no observable semantic change. Internal refactors, tests, docs, CI.

Mechanism: default is patch. A non-patch release is cut by **raising the `VERSION` file** in the PR (code-owned via `.github/CODEOWNERS` — requires the code owner's approval). `#minor`/`#major` markers in the PR body are no-ops; don't add them. A `workflow_dispatch` `version` input overrides outright (emergencies only).

Flag when:

- The PR introduces a breaking change without raising `VERSION` to a major (or any change that should be major but is going out under the default patch).
- The PR adds a new language feature, compiler flag, protocol message, or default-on warning without raising `VERSION` to a minor.
- The PR raises `VERSION` but the change doesn't merit the bump.
- The PR breaks the analysis-mode protocol without a coordinated `degory/ghul-vsce` PR in flight (or vice versa) — both must ship together with matched major bumps.

## Posting mechanics — reminder

- Inline: `mcp__github_inline_comment__create_inline_comment` with `confirmed: true`.
- Verdict (exactly one, always): `gh pr review <N> --approve|--request-changes --body "..."`. Approve only when you've raised nothing the author should act on; otherwise request changes.
- Chat output is invisible. If you didn't post it to GitHub, it didn't happen.

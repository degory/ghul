# AI Agent Guide for ghūl Compiler

## Purpose

This guide is primarily for AI agents (and automated contributors) working on the ghūl programming language compiler. Human contributors may also find it useful. Please follow these instructions to ensure changes are made safely and tested thoroughly.

## Background

The ghūl compiler is written in ghūl. Before making changes:
- Consult the ghūl language quick tutorial and reference ([GHUL.md](./GHUL.md))
- Optionally review the [ghūl programming language website](https://ghul.dev/)
- The compiler source code in this repository is the largest ghūl codebase and serves as a key reference
- The language and compiler are a work in progress; actual behavior may differ from documentation, and bugs are expected

## Test Requirements

All tests must pass before submitting a pull request. The test suite includes:

| Test Type      | How to Run                                   | Typical Duration (agent environment)         | Notes                                                                 |
|----------------|----------------------------------------------|-----------------------------------------|-----------------------------------------------------------------------|
| Unit Tests     | `dotnet test unit-tests`                     | Seconds                                | Coverage is intentionally selective for most areas (rely on integration tests). The *type system and inference paths* are an exception — see "Type-system changes" below.           |
| Bootstrap      | `./build/bootstrap.sh`                       | ~1 minute                              | Verifies compiler self-hosting. May appear to pause during builds; produces little output until each build completes. Can take longer on less powerful machines or in agent environments. |
| Integration    | `dotnet publish --output publish/ && dotnet ghul-test integration-tests` | ~3 minutes | Snapshot-based; see [integration-tests/README.md](integration-tests/README.md) for details. Produces continuous output. Requires compiler to be published to `./publish/` first. May take longer in agent/dev environments. |

### Integration Test Groups

- `integration-tests/execution`: Asserts a binary is created, runs, and specific text output is produced.
- `integration-tests/il`: Asserts IL output.
- `integration-tests/parse`: Asserts parsing errors/warnings.
- `integration-tests/semantic`: Asserts semantic correctness/errors.

**For new or changed functionality, add or update integration tests in the appropriate subfolder.**

## Type-system changes

The type system and inference machinery (`src/semantic/types/`, `src/semantic/symbols/`, `src/semantic/overload_resolver.ghul`, the inference paths in `src/syntax/process/compile_expressions.ghul`, related IR-value gates) are complex and fragile. Patches that work in isolation can interact badly with constraint accumulation, LUB widening, retry-loop convergence, or IL emission gating. Aim higher here than the general "integration tests are enough" baseline:

- **Implement new logic in distinct classes with a single clear responsibility.** Prefer a small new class to a long method on an existing one. If a new method on an existing class is the right call, keep its responsibility narrow.
- **Move existing logic into a new or existing focused class when the surrounding change makes it natural.** Don't refactor speculatively, but do consolidate when a single change reveals duplicated logic across sites (e.g. ancestor-walks in `_back_feed_pair` and `_try_specialize_owner_from_constraint`, sibling-arg binding logic shared between resolve_constructor and the function-call retry).
- **Write unit tests under `unit-tests/src/` that pin the behaviour you care about.** Fast, focused fixtures around the new class are far easier to maintain than integration tests across the full compiler pipeline, and they document the intended contract.
- **Capture observed behaviour even when it seems wrong.** If a corner case behaves unexpectedly but you're not changing it in this PR, *still* add a test that pins the current behaviour. Mark it with a clear note: a comment explaining what looks off, why it's not being fixed here, and what the corrected behaviour would be. Future changes will then either flip the test deliberately (with the rationale visible in the diff) or notice they've broken the existing expectation.

This guidance overrides the general "minimal unit-test coverage" framing for type-system work specifically. Don't take it as license to gold-plate every PR — the rule is: when you touch type-system internals, leave the unit-test suite stronger than you found it.

## Additional Notes

- If unrelated tests fail, report or flag them for human review.
- If you encounter flaky or brittle tests, note them in your PR or commit message.
- Use imperative instructions and keep changes minimal and well-documented.
- Be aware that test durations may be significantly longer in AI agent/dev environments with limited resources.

## Documentation hygiene

When preparing a pull request, verify the accuracy and clarity of documentation:

- Any `AGENTS.md` file
- Any `README.md` file
- `GHUL.md`
- The explanatory comment at the top of any source file

If you discover information in these files that is incorrect, fix it. If wording is confusing, clarify it. When you spend time working out something that should be documented but is missing, add that information. Avoid removing explicit instructions from these files unless you have confirmation from the user.

## See Also
- [GHUL.md](./GHUL.md) – Language reference
- [integration-tests/README.md](integration-tests/README.md) – Integration test details
- [README.md](./README.md) – Project overview


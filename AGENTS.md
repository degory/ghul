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
| Unit Tests     | `dotnet test unit-tests`                     | Seconds                                | Minimal coverage; only fix/add if affected by your changes. Don't waste time trying to add new unit tests if you run into issues           |
| Bootstrap      | `./build/bootstrap.sh`                       | ~1 minute                              | Verifies compiler self-hosting. May appear to pause during builds; produces little output until each build completes. Can take longer on less powerful machines or in agent environments. |
| Integration    | `dotnet publish --output publish/ && dotnet ghul-test integration-tests` | ~3 minutes | Snapshot-based; see [integration-tests/README.md](integration-tests/README.md) for details. Produces continuous output. Requires compiler to be published to `./publish/` first. May take longer in agent/dev environments. |

### Integration Test Groups

- `integration-tests/execution`: Asserts binary output.
- `integration-tests/il`: Asserts IL output.
- `integration-tests/parse`: Asserts parsing errors/warnings.
- `integration-tests/semantic`: Asserts semantic correctness/errors.

**For new or changed functionality, add or update integration tests in the appropriate subfolder.**

## Additional Notes

- If unrelated tests fail, report or flag them for human review.
- If you encounter flaky or brittle tests, note them in your PR or commit message.
- Use imperative instructions and keep changes minimal and well-documented.
- Be aware that test durations may be significantly longer in AI agent/dev environments with limited resources.

## See Also
- [GHUL.md](./GHUL.md) – Language reference
- [integration-tests/README.md](integration-tests/README.md) – Integration test details
- [README.md](./README.md) – Project overview


# AI Agent Guide for the ghūl Compiler

## Purpose

This guide is for AI agents and other automated contributors working on the ghūl
compiler.

**[CONTRIBUTING.md](./CONTRIBUTING.md) is the authority, and it applies to you in
full.** Read it first. The test requirements, the bootstrap rule, the protocol
for type-system changes, the documentation and comment rules, and the pull
request description format all live there and are not repeated here. What
follows is only the part that is specific to working without a human at the
keyboard.

## Before you start

Read [GHUL.md](./GHUL.md) rather than working from what you remember of ghūl.
The syntax is unusual enough that a half-remembered version of it produces
confident, wrong code, and you will not find out until the build fails. The
compiler's own source under `src/` is the largest body of ghūl in existence and
is the best secondary reference for idiom.

The language and the compiler are both works in progress. The documentation
describes what is intended; the compiler does what it does. Where they disagree,
say so rather than quietly coding around it.

## A failing test is your change

Assume every test failure you see was caused by what you just did. "That test
was already broken" is almost never true here: CI runs the whole suite on every
pull request, branch protection blocks the merge unless it is green, and the
same suite runs again on `main` after the merge. A published release has passed
it twice.

Before concluding otherwise, reproduce the failure against the latest published
compiler on an unmodified checkout, and find the CI run where it failed. If you
cannot produce that evidence, the failure is yours - or it is local state: a
stale `publish/` directory, a half-reverted edit, leftover `failed` markers from
an earlier run.

Genuinely intermittent tests are a separate thing. If you find one, name it and
describe how it fails, rather than filing it under "already broken".

## Working within the limits of your environment

- The timings in CONTRIBUTING.md assume a reasonably fast machine. In a
  container or on a small VM, expect several times that. Budget for it instead
  of concluding a run has hung.
- `./build/bootstrap.sh` and the integration suite produce little output for long
  stretches. Silence is not failure.
- Prefer a small reproduction to iterating against the full suite. A focused
  integration test that runs in seconds tells you the same thing as a bootstrap
  cycle that takes minutes.
- Smaller still, when you only want to know what the compiler says about a
  snippet: compile it on its own. `ghul-compiler probe.ghul` needs no project
  file and exits non-zero if it reports an error. Diagnostics go to standard
  error, so redirect with `2>&1` if you are capturing them - redirecting only
  standard output gives you an empty file whatever the compiler said.
  `ghul-compiler --help` lists the options. A compiled program that uses the
  ghūl runtime needs `ghul-runtime.dll` beside it before it will run.

## Reporting your work

- Keep changes minimal and scoped to what was asked.
- If something fails and you cannot explain it, say so plainly in the pull
  request and leave it for a human, rather than working around it or leaving it
  out of the description.
- Describe what you actually did. If you skipped a test, ran a narrower suite
  than usual, or left part of the task undone, that belongs in the pull request,
  not in a summary that implies otherwise.

## See also

- [CONTRIBUTING.md](./CONTRIBUTING.md) - how to build, test, and raise a pull
  request. Applies to you.
- [GHUL.md](./GHUL.md) - language tutorial and reference.
- [README.md](./README.md) - project overview.
- [integration-tests/README.md](integration-tests/README.md) - integration test
  file formats and the capture workflow.

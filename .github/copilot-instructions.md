# Copilot & AI Agent Instructions

AI agents and other automated contributors must follow:

- [CONTRIBUTING.md](../CONTRIBUTING.md) - how to build, test, and raise a pull
  request. The authority, and it applies to automated contributors in full.
- [AGENTS.md](../AGENTS.md) - the additional rules for working without a human
  at the keyboard.
- [GHUL.md](../GHUL.md) - ghūl language reference. Read it; don't work from
  memory of the syntax.
- [README.md](../README.md) - project overview.
- [integration-tests/README.md](../integration-tests/README.md) - integration
  test file formats and the capture workflow.

**Summary:**

- All required tests must pass before a change is submitted.
- Any change in behaviour needs a test. Type-system changes need unit tests too.
- The compiler is self-hosting: `src/` is compiled by the previously published
  release, so a new language feature cannot be used in `src/` in the change that
  adds it.
- If a test fails and you cannot explain it, flag it for a human rather than
  working around it.
- Keep changes minimal and scoped to what was asked.

Follow the linked documents for the detail; this page is only a pointer.

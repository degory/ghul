# Build scripts
Scripts required for local and CI builds. Most of these scripts are internal to the build process, but `bootstrap.sh` and `coverage.sh` can be run directly.

## `bootstrap.sh`
Bootstraps the compiler by compiling it with itself, then checks that the result reproduces itself: it runs four pack-and-install passes and diffs the IL of pass 3 against pass 4, which should differ only in the version information carried in a custom attribute. Must be run with the working directory set to the root of the repo.

## `coverage.sh`
Measures how much of the compiler's own ghūl source each test suite executes: unit, integration, cross-assembly, and analysis.

The compiler is built with debug information so that a Portable PDB maps the emitted IL back to `.ghul` source. Unit tests call into the compiler in the same process, so coverage comes from `coverlet.collector` (referenced from `unit-tests.ghulproj`) through the standard VSTest data-collector protocol. The other three suites spawn the compiler as a separate process, so coverlet instruments the built assembly itself and every spawned process — including MSBuild's, for cross-assembly — runs the instrumented copy. This script only captures — each suite's Cobertura report lands in `coverage/` and the script stops there.

```sh
build/coverage.sh                                   # integration tests only
build/coverage.sh --suite all                       # every suite
build/coverage.sh --filter integration-tests/parse  # one subdirectory
```

Turning the captured reports into the HTML report is [degory/ghul-coverage-report](https://github.com/degory/ghul-coverage-report)'s job, not this script's: its own scheduled workflow checks out this repo, runs this script, and builds+deploys the report to [GitHub Pages](https://degory.github.io/ghul-coverage-report/) — `coverage-data-tool` builds the namespace/type/method breakdown and drives the compiler's own analyser for syntax highlighting and hover info, and `site/` (a VitePress project) renders that into the report.

Instrumentation slows the integration suite by roughly an order of magnitude, so coverage capture is a periodic job rather than part of the pull-request gate. Debug information is turned on per invocation through MSBuild properties, so ordinary builds and the released package are unaffected.

`--help` documents the remaining options.

# Build scripts
Scripts required for local and CI builds. Most of these scripts are internal to the build process, but `bootstrap.sh` and `coverage.sh` can be run directly.

## `bootstrap.sh`
Bootstraps the compiler by compiling it with itself, then checks that the result reproduces itself: it runs four pack-and-install passes and diffs the IL of pass 3 against pass 4, which should differ only in the version information carried in a custom attribute. Must be run with the working directory set to the root of the repo.

## `coverage.sh`
Measures how much of the compiler's own ghūl source the end-to-end test suites execute.

The compiler is built with debug information so that a Portable PDB maps the emitted IL back to `.ghul` source, coverlet rewrites the built assembly to record which sequence points are hit, and ReportGenerator merges the per-suite results. Coverage is attributed to `.ghul` files, so any tool that reads lcov or Cobertura can display it.

```sh
build/coverage.sh                                   # integration tests
build/coverage.sh --suite all                       # and cross-assembly tests
build/coverage.sh --filter integration-tests/parse  # one subdirectory
```

Results land in `coverage/report/`: `index.html` to browse, `lcov.info` for editor gutters, `Cobertura.xml` for other tools, and coverage badges. In VS Code, the Coverage Gutters extension picks up `lcov.info` without configuration — run `Coverage Gutters: Display Coverage`.

Instrumentation slows the integration suite by roughly an order of magnitude, so this is a periodic job rather than part of the pull-request gate; `.github/workflows/coverage.yml` runs it on a schedule. Debug information is turned on per invocation through MSBuild properties, so ordinary builds and the released package are unaffected.

Unit and analysis tests are not included. They run through `dotnet test` against `bin/` rather than the instrumented `publish/` tree, so they would need `coverlet.collector` wired into their project files. Until then, a low figure on a file means "not reached by the end-to-end suites" rather than "untested".

`--help` documents the remaining options.

# ghūl compiler integration tests

The directories under `integration-tests` form the main test suite for the [ghūl compiler](https://github.com/degory/ghul). Tests are executed using the [`ghul-test`](https://github.com/degory/ghul-test) snapshot test runner which is installed as a local .NET tool.

## Publishing the compiler

Each test calls the published compiler via the `ghul.json` file in the test directory. Before running any tests you must publish the compiler:

```sh
dotnet publish --output publish
```

The template `ghul.json` refers to `dotnet ../../../publish/ghul.dll` so the runner finds the freshly built compiler.

## Running tests

To run **all** integration tests:

```sh
dotnet ghul-test integration-tests
```

To run a single test directory:

```sh
dotnet ghul-test integration-tests/<test-folder>
```

If a test fails a `failed` file is left behind. You can rerun only the failed tests with:

```sh
./integration-tests/run-failed.sh
```

## Creating new tests

1. Run `./integration-tests/create.sh` and enter a new test name when prompted.
2. Edit the generated `.ghul` sources and `ghulflags` as needed.
3. Execute the test (it will fail initially):

   ```sh
   dotnet ghul-test integration-tests/<new-test>
   ```
4. Capture the produced output files as expectations:

   ```sh
   ./tasks/capture.sh integration-tests/<new-test>
   ```
5. Re-run the test and verify it now passes.
6. Commit the new test directory.

Each test directory contains a `.vscode/tasks.json` file with `Run test` (test task) and `Capture test expectation` (build task) to streamline this workflow from Visual Studio Code.

## Test folder structure

A test directory must contain one or more `.ghul` source files and a `ghulflags` file. Optional files influence behaviour:

| File | Purpose |
| --- | --- |
| `fail.expected` | If present, the build is expected to fail. The contents are ignored. |
| `err.expected` | Expected compiler error output. |
| `warn.expected` | Expected compiler warning output. |
| `run.expected` | Expected stdout from running the compiled binary. |
| `il.expected` | Expected IL disassembly output. |
| `ghul.json` | Configuration file pointing at the compiler (created from the template). |
| `disabled*` | Any file beginning with `disabled` causes the test to be skipped. |

### Capturing IL output

To assert that specific IL is generated, decorate the definition or statement you
want IL for with `@IL.output("il.out")`. The pragma captures the IL produced for
the following statement or block and writes it to `il.out`. When you capture test
expectations this file will be copied to `il.expected` so the test can compare the
generated IL on subsequent runs.

`out.il` files may appear if the compiler is run with `--keep-out-il`, but these
files are not used by the test runner.

## Expectation comparison workflow

1. The runner invokes the compiler using the arguments in `ghulflags` and the test sources. Compiler output goes to `compiler.out`.
2. Error and warning lines are `grep`ed into `err.grep` and `warn.grep`, sorted into `err.sort` and `warn.sort`, then compared to the `*.expected` files.
3. If compilation succeeds the test binary is executed and its output compared to `run.expected`.
4. If `il.expected` exists the generated `il.out` file is diffed as well.
5. Any mismatch leaves the test directory marked with a `failed` file and unified diffs describing the differences.

## Command line usage

```
ghul-test [--use-dotnet-build] <test-folder> [...]
```

Environment variables:

- `HOST` and `TARGET` &ndash; commands used to run the compiler and compiled program (default `dotnet`).
- `CI` &ndash; set to `1` or `true` for CI mode.
- `TEST_PROCESSES` &ndash; number of worker processes to use.

## Dependencies

`ghul-test` requires the standard Unix utilities `grep`, `sort`, `diff` and `ln` as well as a .NET 8 SDK.
### Visual Studio Code

Each test case is a mini ghul project in its own right and can be opened as a project folder in Visual Studio Code individually. It's generally better to open a test case in a separate Visual Studio Code instance, rather than editing its files from VSCode alongside the compiler (because having files open from multiple different ghul projects in the same VSCode instance can result in confusing/misleading messages from the ghul language extension).

#### Creating a new test case

With the ghul compiler folder open in Visual Studio Code, run the create test task:

`<Ctrl>+<Shift>+P` | `Tasks: Run task` | `Create new test`

Then enter a kebab-case name for the new test when prompted in the terminal window.

A new VSCode window will open pointing at the new test project

#### Running a test case

With a test case folder open in Visual Studio Code, run the default test task to execute the test:

`<Ctrl>+<Shift>+P` | `Tasks: Run task` | `Run test`

The test results will appear in the terminal window

**Note** VSCode has no standard key binding for running the default test, but you can configure a custom binding if you want to access this task more easily

#### Capturing test case expectations

Once you have a test case that generates the appropriate output, you need to capture that output as expectation files. If on a future test run the test produces different output to what was expected, the test runner will flag the test as failed

With a test case folder open in Visual Studio Code, run the default build task to execute the test:

`<Ctrl>+<Shift>+P` | `Tasks: Run task` | `Capture test expectations`

**Note** If you're using the standard VSCode key bindings you can also do this via `<Ctrl>+<Shift>+B`

### Command line

You can also run tests, capture test expectations and create new tests from the command line.

#### Creating a new test case

To create a new test case run `./integration-tests/create.sh` and enter a kebab-case name for the new test case when prompted

#### Running all tests

To run all tests, from the repo root directory run `./integration-tests/test.sh`

#### Running a specific test

To run a specific test run `./integration-tests/test.sh test-case-name`, where `test-case-name` is the name of the directory under integration-tests/cases containing that test's files

#### Capturing test case expectations

To capture expected test result for a test case, from the repo root directory run `./integration-tests/capture.sh test-case-name`

**Note** a test must have previously been run and have produced output before that output can be captured as the expected result)

**Note** the current working directory must be the repository root when running these scripts

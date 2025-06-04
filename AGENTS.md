All the tests should pass before raising a PR
The tests comprise:
1. unit tests `dotnet test unit-tests`
The unit tests are driven by MSTest.
The unit tests are minimal, have very poor coverage and are brittle. The existing tests need to pass, and may need to be fixed if impacted by code changes, but I wouldn't advise trying to add new ones. Coding unit tests in ghūl is awkward at best because ghūl has limited support for language features that frameworks like Moq take for granted.

2. bootstrap `./build/bootstrap.sh`
Bootstraps the compiler by compiling it with itself four times, and verifies that the IL for the third and fourth passes matches

3. integration tests `dotnet publish && dotnet ghul-test integration-tests`
The integration tests are snapshot based - expected errors, warnings, IL and/or compiled binary output are compared against canned expectation files. See integration-tests/README.md for more details. The compiler
The integration tests are roughly grouped in four subfolders:
 integration-tests/execution - for tests that compile a binary and assert it produces specific output
 integration-tests/il - for tests that produce IL assembly language and assert it matches expected IL
 integration-tests/parse - for tests that parse various syntax constructs, often asserting specific syntax errors or warnings are produced
 integration-tests/semantic - for tests that compile various constructs and either assert they compile without errors, or assert they result in specific semantic errors
New or changed functionality should be verified by new or updated integration tests. Place new tests in the appropriate sub-folder

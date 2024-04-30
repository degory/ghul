# Project Tests

This directory contains a collection of tests that are more comprehensive than the standard integration test cases. They either require building with the complete MSBuild process or are larger in scope.

Each test is organized into its own folder, which contains a ghūl project with an associated MSBuild `.ghulproj` file. To run these tests, `ghul-test` must be executed with the `--use-dotnet-build` flag.

For example:
```
ghul-test --use-dotnet-build
```

This ensures that the tests are built and executed using the full MSBuild process
# ghūl compiler

## Compiler for the [ghūl programming language](https://ghul.io)

### Latest compiler .NET tool package

[ghul.compiler](https://www.nuget.org/packages/ghul.compiler/)

### Latest release

[Release](https://github.com/degory/ghul/releases/latest)

### Continuous delivery status

[![workflow](https://github.com/degory/ghul/workflows/CI/badge.svg?branch=master)](https://github.com/degory/ghul/actions?query=workflow%3ACI)

## Host and target

The compiler is hosted on .NET and targets .NET

## Getting started

### Template ghūl application project

If you only want to use the compiler to build an application, as opposed to contributing to the development of the compiler itself, then take a look at the [ghūl console template](https://github.com/degory/ghul-console-template) repository

### Build time dependencies for the compiler itself
- Linux (native, WSL2, or in a container)
- The [.NET 6.0](https://dotnet.microsoft.com/download/dotnet/6.0) SDK
- Bash

See the [template application](https://github.com/degory/ghul-console-template) README for detailed instructions on setting up your build environment

### Optional dependencies

- [Visual Studio Code](https://code.visualstudio.com) will give you rich language support via the [ghūl VSCode language extension](https://marketplace.visualstudio.com/items?itemName=degory.ghul).

### Runtime dependencies for ghūl applications
- [.NET 6.0](https://dotnet.microsoft.com/download/dotnet/6.0)

### Building applications with ghūl

The [hello-world](https://github.com/degory/hello-world) project shows a small example ghūl program, with VSCode config and an example GitHub build workflow

### To build the compiler from Visual Studio Code

- Build the compiler: `<Ctrl>+<Shift>+B`
- Run all the integration tests: `<Ctrl>+<Shift>+P` | `Tasks: Run task` | `Run all integration tests`

### To build and test the compiler from the command line

- Build the compiler: `dotnet build`
- Run all unit tests: `dotnet test unit-tests`
- Run all integration tests: `dotnet tool run ghul-test integration-tests`
- Run a specific integration test: `dotnet tool run ghul-test integration-tests/<path-to-test-folder>`
- Capture a failed integration test's output as its new expected output: `./integration-tests/capture.sh test-case-folder-name`
- Bootstrap the compiler: `./build/bootstrap.sh`
- Start an interactive shell in the development container: `./build/dev.sh`

## Gotchas

This is an incomplete compiler for an experimental programming language. The CI/CD pipeline ensures that a released build will bootstrap and pass the test suite, but nevertheless some features are missing or buggy.

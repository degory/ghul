# ghūl compiler

## Compiler for the [ghūl programming language](https://www.ghul.io)

### Latest installer

[ghul.run](https://github.com/degory/ghul/releases/latest/downloads/ghul.run)

### Latest release

[Release](https://github.com/degory/ghul/releases/latest)

### Continuous delivery status

[![workflow](https://github.com/degory/ghul/workflows/CI/badge.svg?branch=master)](https://github.com/degory/ghul/actions?query=workflow%3ACI)


## Targets

The compiler targets .NET

## Getting started

### Template ghūl application project

If you only want to use the compiler to build an application, as opposed to contributing to the development of the compiler itself, then take a look at the [ghūl application template](https://github.com/degory/ghul-application-template) repository

### Required dependencies
- [Mono](https://www.mono-project.com/) to build .NET executables
- Bash shell

### Optional dependencies

- [Visual Studio Code](https://code.visualstudio.com) will give you rich language support via the [ghūl VSCode language extension](https://github.com/degory/ghul-vsce/releases).

### Building applications with ghūl

There is limited support right now for building ghūl applications other than the compiler itself. The [hello-world](https://github.com/degory/hello-world) project shows a small example ghūl program, with VSCode config and an example GitHub build workflow

### To build the compiler from Visual Studio Code

- Build the compiler: `<Ctrl>+<Shift>+B`
- Run all the tests: `<Ctrl>+<Shift>+P` | `Tasks: Run task` | `Run all tests`

### To build and test the compiler from the command line

- Build the compiler: `./build/build.sh`
- Run all tests: `./tests/test.sh`
- Run a specific test: `./tests/test.sh test-case-folder-name`
- Capture a failed test's output as its new expected output: `./tests/capture.sh test-case-folder-name`
- Bootstrap the compiler: `./build/bootstrap.sh`
- Start an interactive shell in the development container: `./build/dev.sh`

## Gotchas

This is an incomplete compiler for an experimental programming language. The CI/CD pipeline ensures that a released build will bootstrap and pass the test suite, but nevertheless some features are missing or buggy.

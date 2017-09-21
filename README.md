# ghūl compiler
Compiler for the ghūl programming language

[![Build Status](https://build.ghul.io/buildStatus/icon?job=ghul-ci)](https://build.ghul.io/job/ghul-ci)

# Getting started

Prerequisites:
- [Docker](https://www.docker.com) (any recent version should work)
- Bash shell (I develop on Linux but [GitBash](https://git-scm.com/download/win) should work on Windows)
- [Visual Studio Code](https://code.visualstudio.com) (not strictly required, but using VSCode gets you syntax highlighting + integrated builds with error highlighting via the [ghūl VSCode extension](https://github.com/degory/ghul-vsce/releases))

The compiler and any executables it produces currently require specific old versions of some dependencies that are difficult to get working on recent versions of Linux. These dependencies are all packaged in the `ghul/compiler` Docker image, so you do not have to deal with installing them directly, but the compiler needs to be built in, and be run in this container, and so do any compiled binaries.

To build and test from within Visual Studio Code:
- Build the compiler: CTRL+SHIFT+B
- Run all tests: CTRL+SHIFT+T
- Run a specific test: navigate to a test.ghul under test/cases/.../ then CTRL+SHIFT+T

To build and test from the command line:
- Build the compiler: `./dev-build.sh`
- Run all tests: `./dev-test.sh`
- Run a specific test: `./dev-test.sh test-case-name`
- Capture test output: `./dev-capture.sh test-case-name`
- Bootstrap the compiler: `./dev-bootstrap.sh`
- Start a shell in development container: `./dev.sh`



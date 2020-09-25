# ghūl compiler

## Compiler for the [ghūl programming language](https://www.ghul.io)

### Latest installer
[ghul.run](https://github.com/degory/ghul/releases/latest/downloads/ghul.run)

### Latest release
[Workflow](https://github.com/degory/ghul/releases/latest) [![Release](https://github.com/degory/ghul/workflows/Release/badge.svg?branch=master)](https://github.com/degory/ghul/actions?query=workflow%3ARelease)

### Template ghūl language project
[hello-world](https://github.com/degory/hello-world)

## Getting started

### Prerequisites

- Compiler source code (git clone this repo)
- [Docker](https://www.docker.com) to build native executables using the legacy LLVM back end
- [Mono](https://www.mono-project.com/) to build .NET executables
- Bash shell

### Optional

- [Visual Studio Code](https://code.visualstudio.com) will give you rich language support via the [ghūl VSCode extension](https://github.com/degory/ghul-vsce/releases)).
- The ghūl [hello-world](https://github.com/degory/hello-world) example project, which has a small example program, Visual Studio Code config for the ghūl language extension, and a VSCode build task

### To build from Visual Studio Code

- Build the compiler: `<Ctrl>+<Shift>+B`
- Run all the tests: `<Ctrl>+<Shift>+P` | `Tasks: Run task` | `Run all tests`

### To build and test from the command line

- Build the compiler: `./build/build.sh`
- Run all tests: `./tests/test.sh`
- Run a specific test: `./tests/test.sh test-case-folder-name`
- Capture a failed test's output as its new expected output: `./tests/capture.sh test-case-folder-name`
- Bootstrap the compiler: `./build/bootstrap.sh`
- Start an interactive shell in the development container: `./build/dev.sh`

## Targets

The compiler can target both .NET and native x86-64 Linux via LLVM. Note though that the native code target is deprecated and I'm concentrating on bootstrapping on .NET  

## Gotchas

### General

This is an incomplete compiler for an experimental programming language. The stable build should always be able to build itself, but many features are missing or buggy.

### Docker

Building for the LLVM native code target currently specific versions of some dependencies that are difficult to get working on recent versions of Linux. However, these dependencies are packaged in a container ([ghul/compiler:stable](https://hub.docker.com/r/ghul/compiler)) which the compiler back-end pulls and runs automatically, so you don't typically need to deal with this directly, but Docker does need to be on the PATH.

Compiled binaries can be run directly without Docker, provided the [L language runtime](https://github.com/degory/llc/releases) is installed. Alternatively, compiled binaries can also be run via Docker - dev.sh gets you a suitable shell.

### Transpilation

When compiling for the LLVM native code target, the compiler transpiles ghūl source code to [L](https://github.com/degory/llc) as an intermediate step and then that intermediate L source code is compiled down to LLVM bitcode before actual native code is produced. Most of the semantic analysis is repeated at the L level, which can make for confusing error reporting.

### Tests

The test suite is extremely limited. The main test case for the compiler is bootstrapping the compiler itself (which at >25K lines of code is non-trivial)

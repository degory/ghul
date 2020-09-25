# ghūl compiler

## Compiler for the [ghūl programming language](https://www.ghul.io)

### Latest installer

[ghul.run](https://github.com/degory/ghul/releases/latest/downloads/ghul.run)

### Latest release

[Release](https://github.com/degory/ghul/releases/latest)

### Template ghūl language project

[hello-world](https://github.com/degory/hello-world)

### Continuous delivery status

 [![workflow](https://github.com/degory/ghul/workflows/Release/badge.svg?branch=master)](https://github.com/degory/ghul/actions?query=workflow%3ARelease)

## Targets

The compiler can target both .NET and native x86-64 Linux via LLVM, however the native code target is deprecated and I'm concentrating solely on bootstrapping on .NET

## Getting started

### Required dependencies
- [Mono](https://www.mono-project.com/) to build .NET executables, and/or
- [Docker](https://www.docker.com) to build native executables using the legacy LLVM back end
- Boehm GC (libgc.so.1 libgc1c2)
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

### General

This is an incomplete compiler for an experimental programming language. The CD pipeline ensures that a released build will bootstrap and pass the test suite, but nevertheless some features are missing or buggy:
 - Parsing is stable
 - The LLVM based native code target is stable, but is deprecated in favour of the .NET target
 - Semantic analysis is fairly stable
 - The code generator for the .NET target is incomplete and buggy.

### Docker

The LLVM native code target has some dependencies that are difficult to install on recent versions of Linux (including LLVM 2.8 and a specific version of GCC). However, these dependencies are packaged in a container ([ghul/compiler:stable](https://hub.docker.com/r/ghul/compiler)) which the compiler back-end pulls and uses automatically, so you don't typically need to deal with this directly, but Docker does need to be on the PATH.

Compiled binaries can be run directly without Docker, provided the [L language runtime](https://github.com/degory/llc/releases) is installed. Alternatively, compiled binaries can also be run via Docker - dev.sh gets you a suitable shell.

### Transpilation

When compiling for the LLVM native code target, the compiler transpiles ghūl source code to [L](https://github.com/degory/llc) as an intermediate step and then that intermediate L source code is compiled down to LLVM bitcode before actual native code is produced. Most of the semantic analysis is repeated at the L level, which can make for confusing error reporting.


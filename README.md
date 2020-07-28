# ghūl compiler

Compiler for the [ghūl programming language](https://www.ghul.io)

Build ![CI](https://github.com/degory/ghul/workflows/CI/badge.svg?branch=master)

## Getting started

### Prerequisites

- Compiler source code (git clone this repo)
- [Docker](https://www.docker.com)
- Bash shell

### Optional

- [L Language runtime](https://github.com/degory/llc/releases) allows built ghūl binaries to run on Linux systems outside of the ghūl compiler Docker container
- [Visual Studio Code](https://code.visualstudio.com) will give you syntax coloring + integrated builds with error highlighting provided you install the [ghūl VSCode extension](https://github.com/degory/ghul-vsce/releases)). If you're running under Windows, you will need to [switch the integrated terminal to use bash](https://code.visualstudio.com/docs/editor/integrated-terminal)
- [mono](https://www.mono-project.com/docs/getting-started/install/linux/) if you want to try out ghūl's experimental CIL backend, which targets DotNET Core (you'll need mono's `ilasm` to produce CIL PE executables and either the mono runtime or DotNet Core 3.1 or 5.0 run them)
- The ghūl [hello-world](https://github.com/degory/hello-world) example project, which has a small example program, Visual Studio Code config for the ghūl lanugage extension, and a VSCode build task

### To build from Visual Studio Code

- Build the compiler: `<Ctrl>+<Shift>+B`
- Run all the tests: `<Ctrl>+<Shift>+P` | `Tasks: Run task` | `Run all tests`

### To build and test from the command line

- Build the compiler: `./build/build.sh`
- Run all tests: `./test/test.sh`
- Run a specific test: `./test/test.sh test-case-folder-name`
- Capture a failed test's output as its new expected output: `./test/capture.sh test-case-folder-name`
- Bootstrap the compiler: `./build/bootstrap.sh`
- Start an interactive shell in the development container: `./build/dev.sh`

## Gotchas

### General

This is an incomplete compiler for an experimental programming language. The stable build should always be able to build itself, but many features are missing or buggy.

### Docker

The compiler currently requires specific old versions of some dependencies that are difficult to get working on recent versions of Linux. These dependencies are all packaged in the [ghul/compiler](https://cloud.docker.com/swarm/ghul/repository/docker/ghul/compiler/general) Docker image, so you do not have to deal with installing them directly. The build scripts pull the latest stable compiler image automatically and call Docker to run the compiler. Compiled binaries can be run directly, outside of Docker, provided the [L language runtime](https://github.com/degory/llc/releases) is installed. Alternatively, compiled binaries can also be run via Docker - dev.sh gets you a suitable shell.

### Transpilation

The compiler currently transpiles ghūl source code to [L](https://github.com/degory/llc) (an older language of mine), and that intermediate L source code is compiled down to LLVM bitcode before actual native code is produced. Most of the semantic analysis is repeated at the L level, which can make for confusing error reporting. Transpilation is a temporary measure while the ghūl compiler back end is still in development.

### Tests

The test suite is extremely limited. The main test case for the compiler is bootstrapping the compiler itself (which at >25K lines of code is non-trivial)

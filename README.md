# ghūl compiler
Compiler for the [ghūl programming language](https://www.ghul.io)

[![Build Status](https://build.ghul.io/buildStatus/icon?job=ghul-ci)](https://build.ghul.io/job/ghul-ci)

## Getting started
### Prerequisites:
- Compiler source code (git clone this repo)
- [Docker](https://www.docker.com) (any recent version should work)
- Docker image with latest stable version of the ghūl compiler (run `./dev-pull.sh` or `docker pull ghul/compiler:latest`) 
- Bash shell. I develop on Linux but [GitBash](https://git-scm.com/download/win) or [Cygwin](https://cygwin.com/install.html)  should work on Windows,
- [Visual Studio Code](https://code.visualstudio.com) (not strictly required, but using VSCode gets you syntax coloring + integrated builds with error highlighting provided you install the [ghūl VSCode extension](https://github.com/degory/ghul-vsce/releases)). If you're running under Windows, you will need to [switch the integrated terminal to use bash](https://code.visualstudio.com/docs/editor/integrated-terminal)

### To build and test from within Visual Studio Code:
- Build the compiler: CTRL+SHIFT+B
- Run all tests: CTRL+SHIFT+T
- Run a specific test: navigate to a test.ghul under test/cases/.../ then CTRL+SHIFT+T

### To build and test from the command line:
- Build the compiler: `./dev-build.sh`
- Run all tests: `./dev-test.sh`
- Run a specific test: `./dev-test.sh test-case-name`
- Capture test output: `./dev-capture.sh test-case-name`
- Bootstrap the compiler: `./dev-bootstrap.sh`
- Start an interactive shell in the development container: `./dev.sh`

## Gotchas
### General
This is an incomplete compiler for an experimental programming language. The stable build should always be able to build itself, but many features are missing or buggy.

### Docker
The compiler and any executables it produces currently require specific old versions of some dependencies that are difficult to get working on recent versions of Linux. These dependencies are all packaged in the [ghul/compiler](https://cloud.docker.com/swarm/ghul/repository/docker/ghul/compiler/general) Docker image, so you do not have to deal with installing them directly, but the compiler needs to be both built in and  run in this container, as do any compiled binaries. dev.sh gets you a shell you can run binaries in.

### Transpilation
The compiler currently transpiles ghūl source code to [L](https://github.com/degory/llc) (an older language of mine), and that intermediate L source code is compiled down to LLVM bitcode before actual native code is produced. Most of the semantic analysis is done at the L level, which can make for confusing error reporting. Transpilation is a temporary measure while the ghūl compiler back end is still in development.

### Tests
The test suite is extremely limited. The main test case for the compiler is the compiler itself (which at >16K lines of code is already non-trivial)


# Build scripts
Scripts required for local and CI builds. Most of these scripts are internal to the build process, but `bootstrap.sh` can be run directly.

## `bootstrap.sh`
Bootstraps the compiler by compiling it with itself to produce a new version from the current source that is then tested and packaged in a Docker container. Must be run with the working directory set to the root of the repo.

The bootstrap process runs through 4 compilation passes:
1. **Pass 1**: Compiles the current source using the existing compiler installation
2. **Pass 2**: Compiles the current source using the compiler produced in Pass 1
3. **Pass 3**: Compiles the current source using the compiler produced in Pass 2
4. **Pass 4**: Compiles the current source using the compiler produced in Pass 3

After all passes, the script verifies that the IL output from Pass 3 and Pass 4 are identical (except for version information). This proves the compiler is self-hosting and produces consistent, stable output.

## Verification
To check if the compiler can bootstrap successfully, you can also run:
```bash
./verify-bootstrap.sh
```
This provides a user-friendly summary of the bootstrap process and its results.

# Build scripts
Scripts required for local and CI builds. Most of these scripts are internal to the build process, but `build.sh` and `bootstrap.sh` can be run directly.

## `build.sh`
Builds the compiler to produce a new `ghul` executable in the repository root. Must be run with working directory set to the root of the repo.

`./build/build.sh`

## `bootstrap.sh`
Boostraps the compiler by compiling it with itself to produce a new version from the current source that is then tested and packaged in a Docker container. Must be run with the working directory set to the root of the repo

The bootstrap steps are:
- Generate a build name based on the current branch, the build environment, and either a timestamp or a build environment supplied build number.
- Docker pull the stable version of the ghul compiler container
- Build the compiler using the stable compiler container and package in a new container named `ghul/compiler:<build-name>-bs-1`
- Build the compiler again with the new `ghul/compiler:<build-name>-bs-1` container and package in another new container called `ghul/compiler:<build-name>-bs-2`
- Build the compiler a third time using the new `ghul/compiler:<build-name>-bs-2` container, and package the result in a new container called `ghul/compiler:<build-name>`. This final container is the bootstrapped release candidate.
- Build the test runner with the stable compiler container
- Run the test suite against the release candidate compiler container

If this is a CI environment, the build is for a merge into the master branch, and the all tests pass, then also:
- Tag the release candidate container as `ghul/compiler:stable`

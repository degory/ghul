# Build scripts
Scripts required for local and CI builds. Most of these scripts are internal to the build process, but `bootstrap.sh` can be run directly.

## `bootstrap.sh`
Boostraps the compiler by compiling it with itself to produce a new version from the current source that is then tested and packaged in a Docker container. Must be run with the working directory set to the root of the repo

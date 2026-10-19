#!/usr/bin/env bash
#
# llvm-test-objects.sh - builds the object files the llvm tests link beside
# their program, from the fixture.ll each such test holds. The objects are not
# kept in the repository.
#
# Usage: build/llvm-test-objects.sh
#
# ghul-llvm is the one on the PATH, or the one GHUL_LLVM names.

set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
linker="${GHUL_LLVM:-ghul-llvm}"

find "$root/integration-tests" -name fixture.ll | while read -r source; do
    "$linker" --emit=obj "$source" -o "${source%.ll}.o"
done

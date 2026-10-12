#!/bin/bash
# Type-checks the compiler's own source for the llvm target, against the
# core library and runtime sources a native build compiles in. A gap in
# either, or a .NET-only declaration left uncarved, fails here rather than
# at the next native build of the compiler.
#
# usage: build/llvm-self-type-check.sh [<compiler dll> [<ghul-core> [<ghul-runtime>]]]
#
# The defaults are publish/ghul.dll and the library checkouts under
# libraries/, where CI puts them.

set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)

compiler=${1:-$root/publish/ghul.dll}
core=$(cd "${2:-$root/libraries/ghul-core}" && pwd)
runtime=$(cd "${3:-$root/libraries/ghul-runtime}" && pwd)

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

{
    echo --library-source
    echo "ghul-core@$(tr -d '[:space:]' < "$core/VERSION")=$core"
    find "$core/src" -name '*.ghul' | sort

    echo --library-source
    echo "ghul-runtime@$(tr -d '[:space:]' < "$runtime/VERSION")=$runtime"

    while read -r file; do
        if [ -n "$file" ]; then
            echo "$runtime/$file"
        fi
    done < "$runtime/wasm-sources.rsp"
} > "$work/libraries.rsp"

for directory in src wasm/src llvm/src analysis-protocol/src; do
    find "$root/$directory" -name '*.ghul' -not -path '*/bin/*' -not -path '*/obj/*'
done | sort > "$work/sources.rsp"

echo "type-checking $(wc -l < "$work/sources.rsp") files for llvm with $compiler"

cd "$root"

set +e
output=$(dotnet "$compiler" --target llvm --type-check --underscore-access legacy @"$work/libraries.rsp" @"$work/sources.rsp" 2>&1)
status=$?
set -e

# Warnings are the .NET build's too, and reported there; what fails here is
# an error.
printf '%s\n' "$output" | grep -v ': warn: ' || true

exit $status

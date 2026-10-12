#!/bin/bash
# Writes the response files that compile the compiler's own source for the
# llvm target: libraries.rsp names the core library and runtime sources, and
# sources.rsp the compiler's. Shared by llvm-self-type-check.sh and
# llvm-bootstrap.sh.
#
# usage: build/llvm-self-sources.sh <output directory> <ghul-core> <ghul-runtime>

set -euo pipefail

if [ $# -ne 3 ]; then
    echo "usage: build/llvm-self-sources.sh <output directory> <ghul-core> <ghul-runtime>" >&2
    exit 2
fi

root=$(cd "$(dirname "$0")/.." && pwd)

output=$1
core=$(cd "$2" && pwd)
runtime=$(cd "$3" && pwd)

mkdir -p "$output"

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
} > "$output/libraries.rsp"

for directory in src wasm/src llvm/src analysis-protocol/src; do
    find "$root/$directory" -name '*.ghul' -not -path '*/bin/*' -not -path '*/obj/*'
done | sort > "$output/sources.rsp"

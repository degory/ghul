#!/bin/bash
# Checks that the compiler reproduces itself on the wasm target, as
# llvm-bootstrap.sh does on llvm: the compiler builds a wasm compiler from
# its own source, that compiler, run by Node, builds the same source again,
# and the two passes must write the same module and the same loader.
#
# usage: build/wasm-bootstrap.sh [<compiler dll> [<ghul-core> [<ghul-runtime>]]]
#
# The defaults are publish/ghul.dll and the library checkouts under
# libraries/, where CI puts them. Node 24 or later has to be on the PATH;
# NODE_OPTIONS passes it options. The passes are written to a temporary
# directory, or to WASM_BOOTSTRAP_DIR where it is set, which is then kept.

set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)

compiler=${1:-$root/publish/ghul.dll}
core=${2:-$root/libraries/ghul-core}
runtime=${3:-$root/libraries/ghul-runtime}

if [ -n "${WASM_BOOTSTRAP_DIR:-}" ]; then
    work=$WASM_BOOTSTRAP_DIR
    mkdir -p "$work"
else
    work=$(mktemp -d)
    trap 'rm -rf "$work"' EXIT
fi

"$root/build/llvm-self-sources.sh" "$work" "$core" "$runtime"

cd "$root"

# Builds the compiler into <directory>/ghul.wasm and ghul.mjs. Both passes
# use the same names, since the loader names the module it loads.
build() {
    local name=$1
    local directory=$work/$name
    shift

    mkdir -p "$directory"

    local start=$(date +%s)

    if ! "$@" --target wasm --underscore-access legacy -o "$directory/ghul" @"$work/libraries.rsp" @"$work/sources.rsp" > "$work/$name.log" 2>&1; then
        grep -v ': warn: ' "$work/$name.log" || true
        echo "$name failed"
        exit 1
    fi

    echo "$name: $(( $(date +%s) - start ))s"
}

build pass-1 dotnet "$compiler"
build pass-2 node "$work/pass-1/ghul.mjs"

status=0

for file in ghul.wasm ghul.mjs; do
    if cmp -s "$work/pass-1/$file" "$work/pass-2/$file"; then
        echo "$file is identical"
    else
        echo "$file differs"
        status=1
    fi
done

exit $status

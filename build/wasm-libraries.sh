#!/usr/bin/env bash
#
# wasm-libraries.sh - write the response file that gives a wasm build the
# core library and the runtime.
#
# A program built for the wasm target loads no assemblies: what ghul-core
# and ghul-runtime supply on .NET is compiled into the module from their
# sources, each declared with --library-source as ghul-cli declares them.
# The integration tests that run under wasm through a `targets` file get the
# file through ghul-test's --target-flags, and so does anything else that
# builds a program for the target by hand.
#
# Usage: build/wasm-libraries.sh <ghul-core-dir> <ghul-runtime-dir> <out.rsp>
#
# The paths written are absolute, since the file is read from whichever
# directory the build happens in.

set -euo pipefail

if [ $# -ne 3 ]; then
    echo "usage: build/wasm-libraries.sh <ghul-core-dir> <ghul-runtime-dir> <out.rsp>" >&2
    exit 2
fi

core="$(cd "$1" && pwd)"
runtime="$(cd "$2" && pwd)"
out="$3"

for dir in "$core" "$runtime"; do
    if [ ! -f "$dir/VERSION" ]; then
        echo "wasm-libraries: no VERSION in $dir" >&2
        exit 1
    fi
done

if [ ! -f "$runtime/wasm-sources.rsp" ]; then
    echo "wasm-libraries: no wasm-sources.rsp in $runtime" >&2
    exit 1
fi

core_version=$(tr -d '[:space:]' < "$core/VERSION")
runtime_version=$(tr -d '[:space:]' < "$runtime/VERSION")

{
    echo "--library-source"
    echo "ghul-core@$core_version=$core"
    find "$core/src" -name '*.ghul' | sort
    echo "--library-source"
    echo "ghul-runtime@$runtime_version=$runtime"
    while read -r file; do
        [ -n "$file" ] && echo "$runtime/$file"
    done < "$runtime/wasm-sources.rsp"
} > "$out"

echo "wasm-libraries: wrote $out (ghul-core $core_version, ghul-runtime $runtime_version)"

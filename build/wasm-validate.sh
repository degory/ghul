#!/usr/bin/env bash
#
# wasm-validate.sh - hand every module the wasm integration tests build
# to an engine.
#
# ghul-test compiles each test built for the wasm target and compares
# what the compiler said and the text form it wrote, but it has no
# engine, and it deletes a passing test's module. So a module the tests
# accept may still be one an engine rejects. This script builds each
# test's module again, with the compiler in publish/, and asks Node
# about it through WebAssembly.validate.
#
# Usage: build/wasm-validate.sh [test-root]
#        (default: integration-tests; run from the repository root
#        after `dotnet publish --output publish/`)
#
# Fails when Node is missing, when a test that should build a module
# does not, or when any module is rejected.

set -uo pipefail

root="${1:-integration-tests}"
target=wasm
compiler="$(pwd)/publish/ghul.dll"

if ! command -v node >/dev/null 2>&1; then
    echo "wasm-validate: node is not on the PATH" >&2
    exit 1
fi

if [ ! -f "$compiler" ]; then
    echo "wasm-validate: no compiler at $compiler; publish first" >&2
    exit 1
fi

scratch="$(mktemp -d)"
trap 'rm -rf "$scratch"' EXIT

checked=0
failed=0

# Every test under $root built for $target: one whose ghulflags name
# `--target $target`, or whose `targets` file lists it, in which case the
# flag is added as ghul-test adds it. Each is printed as its directory and
# its flags, tab-separated. A `.targets` directory holds ghul-test's own
# copies of a test, not tests.
tests_for_target() {
    find "$root" -name ghulflags -not -path "*/.targets/*" | sort | while IFS= read -r flags_file; do
        dir="$(dirname "$flags_file")"
        flags="$(tr "\n" " " < "$flags_file")"

        if [ -f "$dir/targets" ] && grep -qw "$target" "$dir/targets"; then
            printf "%s\t%s --target %s\n" "$dir" "$flags" "$target"
        elif [[ " $flags " == *" --target $target "* ]]; then
            printf "%s\t%s\n" "$dir" "$flags"
        fi
    done
}

while IFS=$'\t' read -r dir flags_text; do
    dir="$(cd "$dir" && pwd)"

    if [ -e "$dir/fail.expected" ] || [ -e "$dir/fail.$target.expected" ] || compgen -G "$dir/disabled*" >/dev/null; then
        continue
    fi

    out="$scratch/$checked"
    mkdir -p "$out"

    read -r -a flags <<< "$flags_text"

    # Compiled from the test's own directory, as ghul-test compiles it, so
    # a path its ghulflags name is read from there.
    if ! (cd "$dir" && dotnet "$compiler" "${flags[@]}" -o "$out/module.wasm" ./*.ghul) >"$out/compiler.out" 2>&1; then
        echo "wasm-validate: $dir did not compile:" >&2
        head -5 "$out/compiler.out" >&2
        failed=$((failed + 1))
    elif ! node -e '
        const bytes = require("fs").readFileSync(process.argv[1]);
        new WebAssembly.Module(bytes);
    ' "$out/module.wasm" 2>"$out/validate.err"; then
        echo "wasm-validate: $dir: $(grep -m1 CompileError "$out/validate.err" || head -1 "$out/validate.err")" >&2
        failed=$((failed + 1))
    fi

    checked=$((checked + 1))
done < <(tests_for_target)

echo "wasm-validate: $checked modules checked, $failed failed"

[ "$failed" -eq 0 ]

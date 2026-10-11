#!/usr/bin/env bash
#
# llvm-validate.sh - hand every module the llvm integration tests build
# to LLVM, and run the ones that say what they exit with.
#
# ghul-test compiles each test built for the llvm target and compares
# what the compiler said, but it does not assemble the module the compiler
# wrote, and it does not run a native executable on CI, which has no
# ghul-llvm. So a module the tests accept may still be one LLVM rejects.
# This script builds each test's module again, with the compiler in
# publish/, and has ghul-llvm verify and compile it to an object. A test
# with an `exit.expected` is also built as an executable and run, with its
# `input` as standard input where it has one and each line of its
# `arguments` as a command-line argument; its exit status is compared,
# and its standard output too where it has an `output.expected`.
#
# ghul-llvm is found on the PATH unless GHUL_LLVM names it.
#
# Usage: build/llvm-validate.sh [test-root]
#        (default: integration-tests; run from the repository root
#        after `dotnet publish --output publish/`)
#
# Fails when ghul-llvm is missing, when a test that should build a module
# does not, when any module is rejected, or when an executable exits with
# a status other than the one its test expects.

set -uo pipefail

root="${1:-integration-tests}"
target=llvm
compiler="$(pwd)/publish/ghul.dll"
ghul_llvm="${GHUL_LLVM:-ghul-llvm}"

if ! command -v "$ghul_llvm" >/dev/null 2>&1; then
    echo "llvm-validate: $ghul_llvm is not on the PATH; set GHUL_LLVM" >&2
    exit 1
fi

if [ ! -f "$compiler" ]; then
    echo "llvm-validate: no compiler at $compiler; publish first" >&2
    exit 1
fi

scratch="$(mktemp -d)"
trap 'rm -rf "$scratch"' EXIT

checked=0
ran=0
failed=0

# Every test under $root whose ghulflags name `--target $target`, printed
# as its directory and its flags, tab-separated. A test that runs under the
# target through a `targets` file is left to ghul-test, which builds it with
# the core library and runs it, so there is nothing an engine could add. A
# `.targets` directory holds ghul-test's own copies of a test, not tests.
tests_for_target() {
    find "$root" -name ghulflags -not -path "*/.targets/*" | sort | while IFS= read -r flags_file; do
        dir="$(dirname "$flags_file")"
        flags="$(tr "\n" " " < "$flags_file")"

        if [[ " $flags " == *" --target $target "* ]]; then
            printf "%s\t%s\n" "$dir" "$flags"
        fi
    done
}

while IFS=$'\t' read -r dir flags_text; do
    dir="$(cd "$dir" && pwd)"

    if [ -e "$dir/fail.expected" ] || compgen -G "$dir/disabled*" >/dev/null; then
        continue
    fi

    out="$scratch/$checked"
    mkdir -p "$out"

    read -r -a flags <<< "$flags_text"

    checked=$((checked + 1))

    if ! (cd "$dir" && dotnet "$compiler" "${flags[@]}" --library -o "$out/module.ll" ./*.ghul) >"$out/compiler.out" 2>&1; then
        echo "llvm-validate: $dir did not compile:" >&2
        head -5 "$out/compiler.out" >&2
        failed=$((failed + 1))
        continue
    fi

    if ! "$ghul_llvm" --emit=obj "$out/module.ll" -o "$out/module.o" >"$out/ghul-llvm.out" 2>&1; then
        echo "llvm-validate: LLVM rejected the module built from $dir:" >&2
        head -10 "$out/ghul-llvm.out" >&2
        failed=$((failed + 1))
        continue
    fi

    if [ ! -f "$dir/exit.expected" ]; then
        continue
    fi

    executable=()

    for flag in "${flags[@]}"; do
        if [ "$flag" != "--library" ]; then
            executable+=("$flag")
        fi
    done

    if ! (cd "$dir" && GHUL_LLVM="$ghul_llvm" dotnet "$compiler" "${executable[@]}" -o "$out/program" ./*.ghul) >"$out/link.out" 2>&1; then
        echo "llvm-validate: $dir did not link:" >&2
        head -10 "$out/link.out" >&2
        failed=$((failed + 1))
        continue
    fi

    ran=$((ran + 1))

    input="/dev/null"

    if [ -f "$dir/input" ]; then
        input="$dir/input"
    fi

    arguments=()

    if [ -f "$dir/arguments" ]; then
        mapfile -t arguments < "$dir/arguments"
    fi

    "$out/program" "${arguments[@]}" < "$input" > "$out/output" 2> "$out/errors"
    status=$?
    expected="$(tr -d '[:space:]' < "$dir/exit.expected")"

    if [ "$status" != "$expected" ]; then
        echo "llvm-validate: $dir exited with $status, expected $expected" >&2
        failed=$((failed + 1))
    fi

    if [ -f "$dir/output.expected" ] && ! diff -u "$dir/output.expected" "$out/output" >&2; then
        echo "llvm-validate: $dir wrote other output than output.expected" >&2
        failed=$((failed + 1))
    fi
done < <(tests_for_target)

echo "llvm-validate: $checked modules checked, $ran run, $failed failed"

[ "$failed" = 0 ]

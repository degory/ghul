#!/usr/bin/env bash
#
# cross-target-update.sh - refresh the committed cross-target lists from a
# run of the cross-target workflow: each target's list of passing tests
# becomes the tests that run passed, and its times the times that run took.
#
# Usage: build/cross-target-update.sh <run-id>
#
# Needs gh, signed in to read ghul-lang/ghul's workflow runs. Changes
# build/cross-target/<target>-passing.txt and <target>-times.tsv for each
# target the run tested; commit them as an ordinary change.

set -euo pipefail
export LC_ALL=C

if [ $# -ne 1 ]; then
    echo "usage: build/cross-target-update.sh <run-id>" >&2
    exit 2
fi

here="$(cd "$(dirname "$0")" && pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

gh run download "$1" --repo ghul-lang/ghul --pattern 'results-*' --dir "$work"

"$here/cross-target-report.sh" "$work" "$1" > /dev/null || true

for target in wasm llvm; do
    if [ -f "$work/$target-passed.txt" ] && [ -s "$work/$target-passed.txt" ]; then
        cp "$work/$target-passed.txt" "$here/cross-target/$target-passing.txt"
        cp "$work/$target-times.tsv" "$here/cross-target/$target-times.tsv"
        echo "$target: $(wc -l < "$here/cross-target/$target-passing.txt") tests listed as passing"
    fi
done

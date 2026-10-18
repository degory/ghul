#!/usr/bin/env bash
#
# cross-target-report.sh - merge the shards of a cross-target run into one
# report, in Markdown, against the committed lists of tests each target
# passes.
#
# For each target the report puts first the tests the list says pass and
# that failed, each with the first lines of what ghul-test said about it;
# then the tests that ran without being listed, if any, and that passed,
# with the command that adds them; then the counts.
#
# Usage: build/cross-target-report.sh <results-dir> [<run-id>]
#
# <results-dir> holds one directory per shard, named results-<target>-<n>,
# each with the shard's ghul-test output as results.txt and its events log as
# events.txt. Writes the report to standard output, and each target's
# per-test times to <results-dir>/<target>-times.tsv and the tests it passed
# to <results-dir>/<target>-passed.txt. Exits 1 where a target regressed.

set -euo pipefail
export LC_ALL=C
shopt -s nullglob

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    echo "usage: build/cross-target-report.sh <results-dir> [<run-id>]" >&2
    exit 2
fi

results="$1"
run_id="${2:-<run-id>}"
here="$(cd "$(dirname "$0")" && pwd)"
regressed=0

# The targets the run has results for, in a fixed order.
targets=()
for target in wasm llvm; do
    if compgen -G "$results/results-$target-*" > /dev/null; then
        targets+=("$target")
    fi
done

echo "# Cross-target execution tests"
echo

if [ ${#targets[@]} -eq 0 ]; then
    echo "No shard reported any results."
    exit 1
fi

for target in "${targets[@]}"; do
    listed="$here/cross-target/$target-passing.txt"
    passed="$results/$target-passed.txt"
    failed="$results/$target-failed.txt"
    details="$results/$target-details.txt"

    : > "$passed"
    : > "$failed"
    : > "$details"

    # Each failure's ghul-test lines: the `fail:` line and up to eight of
    # the indented lines under it, with the test's path first.
    for shard in "$results"/results-"$target"-*; do
        [ -f "$shard/results.txt" ] || continue

        awk -v passed="$passed" -v failed="$failed" -v details="$details" -v target="$target" '
            function path_of(rest,    p) {
                p = rest
                sub(/\[[a-z]+\].*$/, "", p)
                sub(/:.*$/, "", p)
                return p
            }

            /(✅|❌) (pass|fail): / {
                current = ""
                rest = $0
                sub(/^.*(pass|fail): /, "", rest)

                if ($0 ~ /pass: /) {
                    print path_of(rest) >> passed
                } else {
                    current = path_of(rest)
                    taken = 0
                    print current >> failed
                    reason = rest
                    sub(/^[^:]*: /, "", reason)
                    print current "\t" reason >> details
                }

                next
            }

            current != "" && /^    / && taken < 8 {
                line = $0
                sub(/^    /, "", line)

                if (line != "" && line != "!!! failed !!!") {
                    print current "\t" line >> details
                    taken++
                }

                next
            }

            { current = "" }
        ' "$shard/results.txt"
    done

    sort -u -o "$passed" "$passed"
    sort -u -o "$failed" "$failed"

    # Per-test times from the shards' events logs: a test's `start` to its
    # `pass` or `fail`, in milliseconds.
    events=("$results"/results-"$target"-*/events.txt)

    cat "${events[@]}" /dev/null |
        awk '
            $2 == "start" { path = $4; sub(/\[[a-z]+\]$/, "", path); started[path] = $1 }
            ($2 == "pass" || $2 == "fail") {
                path = $4; sub(/\[[a-z]+\]$/, "", path)
                if (path in started) { print path "\t" ($1 - started[path]) }
            }
        ' | sort -u > "$results/$target-times.tsv"

    regressions="$(comm -12 <(sort -u "$listed" 2>/dev/null || true) "$failed")"
    missing="$(comm -23 <(sort -u "$listed" 2>/dev/null || true) <(sort -u "$passed" "$failed"))"
    newly="$(comm -13 <(sort -u "$listed" 2>/dev/null || true) "$passed")"

    count() { if [ -z "$1" ]; then echo 0; else printf '%s\n' "$1" | wc -l; fi; }

    echo "## $target"
    echo

    if [ -n "$regressions" ]; then
        regressed=1
        echo "### $(count "$regressions") listed as passing, now failing"
        echo

        while IFS= read -r test; do
            echo "**$test**"
            echo
            echo '```'
            awk -F'\t' -v t="$test" '$1 == t { sub(/^[^\t]*\t/, ""); print }' "$details"
            echo '```'
            echo
        done <<< "$regressions"
    else
        echo "No test listed as passing failed."
        echo
    fi

    if [ -n "$missing" ]; then
        regressed=1
        echo "### $(count "$missing") listed as passing, not reported"
        echo
        echo "A shard ended before reaching these, or the test is gone:"
        echo
        printf '%s\n' "$missing" | head -n 50 | sed 's/^/- /'

        if [ "$(count "$missing")" -gt 50 ]; then
            echo "- and $(( $(count "$missing") - 50 )) more"
        fi

        echo
    fi

    if [ -n "$newly" ]; then
        echo "### $(count "$newly") passing, not yet listed"
        echo
        printf '%s\n' "$newly" | sed 's/^/- /'
        echo
        echo "To list every test this run passed, and refresh the times shards are planned from:"
        echo
        echo '```'
        echo "build/cross-target-update.sh $run_id"
        echo '```'
        echo
    fi

    echo "### counts"
    echo
    echo "| | tests |"
    echo "|---|---|"
    echo "| passed | $(count "$(cat "$passed")") |"
    echo "| failed | $(count "$(cat "$failed")") |"
    echo "| listed as passing | $(count "$(cat "$listed" 2>/dev/null || true)") |"
    echo "| regressions | $(count "$regressions") |"
    echo "| newly passing | $(count "$newly") |"
    echo
done

exit $regressed

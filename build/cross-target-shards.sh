#!/usr/bin/env bash
#
# cross-target-shards.sh - divide the execution tests between shards so each
# shard takes about the same time to run for a target.
#
# Every directory under integration-tests/execution that holds a .ghul file is
# a test. Each takes the time build/cross-target/<target>-times.tsv records
# for it, or the median of the recorded times where it has none, and the
# tests are dealt longest first to whichever shard has the least time so far.
#
# Usage: build/cross-target-shards.sh <target> <count> <out-dir>
#
# Writes <out-dir>/<target>-<n>.txt for n from 1 to <count>, one test
# directory a line, and prints each shard's expected seconds.

set -euo pipefail
export LC_ALL=C

if [ $# -ne 3 ]; then
    echo "usage: build/cross-target-shards.sh <target> <count> <out-dir>" >&2
    exit 2
fi

target="$1"
count="$2"
out="$3"
here="$(cd "$(dirname "$0")" && pwd)"
root="$(dirname "$here")"
times="$here/cross-target/$target-times.tsv"

mkdir -p "$out"

(cd "$root" && find integration-tests/execution -name '*.ghul' -printf '%h\n' | sort -u) |
    awk -v times="$times" -v count="$count" -v out="$out" -v target="$target" '
        BEGIN {
            recorded = 0

            while ((getline line < times) > 0) {
                split(line, field, "\t")
                ms[field[1]] = field[2] + 0
                sorted[++recorded] = field[2] + 0
            }

            # The median of what was recorded, for a test with no time yet.
            if (recorded > 0) {
                asort(sorted)
                median = sorted[int((recorded + 1) / 2)]
            } else {
                median = 1000
            }
        }

        {
            tests[++n] = $0
            cost[n] = ($0 in ms) ? ms[$0] : median
        }

        END {
            # Longest first, each to the shard with the least time so far.
            for (i = 1; i <= n; i++) {
                order[i] = i
            }

            for (i = 2; i <= n; i++) {
                j = i

                while (j > 1 && cost[order[j - 1]] < cost[order[j]]) {
                    swap = order[j]; order[j] = order[j - 1]; order[j - 1] = swap
                    j--
                }
            }

            for (s = 1; s <= count; s++) {
                load[s] = 0
                printf "" > (out "/" target "-" s ".txt")
            }

            for (i = 1; i <= n; i++) {
                best = 1

                for (s = 2; s <= count; s++) {
                    if (load[s] < load[best]) {
                        best = s
                    }
                }

                load[best] += cost[order[i]]
                print tests[order[i]] >> (out "/" target "-" best ".txt")
            }

            for (s = 1; s <= count; s++) {
                printf "%s shard %d: about %d s\n", target, s, load[s] / 1000
            }
        }'

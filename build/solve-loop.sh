#!/bin/bash
# Drive the combined-solve prototype to a fixpoint over a build.
#
# Each round is one ordinary build of the project in the current
# directory, run with GHUL_SOLVE_KILLS_IN naming the kills accumulated
# so far and GHUL_SOLVE_KILLS_OUT collecting the fact-crossing pairs the
# round's solved effect relations could not discharge. New kills are
# merged in and the build repeats until a round emits nothing new.
#
# Usage: build/solve-loop.sh <state-dir> [build command...]
#
# The state directory keeps kills.N and log.N per round. The build
# command defaults to `dotnet build`; whatever it is, it must resolve
# the compiler this prototype was built into.

set -euo pipefail

state="${1:?state directory}"
shift

if [ $# -eq 0 ]; then
    set -- dotnet build -v q
fi

mkdir -p "$state"

kills="$state/kills.all"
: > "$kills"

round=1
max_rounds="${SOLVE_MAX_ROUNDS:-8}"

while [ "$round" -le "$max_rounds" ]; do
    out="$state/kills.$round"
    log="$state/log.$round"

    rm -f "$out"

    echo "round $round: consuming $(wc -l < "$kills") kills"

    GHUL_SOLVE_KILLS_IN="$kills" GHUL_SOLVE_KILLS_OUT="$out" "$@" > "$log" 2>&1 || true

    touch "$out"

    new=$(comm -23 <(sort -u "$out") <(sort -u "$kills") | wc -l)

    echo "round $round: $new new kills, $(grep -c ': error' "$log" || true) errors, $(grep -c ': warn' "$log" || true) warnings"

    if [ "$new" -eq 0 ]; then
        echo "fixpoint after $round round(s)"
        exit 0
    fi

    sort -u "$out" "$kills" > "$kills.next"
    mv "$kills.next" "$kills"

    round=$((round + 1))
done

echo "no fixpoint within $max_rounds rounds"
exit 1

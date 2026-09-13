#!/usr/bin/env bash
# Compares two of the oracle's --json reports and prints what changed, as
# Markdown: every program whose verdict differs, and every program new to
# the corpus whose verdict is not `=` or `·`. A program that has left the
# corpus is not a finding, and neither is a new one that resolved as its
# inferred types say. Prints nothing when nothing changed, so a caller can
# test the output for emptiness.
#
#   compare-runs.sh <previous.json> <current.json>
#
# A missing previous report compares as an empty one.
set -euo pipefail

previous=${1:?previous report}
current=${2:?current report}

if [ -f "${previous}" ]; then
  previous_programs=$(jq '[.programs[] | {key: .name, value: .verdict}] | from_entries' "${previous}")
else
  previous_programs='{}'
fi

current_programs=$(jq '[.programs[] | {key: .name, value: .verdict}] | from_entries' "${current}")

jq -rn --argjson before "${previous_programs}" --argjson after "${current_programs}" '
  ($after | keys) as $is
  | [ $is[] | select(($before[.] != null) and ($before[.] != $after[.]))
      | "- `\($before[.])` → `\($after[.])` \(.)" ]
    + [ $is[] | select(($before[.] == null) and ($after[.] != "=") and ($after[.] != "·"))
      | "- new `\($after[.])` \(.)" ]
  | .[]
'

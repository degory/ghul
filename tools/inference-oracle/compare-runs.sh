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

# A corpus of a thousand programs is too long for an argument, so the
# reports reach jq as files.
if [ -f "${previous}" ]; then
  before=${previous}
else
  before=$(mktemp)
  echo '{"programs": []}' > "${before}"
fi

jq -rn --slurpfile before "${before}" --slurpfile after "${current}" '
  ($before[0].programs | map({key: .name, value: .verdict}) | from_entries) as $before
  | ($after[0].programs | map({key: .name, value: .verdict}) | from_entries) as $after
  | ($after | keys) as $is
  | [ $is[] | select(($before[.] != null) and ($before[.] != $after[.]))
      | "- `\($before[.])` → `\($after[.])` \(.)" ]
    + [ $is[] | select(($before[.] == null) and ($after[.] != "=") and ($after[.] != "·"))
      | "- new `\($after[.])` \(.)" ]
  | .[]
'

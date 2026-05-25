#!/usr/bin/env bash
#
# Drive the ghūl analyser through a long stream of random edits and queries
# against the compiler's own source tree, looking for hangs / crashes /
# thrown exceptions. Analysis mode should never throw — a legitimately-empty
# result is fine.
#
# Usage: ./run-soak.sh [extra args passed to analysis-soak.dll]
#
# Examples:
#   ./run-soak.sh --duration 60                         # one-minute smoke pass
#   ./run-soak.sh --iterations 5000 --seed 42           # reproducible 5k-iter run
#   ./run-soak.sh --edit-mode all --duration 600        # 10-minute mixed-edit soak
#   ./run-soak.sh --exit-on-failure --read-timeout-ms 10000
#
set -euo pipefail

cd "$(dirname "$0")"

echo "==> building analysis-soak (and the compiler under test)"
dotnet build analysis-soak.ghulproj -c Debug

SOAK_DLL="$(find bin -name analysis-soak.dll -path '*net8.0*' | head -1)"
if [ -z "$SOAK_DLL" ]; then
  echo "could not locate analysis-soak.dll after build" >&2
  exit 1
fi
SOAK_DLL="$(realpath "$SOAK_DLL")"

dotnet "$SOAK_DLL" "$@"

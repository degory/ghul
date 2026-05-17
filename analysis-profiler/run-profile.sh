#!/usr/bin/env bash
#
# Drive the ghūl analyser through a realistic editor-request workload and
# profile it. Produces:
#   profile-report.md                request-timing report (plain run)
#   profile-report-traced.md         request-timing report (traced run)
#   analyser-trace.speedscope.json   method-level sampling flamegraph
#                                    (open at https://speedscope.app)
#   analyser-hotspots.txt            top methods by self / total time
#
# Usage: ./run-profile.sh [plain|trace|both] [--quick]
#
set -euo pipefail

cd "$(dirname "$0")"

MODE="${1:-both}"
WORKLOAD="${2:-}"

# --show-analysis-stats: have the spawned analyser emit its periodic
#   per-command / per-pass TIMERS dump, captured into the report appendix.
# --no-analysis-heap-watchdog: suppress the watchdog's post-compile heap
#   sampling. It forces a full GC after every compile, which otherwise
#   dominates the trace (≈37% of CPU) and masks the genuine hotspots.
export ANALYSER_EXTRA_ARGS="--show-analysis-stats --no-analysis-heap-watchdog"

echo "==> building analysis-profiler (and the compiler under test)"
dotnet build analysis-profiler.ghulproj -c Debug

PROFILER_DLL="$(find bin -name analysis-profiler.dll -path '*net8.0*' | head -1)"
if [ -z "$PROFILER_DLL" ]; then
  echo "could not locate analysis-profiler.dll after build" >&2
  exit 1
fi
PROFILER_DLL="$(realpath "$PROFILER_DLL")"

run_plain() {
  echo "==> plain run — request-timing report only"
  dotnet "$PROFILER_DLL" --out profile-report.md $WORKLOAD
  echo "==> wrote profile-report.md"
}

run_trace() {
  echo "==> traced run — dotnet-trace method sampling"

  if ! command -v dotnet-trace >/dev/null 2>&1; then
    echo "==> installing dotnet-trace"
    dotnet tool install -g dotnet-trace
  fi
  export PATH="$PATH:$HOME/.dotnet/tools"

  local pidfile
  pidfile="$(mktemp -u)"
  rm -f "$pidfile" "$pidfile.ready"

  dotnet "$PROFILER_DLL" --out profile-report-traced.md --pid-file "$pidfile" $WORKLOAD &
  local driver_pid=$!

  local analyser_pid=""
  for _ in $(seq 1 600); do
    if [ -s "$pidfile" ]; then
      analyser_pid="$(cat "$pidfile")"
      break
    fi
    sleep 0.1
  done

  if [ -z "$analyser_pid" ]; then
    echo "driver never published an analyser PID" >&2
    kill "$driver_pid" 2>/dev/null || true
    exit 1
  fi

  echo "==> attaching dotnet-trace to analyser PID $analyser_pid"
  dotnet-trace collect \
    --process-id "$analyser_pid" \
    --output analyser-trace.nettrace \
    --format speedscope &
  local trace_pid=$!

  # Let dotnet-trace establish its EventPipe session before releasing the
  # driver into the measured workload.
  sleep 2
  touch "$pidfile.ready"

  wait "$driver_pid"
  # The analyser exits when the driver disposes it; dotnet-trace then
  # finalises the trace on its own.
  wait "$trace_pid" 2>/dev/null || true
  rm -f "$pidfile" "$pidfile.ready"
  echo "==> wrote profile-report-traced.md and analyser-trace.speedscope.json"

  # Aggregate the trace into a method-level hotspot list — the repeatable
  # answer to "where does the analyser spend its time".
  {
    echo "Top 40 methods by EXCLUSIVE (self) time"
    echo "========================================"
    dotnet-trace report analyser-trace.nettrace topN -n 40
    echo
    echo "Top 40 methods by INCLUSIVE (total) time"
    echo "========================================"
    dotnet-trace report analyser-trace.nettrace topN -n 40 --inclusive
  } > analyser-hotspots.txt 2>&1
  echo "==> wrote analyser-hotspots.txt"
}

case "$MODE" in
  plain) run_plain ;;
  trace) run_trace ;;
  both)  run_plain; run_trace ;;
  *)
    echo "usage: $0 [plain|trace|both] [--quick]" >&2
    exit 1
    ;;
esac

echo "==> done"

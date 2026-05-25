# analysis-soak

A soak-test harness for the compiler's analysis mode (`--analyse`).

Loads a source tree (the compiler's own `src/` by default), spawns the
analyser as a subprocess, and runs a long sequence of:

1. perturb a random file (whitespace-only by default; opt-in noise mode
   tips into single random-character edits the parser may reject);
2. send `#EDIT#` and read the response;
3. send a random query (`HOVER`, `DEFINITION`, `DECLARATION`,
   `IMPLEMENTATION`, `TYPEDEFINITION`, `REFERENCES`, `COMPLETE`,
   `SIGNATURE`, `HOVERMAP`, `SEMANTICTOKENS`, `SYMBOLS`,
   `RENAMEREQUEST`) at a random position;
4. periodically send `#COMPILE#` and `#HEAPCHECK#`.

The goal is to shake out exceptions / hangs / process death. Empty
results are fine — analysis mode is allowed to return nothing — but it
must never throw, hang past the read timeout, or exit unexpectedly.

When a hang or crash lands, the harness logs an anomaly, respawns the
analyser, replays the cold `#EDIT#`, and continues. At the end it writes
a markdown report and exits non-zero if any serious failure was seen.

## Usage

```sh
./run-soak.sh                              # build and run with defaults
./run-soak.sh --duration 60                # one-minute smoke pass
./run-soak.sh --iterations 5000 --seed 42  # reproducible 5000-iteration run
./run-soak.sh --edit-mode all --duration 600
```

`dotnet analysis-soak.dll --help` lists every option. See `src/main.ghul`
for the option-handling code.

## Layout

- `src/main.ghul` — argument parsing, corpus location, run orchestration.
- `src/corpus.ghul` — mutable source-tree state (per-file current view).
- `src/perturber.ghul` — edit strategies (`insert-blank-line`,
  `insert-leading-space`, `insert-trailing-space`,
  `toggle-final-newline`, `insert-random-alnum`, `delete-random-char`).
- `src/query_positions.ghul` — identifier / member-access / call-arg
  position harvester (mirrors `analysis-profiler`'s scanner).
- `src/soak_run.ghul` — the main loop. Hang detection via task-wrapped
  reads with `--read-timeout-ms` deadline; respawn on hang / death.
- `src/stats.ghul`, `src/anomalies.ghul`, `src/report.ghul` — per-request
  timings, anomaly log, markdown report.

The wire driver (`ANALYSER_PROCESS`, `RESPONSE`, `EDIT_FILE`) is shared
with `analysis-tests` and `analysis-profiler`, in the sibling
`analysis-protocol` project.

By default soak spawns the compiler rebuilt from the current source (via
the `ProjectReference`). Set `ANALYSIS_TESTS_COMPILER_DLL=<path>` to
soak a specific published build instead.

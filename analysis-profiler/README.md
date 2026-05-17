# analysis-profiler

A profiling harness for the compiler's analysis mode (`--analyse`). It drives
the analyser through a realistic sequence of editor requests against a
non-trivial codebase and reports where the time goes.

## What it does

`run-profile.sh` builds the profiler (and the compiler under test), then runs
the workload twice:

- **plain** — measures per-request wall-clock latency, writing
  `profile-report.md`.
- **traced** — runs the same workload while `dotnet-trace` samples the
  analyser, producing `analyser-trace.speedscope.json` (open at
  <https://speedscope.app>) for method-level hotspots.

The workload mirrors how the VS Code extension drives the analyser:

1. a cold whole-project `EDIT` (extension startup);
2. a cold whole-project `COMPILE`;
3. single-file `EDIT` bursts each followed by a debounced `COMPILE` (a typing
   session);
4. interactive `HOVER` / `DEFINITION` / `COMPLETE` / `SIGNATURE` queries at
   positions harvested from the source.

The default corpus is the compiler's own `src/` — the largest ghūl codebase
available.

## Usage

```sh
./run-profile.sh              # build, plain run, then traced run
./run-profile.sh plain        # plain run only
./run-profile.sh trace        # traced run only
./run-profile.sh both --quick # a shorter workload, for a fast pass
```

The profiler itself accepts:

```
dotnet analysis-profiler.dll [--corpus <dir>] [--out <file>] [--quick] [--pid-file <file>]
```

`--pid-file` is the dotnet-trace handshake: the driver publishes the analyser
PID and waits for `<file>.ready` before timing anything (`run-profile.sh`
handles this).

## Layout

- `src/` — the driver (`corpus`, `positions`, `workload`, `stats`, `report`).
- The protocol wire code (`ANALYSER_PROCESS`, `RESPONSE`) is shared with
  `analysis-tests` and lives in the sibling `analysis-protocol` project.

By default the profiler spawns the compiler rebuilt from the current source
(via the `ProjectReference`). Set `ANALYSIS_TESTS_COMPILER_DLL=<path>` to
profile a specific published build instead.

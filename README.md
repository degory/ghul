# oracle-history

The record of every scheduled inference-oracle run, appended by
`.github/workflows/oracle.yml` on `main`. Nothing else writes here.

- `totals.jsonl` - one line per run: the date, the run id, the `ghul.compiler`
  version checked, and the verdict counts for each corpus. The last line's
  compiler version is what the next scheduled run compares against to decide
  whether a new release needs checking.
- `runs/<compiler version>/<corpus>.json` - the oracle's `--json` report for
  each corpus of that run, which the next run diffs its own against.

The corpora are `grid` (the argument-pack grid), `execution`
(`integration-tests/execution`), `rosetta` (the Rosetta Code solutions at
their default branch) and `compiler` (the compiler's own source).

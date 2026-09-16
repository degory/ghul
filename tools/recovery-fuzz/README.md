# recovery-fuzz

Writes well-formed programs, breaks one line of each the way an editor breaks
it, and checks that the compiler still parses the rest of the file.

The property under test is not "how many errors" but "how much survived". A
program is written with three markers, each a read of a name that does not
exist: one in a definition ahead of the damage, one in the damaged body after
the damage, and one in a definition behind it. The compiler reports a marker
once it has parsed and resolved the line carrying it, and says nothing at all
about a line it never parsed - so the diagnostics say exactly which of the
three regions survived. The tail marker is the one that matters most: it is
the difference between resynchronising inside a body and dropping the rest of
it, which is what code completion and incremental editing both need.

The second property is that one mistake is reported in one place. Counting
errors cannot see a cascade, because the damage legitimately produces
semantic fallout wherever the code that depended on it was; what is counted
instead is the number of distinct source lines carrying a *parse* error.

## What it varies

Around the damage: bare statements at the file root, a global function with a
block body, a global function with an expression body, a method, an
expression-bodied method, a trait's default method, a function literal nested
in a function, and a generator. Inside those, nought to two levels of `if`,
`while`, `for`, `case` and `try`.

The damage itself:

| Mutation | What it models |
| --- | --- |
| `truncate-file` | a method whose second half has not been written |
| `drop-value` | `x = ` with the cursor after it |
| `drop-line-tail` | a line cut at a random column, mid-typing |
| `drop-closer` | a closing keyword not typed yet |
| `swap-closer` | a closer belonging to another construct |
| `duplicate-closer` | a closer left behind by an edit |
| `drop-opener-keyword` | `if c` with no `then`, a header with no `is` |
| `drop-open-bracket` / `drop-close-bracket` | an unbalanced bracket |
| `insert-stray` | a token left where a statement should be |

Each mutation declares which markers it leaves reachable, so a truncation is
not asked to preserve what it deleted.

## Running

```sh
dotnet build tools/recovery-fuzz
dotnet run --no-build --project tools/recovery-fuzz -- <work-directory> --count 200 --compiler publish/ghul.dll
```

Options: `--count <n>` cases (200), `--start <seed>` the first seed (1), a
seed always producing the same case. `--compiler <ghul.dll>` the compiler to
test (`publish/ghul.dll`). `--spill <lines>` how many distinct lines may carry
a parse error before it counts as a cascade (2 - one place to report the
mistake, and one more for the closer that turned up instead).
`--timeout <seconds>` per compile (20). The exit status is non-zero if any
case failed.

Each case is left in the work directory as `<seed>-baseline` and
`<seed>-damaged`, so a failing one can be compiled by hand.

## Reading the output

| Verdict | Means |
| --- | --- |
| `.` | the markers the mutation left reachable all survived |
| `G` | the undamaged program did not compile as written - a generator bug |
| `H` | the compiler did not finish |
| `I` | the compiler crashed |
| `B` | the damage took out code written before it |
| `T` | the rest of the damaged body was lost |
| `A` | a definition after the damaged one was lost |
| `S` | one mistake was reported on too many lines |

A program is compiled before it is damaged as well as after, and has to
report exactly its three markers and nothing else. A generator bug therefore
shows up as `G` rather than being read as a recovery finding.

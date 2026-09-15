# inference-fuzz

Writes small programs that leave as much as possible to inference, compiles
and runs each, and compares the types inference settled on with the types
the generator meant.

The corpora the inference oracle checks were all written until they worked,
so they mostly confirm what already works. A generated program has no such
bias: the generator draws statements at random from a grammar of top-level
`let`s, function literals, pipes, conditionals, blocks, tuples and
destructures, annotating a type only where the language leaves it no
choice. Whatever the compiler makes of the result is the finding.

Among the statements are the shapes whose type is decided only later in
the body: a literal whose parameter is pinned by a call after it, wrapping
a spread literal, a stream or a pack combinator over that parameter; a
stored literal composed with `>>` or passed through a pack-returning
function and called afterwards; and a `rec` literal destructuring a
recursive union. Each of these is a shape inference has to wait on rather
than decide from what it has, so they exercise the obligation queue.

## Running

Build the tool with the repository's pinned compiler, then point it at the
compiler to test:

```sh
dotnet build tools/inference-fuzz
dotnet run --no-build --project tools/inference-fuzz -- fuzz <work-directory> --count 200 --compiler ~/.nuget/packages/ghul.compiler/<version>/tools/net10.0/any/ghul.dll
```

Options:

- `--count <n>` programs to write (100), `--start <seed>` the first seed (1).
  A seed always produces the same program.
- `--statements <n>` per program (8), `--depth <n>` the expression budget (3).
- `--compiler <ghul.dll>` the compiler to test; `publish/ghul.dll` otherwise.
  A published compiler references the runtime beside it, which is the one
  it was built with and can predate the one the generator writes for. To
  test against a newer runtime, copy the compiler's directory and replace
  its `ghul-runtime.dll` before pointing `--compiler` at the copy.
- `--json <file>` also writes each program's verdict and detail as JSON.

`generate <directory>` writes the programs without checking them. `shrink
<program-directory>` reduces a failing program by removing statements while
the same failure stands, keeping the original as `original.ghul`.

## Reading the output

One verdict per program, with the failures grouped by their diagnostic:

| Verdict | Means |
| --- | --- |
| `=` | compiled, ran, and every inferred type is the intended one |
| `T` | compiled and ran, but a local's inferred type is not the intended one |
| `C` | the compiler rejected the program |
| `I` | the compiler crashed |
| `X` | the program crashed, or did not finish in ten seconds |
| `A` | the annotator failed on a program that compiled |

Each program is left under `<work-directory>/<seed>/` with `test.ghul`,
`intended.txt` (the type the generator meant each unannotated local to
have), `compile.out`, `run.out` and `annotated.ghul` (the program with the
types inference settled on written in by `--annotate-inferred`). The
grouping key is the first diagnostic with its position, numbers and
generated names taken out, so one cause is one line; the seeds listed under
it are the programs to read.

The layout is the one `tools/inference-oracle`'s `corpus` command reads, so
the same directory can be checked for a difference between the program as
written and the program with its types written out:

```sh
dotnet run --project tools/inference-oracle -- corpus <work-directory> <oracle-work-directory> --compiler <ghul.dll>
```

## What a verdict does and does not say

A `C` on a program the generator considers well-typed is a gap in
inference, but read the diagnostic before filing it: the generator's model
of the language is smaller than the language, and a program it writes can
be one the rules genuinely reject. A `T` compares spellings after the
purity and tuple element names the annotator adds are removed, so it flags
a different type, not a different rendering. A `=` says only that the
program compiled to the intended types and ran without crashing; nothing
checks the values it printed.

## Not in CI

A development tool, like the oracle. Nothing builds it as part of a normal
build, and no scheduled run drives it yet.

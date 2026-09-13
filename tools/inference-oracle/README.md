# inference-oracle

Checks the argument-pack grid for silent mis-resolution.

A cell that compiles and prints the right answer can still have been resolved
wrongly, as long as the wrong resolution happens to compute the same thing.
For each grid cell that compiles, the oracle writes a second program with
every type the compiler would infer written out: lambda parameter and return
types, local variable types, and the type arguments of every generic call. It
compiles both with the same compiler and compares the IL of the two
assemblies. Any difference is a finding.

The explicit programs are rendered from the grid's own cell model,
`tools/argument-pack-grid/src/grid.ghul`, so a new axis value is checked as
soon as the grid has it. The inferred program is the grid's `test.ghul` as
committed, so regenerate the grid first if the generator has changed.

## Running

Publish the compiler, then run from the repository root:

```sh
dotnet publish --output publish
dotnet run --project tools/inference-oracle -- check integration-tests/execution/argument-pack-grid <work-directory>
```

Options:

- `--compiler <ghul.dll>` compiles with a compiler other than
  `publish/ghul.dll`.
- `--ildasm <path>` disassembles with a specific ildasm. Otherwise
  `GHUL_TEST_ILDASM` is used if set, then the newest
  `runtime.linux-x64.microsoft.netcore.ildasm` in the NuGet package cache.
- `--cell <text>` checks only cells whose name contains the text.

## Reading the output

A table of verdicts per cell:

| Verdict | Means |
| --- | --- |
| `=` | the IL matches |
| `≠` | the IL differs |
| `E` | the explicit program does not compile |
| `C` | the grid cell does not compile, so there is nothing to compare |
| `·` | the language rules the cell out |
| `?` | the cell could not be checked: the grid has no test for it, or its expectations say it compiles but this compiler rejects it |

The exit status is non-zero when any cell's IL differs. Each checked cell
leaves `inferred/` and `explicit/` under the work directory, each holding the
program, `compiler.out`, the raw disassembly `il.raw` and `il.normalised`,
plus `il.diff` beside them where the two differ.

## What the comparison ignores

Only what differs between two compiles of one program:

- The assembly header: ildasm's banner, the MVID, the image base, the extern
  references.
- Instruction offsets and code sizes, which move whenever an earlier
  instruction does.
- The numbers in the names of compiler-generated members (`$anon_N`,
  `$frame_N`, `$packed_N`), renumbered in order of first appearance.
- The order of a closure frame class's type parameters, which follows the
  order the compiler first meets them and so can change when a type is
  written out. Each frame's parameters are put in name order, and every
  index reference to them follows.

## Not in CI

A development tool, like `mdump`. Nothing builds it as part of a normal
build, and the suite does not run it.

# mdump

Dumps an assembly's metadata tables.

```sh
dotnet build tools/mdump/mdump.ghulproj
dotnet tools/mdump/bin/Debug/net10.0/mdump.dll <assembly> [<assembly> ...]
```

## What this is not for

Checking whether the IL is *verifiable*. It mostly is not, and neither
is the published compiler's: a path narrow re-reads the path and calls
the narrowed member without a `castclass`, which ILVerify rejects and
the runtime accepts. The published compiler passes the whole suite and
self-hosts, so what it emits is known-good by the only standard that
applies, and emitting something else to satisfy a verifier would be
changing working output to meet a rule nothing enforces.

That makes the published compiler the oracle. When this compiler's
output is wrong, the way to see it is to build the same source with
both and compare — which is how a `T ref` parameter was found going out
as `read(valuetype REFERENCE<int32>)` where the published compiler
emits `read(int32&)`. Reading one assembly on its own, as below, is for
answering a specific question about it, not for deciding whether it is
correct.

## What it is for

`ilspycmd -il` already renders IL, and renders it the way a reader
wants: names resolved, tokens followed, rows hidden. That is the right
output for reading a program and the wrong output for checking how one
was emitted. A back end gets the tables wrong, not the listing, and the
tables are exactly what a disassembler spends its effort concealing.

So this prints what the tables hold:

- The row each type, field and method landed on.
- A method with no body, called out as `NO BODY` rather than `rva 0`.
  That is a legal row for an abstract or bodyless member and a silent
  disaster for anything else.
- Signature blobs as written — a type parameter as `!0` or `!!0` with
  its index, a `TypeDefOrRef` as the table and row it points at. Both
  are resolved away by anything that renders a signature for a reader,
  and both are what signature bugs turn on.
- The local variable signature a body header points at. An `!!0` here
  in a method with no type parameters of its own is the shape the
  runtime rejects at load.
- `InterfaceImpl` and `MethodImpl` per type.

## Reading the output

A type's fields and methods are *runs*: the rows from its own
first-member pointer up to the next type's. Nothing validates a run, so
a member numbered into the wrong one is not an error — it is a member
that has quietly changed owner, in an assembly that still loads. Two
symptoms to look for:

- A member appearing under a type that does not declare it.
- A gap or an overlap in the row numbers between one type and the next.

Signatures are printed by table and row rather than by name for the
same reason: a name would answer whether the emitter meant the right
thing, and the row answers whether it wrote the right thing.

## Verifying

`mdump --verify <assembly>` reports only violations, and exits non-zero
if it found any. It checks one thing: a method row that carries no body
and has no business carrying none — not abstract, not P/Invoke, not
runtime-implemented, not an interface declaration.

That sounds too small to be worth a mode, and is not. A method row
pointing at nothing is invisible to everything else: the assembly loads,
and a disassembler renders an empty method body without comment. It is
also exactly what a back end that emits rows before it can emit bodies
produces, so the whole of one can be missing while every other check
reports nothing wrong.

To read every assembly the suite emitted rather than one, run it with
`GHUL_TEST_KEEP_ARTIFACTS=1` first — a passing test deletes what it
built, so otherwise only the failures are left behind.

## Not in CI

A development tool, like `analysis-profiler`. Nothing builds it as part
of a normal build, and nothing depends on its output.

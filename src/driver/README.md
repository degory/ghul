# Compiler driver and analyser

The `Driver` namespace contains the entry point used by the stand‑alone
compiler tool.  `Main.ghul` parses command line arguments, configures the build
flags and orchestrates compilation.  When started with the `--analyse` flag the
same executable acts as a language service for Visual Studio Code.

Key files:

- `arguments_parser.ghul` &ndash; parses command line arguments into
  `BUILD_FLAGS`.
- `output_file_name_generator.ghul` &ndash; determines assembly and PDB file
  names.
- `path_config.ghul` &ndash; resolves library locations and working paths.
- `source_file_categorizer.ghul` &ndash; separates ghūl files from other inputs.

The driver is intentionally thin; most heavy lifting happens in the
`COMPILER` class found under `src/compiler`.  If you extend the command line
options or need to trigger additional compiler passes, update the logic here

## Compile server

`--compile-server` keeps one compiler process alive and compiles a series of
submissions in it, so each pays for its own few lines rather than for starting
a runtime and importing the reference set: a first submission takes about as
long as a batch compile, and each later one tens of milliseconds. It is the
backend for an interactive session, where every cell is compiled on its own to
a library assembly and later cells reference earlier ones.

The protocol is one JSON object per line each way. The first line out is
`{"ready":true,...}`. Each request line carries the submission's `name`, either
a `source` path or the source itself as `text` (whose diagnostics then name the
file `<name>.ghul`), the `output` assembly to write, and the `references` to
earlier submissions' assemblies. Each reply carries a `status` (0 when the
assembly was written, 1 when the source has errors, 2 when the request could not
be carried out, with a `message` saying why) and the `diagnostics`, in the
analysis protocol's shape. The request and reply types, and a client that runs
the server, are `COMPILE_REQUEST`, `COMPILE_REPLY` and `COMPILE_SERVER_PROCESS`
in the analysis-protocol library.

Each request is answered as a batch compile of the same file with
`--submission <name> --library` and the same references would be: everything
the previous compile left is cleared first, and the only state kept is the
reference set, which grows as requests bring new references. The analysis tests
hold the server to that by compiling each cell both ways and comparing the
assemblies.

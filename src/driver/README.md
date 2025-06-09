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

# ghūl compiler source

This directory contains all of the compiler implementation written in ghūl.
The subfolders roughly map to the traditional phases of a compiler and are
referenced heavily throughout the rest of the codebase.  AI tools often need a
quick orientation, so here is a brief guide to the contents:

- **analysis** – Code used when the compiler runs in *analysis mode* to
  service requests from the Visual Studio Code extension.
- **compiler** – Orchestration types that control the overall compilation
  pipeline.  Entry points such as `COMPILER` live here.
- **driver** – The command line front‑end that parses arguments and invokes the
  compiler or analyser.
- **ioc** – A very small inversion of control container used mainly by the
  parser to break cyclic dependencies.
- **ir** – Internal representation for lower‑level compilation stages.
- **lexical** – Token definitions and the tokenizer.
- **logging** – Diagnostic and timing helpers.
- **semantic** – Symbol table, type system and other semantic analysis code.
- **source** – Structures that track source file locations and build numbers.
- **syntax** – Abstract syntax tree (AST) definitions, parsers and passes.

When updating or adding new modules place them in the most appropriate
subfolder.  Tests and build scripts expect this layout to remain stable.

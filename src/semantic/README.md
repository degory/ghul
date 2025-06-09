# Semantic analysis

The semantic layer sits between parsing and code generation.  It resolves names,
checks types and builds the high‑level intermediate representation (HIR).  Key
concepts include:

- **symbols** – `symbol_table.ghul` stores declarations and scopes.
- **types** – the `types/` subfolder defines `Type` and all concrete type nodes
  used throughout the compiler.
- **stable_symbols.ghul** – a registry of built‑in symbols that other modules
  depend on.
- **dotnet/** – helpers for emitting .NET metadata such as attributes and
  assembly info.

Most passes under `syntax/process` rely on these APIs.
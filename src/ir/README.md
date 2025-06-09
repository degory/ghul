# Intermediate representation (IR)

This folder defines a small set of classes that model instructions close to .NET IL.  Most IR nodes simply wrap a single IL opcode but a few represent more complex operations such as branching helpers or boilerplate generation.

The `generate_il` compiler pass produces these IR nodes then writes them to a text `.il` file.  The driver invokes `ilasm` to assemble that file into a `.dll` or `.exe`.

Useful files:

- `context.ghul` – manages IL output and indentation.
- `block_context.ghul`/`block_stack.ghul` – track nested blocks while emitting code.
- `brancher.ghul` – helpers for conditional and unconditional jumps.
- `innate_operation_generator.ghul` – emits built in operator calls.
- `value_boxer.ghul`/`value_converter.ghul` – helper utilities for boxing and type conversion.

IR values themselves live under `values/` and are documented in that folder.

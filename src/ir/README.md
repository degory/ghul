# Intermediate representation (IR)

This folder defines the intermediate representation the compiler lowers ghūl to: values with a static type and a meaning a backend can lower, whatever the target. Built-in operations are described by the target-neutral kinds in `operations.ghul`, and locals are objects rather than names.

The `generate_il` compiler pass produces these values, and hands each function's finished body to a backend through the `Backend` trait in `backend.ghul`. Bodies no source declares, such as a generator frame's constructor and iterator members, are built as IR values too. The driver also reaches the backend only through the trait. A backend lowers values through the visitor in `values/visitor.ghul`; the CIL backend under `emitter/` lowers them to .NET IL and writes a `.dll` or `.exe`, and the WasmGC backend under `wasmgc/` lowers them to a WebAssembly module, holding classes as GC struct types laid out by `wasmgc/wasmgc_type_registry.ghul`, with virtual and trait calls dispatched through the vtables and trait table `wasmgc/wasmgc_dispatch.ghul` plans, through the module writer in the top-level `wasm/` library, and the LLVM backend under `llvm/` lowers them to an LLVM module through the writer in the top-level `llvm/` library, linked into an executable by `ghul-llvm`. `target_backend.ghul` chooses between them from `--target`.

Loops, `if`, `case`, `try`, `use` disposal, `val` blocks, assertions and comprehensions are built from structured nodes, which say what the control flow is rather than how CIL encodes it: a `LOOP`, `REGION` or `TRY` holds its body, `BREAK` names the node it leaves, and `CONTINUE` the loop it restarts. A `TRY` carries its catch handlers or its finally region, and the CIL protected-region markers are added when it is lowered. A generator's body is a `RESUMABLE`, and a state machine finds its place again through `DISPATCH` nodes, which jump to `RESUME_POINT`s. A structured node is lowered to labels and branches only when it is encoded.

A composite value whose IL branches, such as `?.` or a fused pipe loop, expands into the same structured nodes when it is generated, holding anything it needs after a branch in a local.

Useful files:

- `backend.ghul` – the trait generate-il and the driver write a program through; the CIL backend's is `emitter/cil_backend.ghul`, the WasmGC backend's is `wasmgc/wasmgc_backend.ghul`, and the LLVM backend's is `llvm/llvm_backend.ghul`.
- `program/` – what a whole-program backend plans independently of its target: class and function instances at their type arguments (`instances.ghul`, `type_maps.ghul`), the worklist of reachable functions (`function_worklist.ghul`), the classes, arrays and boxes a program uses and their numbering (`class_set.ghul`, given the built-in types it treats specially by `core_classes.ghul`), the limits on self-instantiating generics (`instantiation_limits.ghul`), class numbering (`class_id_numbering.ghul`, `class_id_ranges.ghul`), the vtable slots and trait selectors calls dispatch through (`dispatch_plan.ghul`), the packing of the trait dispatch table (`row_displacement.ghul`), which types get a displayer (`display_plan.ghul`), the methods a generator frame is given (`frame_member_methods.ghul`), the exits that cross a finally (`exit_numbering.ghul`), and the fixed point that finds everything a program reaches (`program_plan.ghul`, with `function_bodies.ghul` for what the plan asks of a body). A backend supplies its lowering as the plan's `DiscoveryTarget` and reads the plan back. The WasmGC and LLVM backends build on it.
- `frame_member.ghul` – the state-machine frame members no symbol declares.
- `operations.ghul` – the scalar kinds, arithmetic operations and comparisons built-in operators are described by.
- `local.ghul` – a local of the function being generated.
- `runtime_operation.ghul` – the operations a program needs from the runtime it runs on, which each backend maps to its own runtime's members.
- `block_context.ghul`/`block_stack.ghul` – track nested blocks while emitting code.
- `label.ghul` – branch targets and the conditions an exit can test.
- `expansion.ghul` – builds the structured IR a composite value expands to.
- `values/visitor.ghul` – the visitor a backend implements to lower values; the CIL backend's is `emitter/cil_lowering.ghul`.
- `innate_operation_generator.ghul` – emits built in operator calls.
- `value_boxer.ghul`/`value_converter.ghul` – helper utilities for boxing and type conversion.

IR values themselves live under `values/` and are documented in that folder.

# AST passes

The files in this directory implement visitors that walk the syntax trees. Many act as distinct compilation phases while others are used only by the IDE tooling.

Common base classes live in `visitor.ghul`, `strictvisitor.ghul` and `scopevisitorbase.ghul`. The `scopedvisitor.ghul` variant threads the symbol table and namespace context through each visit. `defaultvisitor.ghul` extends the scoped variant to funnel every node kind the concrete visitor does not explicitly override into a single `visit_default` hook, for analyses that must make an explicit decision per node kind. When adding a new AST node kind, every one of these base classes needs a matching method — including a `visit_default` forwarder in `DefaultVisitor`, without which the new kind silently bypasses subclasses' defaults.

### Main compilation passes

The `COMPILER` class (see `src/compiler/compiler.ghul`) runs these in order:

1. **conditional_compilation.ghul** – removes or includes nodes based on build flags.
2. **expand_namespaces.ghul** – rewrites nested namespace declarations and expands relative paths.
3. **add_accessors_for_properties.ghul** – synthesizes getter/setter members for property definitions.
4. **declare_symbols.ghul** – populates the symbol table with declarations.
5. **resolve_uses.ghul** – binds identifier uses to symbols within the current scope.
6. **resolve_type_expressions.ghul** – resolves references inside type expressions.
7. **resolve_ancestors.ghul** – attaches base classes and trait implementations.
8. **resolve_explicit_variable_types.ghul** – checks variables with explicit types against their initialisers.
9. **resolve_overrides.ghul** – verifies override methods match inherited signatures.
10. **infer_store_free.ghul** – proves which functions cannot store to pre-existing heap locations; flow narrowing keeps field narrows alive across calls to them.
11. **record_type_argument_uses.ghul** – records generic type argument usage for later IL generation.
12. **compile_expressions.ghul** – translates expressions into the intermediate representation.
13. **generate_il.ghul** – final pass that emits .NET IL when building an assembly.

### Editor tooling passes

- **completer.ghul** – walks a tree to gather completion suggestions at a location.
- **signature_help.ghul** – determines overload information for function calls.
- **printer/** – visitors that pretty-print trees for debugging.

Support code like the visitor base classes are used by multiple passes. Not every pass runs in every scenario; the driver selects them based on build flags and whether analysis mode is active.

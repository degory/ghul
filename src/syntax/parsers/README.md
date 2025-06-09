# Parser implementations

This folder contains the recursive-descent parsers that build the abstract syntax tree. Each parser corresponds closely to a node type under `../trees` and implements the generic `Parser[T]` trait from `base.ghul`.

Key pieces:

- `context.ghul` – manages token lookahead, error recovery and speculative parsing.
- `base.ghul` – simple `Parser[T]` trait with helper functionality.
- `lazy_parser.ghul` – wrapper that lets parsers reference each other via the IoC container without circular constructors.
- `unwind_exception.ghul` – used to abort nested parsing when error recovery needs to unwind to a safe point.
- Subfolders like `definitions`, `expressions`, `statements` and `type_expressions` group the actual parser classes by grammar area.

Parsers are instantiated by `ioc/container.ghul` so other compiler modules can fetch them on demand. When adding new syntax features remember to update the corresponding parser and the AST node in `trees/`.

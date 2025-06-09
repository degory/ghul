# Syntax analysis and representation

This folder is split into three main parts:

- **trees/** – definitions of the abstract syntax tree (AST) nodes.
- **parsers/** – recursive‑descent parsers that produce the AST from tokens.
- **process/** – visitors and compiler passes that operate over the AST.

The parser hierarchy uses a small IoC container from `src/ioc` so each parser
can refer to others without complex constructor order.  Many passes in
`process/` are run by the `COMPILER` or the language service.  If you add a new
node type or syntax feature, update both the parser and tree structures and
consider whether existing passes need to handle it.

When new syntax nodes are introduced, remember to update the base visitor classes in `process/` (`Visitor`, `StrictVisitor`, `ScopeVisitorBase` and `ScopedVisitor`). Passes that do not care about a node can simply ignore it, but they must still implement a method so the visitor hierarchy compiles.

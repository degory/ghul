# Syntax tree nodes

All concrete AST nodes live here. Each file declares a small class or struct that inherits from `node.ghul` or one of its specialised bases. Subfolders group nodes by role:

- `definitions/` – top level declarations like classes, traits and functions.
- `expressions/` – expression forms such as calls, operators and literals.
- `statements/` – statement constructs including loops and conditionals.
- `type_expressions/` – parse-time type syntax used before semantic resolution.
- `bodies/`, `pragmas/`, `modifiers/` and `identifiers/` – supporting structures.

Every node stores a `Source.LOCATION` for diagnostics. New syntax should define a new node here, add or update a parser in `parsers/` to recognize it, and update the visitors under `process/` to handle it.

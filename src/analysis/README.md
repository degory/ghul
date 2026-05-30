# Analysis mode and language service

The code in this folder lets the compiler act as a lightweight language service. When the driver starts with `--analyse`, `Analysis.ANALYSER` reads commands from standard input and responds over standard output. These commands mirror typical language server requests (hover, definition lookups, completions and so on) and ride a **newline-delimited JSON protocol**: one JSON object per line, `\n`-terminated. Requests are discriminated by a `command` field, responses by a `kind` field.

The main components are:

- `analyser.ghul` – entry point that drives a `COMMAND_DESPATCHER` loop.
- `command_despatcher.ghul` – reads one request line, deserializes it into a `REQUEST` (concrete subtype picked by `command`), and dispatches to the matching handler.
- `command_handlers.ghul` – implements individual requests such as `hover`, `definition` and `edit`. Each handler builds a typed response DTO and emits it via `JSON_PROTOCOL` as a single line.
- `protocol/` – request and response DTOs (`requests.ghul`, `responses.ghul`) plus the small `JSON_PROTOCOL` helper that holds the shared `JsonSerializerOptions` and the write-one-line/read-one-line primitives. The `diagnostics_collector.ghul` neighbour renders the diagnostics store into the typed `DIAGNOSTIC[]` carried by the `diagnostics` response.
- `watchdog.ghul` – decides when the analyser should recycle: on a sustained burst of handler exceptions, or on managed-heap growth past a threshold. The heap is sampled on an explicit `heap_check` request (the IDE sends one during a lull in editing) and, as a fallback, periodically after compiles.

Wire field names are the ghūl property names verbatim (snake_case); no `JsonNamingPolicy` is applied. JSON escapes literal newlines inside strings, so a message never contains a raw newline — `read_line` on either end is a complete framing primitive. Multi-file EDIT requests fit on a single line, with each file's source text escaped inside its JSON string.

EDIT and COMPILE each produce a single `diagnostics` response carrying the diagnostics list plus a `phase` field (`"partial"` after EDIT, `"full"` after COMPILE), `elapsed_ms`, and `compile_needed` inline — replacing the previous two-frame answer. The set of files the analyser knows about and has just checked rides in `checked_paths`, so the client can clear stale squiggles for files whose entries don't appear in the diagnostics list.

`hover_map` is a batch variant of `hover`: given a file path it returns every recorded hover for that file as a list of `entries`, each `{ start_line, start_column, end_line, end_column, description }` — so a tool can collect a whole file's hovers in one response instead of probing position by position. `semantic_tokens` shares the same shape, returning `tokens` with `start_line`/`start_column`/`end_line`/`end_column`/`token_type`/`modifiers`, where `token_type` is one of VS Code's LSP semantic-token names (`class`, `interface`, `struct`, `enum`, `enumMember`, `typeParameter`, `namespace`, `method`, `function`, `property`, `variable`, `parameter`) and `modifiers` is a possibly-empty comma-separated list (currently just `static`). Symbol uses whose kind has no LSP mapping contribute no token. Like `hover_map` it never recompiles; the caller drives an `edit` (and/or `compile`) first.

# Lexical analysis

The lexical layer converts raw source text into a stream of `TOKEN`s that the
parsers can consume.  The main implementation lives in `tokenizer.ghul` which
handles trivia, comments and preprocessing directives.

Other notable files:

- `token.ghul` – token structure and helpers.
- `token_names.ghul` – central list of token kinds used by tests and diagnostics.
- `token_lookahead.ghul` and `token_queue.ghul` – utilities for peeking ahead in
  the token stream.


# Analysis mode and language service

The code in this folder lets the compiler act as a lightweight language service. When the driver starts with `--analyse`, `Analysis.ANALYSER` reads commands from standard input and responds over standard output. These commands mirror typical language server requests (hover, definition lookups, completions and so on) but they use a custom **plain text protocol**. At the time the analyser was written JSON parsing was impractical in ghūl, so messages are simple line based strings.

The main components are:

- `analyser.ghul` – entry point that drives a `COMMAND_DESPATCHER` loop.
- `command_despatcher.ghul` – waits for a command keyword, then invokes the matching handler.
- `command_handlers.ghul` – implements individual requests such as `HOVER`, `DEFINITION` and `ANALYSE`. Each handler reads any additional arguments from the input stream and writes a response terminated by a form feed character (\f).
- `watchdog.ghul` – tracks operation counts and can signal when the analyser should restart to recover from desynchronised input.

Requests are written by the IDE as `#COMMAND#` followed by newline separated arguments. The compiler responds with a header line naming the command, optional result lines and finally a form feed character. The protocol is intentionally minimal but stable; if you extend it keep messages textual so older clients can ignore unknown lines.

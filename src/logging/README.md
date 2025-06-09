# Logging and diagnostics

These utilities provide structured error reporting and simple performance
timers.  `logger.ghul` formats diagnostic messages with `Source.LOCATION`
information so warnings and errors appear with line numbers.  The
`diagnostics_store.ghul` collects messages for later retrieval, while
`timers.ghul` helps measure the duration of compiler passes.

Any new compiler pass should log through `Logger` to ensure messages are routed
correctly, especially when the compiler runs inside IDE tooling (output to stdout
or stderr bypassing `Logger` may disrupt communication with the IDE)
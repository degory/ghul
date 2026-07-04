# ghūl analysis protocol client

Client library for the ghūl compiler's analysis mode. `ANALYSER_PROCESS` spawns
`ghul-compiler --analyse` as a subprocess and drives it over the JSON line
protocol: edit and compile requests with diagnostics, plus hover, definition,
declaration, implementation, references, completion, signature, symbols and
rename queries. Requests and responses are typed classes under
`Analysis.Protocol`.

Published as the `ghul.analysis.protocol` NuGet package. The package version
matches the `ghul.compiler` release built from the same commit, so it
identifies the protocol revision the library speaks.

Consumers in this repository: the compiler itself (server-side types),
`analysis-tests/`, and the analysis profiler harness.

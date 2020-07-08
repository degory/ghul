# Stubs for the L library

## `ghul.ghul`
The ghul compiler depends on a subset of the L library, but it cannot parse the corresponding L source code. So, to avoid compilation errors, any type exposed by the L library and referenced by the ghul compiler must have a corresponding stub definition her.

If you introduce additional L library dependencies then you'll need to add appropriate stubs.

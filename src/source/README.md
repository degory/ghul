# Source utilities

This folder holds types that help the rest of the compiler keep track of where
pieces of code came from.  The `LOCATION` class records file names and
line/column ranges.  It is used throughout diagnostics and in many passes that
need to correlate generated code back to the original source.  `BUILD_NUMBER`
tracks a monotonically increasing integer for incremental builds.

If you are adding new kinds of source metadata, keep the APIs small and prefer
value‑type like classes that can easily be compared.

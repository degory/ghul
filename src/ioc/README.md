# IoC – simplified dependency injection

The compiler has no runtime reflection, so typical convention‑based dependency
injection frameworks are unavailable.  Most classes therefore create their
dependencies directly.  The parsers are special: they reference each other in a
way that makes simple constructor wiring impossible.

`CONTAINER` provides just enough functionality to register factory functions and
resolve them lazily.  It is mainly used by the parser layer where each parser is
wrapped in `LAZY_PARSER[T]` to break the cyclic references.  If you introduce a
new parser or other component with similar requirements, register it here rather
than building a full DI system.

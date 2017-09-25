# IoC - poor man's inversion of control.
While the compiler is still incomplete, and no reflection is available to support convention based dependency injection, most concrete dependencies are simply instantiated directly in constructors throughout the code.

However, the parser classes are inter-dependent on each other, which makes it difficult to just instantiate each parser directly - no instantiation order exists that would enable all parsers' dependencies to be satisfied.
The simple IoC container takes the various parser classes and wraps them all in LAZY_PARSER[T] before passing them into the various constructors. This defers parser instantiation until first real use, breaking the mutual interdependencies between the parser classes.
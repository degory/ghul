class SOME_CLASS is
    do_nothing();

    add(a: int, b:int) => a + b;

    sub(a: int, b:int) is return a - b; si

    apply(f: (int) -> int, x: int) -> int => f(x);

    list(a: int, b: int, c: int, d:int) -> Iterable[int] => [a, b, c, d];

    area: int => width * height;

    prop: int
        => _prop,
        = value is
            _prop = value;
        si

    complex_prop: int
        is
            _count = _count + 1;
            return function(count);
        si,

        = value is
            _count = _count - 1;
            function(count, value);
        si
si

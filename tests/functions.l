class SOME_CLASS is
    do_nothing();

    add(a: int, b:int) => a + b;

    sub(a: int, b:int) is result = a - b; si

    apply(f: (int) -> int, x: int) -> int => f(x);
si

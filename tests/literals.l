namespace Test.Literals is
    class SOME_CLASS is
        some_function() is
            let a = 10;
            let b = "hello world!";
            let c = [x, y, z];
            let d = (a, b, c);
            let e = (a = 1, b = 2, c = 3);
            let f = (a: int = 1, b: int = 2, c: int = 3);
            let g = ["aaa", "bbb", "ccc"]: string;

            let h = [[a, b]: int, [c, d]: word]: System.Object;
        si
    si
si
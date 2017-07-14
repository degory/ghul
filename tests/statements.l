class STATEMENTS is
    f() is
        if condition then
            let a = b + c;
        else
            let d = e / f;
        fi

        if condition[i] then
            x = x * 2;
        fi

        if condition.i then
            a = (b, c, d);
        elif condition(i) then 
            a = x(y, z);
        fi

        if condition then
            c = [r, s, t, u][0](x, y, z);
        elif condition then
            c = [r, s].elements;
        elif condition then
            c = [[a, b], [c(), d()]][i..j];
        else
            c = (a = none, b = none, c = none).a;
        fi
    si
si
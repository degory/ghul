class STATEMENTS is
    if_statements() is
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

    do_statements() is
        while condition do
            a = b + c;

            d = e + f;
        od

        do
            forever();
            and();
            ever();
        od

        label: while condition do
            i = i + 1;
        od

        label: do
            j = j - 1;
        od

        label: while condition do
            i = i + 1;
            if world.is_ended then break label; fi

            continue;
        od

        label: do
            j = j - 1;
            if not_apocalypse then continue label; fi

            break;
        od        
    si
si
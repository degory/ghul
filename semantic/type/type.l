namespace Type is
    use System;

    interface Typed is
        get BASE type;
    si

    interface SettableTyped isa Typed is
        set BASE type = value;
    si
si

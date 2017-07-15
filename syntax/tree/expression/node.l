namespace Syntax is namespace Tree is namespace Expression is
    use System;
    use Generic;

    use Source;

    enum OPERATION is
        NONE,
        ADD,
        SUBTRACT,

        MULTIPLY,
        DIVIDE,
        MODULUS,

        AND,
        OR,

        SHIFT_LEFT,
        SHIFT_RIGHT,

        RANGE,

        LESS,
        LESS_OR_EQUAL,
        EQUAL,
        EQUAL_OBJ,
        NOT_EQUAL,
        NOT_EQUAL_OBJ,
        GREATER,
        GREATER_OR_EQUAL,

        AND_THEN,
        OR_ELSE,

        MEMBER,
        INDEX,
        CALL
    si

    class OPERATION_NAMES is
        static Map<OPERATION, String> names;

        static get String[OPERATION op] is
            if names == null then
                names = new Map<OPERATION, String>();

                names[OPERATION.ADD] = "+";
                names[OPERATION.SUBTRACT] = "-";

                names[OPERATION.MULTIPLY] = "*";
                names[OPERATION.DIVIDE] = "/";
                names[OPERATION.MODULUS] = "%";

                names[OPERATION.AND] = "&";
                names[OPERATION.OR] = "|";

                names[OPERATION.SHIFT_LEFT] = "<<";
                names[OPERATION.SHIFT_RIGHT] = ">>";

                names[OPERATION.LESS] = "<";
                names[OPERATION.LESS_OR_EQUAL] = ">";
                names[OPERATION.EQUAL] = "==";
                names[OPERATION.EQUAL_OBJ] = "=~";
                names[OPERATION.NOT_EQUAL] = "!=";
                names[OPERATION.NOT_EQUAL_OBJ] = "!~";
                names[OPERATION.GREATER] = ">";
                names[OPERATION.GREATER_OR_EQUAL] = ">=";

                names[OPERATION.AND_THEN] = "&&";
                names[OPERATION.OR_ELSE] = "||";

                names[OPERATION.MEMBER] = ".";
                names[OPERATION.INDEX] = "[]";
                names[OPERATION.CALL] = "()";                        
            fi

            var result = names[op];

            if result != null then
                return result;
            else
                return "unknown";
            fi
        si
    si

    class NODE isa Tree.NODE is
        void init(LOCATION location) is
            super.init(location);
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si
si si si
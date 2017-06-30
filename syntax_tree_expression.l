namespace Syntax is
    namespace Tree is
        namespace Expression is
            enum OPERATION is
                ADD,
                SUBTRACT,

                MULTIPLY,
                DIVIDE,
                MODULUS,

                AND,
                OR,

                SHIFT_LEFT,
                SHIFT_RIGHT,

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

                CALL
            si

            class BINARY isa EXPRESSION is
                public LOCATION location;
                public OPERATION operation;
                public EXPRESSION left;
                public EXPRESSION right;
                
                void init(
                    LOCATION location,
                    OPERATION operation,
                    EXPRESSION left,
                    EXPRESSION right
                )
                is
                    this.location = location;
                    this.operation = operation;
                    this.left = left;
                    this.right = right;
                si
            si

            class UNARY isa EXPRESSION is
                public LOCATION location;
                public OPERATION operation;
                public EXPRESSION right;
                
                void init(
                    LOCATION location,
                    OPERATION operation,
                    EXPRESSION right
                )
                is
                    this.location = location;
                    this.operation = operation;
                    this.right = right;
                si
            si

            class PRIMARY isa EXPRESSION is
                void init(LOCATION location) is
                    super.init(location);
                si
            si

            class TUPLE isa PRIMARY is
                public List<EXPRESSION> expressions;

                void init(
                    LOCATION location,
                    Iterable<EXPRESSION> expressions
                )
                is
                    super.init(location);

                    this.expressions = new Vector<EXPRESSION>();
                    this.expressions.add(expressions);
                si
            si

            class LITERAL isa PRIMARY is
                public String value;

                void init(
                    LOCATION location,
                    String value
                )
                is
                    super.init(location);

                    this.value = value;
                si
            si

            class NONE isa LITERAL is
                void init(LOCATION location) is
                    super.init(location);
                si
            si

            class MEMBER isa PRIMARY is 
                public EXPRESSION left;
                public IDENTIFIER right;

                void init(LOCATION location, EXPRESSION left, IDENTIFIER right) is
                    super.init(location);

                    this.left = left;
                    this.right = right;
                si
            si
        si
    si
si
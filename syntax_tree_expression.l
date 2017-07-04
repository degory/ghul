namespace Syntax is
    namespace Tree is
        namespace Expression is
            use System;
            use Generic;

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

                MEMBER,
                INDEX,
                CALL
            si

            class BINARY isa EXPRESSION is
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

            class PRIMARY isa EXPRESSION is
                void init(LOCATION location) is
                    super.init(location);
                si
            si

            class TYPED isa PRIMARY is
                public IDENTIFIER identifier;
                public TYPE type;

                void init(
                    LOCATION location,
                    IDENTIFIER identifier,
                    TYPE type
                )
                is
                    super.init(location);

                    this.identifier = identifier; 
                    this.type = type;
                si
            si            

            class UNARY isa PRIMARY is
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

            class IDENTIFIER isa PRIMARY is
                Tree.IDENTIFIER identifier;

                void init(LOCATION location, Tree.IDENTIFIER identifier) is
                    super.init(location);

                    this.identifier = identifier;
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
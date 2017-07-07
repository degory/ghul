namespace Syntax is
    namespace Tree is
        namespace Expression is
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
                    super.init(location);

                    this.operation = operation;
                    this.left = left;
                    this.right = right;
                si

                void accept(Visitor visitor) is
                    visitor.visit(this);
                si
            si

            class PRIMARY isa EXPRESSION is
                void init(LOCATION location) is
                    super.init(location);
                si

                void accept(Visitor visitor) is
                    visitor.visit(this);
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

                void accept(Visitor visitor) is
                    visitor.visit(this);
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
                    super.init(location);
                    
                    this.operation = operation;
                    this.right = right;
                si

                void accept(Visitor visitor) is
                    visitor.visit(this);
                si
            si

            class IDENTIFIER isa PRIMARY is
                public Tree.IDENTIFIER identifier;

                void init(LOCATION location, Tree.IDENTIFIER identifier) is
                    super.init(location);

                    this.identifier = identifier;
                si

                void accept(Visitor visitor) is
                    visitor.visit(this);
                si
            si

            class EXPRESSION_LIST isa NODE do Iterable<EXPRESSION> is
                public Iterable<EXPRESSION> expressions;

                void init(LOCATION location, Iterable<EXPRESSION> expressions) is
                    super.init(location);                    
                    this.expressions = new Vector<EXPRESSION>(expressions);
                si

                get Iterator<EXPRESSION> Iterator is
                    return expressions.Iterator;
                si

                void accept(Visitor visitor) is
                    visitor.visit(this);
                si
            si

            class TUPLE isa PRIMARY is
                public EXPRESSION_LIST elements;

                void init(
                    LOCATION location,
                    EXPRESSION_LIST elements
                )
                is
                    super.init(location);

                    this.elements = elements;
                si

                void accept(Visitor visitor) is
                    visitor.visit(this);
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

                void accept(Visitor visitor) is
                    visitor.visit(this);
                si                
            si

            class NONE isa LITERAL is
                void init(LOCATION location) is
                    super.init(location);
                si

                void accept(Visitor visitor) is
                    visitor.visit(this);
                si                                
            si

            class CALL isa PRIMARY is
                public EXPRESSION function;
                public EXPRESSION_LIST arguments;

                void init(LOCATION location, EXPRESSION function, EXPRESSION_LIST arguments) is
                    super.init(location);

                    this.function = function;
                    this.arguments = arguments;
                si

                void accept(Visitor visitor) is
                    visitor.visit(this);
                si
            si

            class MEMBER isa PRIMARY is 
                public EXPRESSION left;
                public IDENTIFIER identifier;

                void init(LOCATION location, EXPRESSION left, IDENTIFIER identifier) is
                    super.init(location);

                    this.left = left;
                    this.identifier = identifier;
                si

                void accept(Visitor visitor) is
                    visitor.visit(this);
                si                
            si

            class INDEX isa PRIMARY is 
                public EXPRESSION left;
                public EXPRESSION index;

                void init(LOCATION location, EXPRESSION left, EXPRESSION index) is
                    super.init(location);

                    this.left = left;
                    this.index = index;
                si

                void accept(Visitor visitor) is
                    visitor.visit(this);
                si                
            si            
        si
    si
si
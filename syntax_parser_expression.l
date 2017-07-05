namespace Syntax is
    namespace Parser is
        use Generic;

        use Source;

        class EXPRESSION isa PARSER<Tree.EXPRESSION> is

            Dict<Lexical.TOKEN, Expression.PRECEDENCE> precedence;
            Dict<Lexical.TOKEN, Tree.Expression.OPERATION> operation;

            void init() is
                super.init();

                precedence = new Map<Lexical.TOKEN, Expression.PRECEDENCE>();

                precedence[Lexical.TOKEN.DOT] = Expression.PRECEDENCE.MEMBER;
                precedence[Lexical.TOKEN.SQUARE_OPEN] = Expression.PRECEDENCE.MEMBER;
                precedence[Lexical.TOKEN.PAREN_OPEN] = Expression.PRECEDENCE.MEMBER;

                precedence[Lexical.TOKEN.STAR] = Expression.PRECEDENCE.MULTIPLICATION;
                precedence[Lexical.TOKEN.SLASH] = Expression.PRECEDENCE.MULTIPLICATION;
                precedence[Lexical.TOKEN.PERCENT] = Expression.PRECEDENCE.MULTIPLICATION;

                precedence[Lexical.TOKEN.PLUS] = Expression.PRECEDENCE.ADDITION;
                precedence[Lexical.TOKEN.MINUS] = Expression.PRECEDENCE.ADDITION;

                precedence[Lexical.TOKEN.AND] = Expression.PRECEDENCE.BITWISE;
                precedence[Lexical.TOKEN.OR] = Expression.PRECEDENCE.BITWISE;


                operation = new Map<Lexical.TOKEN, Tree.Expression.OPERATION>();

                operation[Lexical.TOKEN.DOT] = Tree.Expression.OPERATION.MEMBER;
                operation[Lexical.TOKEN.SQUARE_OPEN] = Tree.Expression.OPERATION.INDEX;
                operation[Lexical.TOKEN.PAREN_OPEN] = Tree.Expression.OPERATION.CALL;

                operation[Lexical.TOKEN.SLASH] = Tree.Expression.OPERATION.DIVIDE;
                operation[Lexical.TOKEN.STAR] = Tree.Expression.OPERATION.MULTIPLY;
                operation[Lexical.TOKEN.PERCENT] = Tree.Expression.OPERATION.MODULUS;

                operation[Lexical.TOKEN.PLUS] = Tree.Expression.OPERATION.ADD;
                operation[Lexical.TOKEN.MINUS] = Tree.Expression.OPERATION.SUBTRACT;

                operation[Lexical.TOKEN.AND] = Tree.Expression.OPERATION.AND;
                operation[Lexical.TOKEN.OR] = Tree.Expression.OPERATION.OR;                
            si

            Tree.EXPRESSION parse(CONTEXT context) is
                return parse(
                    context,
                    context.parse_expression_primary(),
                    Expression.PRECEDENCE.NONE
                );
            si

            Tree.EXPRESSION parse(
                CONTEXT context,
                Tree.EXPRESSION left,
                Expression.PRECEDENCE min_precedence
            )
            is
                do
                    var left_precedence = precedence[context.current_token];

                    if left_precedence < min_precedence then break; fi

                    var op = operation[context.current_token];
                    context.next_token();

                    Tree.EXPRESSION right = context.parse_expression_primary();
                    
                    do
                        var right_precedence = precedence[context.current_token];

                        if right_precedence <= left_precedence then
                            break;
                        fi

                        right = parse(context, right, right_precedence);
                    od

                    left = new Tree.Expression.BINARY(
                        left.location..right.location,
                        op,
                        left,
                        right
                    );
                od

                return left;
            si
        si

        namespace Expression is
            enum PRECEDENCE is
                NONE,
                BOOLEAN,
                RELATIONAL,
                SHIFT,
                BITWISE,
                ADDITION,
                MULTIPLICATION,
                MEMBER,
                PRIMARY
            si

            class PRIMARY isa PARSER<Tree.Expression.PRIMARY> is
                void init() is
                    super.init();

                    add_parser(
                        Tree.Expression.PRIMARY proc(CONTEXT context) is
                            return new Tree.Expression.UNARY(
                                context.location,
                                Tree.Expression.OPERATION.SUBTRACT,
                                this.parse(context)
                            );
                        si,
                        Lexical.TOKEN.MINUS
                    );

                    add_parser(
                        Tree.Expression.PRIMARY proc(CONTEXT context) is
                            var identifier = new Tree.Expression.IDENTIFIER(
                                context.location,
                                context.parse_identifier()
                            );                            
                            
                            if context.current_token == Lexical.TOKEN.COLON then
                                context.next_token();

                                return new Tree.Expression.TYPED(
                                    context.location,
                                    identifier,
                                    context.parse_type()
                                );
                            else
                                return identifier;
                            fi
                        si,
                        Lexical.TOKEN.IDENTIFIER
                    );

                    add_parser(
                        Tree.Expression.PRIMARY proc(CONTEXT context) is
                            return context.parse_expression_tuple();
                        si,
                        Lexical.TOKEN.PAREN_OPEN
                    );              

                    add_parser(
                        Tree.Expression.PRIMARY proc(CONTEXT context) is
                            return context.parse_expression_literal();
                        si,
                        {
                            Lexical.TOKEN.INT_LITERAL,
                            Lexical.TOKEN.STRING_LITERAL,
                            Lexical.TOKEN.NONE
                        }
                    );                    
                si
            si

            class TUPLE isa PARSER<Tree.Expression.TUPLE> is
                void init() is
                    super.init();
                si

                Tree.Expression.TUPLE parse(CONTEXT context) is                    
                    var start = context.location;
                    if context.next_token(Lexical.TOKEN.PAREN_OPEN) then
                        var expressions = new Vector<Tree.EXPRESSION>();

                        while context.current_token != Lexical.TOKEN.PAREN_CLOSE do
                            expressions.add(context.parse_expression());

                            if context.current_token == Lexical.TOKEN.COMMA then
                                context.next_token();
                            else
                                break;
                            fi
                        od

                        context.next_token(Lexical.TOKEN.PAREN_CLOSE);

                        return new Tree.Expression.TUPLE(start..context.location, expressions);
                    fi                    
                si
            si

            class LITERAL isa PARSER<Tree.Expression.LITERAL> is
                void init() is
                    super.init();

                    add_parser(
                        Tree.Expression.LITERAL proc(CONTEXT context) is
                            return new Tree.Expression.NONE(context.location);
                        si,
                        Lexical.TOKEN.NONE
                    );
                si          
            si
        si
    si
si
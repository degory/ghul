namespace Syntax is
    namespace Parser is
        use Generic;

        class EXPRESSION isa PARSER<Tree.EXPRESSION> is
            Dict<Lexical.TOKEN, Expression.PRECEDENCE> precedence;
            Dict<Lexical.TOKEN, Tree.Expression.OPERATION> operation;

            void init() is
                super.init();

                precedence = new Map<Lexical.TOKEN, Expression.PRECEDENCE>();

                precedence[Lexical.TOKEN.DOT] = Expression.PRIORITY.MEMBER;
                precedence[Lexical.TOKEN.SQUARE_OPEN] = Expression.PRIORITY.MEMBER;
                precedence[Lexical.TOKEN.PAREN] = Expression.PRIORITY.MEMBER;

                precedence[Lexical.TOKEN.STAR] = Expression.PRIORITY.MULTIPLICATION;
                precedence[Lexical.TOKEN.SLASH] = Expression.PRIORITY.MULTIPLICATION;
                precedence[Lexical.TOKEN.PERCENT] = Expression.PRIORITY.MULTIPLICATION;

                precedence[Lexical.TOKEN.PLUS] = Expression.PRIORITY.ADDITION;
                precedence[Lexical.TOKEN.MINUS] = Expression.PRIORITY.ADDITION;

                precedence[Lexical.TOKEN_AND_BITWISE] = Expression.PRIORITY.BITWISE;
                precedence[Lexical.TOKEN_OR_BITWISE] = Expression.PRIORITY.BITWISE;


                operation = new Map<Lexical.TOKEN, Tree.Expression.OPERATION>();

                operation[Lexical.TOKEN.DOT] = Tree.Expression.OPERATION.MEMBER;
                operation[Lexical.TOKEN.SQUARE_OPEN] = Tree.Expression.OPERATION.MEMBER;
                operation[Lexical.TOKEN.PAREN_OPEN] = Tree.Expression.OPERATION.MEMBER;

                operation[Lexical.TOKEN.SLASH] = Tree.Expression.OPERATION.DIVIDE;
                operation[Lexical.TOKEN.STAR] = Tree.Expression.OPERATION.MULTIPLICATION;
                operation[Lexical.TOKEN.PERCENT] = Tree.EXPRESSION.OPERATION.MODULUS;

                operation[Lexical.TOKEN.PLUS] = Tree.Expression.OPERATION.ADDITION;
                operation[Lexical.TOKEN.MINUS] = Tree.Expression.OPERATION.SUBTRACTION;

                operation[Lexical.TOKEN.AND] = Tree.Expression.OPERATION.AND_BITWISE;
                operation[Lexical.TOKEN.OR] = Tree.Expression.OPERATION.OR_BITWISE;
                
            si

            Tree.EXPRESSION parse(CONTEXT context) is
                return parse(
                    context,
                    context.parse_expression_primary(),
                    Expression.PRECEDENCE.FIRST
                );
            si

            EXPRESSION parse(
                CONTEXT context,
                EXPRESSION left,
                Expression.PRECEDENCE min_precedence
            )
            is
                do
                    var left_precedence = precedence[context.current_token];

                    if left_precedence < min_precedence then break; fi

                    var op = operation[context.current_token];
                    context.next_token();

                    var right = context.parse_expression_primary();
                    
                    do
                        var right_precedence = precedence[context.current_token];

                        if right_precedence <= left_precedence then
                            break;
                        fi

                        right = parse(context, right, right_precedence);
                    od

                    left = new Tree.Expression.INFIX(
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

            class PRIMARY isa PARSER<Tree.EXPRESSION> is
                void init() is
                    super.init();

                    add_parser(
                        PRIMARY proc(CONTEXT context) is
                            return new Expression.UNARY(
                                context.location,
                                OPERATION.SUBTRACTION,
                                this.parse(context)
                            );
                        si,
                        Lexical.TOKEN.MINUS
                    );

                    add_parser(
                        PRIMARY proc(CONTEXT context) is
                            var identifier = new Expression.IDENTIFIER(
                                context.location,
                                context.parse_identifier()
                            );                            
                            
                            if context.current_token == Lexical.TOKEN.COLON then
                                context.next_token();

                                return new Expression.TYPED(
                                    context.LOCATION,
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
                        TUPLE proc()(context.parse_tuple),
                        Lexical.TOKEN.PAREN_OPEN
                    );              

                    add_parser(
                        PRIMARY proc(CONTEXT context) is
                            return new Expression.LITERAL(
                                context.location,
                                context.parse_literal()
                            );
                        si,
                        {
                            Lexical.TOKEN.INTEGER,
                            Lexical.TOKEN.STRING,
                            Lexical.TOKEN.NONE
                        }
                    );                    
                si
            si

            class TUPLE isa PARSER<Tree.Expression.TUPLE> is
                void init() is
                    super.init();
                si

                TUPLE parse(CONTEXT context) is                    
                    if context.expect_token(Lexical.TOKEN.PAREN_OPEN) then
                        var expressions = new Vector<Tree.EXPRESSION>();
                        var start = context.location;

                        context.next_token();

                        while context.current_token != Lexical.TOKEN.PAREN_CLOSE do
                            expressions.add(context.parse_expression());

                            if context.current_token == Lexical.TOKEN.COMMA then
                                context.next_token();
                            else
                                break;
                            fi
                        od

                        context.next_token(Lexical.TOKEN.PAREN_CLOSE);
                    fi
                si
            si
        si
    si
si
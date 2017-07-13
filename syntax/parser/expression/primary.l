namespace Syntax is namespace Parser is namespace Expression is
    use System;

    use Source;

    class PRIMARY isa BASE<Tree.Expression.PRIMARY> is
        Parser<Tree.Identifier.NODE> identifier_parser;

        Parser<Tree.Type.NODE> type_parser;
        
        Parser<Tree.Expression.NODE> expression_parser;
        Parser<Tree.Expression.LIST> expression_list_parser;
        Parser<Tree.Expression.TUPLE> expression_tuple_parser;

        get String description is
            return "primary expression";
        si                

        void init(
            Parser<Tree.Identifier.NODE> identifier_parser,
            Parser<Tree.Type.NODE> type_parser,
            Parser<Tree.Expression.NODE> expression_parser,
            Parser<Tree.Expression.LIST> expression_list_parser,
            Parser<Tree.Expression.TUPLE> expression_tuple_parser            
        )
        is
            super.init();

            this.identifier_parser = identifier_parser;
            this.type_parser = type_parser;
            this.expression_parser = expression_parser;
            this.expression_list_parser = expression_list_parser;
            this.expression_tuple_parser = expression_tuple_parser;

            add_parser(
                Tree.Expression.PRIMARY proc(CONTEXT context) is
                    return new Tree.Expression.UNARY(
                        context.location,
                        Tree.Expression.OPERATION.SUBTRACT,
                        parse(context)
                    );
                si,
                Lexical.TOKEN.MINUS
            );

            add_parser(
                Tree.Expression.PRIMARY proc(CONTEXT context) is
                    var start = context.location;

                    var identifier = identifier_parser.parse(context);

                    // FIXME: tuple elements
                    if context.allow_tuple_element && !isa Tree.Identifier.QUALIFIED(identifier) then
                        context.allow_tuple_element = false;
                        
                        var end = identifier.location;
                        
                        Tree.Type.NODE type;
                        Tree.Expression.NODE initializer;

                        if context.current.token == Lexical.TOKEN.COLON then
                            context.next_token();

                            type = type_parser.parse(context);
                            end = type.location;
                        fi

                        if context.current.token == Lexical.TOKEN.ASSIGN then
                            context.next_token();

                            initializer = expression_parser.parse(context);
                            end = initializer.location;
                        fi

                        if initializer != null then
                            if type == null then
                                type = new Tree.Type.INFER(context.location);
                            fi
                        fi

                        if type != null then
                            return new Tree.Expression.VARIABLE(
                                start..end,
                                identifier,
                                type,
                                initializer
                            );
                        fi
                    fi

                    return new Tree.Expression.IDENTIFIER(
                        identifier.location,
                        identifier
                    );
                si,
                Lexical.TOKEN.IDENTIFIER
            );

            add_parser(
                Tree.Expression.PRIMARY proc(CONTEXT context) is
                    var start = context.location;

                    context.next_token();

                    var elements = expression_list_parser.parse(context);
                    var end = context.location;

                    context.next_token(Lexical.TOKEN.SQUARE_CLOSE);

                    return new Tree.Expression.LIST_LITERAL(
                        start..end,
                        elements
                    );
                si,
                Lexical.TOKEN.SQUARE_OPEN
            );
            
            add_parser(
                Tree.Expression.PRIMARY proc(CONTEXT context) is
                    return expression_tuple_parser.parse(context);
                si,
                Lexical.TOKEN.PAREN_OPEN
            );              

            add_parser(
                Tree.Expression.PRIMARY proc(CONTEXT context) is
                    var location = context.location;
                    var string = context.current.string;
                    context.next_token();
                    return new Tree.Expression.LITERAL(location, string);
                si,
                {
                    Lexical.TOKEN.INT_LITERAL,
                    Lexical.TOKEN.STRING_LITERAL,
                    Lexical.TOKEN.NONE
                }
            );
        si
    si
si si si
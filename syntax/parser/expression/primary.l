namespace Syntax is namespace Parser is namespace Expression is
    use System;

    use Source;

    class PRIMARY isa BASE<Tree.Expression.NODE> is
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
                Tree.Expression.NODE proc(CONTEXT context) is
                    var name = 
                        new Tree.Identifier.NODE(
                            context.location,
                            context.current_string
                        );
                    
                    context.next_token();

                    var right = parse(context);

                    return new Tree.Expression.UNARY(
                        name.location..right.location,
                        name,
                        right
                    );
                si,
                Lexical.TOKEN.OPERATOR
            );

            add_parser(
                Tree.Expression.NODE proc(CONTEXT context) is
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
                Tree.Expression.NODE proc(CONTEXT context) is
                    var start = context.location;

                    context.next_token();

                    var elements = expression_list_parser.parse(context);

                    Tree.Type.NODE type;

                    var end = context.location;

                    context.next_token(Lexical.TOKEN.SQUARE_CLOSE);

                    // legacy language cannot always correctly infer correct
                    // type for list literals, and in the short term we need
                    // to translate new to legacy syntax, so support specifying
                    // explict element type here:
                    if context.current.token == Lexical.TOKEN.COLON then
                        context.next_token();

                        type = type_parser.parse(context);

                        end = type.location;
                    else
                        type = new Tree.Type.INFER(start..end);
                    fi

                    return new Tree.Expression.SEQUENCE(
                        start..end,
                        elements,
                        type
                    );
                si,
                Lexical.TOKEN.SQUARE_OPEN
            );
            
            add_parser(
                Tree.Expression.NODE proc(CONTEXT context) is
                    return expression_tuple_parser.parse(context);
                si,
                Lexical.TOKEN.PAREN_OPEN
            );

            add_parser(
                Tree.Expression.NODE proc(CONTEXT context) is
                    var start = context.location;

                    context.next_token(Lexical.TOKEN.NEW);

                    var type = type_parser.parse(context);

                    var arguments = expression_tuple_parser.parse(context);

                    return new Tree.Expression.NEW(
                        start..arguments.location,
                        type,
                        arguments
                    );
                si,
                Lexical.TOKEN.NEW
            );

            add_parser(
                Tree.Expression.NODE proc(CONTEXT context) is
                    var start = context.location;

                    context.next_token(Lexical.TOKEN.CAST);

                    var type = type_parser.parse(context);

                    context.next_token(Lexical.TOKEN.PAREN_OPEN);

                    var value = expression_parser.parse(context);
                    
                    var result = new Tree.Expression.CAST(
                        start..context.location,
                        type,
                        value
                    );

                    context.next_token(Lexical.TOKEN.PAREN_CLOSE);

                    return result;
                si,
                Lexical.TOKEN.CAST
            );       

            add_parser(
                Tree.Expression.NODE proc(CONTEXT context) is
                    var location = context.location;
                    var string = context.current.string;
                    context.next_token();
                    return new Tree.Expression.Literal.INTEGER(location, string);
                si,
                Lexical.TOKEN.INT_LITERAL
            );

            add_parser(
                Tree.Expression.NODE proc(CONTEXT context) is
                    var location = context.location;
                    var string = context.current.string;
                    context.next_token();
                    return new Tree.Expression.Literal.STRING(location, string);
                si,
                Lexical.TOKEN.STRING_LITERAL
            );

            add_parser(
                Tree.Expression.NODE proc(CONTEXT context) is
                    var location = context.location;
                    var string = context.current.string;
                    context.next_token();
                    return new Tree.Expression.Literal.CHARACTER(location, string);
                si,
                Lexical.TOKEN.CHAR_LITERAL
            );

            add_parser(
                Tree.Expression.NODE proc(CONTEXT context) is
                    var location = context.location;
                    context.next_token();
                    return new Tree.Expression.Literal.NONE(location);
                si,
                Lexical.TOKEN.NONE
            );            

            add_parser(
                Tree.Expression.NODE proc(CONTEXT context) is
                    var location = context.location;
                    context.next_token();
                    return new Tree.Expression.SELF(location);
                si,
                Lexical.TOKEN.SELF
            );            

            add_parser(
                Tree.Expression.NODE proc(CONTEXT context) is
                    var location = context.location;
                    context.next_token();
                    return new Tree.Expression.SUPER(location);
                si,
                Lexical.TOKEN.SUPER
            );                        
        si
    si
si si si
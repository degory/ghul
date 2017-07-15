namespace Syntax is namespace Parser is namespace Definition is
    use System;

    use Source;

    class PROPERTY isa BASE<Tree.Definition.PROPERTY> is
        Parser<Tree.Identifier.NODE> identifier_parser;
        Parser<Tree.Type.NODE> type_parser;
        Parser<Tree.Definition.LIST> definition_list_parser;
        Parser<Tree.Body.NODE> body_parser;

        void init(
            Parser<Tree.Identifier.NODE> identifier_parser,
            Parser<Tree.Type.NODE> type_parser,
            Parser<Tree.Definition.LIST> definition_list_parser,
            Parser<Tree.Body.NODE> body_parser
        ) is
            super.init();
            this.identifier_parser = identifier_parser;
            this.type_parser = type_parser;
            this.definition_list_parser = definition_list_parser;
            this.body_parser = body_parser;
        si

        Tree.Definition.PROPERTY parse(CONTEXT context) is
            var start = context.location;
            var name = identifier_parser.parse(context);

            Tree.Type.NODE type;

            if context.current.token == Lexical.TOKEN.COLON then
                context.next_token();

                type = type_parser.parse(context);
            else
                type = new Tree.Type.INFER(context.location);
            fi

            Tree.Body.NODE getter_body;
            Tree.Body.NODE setter_body;
            Tree.Identifier.NODE setter_argument_name;

            var expect_semicolon = true;

            do
                if context.current.token == Lexical.TOKEN.ASSIGN then
                    if setter_argument_name != null then
                        context.error(context.location, "replacing assign");                        
                    fi

                    context.next_token();

                    setter_argument_name = identifier_parser.parse(context);

                    // FIXME: should we allow expression body here anyway?
                    expect_semicolon = context.current.token == Lexical.TOKEN.ARROW_FAT;

                    setter_body = body_parser.parse(context);

                    if context.current.token == Lexical.TOKEN.COMMA then
                        context.next_token();
                    else
                        break;
                    fi
                elif {Lexical.TOKEN.IS, Lexical.TOKEN.ARROW_FAT}.contains(context.current.token) then
                    expect_semicolon = context.current.token == Lexical.TOKEN.ARROW_FAT;

                    if getter_body != null then
                        context.error(context.location, "replacing read");
                    fi

                    getter_body = body_parser.parse(context);

                    if context.current.token == Lexical.TOKEN.COMMA then
                        context.next_token();
                    else
                        break;
                    fi                    
                fi
            od

            var result = new Tree.Definition.PROPERTY(
                start..context.location,
                type,
                name,
                getter_body,
                setter_argument_name,
                setter_body
            );

            if expect_semicolon then
                context.next_token(Lexical.TOKEN.SEMICOLON);
            fi

            return result;
        si
    si
si si si
            

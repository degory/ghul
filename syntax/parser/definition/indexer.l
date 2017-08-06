namespace Syntax is namespace Parser is namespace Definition is
    use System;
    use Generic;

    use Source;

    class INDEXER isa BASE<Tree.Definition.INDEXER> is
        Parser<Tree.Identifier.NODE> identifier_parser;
        Parser<Tree.Type.NODE> type_parser;
        Parser<Tree.Modifier.LIST> modifier_list_parser;        
        Parser<Tree.Variable.NODE> variable_parser;
        Parser<Tree.Body.NODE> body_parser;
        
        get String description is return "indexer"; si

        void init(
            Parser<Tree.Identifier.NODE> identifier_parser,
            Parser<Tree.Type.NODE> type_parser,
            Parser<Tree.Modifier.LIST> modifier_list_parser,            
            Parser<Tree.Variable.NODE> variable_parser,
            Parser<Tree.Body.NODE> body_parser
        ) is
            super.init();

            this.identifier_parser = identifier_parser;
            this.type_parser = type_parser;
            this.modifier_list_parser = modifier_list_parser;
            this.variable_parser = variable_parser;
            this.body_parser = body_parser;
        si

        Tree.Definition.INDEXER parse(CONTEXT context) is
            Tree.Identifier.NODE name;

            var start = context.location;

            if context.current.token == Lexical.TOKEN.IDENTIFIER then
                name = identifier_parser.parse(context);
            fi

            context.next_token(Lexical.TOKEN.SQUARE_OPEN);

            var index_argument = variable_parser.parse(context);

            context.next_token(Lexical.TOKEN.SQUARE_CLOSE);

            Tree.Type.NODE type;

            if context.current.token == Lexical.TOKEN.COLON then
                context.next_token();
                type = type_parser.parse(context);
            else
                type = new Tree.Type.INFER(context.location);
            fi

            var modifiers = modifier_list_parser.parse(context);

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
                else
                    context.error(context.location, "unexpected input in indexer");
                    break;
                fi
            od
            
            var result = new Tree.Definition.INDEXER(
                start..context.location,
                name,
                index_argument,
                type,
                modifiers,
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
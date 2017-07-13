namespace Syntax is namespace Parser is namespace Definition is
    use System;

    use Source;

    class CLASS isa BASE<Tree.Definition.CLASS> is
        Parser<Tree.Identifier.NODE> identifier_parser;
        Parser<Tree.Type.NODE> type_parser;
        Parser<Tree.Type.LIST> type_list_parser;
        Parser<Tree.Definition.LIST> definition_list_parser;

        void init(
            Parser<Tree.Identifier.NODE> identifier_parser,
            Parser<Tree.Type.NODE> type_parser,
            Parser<Tree.Type.LIST> type_list_parser,
            Parser<Tree.Definition.LIST> definition_list_parser
        ) is
            super.init();
            
            this.identifier_parser = identifier_parser;
            this.type_parser = type_parser;
            this.type_list_parser = type_list_parser;
            this.definition_list_parser = definition_list_parser;
        si

        Tree.Definition.CLASS parse(CONTEXT context) is
            context.next_token(Lexical.TOKEN.CLASS);

            var start = context.location;
            var identifier = identifier_parser.parse(context);

            Tree.Type.LIST arguments;
            Tree.Type.LIST ancestors;

            if context.current.token == Lexical.TOKEN.SQUARE_OPEN then
                context.next_token();

                arguments = type_list_parser.parse(context);

                context.next_token(Lexical.TOKEN.SQUARE_CLOSE);
            fi

            if context.current.token == Lexical.TOKEN.COLON then
                context.next_token();

                ancestors = type_list_parser.parse(context);
            fi

            context.next_token(Lexical.TOKEN.IS);

            var body = definition_list_parser.parse(context);

            var result = new Tree.Definition.CLASS(
                start..context.location,
                identifier,
                arguments,
                ancestors,
                body
            );

            context.next_token(Lexical.TOKEN.SI);

            return result;
        si
    si
si si si

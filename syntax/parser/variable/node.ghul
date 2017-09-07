namespace Syntax is namespace Parser is namespace Variable is

    class NODE isa BASE<Tree.Variable.NODE> is    
        Parser<Tree.Identifier.NODE> identifier_parser;
        Parser<Tree.Type.NODE> type_parser;
        Parser<Tree.Expression.NODE> expression_parser;

        void init(
            Parser<Tree.Identifier.NODE> identifier_parser,
            Parser<Tree.Type.NODE> type_parser,
            Parser<Tree.Expression.NODE> expression_parser
        )
        is
            super.init();

            this.identifier_parser = identifier_parser;
            this.type_parser = type_parser;
            this.expression_parser = expression_parser;
        si

        Tree.Variable.NODE parse(CONTEXT context) is
            var start = context.location;

            if context.expect_token(Lexical.TOKEN.IDENTIFIER, syntax_error_message) then
                var identifier = identifier_parser.parse(context);
                var end = identifier.location;
                
                Tree.Type.NODE type = new Tree.Type.INFER(start..context.location);
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

                return new Tree.Variable.NODE(
                    start..end,
                    identifier,
                    type,
                    initializer);    
            fi
        si
    si
si si si

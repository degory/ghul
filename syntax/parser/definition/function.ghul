namespace Syntax is namespace Parser is namespace Definition is
    use System;

    use Source;

    class FUNCTION isa BASE<Tree.Definition.FUNCTION> is
        Parser<Tree.Identifier.NODE> identifier_function_name_parser;
        Parser<Tree.Type.NODE> type_parser;
        Parser<Tree.Modifier.LIST> modifier_list_parser;        
        Parser<Tree.Body.NODE> body_parser;
        Parser<Tree.Variable.LIST> variable_list_parser;

        void init(
            Parser<Tree.Identifier.NODE> identifier_function_name_parser,
            Parser<Tree.Type.NODE> type_parser,
            Parser<Tree.Modifier.LIST> modifier_list_parser,            
            Parser<Tree.Body.NODE> body_parser,
            Parser<Tree.Variable.LIST> variable_list_parser
        ) is
            super.init();
            
            this.identifier_function_name_parser = identifier_function_name_parser;
            this.type_parser = type_parser;
            this.modifier_list_parser = modifier_list_parser;
            this.body_parser = body_parser;
            this.variable_list_parser = variable_list_parser;
        si

        Tree.Definition.FUNCTION parse(CONTEXT context) is
            var start = context.location;
            var name = identifier_function_name_parser.parse(context);
            context.next_token(Lexical.TOKEN.PAREN_OPEN);

            Tree.Variable.LIST arguments;

            if context.current_token != Lexical.TOKEN.PAREN_CLOSE then
                arguments = variable_list_parser.parse(context);
            else
                arguments = new Tree.Variable.LIST(context.location, new Tree.Variable.NODE[0]);
            fi

            context.next_token(Lexical.TOKEN.PAREN_CLOSE);

            Tree.Type.NODE type;

            if context.current.token == Lexical.TOKEN.ARROW_THIN then
                context.next_token();
                type = type_parser.parse(context);
            else
                type = new Tree.Type.INFER(context.location);
            fi

            var modifiers = modifier_list_parser.parse(context);

            // FIXME: body parser can't handle this as it may be called from an expression,
            // where we never want a semi-colon after a function body
            var expect_semicolon = context.current.token != Lexical.TOKEN.IS;

            var body = body_parser.parse(context);

            var result = new Tree.Definition.FUNCTION(
                start..context.location,
                name,
                arguments,
                type,
                modifiers,
                body
            );

            if expect_semicolon then
                context.next_token(Lexical.TOKEN.SEMICOLON);
            fi

            return result;
        si
    si
si si si

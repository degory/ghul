namespace Syntax is namespace Parser is namespace Definition is
    use System;
    use Generic;

    use Source;

    class ENUM isa BASE<Tree.Definition.ENUM> is
        Parser<Tree.Identifier.NODE> identifier_parser;
        Parser<Tree.Expression.NODE> expression_parser;

        void init(
            Parser<Tree.Identifier.NODE> identifier_parser,
            Parser<Tree.Expression.NODE> expression_parser
        ) is
            super.init();
            
            this.identifier_parser = identifier_parser;
            this.expression_parser = expression_parser;
        si

        Tree.Definition.ENUM parse(CONTEXT context) is
            context.next_token(Lexical.TOKEN.ENUM);

            var start = context.location;
            var name = identifier_parser.parse(context);

            context.next_token(Lexical.TOKEN.IS);

            var members = new Vector<Tree.Definition.ENUM_MEMBER>();

            while context.current.token != Lexical.TOKEN.SI do
                var member_name = identifier_parser.parse(context);
                var member_end = member_name.location;

                Tree.Expression.NODE member_initializer;

                if context.current.token == Lexical.TOKEN.ASSIGN then
                    context.next_token();

                    member_initializer = expression_parser.parse(context);
                    member_end = member_initializer.location;
                fi

                if context.current.token != Lexical.TOKEN.SI then
                    context.next_token(Lexical.TOKEN.COMMA);
                fi

                members.add(
                    new Tree.Definition.ENUM_MEMBER(
                        member_name.location..member_end,
                        member_name,
                        member_initializer
                    )
                );
            od

            var result = new Tree.Definition.ENUM(
                start..context.location,
                name,
                members
            );

            context.next_token(Lexical.TOKEN.SI);

            return result;
        si
    si
si si si

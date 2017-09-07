namespace Syntax is namespace Parser is namespace Definition is
    use Generic;
    use System;

    use Source;

    class USE isa BASE<Tree.Definition.USE> is
        Parser<Tree.Identifier.NODE> identifier_qualified_parser;

        void init(
            Parser<Tree.Identifier.NODE> identifier_qualified_parser
        ) is
            super.init();
            
            this.identifier_qualified_parser = identifier_qualified_parser;
        si

        Tree.Definition.USE parse(CONTEXT context) is
            var start = context.location;
            context.next_token(Lexical.TOKEN.USE);

            var uses = new Vector<Tree.Identifier.NODE>();

            do
                var use_ = identifier_qualified_parser.parse(context);

                uses.add(use_);

                if context.current.token == Lexical.TOKEN.COMMA then
                    context.next_token();
                else
                    break;
                fi
            od

            var result = new Tree.Definition.USE(
                start..context.location,
                uses
            );

            context.next_token(Lexical.TOKEN.SEMICOLON);

            return result;
        si
    si
si si si

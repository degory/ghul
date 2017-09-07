namespace Syntax is namespace Parser is namespace Definition is
    use Generic;
    use System;

    use Source;

    class IMPORT isa BASE<Tree.Definition.IMPORT> is
        Parser<Tree.Identifier.NODE> identifier_parser;

        void init(
            Parser<Tree.Identifier.NODE> identifier_parser
        ) is
            super.init();
            
            this.identifier_parser = identifier_parser;
        si

        Tree.Definition.IMPORT parse(CONTEXT context) is
            var start = context.location;
            context.next_token(Lexical.TOKEN.IMPORT);

            var imports = new Vector<Tree.Identifier.NODE>();

            do
                var import_ = identifier_parser.parse(context);

                imports.add(import_);

                if context.current.token == Lexical.TOKEN.COMMA then
                    context.next_token();
                else
                    break;
                fi
            od

            var result = new Tree.Definition.IMPORT(
                start..context.location,
                imports
            );

            context.next_token(Lexical.TOKEN.SEMICOLON);

            return result;
        si
    si
    
si si si

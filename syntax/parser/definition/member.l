namespace Syntax is namespace Parser is namespace Definition is
    use System;
    use Generic;

    use Source;

    class MEMBER isa BASE<Tree.Definition.NODE> is
        Parser<Tree.Definition.FUNCTION> function_parser;
        Parser<Tree.Definition.PROPERTY> property_parser;

        get String description is return "member"; si

        List<Lexical.TOKEN> property_tokens;

        void init(
            Parser<Tree.Definition.FUNCTION> function_parser,
            Parser<Tree.Definition.PROPERTY> property_parser
        ) is
            super.init();

            this.function_parser = function_parser;
            this.property_parser = property_parser;

            property_tokens = {Lexical.TOKEN.COLON, Lexical.TOKEN.ASSIGN, Lexical.TOKEN.ARROW_FAT, Lexical.TOKEN.SEMICOLON};
        si

        Tree.Definition.NODE parse(CONTEXT context) is
            // need two token lookahead here to determine if this is a
            // property or a function. Read the identifier first:

            var ident = context.current;

            context.next_token();
            
            if property_tokens.contains(context.current.token) then
                var punctuation = context.current;

                // push the identifier and punctuation back, so we can read them again:
                context.write_tokens({ident, punctuation});

                return property_parser.parse(context);

            elif context.current.token == Lexical.TOKEN.PAREN_OPEN then
                var paren = context.current;

                // push the identifier and parenthesis back, so we can read them again:
                context.write_tokens({ident, paren});

                return function_parser.parse(context); 
            fi
        si
    si
si si si
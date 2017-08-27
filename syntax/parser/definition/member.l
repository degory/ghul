namespace Syntax is namespace Parser is namespace Definition is
    use System;
    use Generic;

    use Source;

    class MEMBER isa BASE<Tree.Definition.NODE> is
        Parser<Tree.Definition.FUNCTION> function_parser;
        Parser<Tree.Definition.PROPERTY> property_parser;
        Parser<Tree.Definition.INDEXER> indexer_parser;

        get String description is return "member"; si

        List<Lexical.TOKEN> property_tokens;

        void init(
            Parser<Tree.Definition.FUNCTION> function_parser,
            Parser<Tree.Definition.PROPERTY> property_parser,
            Parser<Tree.Definition.INDEXER> indexer_parser
        ) is
            super.init();

            this.function_parser = function_parser;
            this.property_parser = property_parser;
            this.indexer_parser = indexer_parser;

            property_tokens = {Lexical.TOKEN.COLON, Lexical.TOKEN.ASSIGN, Lexical.TOKEN.ARROW_FAT, Lexical.TOKEN.SEMICOLON};
        si

        Tree.Definition.NODE parse(CONTEXT context) is
            // need two token lookahead here to determine if this is a
            // property or a function. Read the identifier first:

            if context.current.token == Lexical.TOKEN.SQUARE_OPEN then
                return indexer_parser.parse(context);
            fi

            context.mark();
            context.next_token();
            
            if property_tokens.contains(context.current.token) then
                // backtrack to the identifier and parse as a property:
                context.backtrack();

                return property_parser.parse(context);

            elif context.current.token == Lexical.TOKEN.SQUARE_OPEN then
                context.backtrack();

                return indexer_parser.parse(context);

            elif context.current.token == Lexical.TOKEN.PAREN_OPEN then
                // backtrack to the identifier or operator and parse as a function:
                context.backtrack();
                return function_parser.parse(context); 
            fi
            
            context.commit();

            other_token(context);
        si
    si
si si si
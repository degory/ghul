namespace Syntax is namespace Parser is namespace Identifier is
    use System;
    use Source;

    class NODE isa BASE<Tree.Identifier.NODE> is
        void init() is
            super.init();
        si

        get String description is
            return "identifier";
        si            

        Tree.Identifier.NODE parse(CONTEXT context) is
            if context.expect_token(Lexical.TOKEN.IDENTIFIER, syntax_error_message) then
                var name = context.current.string;
                var result = new Tree.Identifier.NODE(context.location, name);

                context.next_token();                    

                return result;
            fi
        si
    si
si si si


namespace Syntax is namespace Parser is namespace Identifier is
    use System;
    use Source;

    class QUALIFIED isa BASE<Tree.Identifier.NODE> is

        get String description is
            return "qualified identifier";
        si            

        public void init() is
            super.init();
        si

        Tree.Identifier.NODE parse(CONTEXT context) is
            var start = context.location;

            if context.expect_token(Lexical.TOKEN.IDENTIFIER, syntax_error_message) then
                var name = context.current.string;
                var result = new Tree.Identifier.NODE(context.location, name);

                context.next_token();                    

                while context.current.token == Lexical.TOKEN.DOT do
                    context.next_token();

                    if context.expect_token(Lexical.TOKEN.IDENTIFIER, syntax_error_message) then
                        result =
                            new Tree.Identifier.QUALIFIED(
                                start..context.location,
                                result,
                                context.current.string);
                        
                        context.next_token();
                    fi                        
                od

                return result;
            fi
        si
    si
si si si

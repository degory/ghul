namespace Syntax is
    namespace Parser is
        use System;
        use Source;

        // a.b.c.d -> d.c.b.a

        class IDENTIFIER isa PARSER<Tree.IDENTIFIER> is
            void init() is
                super.init();
            si

            get String description is
                return "identifier";
            si            

            Tree.IDENTIFIER parse(CONTEXT context) is
                var start = context.location;

                if context.expect_token(Lexical.TOKEN.IDENTIFIER, syntax_error_message) then
                    var name = context.current_string;
                    var result = new Tree.IDENTIFIER(context.location, name);

                    context.next_token();                    

                    while context.current_token == Lexical.TOKEN.DOT do
                        context.next_token();

                        if context.expect_token(Lexical.TOKEN.IDENTIFIER, syntax_error_message) then
                            result =
                                new Tree.QUALIFIED_IDENTIFIER(
                                    start..context.location,
                                    result,
                                    context.current_string);
                            
                            context.next_token();
                        fi                        
                    od

                    return result;
                fi
            si

            Tree.IDENTIFIER parse_unqualified_identifier(CONTEXT context) is
                if context.expect_token(Lexical.TOKEN.IDENTIFIER, syntax_error_message) then
                    var name = context.current_string;
                    var result = new Tree.IDENTIFIER(context.location, name);

                    context.next_token();                    

                    return result;
                fi
            si
        si
    si
si

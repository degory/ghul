namespace Syntax is
    namespace Parser is
        // a.b.c.d -> d.c.b.a

        class IDENTIFIER do Parser<Tree.IDENTIFIER> is
            void init() is
                super.init();
            si

            Tree.IDENTIFIER parse(CONTEXT context) is
                var start = context.location;

                if context.expect_token(Lexical.TOKEN.IDENTIFIER) then
                    var name = context.current_string;
                    var result = new Tree.IDENTIFIER(context.location, name);

                    context.next_token();                    

                    while context.current_token == Lexical.TOKEN.DOT do
                        context.next_token();

                        result =
                            new Tree.QUALIFIED_IDENTIFIER(
                                start..context.location,
                                result,
                                context.current_string);
                    od

                    return result;
                fi
            si
        si
    si
si

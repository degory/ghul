namespace Syntax is
    namespace Parser is
        // a.b.c.d -> d.c.b.a

        class IDENTIFIER do Parser<Tree.IDENTIFIER> is
            void init() is
                super.init();
            si

            Tree.IDENTIFIER parse(CONTEXT context) is
                if context.expect_token(Lexical.TOKEN.IDENTIFIER) then
                    var name = state.token_string;
                    state.next_token();

                    var result = new Tree.IDENTIFER(name);

                    while context.current_token == Lexical.TOKEN.DOT do
                        context.next_token();

                        result =
                            new Tree.QUALIFIED_IDENTIFIER(
                                result,
                                context.current_string);
                    od

                    return result;
                fi
            si
        si
    si
si

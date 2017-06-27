namespace Syntax is
    namespace Parse is
        // a.b.c.d -> d.c.b.a

        class IDENTIFIER do Parser<Tree.IDENTIFIER> is
            IDENTIFIER parse(CONTEXT state) is
                IDENTIFIER result = null;

                if state.ensure_current_token_is(Lexical.Token.IDENTIFIER) then
                    var name = state.token_string;
                    state.next_token();

                    var result = new Tree.IDENTIFER(name);

                    while state.current_token == Lexical.Token.DOT do
                       state.next_token();

                       return new Tree.QUALIFIED_IDENTIFIER(name, state.token_string);
                    od
                fi
            si
        si
    si
si

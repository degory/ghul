namespace Syntax is
    namespace Parse is

        // a.b.c.d -> d.c.b.a

        class DEFINITION do Parser<Tree.DEFINITION> is
            void init() is
              add_paser(
                Definition.
            si

            Tree.DEFINITION parse(CONTEXT context) is
                Tree.IDENTIFIER result = null;

                if state.ensure_current_token_is(Lexical.Token.IDENTIFIER) then
                    var name = context.current_identifier;
                    state.next_token();

                    while context.current_token == Lexical.Token.DOT do
                       context.next_token();

                       
                       
                       return new Tree.QUALIFIED_IDENTIFIER(
                    fi
                fi
            si
        si
    si
si

namespace Syntax is namespace Parser is namespace Identifier is
    use System;
    use Source;

    class FUNCTION_NAME isa BASE<Tree.Identifier.NODE> is
        void init() is
            super.init();

            add_parser(
                Tree.Identifier.NODE proc(CONTEXT context) is
                    var name = context.current.string;
                    var result = new Tree.Identifier.NODE(context.location, name);

                    context.next_token();                    

                    return result;
                si,
                Lexical.TOKEN{Lexical.TOKEN.IDENTIFIER, Lexical.TOKEN.OPERATOR}
            );
        si

        get String description is
            return "function name";
        si            
    si
si si si

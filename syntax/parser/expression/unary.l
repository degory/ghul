namespace Syntax is namespace Parser is namespace Expression is
    use System;

    use Source;

    class UNARY isa BASE<Tree.Expression.NODE> is
        Parser<Tree.Expression.NODE> secondary_parser;

        get String description is
            return "unary expression";
        si                

        void init(
            Parser<Tree.Expression.NODE> secondary_parser
        )
        is
            super.init();

            this.secondary_parser = secondary_parser;

            add_parser(
                Tree.Expression.NODE proc(CONTEXT context) is
                    return new Tree.Expression.UNARY(
                        context.location,
                        Tree.Expression.OPERATION.SUBTRACT,
                        parse(context)
                    );
                si,
                Lexical.TOKEN.MINUS
            );

            add_parser(
                Tree.Expression.NODE proc(CONTEXT context) is
                    return new Tree.Expression.UNARY(
                        context.location,
                        Tree.Expression.OPERATION.NOT,
                        parse(context)
                    );
                si,
                Lexical.TOKEN.BANG
            );

            add_parser(
                Tree.Expression.NODE proc(CONTEXT context) is
                    return new Tree.Expression.UNARY(
                        context.location,
                        Tree.Expression.OPERATION.NOT_BITWISE,
                        parse(context)
                    );
                si,
                Lexical.TOKEN.TILDE
            );            

        si

        Tree.Expression.NODE other_token(CONTEXT context) is
            return secondary_parser.parse(context);
        si
    si
si si si
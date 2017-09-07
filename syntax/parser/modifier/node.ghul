namespace Syntax is namespace Parser is namespace Modifier is

    class NODE isa BASE<Tree.Modifier.NODE> is

        void init(
        )
        is
            super.init();

            add_parser(
                Tree.Modifier.NODE proc(CONTEXT context) is
                    return new Tree.Modifier.PUBLIC(context.location_and_next());
                si,
            Lexical.TOKEN.PUBLIC);

            add_parser(
                Tree.Modifier.NODE proc(CONTEXT context) is
                    return new Tree.Modifier.PRIVATE(context.location_and_next());
                si,
            Lexical.TOKEN.PRIVATE);

            add_parser(
                Tree.Modifier.NODE proc(CONTEXT context) is
                    return new Tree.Modifier.PROTECTED(context.location_and_next());
                si,
            Lexical.TOKEN.PROTECTED);

            add_parser(
                Tree.Modifier.NODE proc(CONTEXT context) is
                    return new Tree.Modifier.STATIC(context.location_and_next());
                si,
            Lexical.TOKEN.STATIC);

            add_parser(
                Tree.Modifier.NODE proc(CONTEXT context) is
                    return new Tree.Modifier.CONST(context.location_and_next());
                si,
            Lexical.TOKEN.CONST);            
        si

        Tree.Modifier.NODE other_token(CONTEXT context) is
            return null;
        si
    si
si si si

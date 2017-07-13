namespace Syntax is namespace Parser is namespace Type is
    use Generic;
    
    class LIST isa BASE<Tree.Type.LIST> is
        Parser<Tree.Type.NODE> type_parser;

        void init(
            Parser<Tree.Type.NODE> type_parser
        )
        is
            super.init();

            this.type_parser = type_parser;
        si

        Tree.Type.LIST parse(CONTEXT context) is                
            var elements = new Vector<Tree.Type.NODE>();

            var start = context.location;                
            var end = context.location;

            do
                var element = type_parser.parse(context);
                elements.add(element);

                end = element.location;

                if context.current.token != Lexical.TOKEN.COMMA then break; fi

                context.next_token();
            od

            var result = new Tree.Type.LIST(start..end, elements);

            return result;
        si
    si
si si si
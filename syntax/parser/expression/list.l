
namespace Syntax is namespace Parser is namespace Expression is
    use System;
    use Generic;

    use Source;

    class LIST isa BASE<Tree.Expression.LIST> is
        Parser<Tree.Expression.NODE> expression_parser;

        void init(
            Parser<Tree.Expression.NODE> expression_parser
        ) is
            super.init();

            this.expression_parser = expression_parser;
        si

        get String description is
            return "expression list";
        si

        Tree.Expression.LIST parse(CONTEXT context) is
            var start = context.location;

            var expressions = new Vector<Tree.Expression.NODE>();

            do
                context.allow_tuple_element = true;
                var expression = expression_parser.parse(context);
                context.allow_tuple_element = false;

                expressions.add(expression);

                if context.current.token != Lexical.TOKEN.COMMA then
                    return new Tree.Expression.LIST(start..expression.location, expressions);
                fi

                context.next_token();
            od
        si
    si
si si si
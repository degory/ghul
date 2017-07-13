namespace Syntax is namespace Parser is namespace Expression is
    use System;
    use Generic;

    use Source;

    class TUPLE isa BASE<Tree.Expression.TUPLE> is
        Parser<Tree.Expression.LIST> expression_list_parser;

        void init(Parser<Tree.Expression.LIST> expression_list_parser) is
            super.init();

            this.expression_list_parser = expression_list_parser;
        si

        get String description is
            return "tuple";
        si                

        Tree.Expression.TUPLE parse(CONTEXT context) is                    
            var start = context.location;
            if context.next_token(Lexical.TOKEN.PAREN_OPEN, syntax_error_message) then
                Tree.Expression.LIST expressions;

                if context.current.token != Lexical.TOKEN.PAREN_CLOSE then
                    expressions = expression_list_parser.parse(context);
                else
                    expressions = new Tree.Expression.LIST(context.location, new Vector<Tree.Expression.NODE>());
                fi
                
                context.next_token(Lexical.TOKEN.PAREN_CLOSE, syntax_error_message);

                return new Tree.Expression.TUPLE(start..context.location, expressions);
            fi                    
        si
    si
si si si
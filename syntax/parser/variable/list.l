namespace Syntax is namespace Parser is namespace Variable is
    use System;
    use Generic;

    use Source;

    class LIST isa BASE<Tree.Variable.LIST> is
        bool allow_empty; // FIXME: pass this in somehow

        Parser<Tree.Variable.NODE> variable_parser;

        void init(Parser<Tree.Variable.NODE> variable_parser) is
            super.init();

            this.variable_parser = variable_parser;
        si

        Tree.Variable.LIST parse(CONTEXT context) is
            var start = context.location;
            var end = context.location;

            var variables = new Vector<Tree.Variable.NODE>();

            if context.current.token == Lexical.TOKEN.IDENTIFIER || !allow_empty then
                do
                    var variable = variable_parser.parse(context);
                    end = variable.location;

                    variables.add(variable);

                    if context.current.token != Lexical.TOKEN.COMMA then
                        break;
                    else
                        context.next_token();
                    fi
                od
            fi

            return new Tree.Variable.LIST(start..end, variables);
        si
    si
si si si
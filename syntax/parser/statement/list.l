namespace Syntax is namespace Parser is namespace Statement is
    use System;
    use Generic;

    use Source;

    class LIST isa BASE<Tree.Statement.LIST> is
        List<Lexical.TOKEN> terminators;
        Parser<Tree.Statement.NODE> statement_parser;

        get String description is return "statement list"; si        

        void init(
            List<Lexical.TOKEN> terminators,
            Parser<Tree.Statement.NODE> statement_parser)
        is
            super.init();

            this.terminators = terminators;
            this.statement_parser = statement_parser;
        si

        Tree.Statement.LIST parse(CONTEXT context) is
            this.terminators = terminators;

            var start = context.location;
            var end = context.location;

            var statements = new Vector<Tree.Statement.NODE>();

            while !at_terminator(context) do
                var statement = statement_parser.parse(context);

                if statement != null then
                    statements.add(statement);
                fi
            od                

            return new Tree.Statement.LIST(start..end, statements);
        si

        bool at_terminator(CONTEXT context) is
            return terminators.contains(context.current.token);
        si
    si
si si si
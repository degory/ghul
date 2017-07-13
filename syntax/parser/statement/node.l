namespace Syntax is namespace Parser is namespace Statement is
    use System;
    use Generic;

    class NODE isa BASE<Tree.Statement.NODE> is
        Parser<Tree.Expression.NODE> expression_parser;
        Parser<Tree.Variable.LIST> variable_list_parser;

        get String description is return "statement"; si

        void init(
            Parser<Tree.Expression.NODE> expression_parser,
            Parser<Tree.Variable.LIST> variable_list_parser
            ) is
            super.init();

            this.expression_parser = expression_parser;
            this.variable_list_parser = variable_list_parser;
            
            add_parser(
                Tree.Statement.NODE proc(CONTEXT context) is
                    var start = context.location;

                    if context.next_token(Lexical.TOKEN.LET, syntax_error_message) then
                        // FIXME:  parse_variable_list(context, false);
                        var variable_list = variable_list_parser.parse(context);

                        var result = new Tree.Statement.LET(start..variable_list.location, variable_list);

                        context.next_token(Lexical.TOKEN.SEMICOLON);

                        return result;
                    fi
                si,
                Lexical.TOKEN.LET
            );

            add_parser(
                Tree.Statement.NODE proc(CONTEXT context) is
                    var start = context.location;

                    if context.next_token(Lexical.TOKEN.VAR, syntax_error_message) then
                        // FIXME: should not allow tuple elements here:
                        var variable_list = variable_list_parser.parse(context);

                        var result = new Tree.Statement.VAR(start..variable_list.location, variable_list);

                        context.next_token(Lexical.TOKEN.SEMICOLON);

                        return result;
                    fi
                si,
                Lexical.TOKEN.VAR
            );
        si

        Tree.Statement.NODE other_token(CONTEXT context) is
            var left = expression_parser.parse(context);

            if context.current.token == Lexical.TOKEN.ASSIGN then
                context.next_token();

                var right = expression_parser.parse(context);

                context.next_token(Lexical.TOKEN.SEMICOLON);

                return new Tree.Statement.ASSIGNMENT(
                    left.location..right.location,
                    left,
                    right
                );
            else
                context.next_token(Lexical.TOKEN.SEMICOLON);

                return new Tree.Statement.EXPRESSION(
                    left.location,
                    left
                );
            fi
        si            
    si    
si si si
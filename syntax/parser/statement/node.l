namespace Syntax is namespace Parser is namespace Statement is
    use System;
    use Generic;

    // TODO: break this up into smaller classes
    class NODE isa BASE<Tree.Statement.NODE> is
        List<Lexical.TOKEN> labellable_statement_tokens;

        Parser<Tree.Identifier.NODE> identifier_parser;

        Parser<Tree.Expression.NODE> expression_parser;
        Parser<Tree.Variable.NODE> variable_parser;
        Parser<Tree.Variable.LIST> variable_list_parser;

        Parser<Tree.Statement.LIST> statement_list_parser;

        Tree.Statement.NODE proc(CONTEXT) if_parser;

        get String description is return "statement"; si

        void init(
            List<Lexical.TOKEN> labellable_statement_tokens,
            Parser<Tree.Identifier.NODE> identifier_parser,
            Parser<Tree.Expression.NODE> expression_parser,
            Parser<Tree.Variable.NODE> variable_parser,
            Parser<Tree.Variable.LIST> variable_list_parser,
            Parser<Tree.Statement.LIST> statement_list_parser
        )
        is
            super.init();

            this.labellable_statement_tokens = labellable_statement_tokens;
            this.identifier_parser = identifier_parser;
            this.expression_parser = expression_parser;
            this.variable_parser = variable_parser;
            this.variable_list_parser = variable_list_parser;
            this.statement_list_parser = statement_list_parser;
            
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

            add_parser(
                Tree.Statement.NODE proc(CONTEXT context) is
                    var start = context.location;
                    var end = context.location;

                    if context.next_token(Lexical.TOKEN.RETURN, syntax_error_message) then
                        Tree.Expression.NODE expression;

                        if context.current.token != Lexical.TOKEN.SEMICOLON then
                            expression = expression_parser.parse(context);
                            end = expression.location;
                        fi

                        context.next_token(Lexical.TOKEN.SEMICOLON);
                        
                        return new Tree.Statement.RETURN(start..end, expression);
                    fi
                si,
                Lexical.TOKEN.RETURN
            );

            add_parser(
                Tree.Statement.NODE proc(CONTEXT context) is
                    var result = parse_if(context);

                    context.next_token(Lexical.TOKEN.FI);

                    return result;
                si,
                Lexical.TOKEN.IF
            );      

            add_parser(
                Tree.Statement.NODE proc(CONTEXT context) is
                    var start = context.location;

                    context.next_token(Lexical.TOKEN.CASE);

                    var expression = expression_parser.parse(context);

                    var seen_default = false;

                    var match_list = new Vector<Tree.Statement.CASE_MATCH>();

                    while context.current.token != Lexical.TOKEN.ESAC do
                        var match_start = context.location;
                        Tree.Expression.NODE match_expression;

                        if context.current.token != Lexical.TOKEN.DEFAULT then
                            context.next_token(Lexical.TOKEN.WHEN);
                            match_expression = expression_parser.parse(context);

                            context.next_token(Lexical.TOKEN.COLON);
                        else
                            if seen_default then
                                context.error(context.location, "more than one default in case statement");
                            else
                                seen_default = true;
                            fi

                            context.next_token(Lexical.TOKEN.DEFAULT);                            
                        fi

                        var match_statement = statement_list_parser.parse(context);

                        match_list.add(
                            new Tree.Statement.CASE_MATCH(
                                match_start..match_statement.location,
                                match_expression,
                                match_statement
                            )
                        );
                    od

                    var result = new Tree.Statement.CASE(
                        start..context.location,
                        expression,
                        match_list
                    );

                    context.next_token(Lexical.TOKEN.ESAC);

                    return result;
                si,
                Lexical.TOKEN.CASE
            );
                  
            add_parser(
                Tree.Statement.NODE proc(CONTEXT context) is
                    var start = context.location;

                    Tree.Expression.NODE condition;

                    if context.current.token == Lexical.TOKEN.WHILE then
                        context.next_token();

                        condition = expression_parser.parse(context);
                    fi

                    Tree.Statement.LIST body;

                    context.next_token(Lexical.TOKEN.DO, syntax_error_message);
                    
                    body = statement_list_parser.parse(context);

                    var result = new Tree.Statement.DO(
                        start..context.location,
                        condition,
                        body
                    );

                    context.next_token(Lexical.TOKEN.OD);

                    return result;
                si,
                {Lexical.TOKEN.WHILE, Lexical.TOKEN.DO}
            );

            add_parser(
                Tree.Statement.NODE proc(CONTEXT context) is
                    var start = context.location;

                    context.next_token(Lexical.TOKEN.FOR);

                    var variable = variable_parser.parse(context);

                    context.next_token(Lexical.TOKEN.IN);

                    var expression = expression_parser.parse(context);

                    context.next_token(Lexical.TOKEN.DO, syntax_error_message);
                    
                    var body = statement_list_parser.parse(context);

                    var result = new Tree.Statement.FOR(
                        start..context.location,
                        variable,
                        expression,
                        body
                    );

                    context.next_token(Lexical.TOKEN.OD);

                    return result;
                si,
                Lexical.TOKEN.FOR
            );            
            
            add_parser(
                Tree.Statement.NODE proc(CONTEXT context) is
                    var start = context.location;
                    var end = context.location;

                    context.next_token();

                    Tree.Identifier.NODE label;

                    if context.current.token == Lexical.TOKEN.IDENTIFIER then
                        label = identifier_parser.parse(context);
                        end = label.location;
                    fi

                    var result = new Tree.Statement.BREAK(start..end, label);
                    context.next_token(Lexical.TOKEN.SEMICOLON);
                    return result;
                si,
                Lexical.TOKEN.BREAK
            );            

            add_parser(
                Tree.Statement.NODE proc(CONTEXT context) is
                    var start = context.location;
                    var end = context.location;

                    context.next_token();

                    Tree.Identifier.NODE label;

                    if context.current.token == Lexical.TOKEN.IDENTIFIER then
                        label = identifier_parser.parse(context);
                        end = label.location;
                    fi

                    var result = new Tree.Statement.CONTINUE(start..end, label);
                    context.next_token(Lexical.TOKEN.SEMICOLON);
                    return result;
                si,
                Lexical.TOKEN.CONTINUE
            );
        si

        Tree.Statement.IF parse_if(CONTEXT context) is
            var start = context.location;

            context.next_token();

            var condition = expression_parser.parse(context);

            context.next_token(Lexical.TOKEN.THEN);

            var then_branch = statement_list_parser.parse(context);
            Tree.Statement.LIST else_branch;
            Tree.Statement.IF elif_branch;

            if context.current.token == Lexical.TOKEN.ELSE then
                context.next_token();
                else_branch = statement_list_parser.parse(context);
            elif context.current.token == Lexical.TOKEN.ELIF then
                elif_branch = parse_if(context);
            fi

            return new Tree.Statement.IF(
                start..context.location,
                condition,
                then_branch,
                else_branch,
                elif_branch
            );
        si

        Tree.Statement.NODE other_token(CONTEXT context) is

            if context.current.token == Lexical.TOKEN.IDENTIFIER then
                context.mark();

                var label = identifier_parser.parse(context);

                if context.current.token == Lexical.TOKEN.COLON then
                    context.next_token();

                    if labellable_statement_tokens.contains(context.current.token) then
                        context.commit();

                        var statement = this.parse(context);

                        return new Tree.Statement.LABELLED(
                            label.location..statement.location,
                            label,
                            statement
                        );
                    fi
                fi

                // was not a statement label, so backtrack
                context.backtrack();
            fi

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
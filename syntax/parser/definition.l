namespace Syntax is
    namespace Parser is
        use System;
        use Generic;

        use Source;

        class DEFINITION isa PARSER<Tree.DEFINITION> is
            void init() is
                super.init();
            si

            get String description is
                return "definition";
            si

            Tree.DEFINITION parse(CONTEXT context) is
                case context.current_token
                is Lexical.TOKEN.LET: return parse_let(context);
                is Lexical.TOKEN.VAR: return parse_var(context);
                esac

                context.expect_token({Lexical.TOKEN.LET, Lexical.TOKEN.VAR}, syntax_error_message);                
            si

            Tree.Definition.LET parse_let(CONTEXT context) is
                var start = context.location;

                if context.next_token(Lexical.TOKEN.LET, syntax_error_message) then
                    var variable_list = parse_variable_list(context, false);

                    return new Tree.Definition.LET(start..variable_list.location, variable_list);
                fi
            si

            Tree.Definition.VAR parse_var(CONTEXT context) is
                var start = context.location;

                if context.next_token(Lexical.TOKEN.VAR, syntax_error_message) then
                    var variable_list = parse_variable_list(context, false);

                    return new Tree.Definition.VAR(start..variable_list.location, variable_list);
                fi
            si            

            Tree.Definition.VARIABLE_LIST parse_variable_list(CONTEXT context, bool allow_empty) is
                var start = context.location;
                var end = context.location;

                var variables = new Vector<Tree.Definition.VARIABLE>();

                if context.current_token == Lexical.TOKEN.IDENTIFIER || !allow_empty then
                    do
                        var variable = parse_variable(context);
                        end = variable.location;

                        variables.add(variable);

                        if context.current_token != Lexical.TOKEN.COMMA then
                            break;
                        else
                            context.next_token();
                        fi
                    od
                fi

                return new Tree.Definition.VARIABLE_LIST(start..end, variables);
            si

            Tree.Definition.VARIABLE parse_variable(CONTEXT context) is
                var start = context.location;

                if context.expect_token(Lexical.TOKEN.IDENTIFIER, syntax_error_message) then
                    var identifier = context.parse_unqualified_identifier();
                    var end = identifier.location;
                    
                    Tree.TYPE type = new Tree.Type.INFER(start..context.location);
                    Tree.EXPRESSION initializer; // = new Tree.Expression.NONE(context.location);

                    if context.current_token == Lexical.TOKEN.COLON then
                        context.next_token();
                        
                        type = context.parse_type();
                        end = type.location;
                    fi

                    if context.current_token == Lexical.TOKEN.ASSIGN then
                        context.next_token();

                        initializer = context.parse_expression();
                        end = initializer.location;
                    fi

                    return new Tree.Definition.VARIABLE(
                        start..end,
                        identifier,
                        type,
                        initializer);    
                fi
            si

            Tree.DEFINITION unexpected_token(CONTEXT context) is
                return null; 
            si            
        si
    si
si

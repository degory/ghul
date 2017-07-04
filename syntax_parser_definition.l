namespace Syntax is
    namespace Parser is
        use Generic;

        class DEFINITION isa PARSER<Tree.DEFINITION> is
            void init() is
                super.init();
            si

            Tree.DEFINITION parse(CONTEXT context) is
                case context.current_token
                is Lexical.TOKEN.LET: return parse_let(context);
                is Lexical.TOKEN.VAR: return parse_var(context);
                esac

                context.expect_token({Lexical.TOKEN.LET, Lexical.TOKEN.VAR});                
            si

            Tree.Definition.LET parse_let(CONTEXT context) is
                var start = context.location;

                if context.next_token(Lexical.TOKEN.LET) then
                    var variable_list = parse_variable_list(context, false);

                    return new Tree.Definition.LET(start..context.location, variable_list);
                fi
            si

            Tree.Definition.VAR parse_var(CONTEXT context) is
                var start = context.location;

                if context.next_token(Lexical.TOKEN.LET) then
                    var variable_list = parse_variable_list(context, false);

                    return new Tree.Definition.VAR(start..context.location, variable_list);
                fi
            si            

            Tree.Definition.VARIABLE_LIST parse_variable_list(CONTEXT context, bool allow_empty) is
                var start = context.location;

                var variables = new Vector<Tree.Definition.VARIABLE>();

                if context.current_token == Lexical.TOKEN.IDENTIFIER || !allow_empty then
                    do
                        var variable = parse_variable(context);

                        if context.current_token != Lexical.TOKEN.COMMA then
                            break;
                        else
                            context.next_token();
                        fi
                    od
                fi

                return new Tree.Definition.VARIABLE_LIST(start..context.location, variables);
            si

            Tree.Definition.VARIABLE parse_variable(CONTEXT context) is
                var start = context.location;

                if context.expect_token(Lexical.TOKEN.IDENTIFIER) then
                    var identifier = context.parse_identifier();
                    
                    Tree.TYPE type = Tree.Type.BUILT_IN.INFER;
                    Tree.EXPRESSION initializer = new Tree.Expression.NONE(context.location);

                    if context.current_token == Lexical.TOKEN.COLON then
                        context.next_token();
                        
                        type = context.parse_type();
                    fi

                    if context.current_token == Lexical.TOKEN.ASSIGN then
                        context.next_token();

                        initializer = context.parse_expression();
                    fi

                    return new Tree.Definition.VARIABLE(
                        start..context.location,
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

namespace Syntax is
    namespace Parser is
        use Generic;

        class DEFINITION_LIST isa PARSER<Tree.Definition.DEFINITION_LIST> is
            void init() is
                super.init();
            si

            Tree.Definition.DEFINITION_LIST parse(CONTEXT context) is
                var start = context.location;

                var definitions = new Vector<Tree.DEFINITION>();

                do
                    var definition = context.parse_definition();
                    
                    if definition != null then
                        definitions.add(definition);
                    else
                        break;
                    fi
                od

                return new Tree.Definition.DEFINITION_LIST(start..context.location, definitions);
            si
        si

        class DEFINITION isa PARSER<Tree.DEFINITION> is
            void init() is
                super.init();

                add_parser(
                    Tree.DEFINITION proc(CONTEXT context) is
                        var start = context.location;

                        context.next_token();

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

                        return new Tree.Definition.LET(
                            start..context.location,
                            identifier,
                            type,
                            initializer);    
                    si,
                    Lexical.TOKEN.LET
                );
            si

            Tree.DEFINITION parse_var_or_let() is
                
            si

            Tree.DEFINITION unexpected_token(CONTEXT context) is
                return null;
            si
        si

        class LET isa PARSER<Tree.Definition.LET> is
            LET parse(CONTEXT context) is
                if context.expect_token(Lexical.TOKEN.LET) then
                    context.next_token();

                    var identifier = context.parse_identifier();
                    
                    TYPE type = new Tree.Type.INFER(context.location);

                    if context.current_token == Lexical.TOKEN.COLON then
                        context.next_token();
                        
                        type = context.parse_type();
                    fi
                fi
            si
        si
    si
si

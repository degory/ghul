namespace Syntax is
    namespace Parser is
        class DEFINITION_LIST isa PARSER<Tree.DEFINITION_LIST> is
            void init() is
                super.init();
            si

            Tree.DEFINITION parse(CONTEXT context) is
                var start = context.location;

                var definitions = new List<DEFINITION>();

                do
                    var defintion = maybe_parse_definition(context);
                    
                    if definition != null then
                        definitions.add(definition);

                od

                return new DEFINITION_LIST(start..context.location, definitions);
            si
        si

        class DEFINITION isa PARSER<Tree.DEFINITION> is
            void init() is
                super.init();

                add_parser(
                    this.parse_definition,
                    {
                        Lexical.TOKEN.VAR, Lexical.TOKEN.LET
                    }
                );
            si

            DEFINITION_LIST parse_definition(CONTEXT context) is
                var start = context.location;

                var definitions = new List<DEFINITION>();

                do
                    var defintion = parse(context);
                    
                    if definition != null then
                        definitions.add(definition);
                    else
                        break;
                    fi
                od

                return new DEFINITION_LIST(start..context.location, definitions);
            si

            DEFINITION unexpected_token(CONTEXT context) is
                return null;
            si
        si

        class LET isa Parser<Tree.LET> is
            LET parse(CONTEXT context) is
                if context.expect_token(Lexical.TOKEN.LET) then
                    context.next_token();

                    var identifier = context.parse_identifier();
                    
                    var type = Tree.Type.INFER;

                    if context.current_token == Lexical.TOKEN.COLON then
                        context.next_token();
                        
                        type = context.parse_type();
                    fi

                    if 
                fi
            si
        si
    si
si

namespace IoC is
    // I have no IoC framework and it's not required for bootstrap, so
    // fake it out for now.
    // Post boostrap, should implement proper IoC + reflection, then
    // most of this stuff could autowire based on naming convention.

    use Syntax;
    use Parser.LAZY_PARSER;

    class CONTAINER is
        static CONTAINER _instance;

        static get CONTAINER instance is
            if _instance == null then
                _instance = new CONTAINER();
            fi

            return _instance;
        si

        public Logging.LOGGER logger;

        Syntax.Parser.Parser<Tree.Identifier.NODE> identifier_parser;
        Syntax.Parser.Parser<Tree.Identifier.NODE> identifier_qualified_parser;
        Syntax.Parser.Parser<Tree.Identifier.NODE> identifier_function_name_parser;
        Syntax.Parser.Parser<Tree.Modifier.NODE> modifier_parser;

        // Parsers are mutually recursive, and so the corresponding classes are mutually
        // inter dependent. This means we can't just inject dependencies into constructors,
        // so instead, we inject lazy wrapped dependencies. (Strictly they don't all need to be
        // lazy, but it's easier to just make them all lazy than figure out specific places
        // to break the cycles in the dependency graph)
        
        LAZY_PARSER<Tree.Type.NODE> type_parser;
        LAZY_PARSER<Tree.Type.LIST> type_list_parser;

        LAZY_PARSER<Tree.Variable.NODE> variable_parser;
        LAZY_PARSER<Tree.Variable.LIST> variable_list_parser;

        LAZY_PARSER<Tree.Modifier.LIST> modifier_list_parser;

        public LAZY_PARSER<Tree.Definition.NODE> definition_parser;
        LAZY_PARSER<Tree.Definition.LIST> definition_list_parser;

        LAZY_PARSER<Tree.Definition.IMPORT> definition_import_parser;
        LAZY_PARSER<Tree.Definition.NAMESPACE> definition_namespace_parser;
        LAZY_PARSER<Tree.Definition.CLASS> definition_class_parser;
        LAZY_PARSER<Tree.Definition.USE> definition_use_parser;
        LAZY_PARSER<Tree.Definition.INTERFACE> definition_interface_parser;
        LAZY_PARSER<Tree.Definition.ENUM> definition_enum_parser;
        LAZY_PARSER<Tree.Definition.NODE> definition_member_parser;
        LAZY_PARSER<Tree.Definition.FUNCTION> definition_function_parser;
        LAZY_PARSER<Tree.Definition.PROPERTY> definition_property_parser;
        LAZY_PARSER<Tree.Definition.INDEXER> definition_indexer_parser;

        LAZY_PARSER<Tree.Expression.NODE> expression_parser;
        LAZY_PARSER<Tree.Expression.LIST> expression_list_parser;
        LAZY_PARSER<Tree.Expression.NODE> expression_primary_parser;
        LAZY_PARSER<Tree.Expression.NODE> expression_secondary_parser;
        LAZY_PARSER<Tree.Expression.TUPLE> expression_tuple_parser;

        LAZY_PARSER<Tree.Statement.NODE> statement_parser;
        LAZY_PARSER<Tree.Statement.LIST> statement_list_parser;

        LAZY_PARSER<Tree.Body.NODE> body_parser;        

        void init() is
            logger = new Logging.LOGGER();

            // non circular/leaf dependencies
            identifier_parser = new Parser.Identifier.NODE();
            identifier_qualified_parser = new Parser.Identifier.QUALIFIED();
            identifier_function_name_parser = new Parser.Identifier.FUNCTION_NAME();
            modifier_parser = new Parser.Modifier.NODE();

            // circular dependencies

            type_parser = new LAZY_PARSER<Tree.Type.NODE>();
            type_list_parser = new LAZY_PARSER<Tree.Type.LIST>();

            variable_parser = new LAZY_PARSER<Tree.Variable.NODE>();
            variable_list_parser = new LAZY_PARSER<Tree.Variable.LIST>();

            modifier_list_parser = new LAZY_PARSER<Tree.Modifier.LIST>();

            definition_parser = new LAZY_PARSER<Tree.Definition.NODE>();
            definition_list_parser = new LAZY_PARSER<Tree.Definition.LIST>();

            definition_import_parser = new LAZY_PARSER<Tree.Definition.IMPORT>();
            definition_namespace_parser = new LAZY_PARSER<Tree.Definition.NAMESPACE>();
            definition_use_parser = new LAZY_PARSER<Tree.Definition.USE>();
            definition_class_parser = new LAZY_PARSER<Tree.Definition.CLASS>();
            definition_interface_parser = new LAZY_PARSER<Tree.Definition.INTERFACE>();
            definition_enum_parser = new LAZY_PARSER<Tree.Definition.ENUM>();
            definition_member_parser = new LAZY_PARSER<Tree.Definition.NODE>();
            definition_function_parser = new LAZY_PARSER<Tree.Definition.FUNCTION>();
            definition_property_parser = new LAZY_PARSER<Tree.Definition.PROPERTY>();
            definition_indexer_parser = new LAZY_PARSER<Tree.Definition.INDEXER>();

            expression_parser = new LAZY_PARSER<Tree.Expression.NODE>();
            expression_list_parser = new LAZY_PARSER<Tree.Expression.LIST>();            
            expression_primary_parser = new LAZY_PARSER<Tree.Expression.NODE>();
            expression_secondary_parser = new LAZY_PARSER<Tree.Expression.NODE>();
            expression_tuple_parser = new LAZY_PARSER<Tree.Expression.TUPLE>();

            statement_parser = new LAZY_PARSER<Tree.Statement.NODE>();
            statement_list_parser = new LAZY_PARSER<Tree.Statement.LIST>();

            body_parser = new LAZY_PARSER<Tree.Body.NODE>();

            type_parser.create =
                Parser.Parser<Tree.Type.NODE> proc() is
                    return new Parser.Type.NODE(
                        identifier_qualified_parser,
                        type_list_parser
                    );
                si;
                
            type_list_parser.create =
                Parser.Parser<Tree.Type.LIST> proc() is
                    return new Parser.Type.LIST(
                        type_parser
                    );
                si;

            variable_parser.create = 
                Parser.Parser<Tree.Variable.NODE> proc() is
                    return new Parser.Variable.NODE(
                        identifier_parser,
                        type_parser,
                        expression_parser                        
                    );
                si;

            variable_list_parser.create = 
                Parser.Parser<Tree.Variable.LIST> proc() is
                    return new Parser.Variable.LIST(
                        variable_parser
                    );
                si;

            modifier_list_parser.create =
                Parser.Parser<Tree.Modifier.LIST> proc() is
                    return new Parser.Modifier.LIST(
                        modifier_parser
                    );
                si;

            definition_parser.create = 
                Parser.Parser<Tree.Definition.NODE> proc() is
                    return new Parser.Definition.NODE(
                        definition_import_parser,
                        definition_namespace_parser,
                        definition_use_parser,
                        definition_class_parser,
                        definition_interface_parser,
                        definition_enum_parser,
                        definition_member_parser
                    );
                si;

            definition_list_parser.create = 
                Parser.Parser<Tree.Definition.LIST> proc() is
                    return new Parser.Definition.LIST(
                        definition_parser
                    );
                si;

            definition_import_parser.create =
                Parser.Parser<Tree.Definition.IMPORT> proc() is
                    return new Parser.Definition.IMPORT(
                        identifier_parser
                    );
                si;

            definition_namespace_parser.create =
                Parser.Parser<Tree.Definition.NAMESPACE> proc() is
                    return new Parser.Definition.NAMESPACE(
                        identifier_qualified_parser,
                        definition_list_parser
                    );
                si;

            definition_use_parser.create =
                Parser.Parser<Tree.Definition.USE> proc() is
                    return new Parser.Definition.USE(
                        identifier_qualified_parser
                    );
                si;

            definition_class_parser.create =
                Parser.Parser<Tree.Definition.CLASS> proc() is
                    return new Parser.Definition.CLASS(
                        identifier_parser,
                        type_parser,
                        type_list_parser,
                        modifier_list_parser,
                        definition_list_parser
                    );
                si;

            definition_interface_parser.create = 
                Parser.Parser<Tree.Definition.INTERFACE> proc() is
                    return new Parser.Definition.INTERFACE(
                        identifier_parser,
                        type_parser,
                        type_list_parser,
                        modifier_list_parser,
                        definition_list_parser
                    );
                si;

            definition_enum_parser.create =
                Parser.Parser<Tree.Definition.ENUM> proc() is
                    return new Parser.Definition.ENUM(
                        identifier_parser,
                        modifier_list_parser,
                        expression_parser
                    );
                si;

            definition_member_parser.create = 
                Parser.Parser<Tree.Definition.NODE> proc() is
                    return new Parser.Definition.MEMBER(
                        definition_function_parser,
                        definition_property_parser,
                        definition_indexer_parser
                    );
                si;

            definition_function_parser.create = 
                Parser.Parser<Tree.Definition.FUNCTION> proc() is
                    return new Parser.Definition.FUNCTION(
                        identifier_function_name_parser,
                        type_parser,
                        modifier_list_parser,
                        body_parser,
                        variable_list_parser
                    );
                si;

            definition_property_parser.create = 
                Parser.Parser<Tree.Definition.PROPERTY> proc() is
                    return new Parser.Definition.PROPERTY(
                        identifier_parser,
                        type_parser,
                        modifier_list_parser,
                        definition_list_parser,
                        body_parser
                    );
                si;

            definition_indexer_parser.create = 
                Parser.Parser<Tree.Definition.INDEXER> proc() is
                    return new Parser.Definition.INDEXER(
                        identifier_parser,
                        type_parser,
                        modifier_list_parser,
                        variable_parser,
                        body_parser
                    );
                si;                
                
            expression_parser.create =
                Parser.Parser<Tree.Expression.NODE> proc() is
                    return new Parser.Expression.NODE(
                        // expression_primary_parser,
                        expression_secondary_parser
                        // expression_tuple_parser,
                        // expression_literal_parser
                    );
                si;

            expression_list_parser.create =
                Parser.Parser<Tree.Expression.LIST> proc() is
                    return new Parser.Expression.LIST(
                        expression_parser
                    );
                si;
            
            expression_primary_parser.create = 
                Parser.Parser<Tree.Expression.NODE> proc() is
                    return new Parser.Expression.PRIMARY(
                        identifier_parser,
                        type_parser,
                        expression_parser,
                        expression_list_parser,
                        expression_tuple_parser
                    );
                si;

            expression_secondary_parser.create =
                Parser.Parser<Tree.Expression.NODE> proc() is
                    return new Parser.Expression.SECONDARY(
                        identifier_parser,            
                        type_parser,
                        expression_parser,
                        expression_primary_parser,
                        expression_list_parser,
                        body_parser
                    );
                si;

            expression_tuple_parser.create =
                Parser.Parser<Tree.Expression.TUPLE> proc() is
                    return new Parser.Expression.TUPLE(
                        expression_list_parser
                    );
                si;

            statement_parser.create =
                Parser.Parser<Tree.Statement.NODE> proc() is
                    return new Parser.Statement.NODE(
                        { Lexical.TOKEN.FOR, Lexical.TOKEN.WHILE, Lexical.TOKEN.DO },
                        identifier_parser,
                        expression_parser,
                        expression_list_parser,
                        variable_parser,
                        variable_list_parser,
                        statement_list_parser
                    );
                si;

            statement_list_parser.create =
                Parser.Parser<Tree.Statement.LIST> proc() is
                    return new Parser.Statement.LIST(
                        {
                            // if ... then ... elif ... else ... fi
                            Lexical.TOKEN.ELSE, Lexical.TOKEN.ELIF, Lexical.TOKEN.FI,

                            // while do ... od
                            Lexical.TOKEN.OD,

                            // try ... catch ... finally ... yrt
                            Lexical.TOKEN.CATCH, Lexical.TOKEN.FINALLY, Lexical.TOKEN.YRT,

                            // case ... when ... when ... default ... esac
                            Lexical.TOKEN.WHEN, Lexical.TOKEN.DEFAULT, Lexical.TOKEN.ESAC,

                            // is ... si
                            Lexical.TOKEN.SI
                        },
                        statement_parser
                    );
                si;

            // function body

            body_parser.create =
                Parser.Parser<Tree.Body.NODE> proc() is
                    return new Parser.Body.NODE(
                        expression_parser,
                        statement_parser,
                        statement_list_parser
                    );
                si;
        si        
    si
si




namespace Syntax is namespace Parser is namespace Definition is
    use System;
    use Generic;

    use Source;

    // definitions are the kind of things you get directly inside a class or an interface, including other definitions.

    class NODE isa BASE<Tree.Definition.NODE> is        
        Parser<Tree.Definition.IMPORT> definition_import_parser;
        Parser<Tree.Definition.NAMESPACE> definition_namespace_parser;
        Parser<Tree.Definition.USE> definition_user_parser;
        Parser<Tree.Definition.CLASS> definition_class_parser;
        Parser<Tree.Definition.INTERFACE> definition_interface_parser;
        Parser<Tree.Definition.ENUM> definition_enum_parser;
        Parser<Tree.Definition.NODE> definition_member_parser;

        get String description is
            return "definition";
        si

        void init(
            Parser<Tree.Definition.IMPORT> definition_import_parser,
            Parser<Tree.Definition.NAMESPACE> definition_namespace_parser,            
            Parser<Tree.Definition.USE> definition_user_parser,
            Parser<Tree.Definition.CLASS> definition_class_parser,
            Parser<Tree.Definition.INTERFACE> definition_interface_parser,
            Parser<Tree.Definition.ENUM> definition_enum_parser,
            Parser<Tree.Definition.NODE> definition_member_parser
        )
        is
            super.init();

            this.definition_import_parser = definition_import_parser;
            this.definition_namespace_parser = definition_namespace_parser;
            this.definition_user_parser = definition_user_parser;
            this.definition_class_parser = definition_class_parser;
            this.definition_interface_parser = definition_interface_parser;
            this.definition_enum_parser = definition_enum_parser;
            this.definition_member_parser = definition_member_parser;

            add_parser(
                Tree.Definition.NODE proc(CONTEXT context) is
                    return definition_import_parser.parse(context);
                si,
                Lexical.TOKEN.IMPORT
            );

            add_parser(
                Tree.Definition.NODE proc(CONTEXT context) is
                    return definition_namespace_parser.parse(context);
                si,
                Lexical.TOKEN.NAMESPACE
            );

            add_parser(
                Tree.Definition.NODE proc(CONTEXT context) is
                    return definition_user_parser.parse(context);
                si,
                Lexical.TOKEN.USE
            );

            add_parser(
                Tree.Definition.NODE proc(CONTEXT context) is
                    return definition_class_parser.parse(context);
                si,
                Lexical.TOKEN.CLASS
            );

            add_parser(
                Tree.Definition.NODE proc(CONTEXT context) is
                    return definition_interface_parser.parse(context);
                si,
                Lexical.TOKEN.INTERFACE
            );

            add_parser(
                Tree.Definition.NODE proc(CONTEXT context) is
                    return definition_enum_parser.parse(context);
                si,
                Lexical.TOKEN.ENUM
            );

            add_parser(
                Tree.Definition.NODE proc(CONTEXT context) is
                    return definition_member_parser.parse(context);
                si,
                {Lexical.TOKEN.IDENTIFIER, Lexical.TOKEN.OPERATOR, Lexical.TOKEN.SQUARE_OPEN}
            );
        si
    si
si si si

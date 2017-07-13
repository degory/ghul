namespace Syntax is namespace Parser is namespace Definition is
    use System;
    use Generic;

    use Source;

    // definitions are the kind of things you get directly inside a class or an interface, including other definitions.

    class NODE isa BASE<Tree.Definition.NODE> is
        Parser<Tree.Definition.CLASS> definition_class_parser;
        Parser<Tree.Definition.INTERFACE> definition_interface_parser;
        Parser<Tree.Definition.NODE> definition_member_parser;

        get String description is
            return "definition";
        si

        void init(
            Parser<Tree.Definition.CLASS> definition_class_parser,
            Parser<Tree.Definition.INTERFACE> definition_interface_parser,
            Parser<Tree.Definition.NODE> definition_member_parser
        )
        is
            super.init();

            this.definition_class_parser = definition_class_parser;
            this.definition_interface_parser = definition_interface_parser;
            this.definition_member_parser = definition_member_parser;

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
                    return definition_member_parser.parse(context);
                si,
                Lexical.TOKEN.IDENTIFIER
            );            
        si
    si
si si si

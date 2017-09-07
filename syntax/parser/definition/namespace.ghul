namespace Syntax is namespace Parser is namespace Definition is
    use System;

    use Source;

    class NAMESPACE isa BASE<Tree.Definition.NAMESPACE> is
        Parser<Tree.Identifier.NODE> identifier_qualified_parser;
        Parser<Tree.Definition.LIST> definition_list_parser;

        void init(
            Parser<Tree.Identifier.NODE> identifier_qualified_parser,
            Parser<Tree.Definition.LIST> definition_list_parser
        ) is
            super.init();
            
            this.identifier_qualified_parser = identifier_qualified_parser;
            this.definition_list_parser = definition_list_parser;
        si

        Tree.Definition.NAMESPACE parse(CONTEXT context) is
            context.next_token(Lexical.TOKEN.NAMESPACE);

            var start = context.location;
            var identifier = identifier_qualified_parser.parse(context);

            context.next_token(Lexical.TOKEN.IS);

            var body = definition_list_parser.parse(context);

            var result = new Tree.Definition.NAMESPACE(
                start..context.location,
                identifier,
                body
            );

            context.next_token(Lexical.TOKEN.SI);

            return result;
        si
    si
si si si

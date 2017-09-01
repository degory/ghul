namespace Syntax is namespace Parser is namespace Definition is
    use System;
    use Generic;

    use Source;

    class LIST isa BASE<Tree.Definition.LIST> is
        Parser<Tree.Definition.NODE> definition_parser;

        get String description is
            return "definition list";
        si

        void init(
            Parser<Tree.Definition.NODE> definition_parser
        ) is
            super.init();
            this.definition_parser = definition_parser;
        si

        Tree.Definition.LIST parse(CONTEXT context) is
            var start = context.location;
            var end = context.location;

            var definitions = new Vector<Tree.Definition.NODE>();

            while context.current.token != Lexical.TOKEN.SI do
                var definition = definition_parser.parse(context);

                if definition != null then
                    end = definition.location;
                    definitions.add(definition);
                else
                    IoC.CONTAINER.instance.logger.fatal(context.location, "read null defintion");
                fi
            od

            return new Tree.Definition.LIST(
                start..end,
                definitions
            );
        si
    si
si si si

namespace Syntax is namespace Parser is namespace Modifier is
    use System;
    use Generic;

    use Source;

    class LIST isa BASE<Tree.Modifier.LIST> is
        Parser<Tree.Modifier.NODE> modifier_parser;

        void init(Parser<Tree.Modifier.NODE> modifier_parser) is
            super.init();

            this.modifier_parser = modifier_parser;
        si

        Tree.Modifier.LIST parse(CONTEXT context) is
            var start = context.location;
            var end = context.location;

            var modifier = modifier_parser.parse(context);

            Tree.Modifier.ACCESS_MODIFIER access_modifier;
            Tree.Modifier.STORAGE_CLASS storage_class;

            if modifier != null && isa Tree.Modifier.ACCESS_MODIFIER(modifier) then
                access_modifier = cast Tree.Modifier.ACCESS_MODIFIER(modifier);

                modifier = modifier_parser.parse(context);

                if modifier != null then
                    end = modifier.location;
                fi
            fi

            if modifier != null then
                if isa Tree.Modifier.STORAGE_CLASS(modifier) then
                    storage_class = cast Tree.Modifier.STORAGE_CLASS(modifier);

                    end = modifier.location;                
                else
                    context.error(modifier.location, "unexpected modifier");
                fi
            fi

            return new Tree.Modifier.LIST(start..end, access_modifier, storage_class);
        si
    si
si si si
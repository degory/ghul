namespace Syntax is namespace Tree is namespace Definition is
    use Source;

    class CLASS isa MODIFIABLE is
        public Identifier.NODE name;
        public Type.LIST arguments;
        public Type.LIST ancestors;
        public LIST body;

        void init(
            LOCATION location,
            Identifier.NODE name,
            Type.LIST arguments,
            Type.LIST ancestors,
            Modifier.LIST modifiers,
            Definition.LIST body
        )
        is
            super.init(location, modifiers);

            this.name = name;
            this.arguments = arguments;
            this.ancestors = ancestors;
            this.body = body;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                name.walk(visitor);

                if arguments != null then
                    arguments.walk(visitor);
                fi

                if ancestors != null then
                    ancestors.walk(visitor);
                fi

                modifiers.walk(visitor);
                
                body.walk(visitor);
            fi

            accept(visitor);
        si
    si
si si si

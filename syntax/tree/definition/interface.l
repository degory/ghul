namespace Syntax is namespace Tree is namespace Definition is
    use Source;

    class INTERFACE isa MODIFIABLE is
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
            LIST body
        )
        is
            super.init(location, modifiers);

            this.name = name;
            this.arguments = arguments;
            this.ancestors = ancestors;
            this.body = body;
        si

        public void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si
si si si

namespace Syntax is namespace Tree is namespace Definition is
    use Source;

    class MODIFIABLE isa NODE is
        public Identifier.NODE name;
        public Modifier.LIST modifiers;

        void init(
            LOCATION location,
            Modifier.LIST modifiers
        )
        is
            super.init(location);

            this.modifiers = modifiers;
        si

        public void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si
si si si

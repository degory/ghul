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

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                modifiers.walk(visitor);
            fi

            accept(visitor);
        si
    si
si si si

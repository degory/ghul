namespace Syntax is namespace Tree is namespace Definition is
    use Generic;

    use Source;

    class ENUM isa MODIFIABLE is
        public Identifier.NODE name;
        public List<ENUM_MEMBER> members;

        void init(
            LOCATION location,
            Identifier.NODE name,
            Modifier.LIST modifiers,
            List<ENUM_MEMBER> members
        )
        is
            super.init(location, modifiers);

            this.name = name;
            this.members = members;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            name.walk(visitor);
            modifiers.walk(visitor);

            accept(visitor);
        si
    si

    class ENUM_MEMBER isa NODE is
        public Identifier.NODE name;
        public Expression.NODE initializer;

        void init(
            LOCATION location,
            Identifier.NODE name,
            Expression.NODE initializer
        )
        is
            super.init(location);

            this.name = name;
            this.initializer = initializer;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                name.walk(visitor);
                initializer.walk(visitor);
            fi

            accept(visitor);
        si
    si
si si si
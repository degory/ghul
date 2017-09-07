namespace Syntax is namespace Tree is namespace Definition is
    use Source;

    class NAMESPACE isa NODE is
        public Identifier.NODE name;
        public LIST body;

        void init(
            LOCATION location,
            Identifier.NODE name,
            Definition.LIST body
        )
        is
            super.init(location);

            this.name = name;
            this.body = body;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                name.walk(visitor);
                body.walk(visitor);
            fi

            accept(visitor);
        si
    si
si si si

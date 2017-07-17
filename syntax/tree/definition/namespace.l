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

        public void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si
si si si

namespace Syntax is namespace Tree is namespace Type is
    use Source;

    class NAMED_TUPLE_ELEMENT isa NODE is
        public Identifier.NODE name;
        public NODE type;

        void init(LOCATION location, Identifier.NODE name, NODE type) is
            super.init(location);

            this.name = name;
            this.type = type;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si
si si si

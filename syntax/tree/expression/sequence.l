namespace Syntax is namespace Tree is namespace Expression is
    use Source;
    class SEQUENCE isa NODE is
        public Type.NODE type;
        public LIST elements;

        void init(
            LOCATION location,
            LIST elements,
            Type.NODE type
        )
        is
            super.init(location);

            this.elements = elements;
            this.type = type;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si
si si si
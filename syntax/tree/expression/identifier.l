namespace Syntax is namespace Tree is namespace Expression is
    use Source;
    class IDENTIFIER isa NODE is
        public Identifier.NODE identifier;

        void init(LOCATION location, Identifier.NODE identifier) is
            super.init(location);

            this.identifier = identifier;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si
si si si

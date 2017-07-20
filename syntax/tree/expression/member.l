namespace Syntax is namespace Tree is namespace Expression is
    use Source;

    class MEMBER isa NODE is 
        public NODE left;
        public Identifier.NODE identifier;

        void init(LOCATION location, NODE left, Identifier.NODE identifier) is
            super.init(location);

            this.left = left;
            this.identifier = identifier;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si                
    si
si si si

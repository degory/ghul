namespace Syntax is namespace Tree is namespace Expression is
    use Source;

    class HAS_VALUE isa NODE is
        public NODE left;
        
        void init(
            LOCATION location,
            NODE left
        )
        is
            super.init(location);
            
            this.left = left;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si
si si si

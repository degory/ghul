namespace Syntax is namespace Tree is namespace Expression is
    use Source;

    class CAST isa NODE is
        public Type.NODE type;
        public NODE right;
        
        void init(
            LOCATION location,
            Type.NODE type,
            NODE right
        )
        is
            super.init(location);
            
            this.type = type;
            this.right = right;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si
si si si

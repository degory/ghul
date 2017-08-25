namespace Syntax is namespace Tree is namespace Expression is
    use Source;

    class UNARY isa NODE is
        public Identifier.NODE operation;
        public NODE right;
        
        void init(
            LOCATION location,
            Identifier.NODE operation,
            NODE right
        )
        is
            super.init(location);
            
            this.operation = operation;
            this.right = right;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                right.walk(visitor);
            fi

            accept(visitor);
        si
    si
si si si

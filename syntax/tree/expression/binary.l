namespace Syntax is namespace Tree is namespace Expression is
    use Generic;
    
    use Source;

    class BINARY isa NODE is
        public Identifier.NODE operation;
        public NODE left;
        public NODE right;
        
        void init(
            LOCATION location,
            Identifier.NODE operation,
            NODE left,
            NODE right
        )
        is
            super.init(location);

            this.operation = operation;
            this.left = left;
            this.right = right;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                left.walk(visitor);
                right.walk(visitor);
            fi

            accept(visitor);
        si

        void rewrite(Dict<NODE,NODE> m) is
            left = cast NODE(m[left]);
            right = cast NODE(m[right]);
        si
    si
si si si
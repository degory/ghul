namespace Syntax is namespace Tree is namespace Expression is

    use Source;

    class BINARY isa NODE is
        public OPERATION operation;
        public NODE left;
        public NODE right;
        
        void init(
            LOCATION location,
            OPERATION operation,
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
    si
si si si
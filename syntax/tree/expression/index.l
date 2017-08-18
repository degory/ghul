namespace Syntax is namespace Tree is namespace Expression is
    use Source;

    class INDEX isa NODE is 
        public NODE left;
        public NODE index;

        void init(LOCATION location, NODE left, NODE index) is
            super.init(location);

            this.left = left;
            this.index = index;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si
        
        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                left.walk(visitor);
                index.walk(visitor);
            fi

            accept(visitor);
        si
    si
si si si

namespace Syntax is namespace Tree is namespace Expression is
    use Generic;
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

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                left.walk(visitor);
            fi

            accept(visitor);
        si

        void rewrite(Dict<NODE,NODE> m) is
            left = cast NODE(m[left]);
        si
    si
si si si

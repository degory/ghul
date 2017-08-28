namespace Syntax is namespace Tree is namespace Expression is
    use Generic;
    
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

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                left.walk(visitor);
                identifier.walk(visitor);
            fi

            accept(visitor);
        si

        void rewrite(Dict<NODE,NODE> m) is
            left = cast NODE(m[left]);
            identifier = cast Identifier.NODE(m[identifier]);
        si
    si
si si si

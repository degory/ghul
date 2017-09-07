namespace Syntax is namespace Tree is namespace Expression is
    use Generic;

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

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                identifier.walk(visitor);
            fi

            accept(visitor);            
        si

        void rewrite(Dict<Tree.NODE,Tree.NODE> m) is
            identifier = cast Identifier.NODE(m[identifier]);
        si
    si
si si si

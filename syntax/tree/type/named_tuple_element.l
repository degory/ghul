namespace Syntax is namespace Tree is namespace Type is
    use Generic;

    use Source;

    class NAMED_TUPLE_ELEMENT isa NODE is
        public Identifier.NODE name;
        public NODE type;

        void init(LOCATION location, Identifier.NODE name, NODE type) is
            super.init(location);

            this.name = name;
            this.type = type;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                name.walk(visitor);
                type.walk(visitor);
            fi

            accept(visitor);
        si

        void rewrite(Dict<Tree.NODE,Tree.NODE> m) is
            name = cast Identifier.NODE(m[name]);
            type = cast Type.NODE(m[type]);
        si
    si
si si si

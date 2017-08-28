namespace Syntax is namespace Tree is namespace Expression is
    use Generic;
    
    use Source;

    class TUPLE isa NODE is
        public LIST elements;

        void init(
            LOCATION location,
            LIST elements
        )
        is
            super.init(location);

            this.elements = elements;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                elements.walk(visitor);
            fi

            accept(visitor);
        si

        void rewrite(Dict<Tree.NODE,Tree.NODE> m) is
            elements = cast LIST(m[elements]);
        si
    si
si si si

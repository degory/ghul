namespace Syntax is namespace Tree is namespace Type is 
    use Generic;

    use Source;

    class LIST isa Tree.NODE do Iterable<NODE> is
        public Iterable<NODE> elements;

        get Iterator<NODE> Iterator is
            return elements.Iterator;
        si

        void init(LOCATION location, Iterable<NODE> elements) is
            super.init(location);
            this.elements = new Vector<NODE>(elements);
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                foreach var t; elements do
                    t.walk(visitor);
                od
            fi

            accept(visitor);
        si

        void rewrite(Dict<Tree.NODE,Tree.NODE> m) is
            var ne = new Vector<NODE>();

            foreach var e; elements do
                ne.add(cast NODE(m[e]));
            od

            elements = ne;
        si           
    si
si si si
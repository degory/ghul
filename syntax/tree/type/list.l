namespace Syntax is namespace Tree is namespace Type is 
    use Generic;

    use Source;

    class LIST isa Tree.NODE do Iterable<NODE> is
        public Iterable<NODE> elements;

        void init(LOCATION location, Iterable<NODE> elements) is
            super.init(location);
            this.elements = new Vector<NODE>(elements);
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        get Iterator<NODE> Iterator is
            return elements.Iterator;
        si
    si
si si si
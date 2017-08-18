namespace Syntax is namespace Tree is namespace Type is 
    use Source;

    class TUPLE isa NODE is
        public LIST elements;

        void init(LOCATION location, LIST elements) is
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
    si
si si si
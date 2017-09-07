namespace Syntax is namespace Tree is namespace Type is 
    use Generic;
    
    use Source;

    class STRUCTURED isa NODE is
        public NODE element;

        get int size is return 8; si

        void init(LOCATION location, NODE element) is
            super.init(location);

            this.element = element;
        si

        void accept(Visitor visitor) is visitor.visit(this); si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                element.walk(visitor);
            fi

            accept(visitor);
        si

        void rewrite(Dict<Tree.NODE,Tree.NODE> m) is
            element = cast NODE(m[element]);
        si
    si
si si si


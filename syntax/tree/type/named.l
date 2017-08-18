namespace Syntax is namespace Tree is namespace Type is
    use Source;
    
    class NAMED isa NODE is
        public Identifier.NODE name;

        void init(LOCATION location, Identifier.NODE name) is
            super.init(location);
            this.name = name;
        si

        get int size is return 8; si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si        

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                name.walk(visitor);
            fi

            accept(visitor);
        si
    si
si si si
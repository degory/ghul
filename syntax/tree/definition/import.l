namespace Syntax is namespace Tree is namespace Definition is
    use Generic;

    use Source;

    class IMPORT isa NODE is
        public List<Identifier.NODE> imports;

        void init(
            LOCATION location,
            List<Identifier.NODE> imports
        )
        is
            super.init(location);

            this.imports = imports;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                foreach var i; imports do
                    i.walk(visitor);
                od
            fi

            accept(visitor);
        si
    si
    
si si si

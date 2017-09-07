namespace Syntax is namespace Tree is namespace Definition is
    use Generic;

    use Source;

    class USE isa NODE is
        public List<Identifier.NODE> uses;

        get Iterator<Identifier.NODE> Iterator is
            return uses.Iterator;
        si

        get Iterator<Identifier.NODE> ReverseIterator is
            return new Vector<Identifier.NODE>(uses).ReverseIterator;
        si

        void init(
            LOCATION location,
            List<Identifier.NODE> uses
        )
        is
            super.init(location);

            this.uses = uses;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                foreach var u; uses do
                    u.walk(visitor);
                od
            fi

            accept(visitor);
        si
    si    
si si si

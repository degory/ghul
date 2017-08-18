namespace Syntax is namespace Tree is namespace Expression is
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
    si
si si si

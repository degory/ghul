namespace Syntax is namespace Tree is namespace Definition is
    use Generic;

    use Source;

    class USE isa NODE is
        public List<Identifier.NODE> uses;

        void init(
            LOCATION location,
            List<Identifier.NODE> uses
        )
        is
            super.init(location);

            this.uses = uses;
        si

        public void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si
si si si

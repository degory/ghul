namespace Syntax is namespace Tree is namespace Statement is
    use Source;

    class BREAK isa NODE is
        public Identifier.NODE label;

        void init(
            LOCATION location,
            Identifier.NODE label
        )
        is
            super.init(location);

            this.label = label;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si      
    si
si si si
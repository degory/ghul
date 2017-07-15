namespace Syntax is namespace Tree is namespace Statement is
    use Source;

    class LABELLED isa NODE is
        public Identifier.NODE label;
        public Statement.NODE statement;

        void init(
            LOCATION location,
            Identifier.NODE label,
            Statement.NODE statement
        )
        is
            super.init(location);

            this.label = label;
            this.statement = statement;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si      
    si
si si si
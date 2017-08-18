namespace Syntax is namespace Tree is namespace Statement is
    use Source;

    class EXPRESSION isa NODE is
        public Expression.NODE expression;

        void init(
            LOCATION location,
            Expression.NODE expression
        )
        is
            super.init(location);

            this.expression = expression;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        
    si
si si si
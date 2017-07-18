namespace Syntax is namespace Tree is namespace Statement is
    use Source;

    class FOR isa NODE is
        public Variable.NODE variable;
        public Expression.NODE expression;
        public Statement.LIST body;

        void init(
            LOCATION location,
            Variable.NODE variable,
            Expression.NODE expression,
            Statement.LIST body
        )
        is
            super.init(location);
            this.variable = variable;
            this.expression = expression;
            this.body = body;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si      
    si
si si si
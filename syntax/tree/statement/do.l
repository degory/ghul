namespace Syntax is namespace Tree is namespace Statement is
    use Source;

    class DO isa NODE is
        public Expression.NODE condition;
        public Statement.LIST body;

        void init(
            LOCATION location,
            Expression.NODE condition,
            Statement.LIST body
        )
        is
            super.init(location);
            
            this.condition = condition;
            this.body = body;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si      
    si
si si si
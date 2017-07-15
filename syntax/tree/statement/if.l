namespace Syntax is namespace Tree is namespace Statement is
    use Source;

    class IF isa NODE is
        public Expression.NODE condition;
        public Statement.LIST then_branch;
        public Statement.LIST else_branch;
        public IF elif_branch;

        void init(
            LOCATION location,
            Expression.NODE condition,
            Statement.LIST then_branch,
            Statement.LIST else_branch,
            IF elif_branch
        )
        is
            super.init(location);

            assert(else_branch == null || elif_branch == null);
            
            this.condition = condition;
            this.then_branch = then_branch;
            this.else_branch = else_branch;
            this.elif_branch = elif_branch;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si      
    si
si si si
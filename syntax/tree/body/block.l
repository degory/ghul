namespace Syntax is namespace Tree is namespace Body is
    use Source;

    class BLOCK isa NODE is
        public Statement.LIST statements;

        void init(
            LOCATION location,
            Statement.LIST statements)
        is
            super.init(location);

            this.statements = statements;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        get bool is_block is
            return true;
        si
    si
si si si

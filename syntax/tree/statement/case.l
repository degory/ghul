namespace Syntax is namespace Tree is namespace Statement is
    use Source;

    use Generic;

    class CASE isa NODE is // do List<CASE_MATCH> is
        public Expression.NODE expression;

        public List<CASE_MATCH> matches;

        void init(
            LOCATION location,
            Expression.NODE expression,
            List<CASE_MATCH> matches
        )
        is
            super.init(location);

            this.expression = expression;
            this.matches = matches;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si      

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                expression.walk(visitor);

                foreach var m; matches do
                    m.walk(visitor);
                od
            fi

            accept(visitor);
        si
    si

    class CASE_MATCH isa NODE is
        public Expression.NODE expression;
        public LIST statements;

        void init(
            LOCATION location,
            Expression.NODE expression,
            LIST statements
        )
        is
            super.init(location);

            this.expression = expression;
            this.statements = statements;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                expression.walk(visitor);
                statements.walk(visitor);
            fi

            accept(visitor);
        si
    si
si si si
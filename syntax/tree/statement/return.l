namespace Syntax is namespace Tree is namespace Statement is
    use Generic;

    use Source;

    class RETURN isa NODE is
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

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                expression.walk(visitor);
            fi

            accept(visitor);
        si
    si
si si si
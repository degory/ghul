namespace Syntax is namespace Tree is namespace Statement is
    use Source;

    class ASSIGNMENT isa NODE is
        public Expression.NODE left;
        public Expression.NODE right;

        void init(
            LOCATION location,
            Expression.NODE left,
            Expression.NODE right
        )
        is
            super.init(location);

            this.left = left;
            this.right = right;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                left.walk(visitor);
                right.walk(visitor);
            fi

            accept(visitor);
        si
    si
si si si
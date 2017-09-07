namespace Syntax is namespace Tree is namespace Statement is
    use Generic;

    use Source;

    class IF isa NODE is
        public Iterable<IF_BRANCH> branches;

        void init(
            LOCATION location,
            Iterable<IF_BRANCH> branches
        )
        is
            super.init(location);

            this.branches = new Vector<IF_BRANCH>(branches);
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                foreach var branch; branches do
                    branch.walk(visitor);
                od
            fi

            accept(visitor);
        si
    si

    class IF_BRANCH isa Tree.NODE is
        public Expression.NODE condition;
        public LIST body;

        void init(
            LOCATION location,
            Expression.NODE condition,
            LIST body
        )
        is
            super.init(location);
            this.condition = condition;
            this.body = body;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is            
            if !visitor.pre(this) then
                if condition != null then
                    condition.walk(visitor);
                fi
                body.walk(visitor);
            fi

            accept(visitor);
        si
    si
si si si

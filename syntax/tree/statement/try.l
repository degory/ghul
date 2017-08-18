namespace Syntax is namespace Tree is namespace Statement is
    use Source;

    use Generic;

    class TRY isa NODE is
        public Expression.NODE expression;

        public LIST body;
        public List<CATCH> catches;
        public LIST finally_;

        void init(
            LOCATION location,
            LIST body,
            List<CATCH> catches,
            LIST finally_
        )
        is
            super.init(location);

            this.body = body;
            this.catches = catches;
            this.finally_ = finally_;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si      
    si

    class CATCH isa NODE is
        public Variable.NODE variable;
        public LIST body;

        void init(
            LOCATION location,
            Variable.NODE variable,
            LIST body
        )
        is
            super.init(location);

            this.variable = variable;
            this.body = body;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                variable.walk(visitor);
                body.walk(visitor);
            fi

            accept(visitor);
        si
    si
si si si
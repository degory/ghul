namespace Syntax is namespace Tree is namespace Statement is
    use System;

    use Source;

    class LABELLED isa NODE is
        public Identifier.NODE label;
        public Statement.NODE statement;

        void init(
            LOCATION location,
            Identifier.NODE label,
            Statement.NODE statement
        )
        is
            super.init(location);

            this.label = label;
            this.statement = statement;
        si

        void accept(Visitor visitor) is
            IO.Std.err.println("" + Object.dump(this) + "accept: " + Object.dump(visitor));
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            IO.Std.err.println("" + Object.dump(this) + "pre: " + Object.dump(visitor));

            if !visitor.pre(this) then 
                label.walk(visitor);
                statement.walk(visitor);
            fi

            accept(visitor);
        si      
    si
si si si
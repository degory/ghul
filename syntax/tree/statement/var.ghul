
namespace Syntax is namespace Tree is namespace Statement is
    use Generic;

    use Source;

    class VAR isa NODE do Iterable<Variable.NODE> is
        public Variable.LIST variables;

        void init(
            LOCATION location,
            Variable.LIST variables
        )
        is
            super.init(location);
            this.variables = variables;
        si     

        get Iterator<Variable.NODE> Iterator is
            return variables.Iterator;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                variables.walk(visitor);
            fi

            accept(visitor);
        si
    si
si si si
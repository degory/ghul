namespace Syntax is namespace Tree is namespace Variable is
    use Generic;

    use Source;

    class LIST isa Tree.NODE do Iterable<NODE> is
        public List<NODE> variables;

        void init(
            LOCATION location,
            Iterable<NODE> variables
        )
        is
            super.init(location);

            this.variables = new Vector<NODE>();
            this.variables.add(variables);
        si

        get Iterator<NODE> Iterator is
            return variables.Iterator;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si
si si si

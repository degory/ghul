namespace Syntax is namespace Tree is namespace Statement is
    use System;
    use Generic;

    use Source;

    class LIST isa Tree.NODE do Iterable<NODE> is
        public Iterable<NODE> statements;

        void init(LOCATION location, Iterable<NODE> statements) is
            super.init(location);                    
            this.statements = new Vector<NODE>(statements);
        si

        get Iterator<NODE> Iterator is
            return statements.Iterator;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si
si si si

namespace Syntax is namespace Tree is namespace Expression is
    use System;
    use Generic;

    use Source;

    class LIST isa Tree.NODE do Iterable<NODE> is
        public Iterable<NODE> expressions;

        void init(LOCATION location, Iterable<NODE> expressions) is
            super.init(location);                    
            this.expressions = new Vector<NODE>(expressions);
        si

        get Iterator<NODE> Iterator is
            return expressions.Iterator;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si
si si si
namespace Syntax is namespace Tree is namespace Identifier is
    use System;
    use Generic;

    use Source;

    class NODE isa Tree.NODE do Iterable<String> is
        public String name;

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void init(LOCATION location, String name) is
            super.init(location);

            this.name = name;
        si

        get NODE parent is
            return null;
        si

        get Iterator<String> Iterator is
            return String{name}.Iterator;
        si
    si

    class QUALIFIED isa NODE is
        public NODE _parent;

        void init(LOCATION location, NODE parent, String name) is
            super.init(location, name);
        
            this._parent = parent;
        si

        get NODE parent is
            return _parent;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        get Iterator<String> Iterator is
            var result = new Vector<String>();

            result.add(name);

            for var p = parent; p != null; p = p.parent do
                result.add(p.name);
            od 

            return result.ReverseIterator;
        si
    si
si si si
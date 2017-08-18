
namespace Syntax is namespace Tree is namespace Definition is
    use System;
    use Generic;

    use Source;
        
    class LIST isa NODE do Iterable<NODE> is
        public List<NODE> definitions;

        void init(
            LOCATION location,
            Iterable<NODE> definitions
        )
        is
            super.init(location);
            
            this.definitions = new Vector<NODE>(definitions);
        si

        get Iterator<NODE> Iterator is
            return definitions.Iterator;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                foreach var d; definitions do
                    d.walk(visitor);
                od
            fi

            accept(visitor);
        si
    si
si si si 

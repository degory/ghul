
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

        String argl() is
            var result = new StringBuffer();

            foreach var d; definitions do
                result.append(Object.dump(d));
            od

            return result;
        si
    si
si si si 

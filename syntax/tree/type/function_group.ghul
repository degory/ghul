namespace Syntax is namespace Tree is namespace Type is 
    use Generic;

    use Source;
    
    class FUNCTION_GROUP isa NODE do Iterable<FUNCTION> is
        public List<FUNCTION> functions;

        get Iterator<FUNCTION> Iterator is
            return functions.Iterator;
        si

        void init(
            LOCATION location
        )
        is
            super.init(location);
            
            this.functions = new Vector<FUNCTION>();
        si

        void add(FUNCTION function) is
            functions.add(function);
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                foreach var f; functions do
                    f.walk(visitor);
                od
            fi

            accept(visitor);
        si

        void rewrite(Dict<Tree.NODE,Tree.NODE> m) is
            var nf = new Vector<FUNCTION>();

            foreach var f; functions do
                nf.add(cast FUNCTION(m[f]));
            od

            functions = nf;
        si   
    si
si si si
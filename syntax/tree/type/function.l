namespace Syntax is namespace Tree is namespace Type is 
    use Generic;

    use Source;
    
    class FUNCTION isa NODE is
        public NODE result;
        public LIST arguments;

        void init(LOCATION location, LIST arguments, NODE result) is
            super.init(location);

            this.result = result;
            this.arguments = arguments;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                result.walk(visitor);
                arguments.walk(visitor);
            fi

            accept(visitor);
        si

        void rewrite(Dict<Tree.NODE,Tree.NODE> m) is
            result = cast NODE(m[result]);
            arguments = cast LIST(m[arguments]);
        si   
    si
si si si
namespace Syntax is namespace Tree is namespace Type is 
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
    si
si si si
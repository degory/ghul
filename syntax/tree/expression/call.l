namespace Syntax is namespace Tree is namespace Expression is
    use System;
    use Generic;
    
    use Source;

    class CALL isa NODE is
        public NODE function;
        public LIST arguments;

        void init(LOCATION location, NODE function, LIST arguments) is
            super.init(location);

            this.function = function;
            this.arguments = arguments;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                arguments.walk(visitor);
                function.walk(visitor);
            fi

            accept(visitor);
        si

        void rewrite(Dict<NODE,NODE> m) is
            function = cast NODE(m[function]);
            arguments = cast LIST(m[arguments]);
        si
    si
si si si

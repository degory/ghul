namespace Syntax is namespace Tree is namespace Expression is
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
    si
si si si

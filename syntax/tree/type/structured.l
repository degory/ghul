namespace Syntax is namespace Tree is namespace Type is 
    use Source;

    class STRUCTURED isa NODE is
        public NODE element;

        get int size is return 8; si

        void init(LOCATION location, NODE element) is
            super.init(location);

            this.element = element;
        si

        void accept(Visitor visitor) is visitor.visit(this); si        
    si
si si si


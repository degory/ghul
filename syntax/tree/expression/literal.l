namespace Syntax is namespace Tree is namespace Expression is
    use System;

    use Source;

    class LITERAL isa NODE is
        public String value;

        void init(
            LOCATION location,
            String value
        )
        is
            super.init(location);

            this.value = value;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si                
    si

    class NONE isa LITERAL is
        void init(LOCATION location) is
            super.init(location);
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si                                
    si    

    class LIST_LITERAL isa NODE is
        public LIST elements;

        void init(
            LOCATION location,
            LIST elements
        )
        is
            super.init(location);

            this.elements = elements;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si
si si si
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
        public Type.NODE type;
        public LIST elements;

        void init(
            LOCATION location,
            LIST elements,
            Type.NODE type
        )
        is
            super.init(location);

            this.elements = elements;
            this.type = type;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si
si si si
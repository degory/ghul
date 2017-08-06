namespace Syntax is namespace Tree is namespace Expression is namespace Literal is
    use System;

    use Source;

    class CHARACTER isa Literal.NODE is
        void init(
            LOCATION location,
            String value
        )
        is
            super.init(location, value);
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si                
    si
si si si si
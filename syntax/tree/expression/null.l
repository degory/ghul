namespace Syntax is namespace Tree is namespace Expression is
    use Generic;
    
    use Source;

    class NULL isa NODE is
        void init(
            LOCATION location
        )
        is
            super.init(location);
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si
si si si
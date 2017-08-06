namespace Syntax is namespace Tree is namespace Expression is namespace Literal is
    use System;

    use Source;

    class NONE isa NODE is
        void init(LOCATION location) is
            super.init(location, "none");
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si                                
    si    
si si si si
namespace Syntax is namespace Tree is namespace Type is 
    use System;
    
    use Source;

    class NODE isa Tree.NODE is
        get int size is 
            throw new Exception("type has unknown size: " + this);
        si
        
        void init(LOCATION location) is
            super.init(location);
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

    si
si si si

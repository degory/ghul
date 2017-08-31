namespace Syntax is namespace Tree is namespace Expression is
    use Generic;
    
    use Source;

    class SELF isa NODE is
        void init(
            LOCATION location,
            Type.NODE type
        )
        is
            super.init(location);
            this.type = type;    
        si
    si
si si si
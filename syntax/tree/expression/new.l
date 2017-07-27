namespace Syntax is namespace Tree is namespace Expression is
    use Source;

    class NEW isa NODE is
        public Type.NODE type;
        public TUPLE arguments;
        
        void init(
            LOCATION location,
            Type.NODE type,
            TUPLE arguments
        )
        is
            super.init(location);
            
            this.type = type;
            this.arguments = arguments;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si
si si si

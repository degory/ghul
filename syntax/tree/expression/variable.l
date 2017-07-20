namespace Syntax is namespace Tree is namespace Expression is
    use Source;

    // FIXME: not really sure how this relates to a variable definition
    // is it exactly the same thing?
    class VARIABLE isa NODE is
        public Identifier.NODE identifier;
        public Type.NODE type;
        public NODE initializer;

        void init(
            LOCATION location,
            Identifier.NODE identifier,
            Type.NODE type,
            NODE initializer
        )
        is
            super.init(location);

            this.identifier = identifier; 
            this.type = type;
            this.initializer = initializer;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si            
si si si

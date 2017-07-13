namespace Syntax is namespace Tree is namespace Variable is
    use Source;
    
    class NODE isa Tree.NODE is
        public Identifier.NODE identifier;
        public Type.NODE type;
        public Expression.NODE initializer;

        void init(
            LOCATION location,
            Identifier.NODE identifier,
            Type.NODE type,
            Expression.NODE initializer
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

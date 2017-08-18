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

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                IO.Std.err.println("identifier: " + identifier);
                identifier.walk(visitor);
                IO.Std.err.println("type: " + type);
                
                type.walk(visitor);

                if initializer != null then
                   initializer.walk(visitor);
                fi                
            fi
        si
    si
si si si

namespace Syntax is namespace Tree is namespace Variable is
    use Generic;
    
    use Source;
    
    class NODE isa Tree.NODE is
        public Identifier.NODE name;
        public Type.NODE type;
        public Expression.NODE initializer;

        void init(
            LOCATION location,
            Identifier.NODE name,
            Type.NODE type,
            Expression.NODE initializer
        )
        is
            super.init(location);

            this.name = name;
            this.type = type;
            this.initializer = initializer;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                name.walk(visitor);
                
                type.walk(visitor);

                if initializer != null then
                   initializer.walk(visitor);
                fi
            fi

            accept(visitor);
        si

        void rewrite(Dict<Tree.NODE,Tree.NODE> m) is
            name = cast Identifier.NODE(m[name]);
            type = cast Type.NODE(m[type]);
            initializer = cast Expression.NODE(m[initializer]);
        si
    si
si si si

namespace Syntax is namespace Tree is namespace Expression is
    use Generic;
    
    use Source;

    // FIXME: not really sure how this relates to a variable definition
    // is it exactly the same thing?
    class VARIABLE isa NODE is
        public Identifier.NODE identifier;
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

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                identifier.walk(visitor);
                type.walk(visitor);
                if initializer != null then
                    initializer.walk(visitor);
                fi
            fi

            accept(visitor);        
        si

        void rewrite(Dict<Tree.NODE,Tree.NODE> m) is
            identifier = cast Identifier.NODE(m[identifier]);
            type = cast Type.NODE(m[type]);
            initializer = cast NODE(m[initializer]);
        si
    si            
si si si

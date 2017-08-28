namespace Syntax is namespace Tree is namespace Expression is
    use Generic;
    
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

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                type.walk(visitor);
                arguments.walk(visitor);
            fi

            accept(visitor);
        si

        void rewrite(Dict<NODE,NODE> m) is
            type = cast Type.NODE(m[type]);
            arguments = cast TUPLE(m[arguments]);
        si
    si
si si si

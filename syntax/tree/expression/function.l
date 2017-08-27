namespace Syntax is namespace Tree is namespace Expression is
    use Source;

    class FUNCTION isa NODE is
        public TUPLE arguments;
        public Type.NODE type;
        public Body.NODE body;

        void init(
            LOCATION location,
            TUPLE arguments,
            Type.NODE type,                    
            Body.NODE body)
        is
            super.init(location);

            this.arguments = arguments;
            this.type = type;
            this.body = body;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                type.walk(visitor);
                body.walk(visitor);
            fi

            accept(visitor);
        si

        void rewrite(MAP m) is
            type = cast Type.NODE(m[type]);
            body = cast Type.NODE(m[body]);
        si
    si
si si si

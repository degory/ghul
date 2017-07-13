namespace Syntax is namespace Tree is namespace Definition is
    use Source;

    class PROPERTY isa NODE is
        public Type.NODE type;
        public Identifier.NODE name;
        public Body.NODE getter_body;
        public Identifier.NODE setter_argument;
        public Body.NODE setter_body;

        void init(
            LOCATION location,
            Type.NODE type,
            Identifier.NODE name,
            Body.NODE getter_body,
            Identifier.NODE setter_argument,
            Body.NODE setter_body
        )
        is
            super.init(location);

            this.type = type;
            this.name = name;
            this.getter_body = getter_body;
            this.setter_argument = setter_argument;
            this.setter_body = setter_body;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si
si si si

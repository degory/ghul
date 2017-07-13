namespace Syntax is namespace Tree is namespace Definition is
    use Source;

    class FUNCTION isa NODE is
        public Identifier.NODE name;
        public Variable.LIST arguments;
        public Type.NODE type;
        public Body.NODE body;

        void init(
            LOCATION location,
            Identifier.NODE name,
            Variable.LIST arguments,
            Type.NODE type,
            Body.NODE body
        )
        is
            super.init(location);

            this.name = name;
            this.arguments = arguments;
            this.type = type;
            this.body = body;
        si

        public void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si
si si si

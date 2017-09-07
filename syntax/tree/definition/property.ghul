namespace Syntax is namespace Tree is namespace Definition is
    use Source;

    class PROPERTY isa MODIFIABLE is
        public Type.NODE type;
        public Identifier.NODE name;
        public Body.NODE getter_body;
        public Identifier.NODE setter_argument;
        public Body.NODE setter_body;

        void init(
            LOCATION location,
            Type.NODE type,
            Identifier.NODE name,
            Modifier.LIST modifiers,            
            Body.NODE getter_body,
            Identifier.NODE setter_argument,
            Body.NODE setter_body
        )
        is
            super.init(location, modifiers);

            this.type = type;
            this.name = name;
            this.getter_body = getter_body;
            this.setter_argument = setter_argument;
            this.setter_body = setter_body;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then                
                modifiers.walk(visitor);

                type.walk(visitor);

                if name != null then
                    name.walk(visitor);
                fi

                if getter_body != null then                
                    getter_body.walk(visitor);
                fi

                if setter_argument != null then
                    setter_argument.walk(visitor);
                fi

                if setter_body != null then
                    setter_body.walk(visitor);
                fi
            fi

            accept(visitor);
        si
    si
si si si

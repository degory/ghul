namespace Syntax is namespace Tree is namespace Expression is
    use Source;

    class PRIMARY isa NODE is
        void init(LOCATION location) is
            super.init(location);
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si

    class FUNCTION isa PRIMARY is
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
    si

    // FIXME: not really sure how this relates to a variable definition
    // is it exactly the same thing?
    class VARIABLE isa PRIMARY is
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

    class UNARY isa PRIMARY is
        public OPERATION operation;
        public NODE right;
        
        void init(
            LOCATION location,
            OPERATION operation,
            NODE right
        )
        is
            super.init(location);
            
            this.operation = operation;
            this.right = right;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si

    class IDENTIFIER isa PRIMARY is
        public Identifier.NODE identifier;

        void init(LOCATION location, Identifier.NODE identifier) is
            super.init(location);

            this.identifier = identifier;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si

    class CALL isa PRIMARY is
        public NODE function;
        public LIST arguments;

        void init(LOCATION location, NODE function, LIST arguments) is
            super.init(location);

            this.function = function;
            this.arguments = arguments;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si

    class MEMBER isa PRIMARY is 
        public NODE left;
        public Identifier.NODE identifier;

        void init(LOCATION location, NODE left, Identifier.NODE identifier) is
            super.init(location);

            this.left = left;
            this.identifier = identifier;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si                
    si

    class INDEX isa PRIMARY is 
        public NODE left;
        public NODE index;

        void init(LOCATION location, NODE left, NODE index) is
            super.init(location);

            this.left = left;
            this.index = index;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si                
    si

    class TUPLE isa PRIMARY is
        public LIST elements;

        void init(
            LOCATION location,
            LIST elements
        )
        is
            super.init(location);

            this.elements = elements;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si
si si si

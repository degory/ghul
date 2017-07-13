namespace Syntax is namespace Tree is namespace Type is 
    use Source;
    
    class GENERIC isa NAMED is
        public Type.LIST arguments;

        void init(LOCATION location, Identifier.NODE name, Type.LIST arguments) is
            super.init(location, name);
            this.arguments = arguments;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si        
    si
si si si 
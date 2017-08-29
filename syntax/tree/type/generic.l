namespace Syntax is namespace Tree is namespace Type is 
    use Generic;
    
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

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                arguments.walk(visitor);
            fi

            accept(visitor);
        si

        void rewrite(Dict<Tree.NODE,Tree.NODE> m) is
            super.rewrite(m);
            arguments = cast LIST(m[arguments]);
        si           
    si
si si si 
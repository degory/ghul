namespace Syntax is namespace Tree is namespace Expression is
    use System;
    use Generic;
    
    use Source;

    class GLOBAL_VARIABLE isa NODE is
        public String name;
        
        void init(
            LOCATION location,
            String name,
            Type.NODE type
        )
        is
            super.init(location);

            this.name = name;
            this.type = type;    
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                type.walk(visitor);
            fi

            accept(visitor);            
        si

        void rewrite(Dict<Tree.NODE,Tree.NODE> m) is
            type = cast Type.NODE(m[type]);
        si        
    si
si si si
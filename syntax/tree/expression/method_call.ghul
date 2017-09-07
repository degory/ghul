namespace Syntax is namespace Tree is namespace Expression is
    use System;
    use Generic;
    
    use Source;

    class INSTANCE_CALL isa NODE is
        public NODE self_;
        public String name;
        public LIST arguments;
        
        void init(
            LOCATION location,
            NODE self_,
            String name,
            LIST arguments,
            Type.NODE type
        )
        is
            super.init(location);

            this.self_ = self_;
            this.name = name;
            this.arguments = arguments;
            this.type = type;    
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                self_.walk(visitor);
                arguments.walk(visitor);
                type.walk(visitor);
            fi

            accept(visitor);
        si

        void rewrite(Dict<Tree.NODE,Tree.NODE> m) is
            self_ = cast NODE(m[self_]);
            arguments = cast LIST(m[arguments]);
            type = cast Type.NODE(m[type]);
        si        
    si
si si si
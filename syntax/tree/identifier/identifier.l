namespace Syntax is namespace Tree is namespace Identifier is
    use System;

    use Source;

    class NODE isa Tree.NODE is
        public String name;

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        void init(LOCATION location, String name) is
            super.init(location);

            this.name = name;
        si
    si

    class QUALIFIED isa NODE is
        public NODE parent;

        void init(LOCATION location, NODE parent, String name) is
            super.init(location, name);
        
            this.parent = parent;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si
si si si
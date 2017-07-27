namespace Syntax is namespace Tree is namespace Type is
    use System;

    use Source;

    // FIXME: this is a hack to try and get parser self hosting on top of L compiler
    // as quickly as possible. 

    class MODIFIER isa NODE is
        public NODE element;

        void init(LOCATION location, NODE element) is
            super.init(location);

            this.element = element;
        si

        get String name is
            throw new NotImplementedException("% does not implement name" % Object{this});
        si

        void accept(Visitor visitor) is visitor.visit(this); si                
    si

    class PUBLIC isa MODIFIER is
        void init(LOCATION location, NODE element) is super.init(location, element); si

        get String name is return "public"; si
    si

    class PROTECTED isa MODIFIER is
        void init(LOCATION location, NODE element) is super.init(location, element); si

        get String name is return "protected"; si
    si

    class PRIVATE isa MODIFIER is
        void init(LOCATION location, NODE element) is super.init(location, element); si

        get String name is return "private"; si
    si

    class STATIC isa MODIFIER is
        void init(LOCATION location, NODE element) is super.init(location, element); si

        get String name is return "static"; si
    si    
si si si
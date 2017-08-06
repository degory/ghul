namespace Syntax is namespace Tree is namespace Modifier is
    use System;

    use Source;

    // FIXME: this is a hack to try and get parser self hosting on top of L compiler
    // as quickly as possible. 

    class NODE isa Tree.NODE is
        void init(LOCATION location) is
            super.init(location);
        si

        get String name is
            throw new NotImplementedException("% does not implement name" % Object{this});
        si

        void accept(Visitor visitor) is visitor.visit(this); si                
    si

    class ACCESS_MODIFIER isa NODE is
        void init(LOCATION location) is
            super.init(location);
        si
    si

    class STORAGE_CLASS isa NODE is
        void init(LOCATION location) is
            super.init(location);
        si        
    si

    class PUBLIC isa ACCESS_MODIFIER is
        void init(LOCATION location) is super.init(location); si

        get String name is return "public"; si
    si

    class PROTECTED isa ACCESS_MODIFIER is
        void init(LOCATION location) is super.init(location); si

        get String name is return "protected"; si
    si

    class PRIVATE isa ACCESS_MODIFIER is
        void init(LOCATION location) is super.init(location); si

        get String name is return "private"; si
    si

    class STATIC isa STORAGE_CLASS is
        void init(LOCATION location) is super.init(location); si

        get String name is return "static"; si
    si    

    class CONST isa STORAGE_CLASS is
        void init(LOCATION location) is super.init(location); si

        get String name is return "const"; si
    si        
si si si

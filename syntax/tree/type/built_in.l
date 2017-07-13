namespace Syntax is namespace Tree is namespace Type is
    use System;

    use Source;

    class BUILT_IN isa NODE is
        void init(LOCATION location) is
            super.init(location);
        si

        get String name is
            throw new NotImplementedException("% does not implement name" % Object{this});
        si

        void accept(Visitor visitor) is visitor.visit(this); si                
    si

    class SCALAR isa BUILT_IN is
        void init(LOCATION location) is super.init(location); si
    si

    class INTEGER isa SCALAR is
        void init(LOCATION location) is super.init(location); si    
    si

    class VOID isa BUILT_IN is
        void init(LOCATION location) is super.init(location); si

        get String name is return "void"; si
    si

    class UNDEFINED isa BUILT_IN is
        void init(LOCATION location) is super.init(location); si

        get String name is return "undefined"; si
    si

    class NONE isa BUILT_IN is
        void init(LOCATION location) is super.init(location); si

        get String name is return "none"; si
    si

    class INFER isa NODE is
        void init(LOCATION location) is super.init(location); si

        get String name is return "infer"; si
    si      

    class BOOL isa BUILT_IN is
        void init(LOCATION location) is super.init(location); si

        get int size is return 1; si

        get String name is return "bool"; si
    si

    class BYTE isa INTEGER is
        void init(LOCATION location) is super.init(location); si

        get int size is return 1; si

        get String name is return "byte"; si        
    si
      
    class CHAR isa INTEGER is
        void init(LOCATION location) is super.init(location); si

        get int size is return 1; si

        get String name is return "char"; si
    si

    class INT isa INTEGER is
        void init(LOCATION location) is super.init(location); si

        get int size is return 4; si

        get String name is return "int"; si      
    si

    class WORD isa INTEGER is
        void init(LOCATION location) is super.init(location); si

        get int size is return 8; si

        get String name is return "word"; si        
    si

    class LONG isa INTEGER is
        void init(LOCATION location) is super.init(location); si

        get int size is return 8; si

        get String name is return "long"; si                
      si
si si si
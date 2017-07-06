import glist;

namespace Syntax is
  namespace Tree is
    namespace Type is 
      use System;
      use Generic;

      use Source;

      class BUILT_IN isa TYPE is
        void init(LOCATION location) is
          super.init(location);
        si

        public get String name is
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

        public get String name is return "void"; si
      si

      class NONE isa BUILT_IN is
        void init(LOCATION location) is super.init(location); si

        public get String name is return "none"; si
      si

      class INFER isa TYPE is
        void init(LOCATION location) is super.init(location); si

        public get String name is return "infer"; si
      si      

      class BOOL isa BUILT_IN is
        void init(LOCATION location) is super.init(location); si

        get int size is return 1; si

        public get String name is return "bool"; si
      si

      class BYTE isa INTEGER is
        void init(LOCATION location) is super.init(location); si

        get int size is return 1; si

        public get String name is return "byte"; si        
      si
      
      class CHAR isa INTEGER is
        void init(LOCATION location) is super.init(location); si

        get int size is return 1; si

        public get String name is return "char"; si
      si

      class INT isa INTEGER is
        void init(LOCATION location) is super.init(location); si

        get int size is return 4; si

        public get String name is return "int"; si      
      si

      class WORD isa INTEGER is
        void init(LOCATION location) is super.init(location); si

        get int size is return 8; si

        public get String name is return "word"; si        
      si

      class LONG isa INTEGER is
        void init(LOCATION location) is super.init(location); si

        get int size is return 8; si

        public get String name is return "long"; si                
      si

      class STRUCTURED isa TYPE is
        public TYPE element;

        void init(LOCATION location, TYPE element) is
          super.init(location);

          this.element = element;
        si

        public get int size is return 8; si

        void accept(Visitor visitor) is visitor.visit(this); si        
      si

      class ARRAY isa STRUCTURED is
        void init(LOCATION location, TYPE element) is super.init(location, element); si

        void accept(Visitor visitor) is
          visitor.visit(this);
        si
      si

      class POINTER isa STRUCTURED is
        void init(LOCATION location, TYPE element) is super.init(location, element); si

        void accept(Visitor visitor) is
          visitor.visit(this);
        si
      si

      class REFERENCE isa STRUCTURED is
        void init(LOCATION location, TYPE element) is super.init(location, element); si

        void accept(Visitor visitor) is
          visitor.visit(this);
        si
      si

      class NAMED isa TYPE is
        public IDENTIFIER name;

        void init(LOCATION location, IDENTIFIER name) is
            super.init(location);
            this.name = name;
        si

        public get int size is return 8; si

        void accept(Visitor visitor) is
          visitor.visit(this);
        si        
      si

      class GENERIC isa NAMED is
        public List<TYPE> arguments;

        void init(LOCATION location, IDENTIFIER name, List<TYPE> arguments) is
          super.init(location, name);
          this.arguments = arguments;
        si

        void accept(Visitor visitor) is
          visitor.visit(this);
        si        
      si
    si
  si
si

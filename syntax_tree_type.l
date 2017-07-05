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
      si

      class SCALAR isa BUILT_IN is
        void init(LOCATION location) is super.init(location); si
      si

      class INTEGER isa SCALAR is
        void init(LOCATION location) is super.init(location); si    
      si

      class VOID isa BUILT_IN is
        void init(LOCATION location) is super.init(location); si
      si

      class NONE isa BUILT_IN is
        void init(LOCATION location) is super.init(location); si
      si

      class INFER isa TYPE is
        void init(LOCATION location) is super.init(location); si
      si      

      class BOOL isa BUILT_IN is
        void init(LOCATION location) is super.init(location); si

        get int size is return 1; si
      si

      class BYTE isa INTEGER is
        void init(LOCATION location) is super.init(location); si

        get int size is return 1; si
      si

      class CHAR isa INTEGER is
        void init(LOCATION location) is super.init(location); si

        get int size is return 1; si
      si

      class INT isa INTEGER is
        void init(LOCATION location) is super.init(location); si

        get int size is return 4; si
      si

      class WORD isa INTEGER is
        void init(LOCATION location) is super.init(location); si

        get int size is return 8; si
      si

      class LONG isa INTEGER is
        void init(LOCATION location) is super.init(location); si

        get int size is return 8; si
      si

      class STRUCTURED isa TYPE is
        public TYPE element;

        void init(LOCATION location, TYPE element) is
          super.init(location);

          this.element = element;
        si

        public get int size is return 8; si
      si

      class ARRAY isa STRUCTURED is
        void init(LOCATION location, TYPE element) is super.init(location, element); si
      si

      class POINTER isa STRUCTURED is
        void init(LOCATION location, TYPE element) is super.init(location, element); si
      si

      class REFERENCE isa STRUCTURED is
        void init(LOCATION location, TYPE element) is super.init(location, element); si
      si

      class NAMED isa TYPE is
        public IDENTIFIER name;

        void init(LOCATION location, IDENTIFIER name) is
            super.init(location);
            this.name = name;
        si

        public get int size is return 8; si
      si

      class GENERIC isa NAMED is
        public List<TYPE> arguments;

        void init(LOCATION location, IDENTIFIER name, List<TYPE> arguments) is
          super.init(location, name);
          this.arguments = arguments;
        si
      si
    si
  si
si

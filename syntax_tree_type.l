import glist;

namespace Syntax is
  namespace Tree is
    namespace Type is 
      use System;
      use Generic;

      class BUILT_IN isa TYPE is
        public static VOID VOID = new VOID();
        public static BOOL BOOL = new BOOL();
        public static BYTE BYTE = new BYTE();
        public static CHAR CHAR = new CHAR();
        public static INT INT = new INT();
        public static WORD WORD = new WORD();
      si

      class SCALAR isa BUILT_IN is
        void init() is super.init(); si    
      si

      class INTEGER isa SCALAR is
        void init() is super.init(); si    
      si

      class VOID isa BUILT_IN is
        void init() is super.init(); si
      si

      class NONE isa BUILT_IN is
        void init() is super.init(); si
      si

      class BOOL isa BUILT_IN is
        void init() is super.init(); si

        get int size is return 1; si
      si

      class BYTE isa INTEGER is
        void init() is super.init(); si

        get int size is return 1; si
      si

      class CHAR isa INTEGER is
        void init() is super.init(); si

        get int size is return 1; si
      si

      class INT isa INTEGER is
        void init() is super.init(); si

        get int size is return 4; si
      si

      class WORD isa INTEGER is
        void init() is super.init(); si

        get int size is return 8; si
      si

      class LONG isa INTEGER is
        void init() is super.init(); si

        get int size is return 8; si
      si

      class STRUCTURED isa TYPE is
        public TYPE element;

        void init(TYPE element) is
          super.init();

          this.element = element;
        si

        public get int size is return 8; si
      si

      class ARRAY isa STRUCTURED is
        void init(TYPE element) is super.init(element); si
      si

      class POINTER isa STRUCTURED is
        void init(TYPE element) is super.init(element); si
      si

      class REFERENCE isa STRUCTURED is
        void init(TYPE element) is super.init(element); si
      si

      class NAMED isa TYPE is
        public IDENTIFIER name;

        void init(IDENTIFIER name) is
            super.init();
            this.name = name;
        si

        public get int size is return 8; si
      si

      class GENERIC isa NAMED is
        public List<TYPE> arguments;

        void init(IDENTIFIER name, List<TYPE> arguments) is
          super.init(name);
          this.arguments = arguments;
        si
      si
    si
  si
si

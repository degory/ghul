import glist;

import ast_type;

namespace Syntax is
  use System;
  use Generic;

  namespace Tree is
    class NODE is

    si

    class IDENTIFIER isa NODE is
      public String name;

      void init(String name) is
        super.init();

        this.name = name;
      si
    si

    class QUALIFIED_IDENTIFIER isa IDENTIFIER is
      public IDENTIFIER parent;

      void init(IDENTIFIER parent, String name) is
        super.init(name);
      si
    si

    class EXPRESSION isa NODE is
  
    si

    class DEFINITION isa NODE is

    si

    namespace Definition is

      class VARIABLE isa DEFINITION is
        public List<IDENTIFIER> identifiers;
        public List<EXPRESSION> initializers;

        void init(List<IDENTIFIER> identifiers, List<EXPRESSION> initializers) is
          super.init();

          this.identifiers = identifiers;
          this.initializers = initializers;        
        si
      si

      class LET isa VARIABLE is
        void init(List<IDENTIFIER> identifiers, List<EXPRESSION> initializers) is
          super.init(identifiers, initializers);
        si      
      si
    si

    class TYPE isa NODE is
      void init() is
        super.init();
      si

      get int size is 
        throw new Exception("type has unknown size: " + this);
      si
    si

  si
si

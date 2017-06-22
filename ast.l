import "forward.o";
import "type.tab.o";
import "grammar_test.o";

namespace Syntax is
  use System;

  class TREE is

  si

  class IDENTIFIER isa TREE is
    public String name;

    void init(String name) is
      this.name = name;
    si

    static IDENTIFIER create(char ptr name) is
      @Forward;
      return new IDENTIFIER(new String(name));
    si
  si

  class QUALIFIED_IDENTIFIER isa IDENTIFIER is
    public IDENTIFIER parent;

    void init(IDENTIFIER parent, String name) is
      super.init(name);
    si

    static QUALIFIED_IDENTIFIER create(IDENTIFIER parent, char ptr name) is
      @Forward;
      return new QUALIFIED_IDENTIFIER(parent, new String(name));
    si
  si

  namespace Type is

    class TYPE isa TREE is
      void init() is si
      static TYPE create() is
        @Forward;
        return new TYPE();
      si

      get int size is 
        throw new Exception("type has unknown size: " + this);
      si
    si

    enum ID is
      UNKNOWN,
      INFER,
      VOID,
      BOOL,
      BYTE,
      CHAR,
      INT,
      WORD,
      LONG
    si

    class BUILT_IN isa TYPE is
      public ID id;

      void init(ID id) is
        super.init();
        this.id = id;
      si
    si

    class SCALAR isa BUILT_IN is
      void init(ID type_id) is super.init(id); si    
    si

    class INTEGER isa SCALAR is
      void init(ID id) is super.init(id); si    
    si

    class VOID isa BUILT_IN is
      void init() is super.init(ID.VOID); si

      static VOID create() is @Forward; return new VOID(); si
    si

    class BOOL isa BUILT_IN is
      void init() is super.init(ID.BOOL); si

      static BOOL create() is @Forward; return new BOOL(); si

      get int size is return 1; si
    si

    class BYTE isa INTEGER is
      void init() is super.init(ID.BYTE); si

      static BYTE create() is @Forward; return new BYTE(); si

      get int size is return 1; si
    si

    class CHAR isa INTEGER is
      void init() is super.init(ID.CHAR); si

      static CHAR create() is @Forward; return new CHAR(); si

      get int size is return 1; si
    si

    class INT isa INTEGER is
      void init() is super.init(ID.INT); si

      static INT create() is @Forward; return new INT(); si

      get int size is return 4; si
    si

    class WORD isa INTEGER is
      void init() is super.init(ID.WORD); si

      static WORD create() is @Forward; return new WORD(); si

      get int size is return 8; si
    si

    class LONG isa INTEGER is
      void init() is super.init(ID.LONG); si

      static LONG create() is @Forward; return new LONG(); si

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

      static ARRAY create(TYPE element) is @Forward; return new ARRAY(element); si
    si

    class POINTER isa STRUCTURED is
      void init(TYPE element) is super.init(element); si

      static POINTER create(TYPE element) is @Forward; return new POINTER(element); si
    si

    class REFERENCE isa STRUCTURED is
      void init(TYPE element) is super.init(element); si

      static REFERENCE create(TYPE element) is @Forward; return new REFERENCE(element); si
    si

    class NAMED isa TYPE is
      public IDENTIFIER name;

      void init(IDENTIFIER name) is this.name = name; si

      static NAMED create(IDENTIFIER name) is @Forward; return new NAMED(name); si

      public get int size is return 8; si
    si
  si

  class Main is
    native int yyparse();

    void init() is
      IO.Std.err.println("calling yyparse...");
      yyparse();
    si
  si
si

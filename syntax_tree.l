import glist;

namespace Syntax is
  use System;
  use Generic;

  namespace Tree is
    class NODE is
      public LOCATION location;

      void init(LOCATION location) is
        this.location = location;
      si

      void accept(Visitor visitor) is
        visitor.visit(this);
      si

      NODE transform(Transformer transformer) is
        var result = transformer.visit(this);
        if result != null then
          return result;
        else
          return this;
        fi
      si
    si

    class IDENTIFIER isa NODE is
      public String name;

      void accept(Visitor visitor) is
        visitor.visit(this);
      si

      IDENTIFIER accept(Transformer transformer) is
        return Coalesce<IDENTIFIER>.c(transformer.visit(this), this);
      si

      void init(LOCATION location, String name) is
        super.init(location);

        this.name = name;
      si
    si

    class QUALIFIED_IDENTIFIER isa IDENTIFIER is
      public IDENTIFIER parent;

      void init(LOCATION location, IDENTIFIER parent, String name) is
        super.init(location, name);
      si

      void accept(Visitor visitor) is
        visitor.visit(this);
      si

      IDENTIFIER accept(Transformer transformer) is
        parent = parent.accept(transformer);

        return Coalesce<IDENTIFIER>.c(transformer.visit(this), this);
      si
    si

    class EXPRESSION isa NODE is
      void init(LOCATION location) is
        super.init(location, name);
      si

      void accept(Visitor visitor) is
        visitor.visit(this);
      si

      EXPRESSION accept(Transformer transformer) is
        return Coalesce<EXPRESSION>.c(transformer.visit(this), this);
      si
    si

    class DEFINITION isa NODE is
      void init(LOCATION location) is
        super.init(location, name);
      si

      void accept(Visitor visitor) is
        visitor.visitor(this);
      si

      DEFINITION accept(Transformer transformer) is
        return Coalesce<DEFINITION>.c(transformer.visit(this), this);
      si
    si

    class TYPE isa NODE is
      void init(LOCATION location) is
        super.init(location);
      si

      void accept(Visitor visitor) is
        visitor.visit(this);
      si

      TYPE accept(Transformer transformer) is
        return Coalesce<TYPE>.c(transformer.visit(this), this);
      si

      get int size is 
        throw new Exception("type has unknown size: " + this);
      si
    si

  si
si

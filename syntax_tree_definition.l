namespace Syntax is
  namespace Tree is
    use System;
    use Generic;

    use Source;

    namespace Definition is
      class VARIABLE isa DEFINITION is
        public IDENTIFIER identifier;
        public TYPE type;
        public EXPRESSION initializer;

        void init(
          LOCATION location,
          IDENTIFIER identifier,
          TYPE type,
          EXPRESSION initializer
        )
        is
          super.init(location);

          this.identifier = identifier;
          this.type = type;
          this.initializer = initializer;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si

        DEFINITION accept(Transformer transformer) is
            identifier = identifier.accept(transformer);
            type = type.accept(transformer);
            initializer = initializer.accept(transformer);

            return Coalesce<DEFINITION>.c(transformer.visit(this), this);
        si
      si

      class VARIABLE_LIST isa DEFINITION do Iterable<VARIABLE> is
        public List<VARIABLE> variables;

        void init(
          LOCATION location,
          Iterable<VARIABLE> variables
        )
        is
          super.init(location);
          IO.Std.err.println("" + this + " add " + variables); 

          this.variables = new Vector<VARIABLE>();
          this.variables.add(variables);

          IO.Std.err.println("" + this + " has " + this.variables); 
        si

        get Iterator<VARIABLE> Iterator is
          return variables.Iterator;
        si

        void accept(Visitor visitor) is
          visitor.visit(this);
        si
      si

      class LET isa DEFINITION do Iterable<VARIABLE> is
        public VARIABLE_LIST variables;

        void init(
          LOCATION location,
          VARIABLE_LIST variables
        )
        is
          super.init(location);
          this.variables = variables;
        si 

        public get Iterator<VARIABLE> Iterator is
          return variables.Iterator;
        si

        void accept(Visitor visitor) is
          visitor.visit(this);
        si      
      si

      class VAR isa DEFINITION do Iterable<VARIABLE> is
        public VARIABLE_LIST variables;

        void init(
          LOCATION location,
          VARIABLE_LIST variables
        )
        is
          super.init(location);
          this.variables = variables;
        si     

        public get Iterator<VARIABLE> Iterator is
          return variables.Iterator;
        si

        void accept(Visitor visitor) is
          visitor.visit(this);
        si 
      si

      class DEFINITION_LIST isa DEFINITION do Iterable<DEFINITION> is
        public List<DEFINITION> definitions;

        void init(
          LOCATION location,
          Iterable<DEFINITION> definitions
        )
        is
          super.init(location);
          
          this.definitions = new Vector<DEFINITION>();
          this.definitions.add(definitions);
        si

        get Iterator<DEFINITION> Iterator is
          return definitions.Iterator;
        si

        void accept(Visitor visitor) is
          this.accept(visitor);
        si

        DEFINITION accept(Transformer transformer) is
          var new_definitions = new Vector<DEFINITION>(definitions.Length);

          foreach var d; definitions do
            new_definitions.add(d.accept(transformer));
          od

          definitions = new_definitions;

          return Coalesce<DEFINITION>.c(transformer.visit(this), this);
        si
      si
    si
  si
si

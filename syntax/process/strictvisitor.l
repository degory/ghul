namespace Syntax is
    use System;

    use Tree;

    class StrictVisitor isa Visitor is
        void init() is
            super.init();
        si

        private void throwNotImplemented(String name, NODE node) is
            throw new NotImplementedException("Visitor % does not define a visit method for % % and/or this node does not accept this visitor" % Object{this, name, Object.dump(node)});
        si

        // node

        void visit(NODE node) is
            throw new NotImplementedException("Visitor itself is missing a matching method for %" % Object{node});
        si

        // identifiers

        void visit(Identifier.NODE identifier) is
            throwNotImplemented("identifier", identifier);
        si

        void visit(Identifier.QUALIFIED identifier) is
            throwNotImplemented("qualified identifier", identifier);
        si

        // modifiers

        void visit(Modifier.NODE modifier) is
            throwNotImplemented("modifier", modifier);
        si

        void visit(Modifier.LIST modifiers) is
            throwNotImplemented("modifiers", modifiers);
        si        

        // definitions

        void visit(Definition.NODE definition) is
            throwNotImplemented("definition", definition);
        si

        void visit(Definition.LIST definitions) is
            throwNotImplemented("definition list", definitions);
        si

        void visit(Definition.IMPORT import_) is
            throwNotImplemented("import", import_);
        si        
        
        void visit(Definition.NAMESPACE namespace_) is
            throwNotImplemented("namespace", namespace_);
        si        

        void visit(Definition.USE use_) is
            throwNotImplemented("use", use_);
        si

        void visit(Definition.CLASS class_) is
            throwNotImplemented("class", class_);
        si

        void visit(Definition.INTERFACE interface_) is
            throwNotImplemented("interface", interface_);
        si        

        void visit(Definition.ENUM enum_) is
            throwNotImplemented("enum", enum_);
        si

        void visit(Definition.ENUM_MEMBER enum_member) is
            throwNotImplemented("enum member", enum_member);
        si        

        void visit(Definition.FUNCTION function) is
            throwNotImplemented("function", function);
        si

        void visit(Definition.PROPERTY property) is
            throwNotImplemented("property", property);
        si

        void visit(Definition.INDEXER indexer) is
            throwNotImplemented("indexer", indexer);
        si        

        // variables

        void visit(Variable.NODE variable) is
            throwNotImplemented("variable", variable);
        si

        void visit(Variable.LIST variables) is
            throwNotImplemented("variable list", variables);
        si

        // types

        void visit(Type.NODE type) is
            throwNotImplemented("type", type);
        si

        void visit(Type.INFER type) is
            throwNotImplemented("infer", type);
        si        

        void visit(Type.BUILT_IN built_in) is
            throwNotImplemented("built id", built_in);
        si        

        void visit(Type.STRUCTURED structured) is
            throwNotImplemented("structured", structured);
        si

        void visit(Type.ARRAY array) is
            throwNotImplemented("array", array);
        si

        void visit(Type.POINTER pointer) is
            throwNotImplemented("pointer", pointer);
        si

        void visit(Type.REFERENCE reference) is
            throwNotImplemented("reference", reference);            
        si

        void visit(Type.NAMED named) is
            throwNotImplemented("named", named);
        si

        void visit(Type.LIST types) is
            throwNotImplemented("type list", types);
        si

        void visit(Type.GENERIC generic) is
            throwNotImplemented("generic", generic);
        si

        void visit(Type.FUNCTION function) is
            throwNotImplemented("function", function);
        si

        void visit(Type.TUPLE tuple) is
            throwNotImplemented("tuple", tuple);
        si

        void visit(Type.NAMED_TUPLE_ELEMENT element) is
            throwNotImplemented("name tuple element", element);
        si

        // expressions

        void visit(Expression.NODE expression) is
            throwNotImplemented("expression", expression);
        si

        void visit(Expression.IDENTIFIER identifier) is
            throwNotImplemented("identifier", identifier);
        si

        void visit(Expression.Literal.NODE literal) is
            throwNotImplemented("literal", literal);
        si                        

        void visit(Expression.Literal.STRING string) is
            throwNotImplemented("string literal", string);
        si

        void visit(Expression.Literal.CHARACTER character) is
            throwNotImplemented("character literal", character);            
        si
                
        void visit(Expression.VARIABLE variable) is
            throwNotImplemented("variable", variable);
        si

        void visit(Expression.Literal.NONE none) is
            throwNotImplemented("none", none);
        si

        void visit(Expression.NEW new_) is
            throwNotImplemented("new", new_);
        si

        void visit(Expression.CAST cast_) is
            throwNotImplemented("cast", cast_);
        si        

        void visit(Syntax.Tree.Expression.FUNCTION function) is
            throwNotImplemented("function", function);
        si        

        void visit(Expression.TUPLE tuple) is
            throwNotImplemented("tuple", tuple);
        si

        void visit(Expression.SEQUENCE sequence) is
            throwNotImplemented("sequence", sequence);
        si                           

        void visit(Expression.LIST list) is
            throwNotImplemented("list", list);
        si        

        void visit(Expression.CALL call) is
            throwNotImplemented("call", call);
        si

        void visit(Expression.MEMBER member) is
            throwNotImplemented("member", member);
        si

        void visit(Expression.INDEX index) is
            throwNotImplemented("index", index);
        si        

        void visit(Expression.HAS_VALUE has_value) is
            throwNotImplemented("has value", has_value);
        si

        void visit(Expression.UNARY unary) is
            throwNotImplemented("unary", unary);
        si

        void visit(Expression.BINARY binary) is
            throwNotImplemented("binary", binary);
        si

        // statements

        void visit(Statement.NODE statement) is
            throwNotImplemented("statement", statement);
        si

        void visit(Statement.LIST statements) is
            throwNotImplemented("statement list", statements);
        si

        void visit(Statement.LET l) is
            throwNotImplemented("let", l);
        si

        void visit(Statement.VAR v) is
            throwNotImplemented("var", v);
        si

        void visit(Statement.ASSIGNMENT assign) is
            throwNotImplemented("assignment", assign);
        si
        
        void visit(Statement.EXPRESSION expression) is
            throwNotImplemented("expression", expression);
        si

        void visit(Statement.RETURN return_) is
            throwNotImplemented("return", return_);
        si

        void visit(Statement.IF if_) is
            throwNotImplemented("if", if_);
        si

        void visit(Statement.CASE case_) is
            throwNotImplemented("case", case_);
        si

        void visit(Statement.CASE_MATCH case_match) is
            throwNotImplemented("case match", case_match);
        si

        void visit(Statement.TRY try_) is
            throwNotImplemented("try", try_);
        si

        void visit(Statement.CATCH catch_) is
            throwNotImplemented("catch", catch_);
        si        

        void visit(Statement.DO do_) is
            throwNotImplemented("do", do_);
        si

        void visit(Statement.FOR for_) is
            throwNotImplemented("for", for_);
        si

        void visit(Statement.LABELLED labelled) is
            throwNotImplemented("labelled", labelled);
        si

        void visit(Statement.BREAK break_) is
            throwNotImplemented("break", break_);
        si

        void visit(Statement.CONTINUE continue_) is
            throwNotImplemented("continue", continue_);
        si

        // function body

        void visit(Body.NODE body) is
            throwNotImplemented("body", body);
        si

        void visit(Body.EXPRESSION expression) is
            throwNotImplemented("expression body", expression);
        si

        void visit(Body.BLOCK block) is
            throwNotImplemented("block body", block);
        si
    si
si

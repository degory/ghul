namespace Syntax is
    use System;

    use Tree;

    class Visitor is
        void init() is
            super.init();
        si

        private void throwNotImplemented(String name, NODE node) is
            throw new NotImplementedException("Visitor % does not define a visit method for % % and/or this node does not accept this visitor" % Object{this, name, Object.dump(node)});
        si

        // node

        bool pre(NODE node) is
            return false;
        si

        void visit(NODE node) is
            throw new NotImplementedException("Visitor itself is missing a matching method for %" % Object{node});
        si

        // identifiers

        bool pre(Identifier.NODE identifier) is
            return false;
        si

        void visit(Identifier.NODE identifier) is
            throwNotImplemented("identifier", identifier);
        si

        bool pre(Identifier.QUALIFIED identifier) is
            return false;
        si

        void visit(Identifier.QUALIFIED identifier) is
            throwNotImplemented("qualified identifier", identifier);
        si

        // modifiers

        bool pre(Modifier.NODE modifier) is
            return false;
        si

        void visit(Modifier.NODE modifier) is
            throwNotImplemented("modifier", modifier);
        si

        bool pre(Modifier.LIST modifiers) is
            return false;
        si

        void visit(Modifier.LIST modifiers) is
            throwNotImplemented("modifiers", modifiers);
        si        

        // definitions

        bool pre(Definition.NODE definition) is
            return false;
        si

        void visit(Definition.NODE definition) is
            throwNotImplemented("definition", definition);
        si

        bool pre(Definition.LIST definitions) is
            return false;
        si

        void visit(Definition.LIST definitions) is
            throwNotImplemented("definition list", definitions);
        si

        bool pre(Definition.IMPORT import_) is
            return false;
        si

        void visit(Definition.IMPORT import_) is
            throwNotImplemented("import", import_);
        si        
        
        bool pre(Definition.NAMESPACE namespace_) is
            return false;
        si

        void visit(Definition.NAMESPACE namespace_) is
            throwNotImplemented("namespace", namespace_);
        si        

        bool pre(Definition.USE use_) is
            return false;
        si

        void visit(Definition.USE use_) is
            throwNotImplemented("use", use_);
        si

        bool pre(Definition.CLASS class_) is
            return false;
        si

        void visit(Definition.CLASS class_) is
            throwNotImplemented("class", class_);
        si

        bool pre(Definition.INTERFACE interface_) is
            return false;
        si

        void visit(Definition.INTERFACE interface_) is
            throwNotImplemented("interface", interface_);
        si        

        bool pre(Definition.ENUM enum_) is
            return false;
        si

        void visit(Definition.ENUM enum_) is
            throwNotImplemented("enum", enum_);
        si

        bool pre(Definition.ENUM_MEMBER enum_member) is
            return false;
        si

        void visit(Definition.ENUM_MEMBER enum_member) is
            throwNotImplemented("enum member", enum_member);
        si        

        bool pre(Definition.FUNCTION function) is
            return false;
        si

        void visit(Definition.FUNCTION function) is
            throwNotImplemented("function", function);
        si

        bool pre(Definition.PROPERTY property) is
            return false;
        si

        void visit(Definition.PROPERTY property) is
            throwNotImplemented("property", property);
        si

        bool pre(Definition.INDEXER indexer) is
            return false;
        si

        void visit(Definition.INDEXER indexer) is
            throwNotImplemented("indexer", indexer);
        si        

        // variables
        
        bool pre(Variable.NODE variable) is
            return false;
        si

        void visit(Variable.NODE variable) is
            throwNotImplemented("variable", variable);
        si

        bool pre(Variable.LIST variables) is
            return false;
        si

        void visit(Variable.LIST variables) is
            throwNotImplemented("variable list", variables);
        si

        // types

        bool pre(Type.NODE type) is
            return false;
        si

        void visit(Type.NODE type) is
            throwNotImplemented("type", type);
        si

        bool pre(Type.INFER infer) is
            return false;
        si

        void visit(Type.INFER type) is
            throwNotImplemented("infer", type);
        si        

        bool pre(Type.BUILT_IN built_in) is
            return false;
        si

        void visit(Type.BUILT_IN built_in) is
            throwNotImplemented("built id", built_in);
        si        

        bool pre(Type.STRUCTURED structured) is
            return false;
        si

        void visit(Type.STRUCTURED structured) is
            throwNotImplemented("structured", structured);
        si

        bool pre(Type.ARRAY array) is
            return false;
        si

        void visit(Type.ARRAY array) is
            throwNotImplemented("array", array);
        si

        bool pre(Type.POINTER pointer) is
            return false;
        si

        void visit(Type.POINTER pointer) is
            throwNotImplemented("pointer", pointer);
        si

        bool pre(Type.REFERENCE reference) is
            return false;
        si

        void visit(Type.REFERENCE reference) is
            throwNotImplemented("reference", reference);            
        si

        bool pre(Type.NAMED named) is
            return false;
        si

        void visit(Type.NAMED named) is
            throwNotImplemented("named", named);
        si

        bool pre(Type.LIST types) is
            return false;
        si

        void visit(Type.LIST types) is
            throwNotImplemented("type list", types);
        si

        bool pre(Type.GENERIC generic) is
            return false;
        si

        void visit(Type.GENERIC generic) is
            throwNotImplemented("generic", generic);
        si

        bool pre(Type.FUNCTION function) is
            return false;
        si

        void visit(Type.FUNCTION function) is
            throwNotImplemented("function", function);
        si
        
        bool pre(Type.TUPLE tuple) is
            return false;
        si

        void visit(Type.TUPLE tuple) is
            throwNotImplemented("tuple", tuple);
        si

        bool pre(Type.NAMED_TUPLE_ELEMENT element) is
            return false;
        si

        void visit(Type.NAMED_TUPLE_ELEMENT element) is
            throwNotImplemented("name tuple element", element);
        si

        // expressions

        bool pre(Expression.NODE expression) is
            return false;
        si

        void visit(Expression.NODE expression) is
            throwNotImplemented("expression", expression);
        si

        bool pre(Expression.IDENTIFIER identifier) is
            return false;
        si

        void visit(Expression.IDENTIFIER identifier) is
            throwNotImplemented("identifier", identifier);
        si

        bool pre(Expression.Literal.NODE literal) is
            return false;
        si

        void visit(Expression.Literal.NODE literal) is
            throwNotImplemented("literal", literal);
        si                        

        bool pre(Expression.Literal.STRING string) is
            return false;
        si

        void visit(Expression.Literal.STRING string) is
            throwNotImplemented("string literal", string);
        si

        bool pre(Expression.Literal.CHARACTER character) is
            return false;
        si

        void visit(Expression.Literal.CHARACTER character) is
            throwNotImplemented("character literal", character);            
        si
                
        bool pre(Expression.VARIABLE variable) is
            return false;
        si

        void visit(Expression.VARIABLE variable) is
            throwNotImplemented("variable", variable);
        si

        bool pre(Expression.Literal.NONE none) is
            return false;
        si

        void visit(Expression.Literal.NONE none) is
            throwNotImplemented("none", none);
        si

        bool pre(Expression.NEW new_) is
            return false;
        si

        void visit(Expression.NEW new_) is
            throwNotImplemented("new", new_);
        si

        bool pre(Expression.CAST cast_) is
            return false;
        si

        void visit(Expression.CAST cast_) is
            throwNotImplemented("cast", cast_);
        si        

        bool pre(Syntax.Tree.Expression.FUNCTION function) is
            return false;
        si

        void visit(Syntax.Tree.Expression.FUNCTION function) is
            throwNotImplemented("function", function);
        si        

        bool pre(Expression.TUPLE tuple) is
            return false;
        si

        void visit(Expression.TUPLE tuple) is
            throwNotImplemented("tuple", tuple);
        si

        bool pre(Expression.SEQUENCE sequence) is
            return false;
        si

        void visit(Expression.SEQUENCE sequence) is
            throwNotImplemented("sequence", sequence);
        si                           

        bool pre(Expression.LIST list) is
            return false;
        si

        void visit(Expression.LIST list) is
            throwNotImplemented("list", list);
        si        

        bool pre(Expression.CALL call) is
            return false;
        si

        void visit(Expression.CALL call) is
            throwNotImplemented("call", call);
        si

        bool pre(Expression.MEMBER member) is
            return false;
        si

        void visit(Expression.MEMBER member) is
            throwNotImplemented("member", member);
        si

        bool pre(Expression.INDEX index) is
            return false;
        si

        void visit(Expression.INDEX index) is
            throwNotImplemented("index", index);
        si        

        bool pre(Expression.HAS_VALUE has_value) is
            return false;
        si

        void visit(Expression.HAS_VALUE has_value) is
            throwNotImplemented("has value", has_value);
        si

        bool pre(Expression.UNARY unary) is
            return false;
        si

        void visit(Expression.UNARY unary) is
            throwNotImplemented("unary", unary);
        si

        bool pre(Expression.BINARY binary) is
            return false;
        si

        void visit(Expression.BINARY binary) is
            throwNotImplemented("binary", binary);
        si

        // statements

        bool pre(Statement.NODE statement) is
            return false;
        si

        void visit(Statement.NODE statement) is
            throwNotImplemented("statement", statement);
        si

        bool pre(Statement.LIST statements) is
            return false;
        si

        void visit(Statement.LIST statements) is
            throwNotImplemented("statement list", statements);
        si

        bool pre(Statement.LET l) is
            return false;
        si

        void visit(Statement.LET l) is
            throwNotImplemented("let", l);
        si

        bool pre(Statement.VAR v) is
            return false;
        si

        void visit(Statement.VAR v) is
            throwNotImplemented("var", v);
        si
               
        bool pre(Statement.ASSIGNMENT assign) is
            return false;
        si

        void visit(Statement.ASSIGNMENT assign) is
            throwNotImplemented("assignment", assign);
        si
        
        bool pre(Statement.EXPRESSION expression) is
            return false;
        si

        void visit(Statement.EXPRESSION expression) is
            throwNotImplemented("expression", expression);
        si

        bool pre(Statement.RETURN return_) is
            return false;
        si

        void visit(Statement.RETURN return_) is
            throwNotImplemented("return", return_);
        si

        bool pre(Statement.IF if_) is
            return false;
        si

        void visit(Statement.IF if_) is
            throwNotImplemented("if", if_);
        si

        bool pre(Statement.CASE case_) is
            return false;
        si

        void visit(Statement.CASE case_) is
            throwNotImplemented("case", case_);
        si

        bool pre(Statement.CASE_MATCH case_match) is
            return false;
        si

        void visit(Statement.CASE_MATCH case_match) is
            throwNotImplemented("case match", case_match);
        si

        bool pre(Statement.TRY try_) is
            return false;
        si

        void visit(Statement.TRY try_) is
            throwNotImplemented("try", try_);
        si

        bool pre(Statement.CATCH catch_) is
            return false;
        si

        void visit(Statement.CATCH catch_) is
            throwNotImplemented("catch", catch_);
        si        

        bool pre(Statement.DO do_) is
            return false;
        si

        void visit(Statement.DO do_) is
            throwNotImplemented("do", do_);
        si

        bool pre(Statement.FOR for_) is
            return false;
        si

        void visit(Statement.FOR for_) is
            throwNotImplemented("for", for_);
        si

        bool pre(Statement.LABELLED labelled) is
            return false;
        si

        void visit(Statement.LABELLED labelled) is
            throwNotImplemented("labelled", labelled);
        si

        bool pre(Statement.BREAK break_) is
            return false;
        si

        void visit(Statement.BREAK break_) is
            throwNotImplemented("break", break_);
        si

        bool pre(Statement.CONTINUE continue_) is
            return false;
        si

        void visit(Statement.CONTINUE continue_) is
            throwNotImplemented("continue", continue_);
        si

        // function body

        bool pre(Body.NODE body) is
            return false;
        si

        void visit(Body.NODE body) is
            throwNotImplemented("body", body);
        si

        bool pre(Body.EXPRESSION expression) is
            return false;
        si

        void visit(Body.EXPRESSION expression) is
            throwNotImplemented("expression body", expression);
        si

        bool pre(Body.BLOCK block) is
            return false;
        si

        void visit(Body.BLOCK block) is
            throwNotImplemented("block body", block);
        si
    si
si

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

        // definitions

        void visit(Definition.NODE definition) is
            throwNotImplemented("definition", definition);
        si

        void visit(Definition.LIST definitions) is
            throwNotImplemented("definition list", definitions);
        si

        void visit(Definition.CLASS class_) is
            throwNotImplemented("class", class_);
        si

        void visit(Definition.INTERFACE interface_) is
            throwNotImplemented("interface", interface_);
        si        

        void visit(Definition.FUNCTION function) is
            throwNotImplemented("function", function);
        si

        void visit(Definition.PROPERTY property) is
            throwNotImplemented("property", property);
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

        void visit(Expression.LITERAL literal) is
            throwNotImplemented("literal", literal);
        si                        

        void visit(Expression.LIST_LITERAL list) is
            throwNotImplemented("list literal", list);
        si                                
                
        void visit(Expression.VARIABLE variable) is
            throwNotImplemented("variable", variable);
        si

        void visit(Expression.NONE none) is
            throwNotImplemented("none", none);
        si

        void visit(Syntax.Tree.Expression.FUNCTION function) is
            throwNotImplemented("function", function);
        si        

        void visit(Expression.TUPLE tuple) is
            throwNotImplemented("tuple", tuple);
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

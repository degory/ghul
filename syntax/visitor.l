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
            throwNotImplemented("node", node);
        si

        // identifiers

        void visit(IDENTIFIER identifier) is
            throwNotImplemented("identifier", identifier);
        si

        void visit(QUALIFIED_IDENTIFIER identifier) is
            throwNotImplemented("qualified identifier", identifier);
        si

        // definitions

        void visit(DEFINITION definition) is
            throwNotImplemented("definition", definition);
        si

        void visit(Definition.VARIABLE variable) is
            throwNotImplemented("variable", variable);
        si

        void visit(Definition.VARIABLE_LIST variables) is
            throwNotImplemented("variable list", variables);
        si

        void visit(Definition.LET l) is
            throwNotImplemented("let", l);
        si

        void visit(Definition.VAR v) is
            throwNotImplemented("var", v);
        si

        void visit(Definition.DEFINITION_LIST definitions) is
            throwNotImplemented("definition list", definitions);
        si

        // types

        void visit(TYPE type) is
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

        void visit(Type.TYPE_LIST types) is
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

        void visit(EXPRESSION expression) is
            throwNotImplemented("expression", expression);
        si

        void visit(Expression.IDENTIFIER identifier) is
            throwNotImplemented("identifier", identifier);
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

        void visit(Expression.EXPRESSION_LIST expressions) is
            throwNotImplemented("expression list", expressions);
        si        
    si
si

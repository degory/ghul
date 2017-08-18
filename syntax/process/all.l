namespace Syntax is
    use System;
    use Generic;

    use Tree;

    class All isa Visitor is
        void init() is
            super.init();

            IO.Std.err.println("new all-visitor...");

            _log = new Map<NODE, String>(65521);
        si

        Map<NODE, String> _log;

        private void log(String name, NODE node) is
            IO.Std.err.println("log...");
            _log[node] = "visitor % visit % %" % Object{this, name, Object.dump(node)};
        si

        get String result is
            return _log.toString();
        si

        // node
        void visit(NODE node) is
            log("node", node);
        si

        // identifiers

        void visit(Identifier.NODE identifier) is
            log("identifier", identifier);
        si

        void visit(Identifier.QUALIFIED identifier) is
            log("qualified identifier", identifier);
        si

        // modifiers

        void visit(Modifier.NODE modifier) is
            log("modifier", modifier);
        si

        void visit(Modifier.LIST modifiers) is
            log("modifiers", modifiers);
        si        

        // definitions

        void visit(Definition.NODE definition) is
            log("definition", definition);
        si

        void visit(Definition.LIST definitions) is
            log("definition list", definitions);
        si

        void visit(Definition.IMPORT import_) is
            log("import", import_);
        si        
        
        void visit(Definition.NAMESPACE namespace_) is
            log("namespace", namespace_);
        si        

        void visit(Definition.USE use_) is
            log("use", use_);
        si

        void visit(Definition.CLASS class_) is
            log("class", class_);
        si

        void visit(Definition.INTERFACE interface_) is
            log("interface", interface_);
        si        

        void visit(Definition.ENUM enum_) is
            log("enum", enum_);
        si

        void visit(Definition.ENUM_MEMBER enum_member) is
            log("enum member", enum_member);
        si        

        void visit(Definition.FUNCTION function) is
            log("function", function);
        si

        void visit(Definition.PROPERTY property) is
            log("property", property);
        si

        void visit(Definition.INDEXER indexer) is
            log("indexer", indexer);
        si        

        // variables
        
        void visit(Variable.NODE variable) is
            log("variable", variable);
        si

        void visit(Variable.LIST variables) is
            log("variable list", variables);
        si

        // types

        void visit(Type.NODE type) is
            log("type", type);
        si

        void visit(Type.BUILT_IN built_in) is
            log("built id", built_in);
        si        

        void visit(Type.STRUCTURED structured) is
            log("structured", structured);
        si

        void visit(Type.ARRAY array) is
            log("array", array);
        si

        void visit(Type.POINTER pointer) is
            log("pointer", pointer);
        si

        void visit(Type.REFERENCE reference) is
            log("reference", reference);            
        si

        void visit(Type.NAMED named) is
            log("named", named);
        si

        void visit(Type.LIST types) is
            log("type list", types);
        si

        void visit(Type.GENERIC generic) is
            log("generic", generic);
        si

        void visit(Type.FUNCTION function) is
            log("function", function);
        si
        
        void visit(Type.TUPLE tuple) is
            log("tuple", tuple);
        si

        void visit(Type.NAMED_TUPLE_ELEMENT element) is
            log("name tuple element", element);
        si

        // expressions

        void visit(Expression.NODE expression) is
            log("expression", expression);
        si

        void visit(Expression.IDENTIFIER identifier) is
            log("identifier", identifier);
        si

        void visit(Expression.Literal.NODE literal) is
            log("literal", literal);
        si                        

        void visit(Expression.Literal.STRING string) is
            log("string literal", string);
        si

        void visit(Expression.Literal.CHARACTER character) is
            log("character literal", character);            
        si
                
        void visit(Expression.VARIABLE variable) is
            log("variable", variable);
        si

        void visit(Expression.Literal.NONE none) is
            log("none", none);
        si

        void visit(Expression.NEW new_) is
            log("new", new_);
        si

        void visit(Expression.CAST cast_) is
            log("cast", cast_);
        si        

        void visit(Syntax.Tree.Expression.FUNCTION function) is
            log("function", function);
        si        

        void visit(Expression.TUPLE tuple) is
            log("tuple", tuple);
        si

        void visit(Expression.SEQUENCE sequence) is
            log("sequence", sequence);
        si                           

        void visit(Expression.LIST list) is
            log("list", list);
        si        

        void visit(Expression.CALL call) is
            log("call", call);
        si

        void visit(Expression.MEMBER member) is
            log("member", member);
        si

        void visit(Expression.INDEX index) is
            log("index", index);
        si        

        void visit(Expression.HAS_VALUE has_value) is
            log("has value", has_value);
        si

        void visit(Expression.UNARY unary) is
            log("unary", unary);
        si

        void visit(Expression.BINARY binary) is
            log("binary", binary);
        si

        // statements

        void visit(Statement.NODE statement) is
            log("statement", statement);
        si

        void visit(Statement.LIST statements) is
            log("statement list", statements);
        si

        void visit(Statement.LET l) is
            log("let", l);
        si

        void visit(Statement.VAR v) is
            log("var", v);
        si
               
        void visit(Statement.ASSIGNMENT assign) is
            log("assignment", assign);
        si
        
        void visit(Statement.EXPRESSION expression) is
            log("expression", expression);
        si

        void visit(Statement.RETURN return_) is
            log("return", return_);
        si

        void visit(Statement.IF if_) is
            log("if", if_);
        si

        void visit(Statement.CASE case_) is
            log("case", case_);
        si

        void visit(Statement.CASE_MATCH case_match) is
            log("case match", case_match);
        si

        void visit(Statement.TRY try_) is
            log("try", try_);
        si

        void visit(Statement.CATCH catch_) is
            log("catch", catch_);
        si        

        void visit(Statement.DO do_) is
            log("do", do_);
        si

        void visit(Statement.FOR for_) is
            log("for", for_);
        si

        void visit(Statement.LABELLED labelled) is
            log("labelled", labelled);
        si

        void visit(Statement.BREAK break_) is
            log("break", break_);
        si

        void visit(Statement.CONTINUE continue_) is
            log("continue", continue_);
        si

        // function body

        void visit(Body.NODE body) is
            log("body", body);
        si

        void visit(Body.EXPRESSION expression) is
            log("expression body", expression);
        si

        void visit(Body.BLOCK block) is
            log("block body", block);
        si
    si
si

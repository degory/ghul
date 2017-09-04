namespace Syntax is
    use System;

    use Tree;

    class Visitor is
        void init() is
            super.init();
        si

        private void throwNotImplemented(String name, NODE node) is
            throw new NotImplementedException(
                "Visitor % does not define a visit method for % % and/or this node does not accept this visitor" %
                    Object{this, name, node.ClassName});
        si

        // node

        bool pre(NODE node) is
            return false;
        si

        void visit(NODE node) is
        si

        void post(NODE node) is
        si

        // identifiers

        bool pre(Identifier.NODE identifier) is
            return false;
        si

        void visit(Identifier.NODE identifier) is
        si

        void post(Identifier.NODE identifier) is
        si

        bool pre(Identifier.QUALIFIED identifier) is
            return false;
        si

        void visit(Identifier.QUALIFIED identifier) is
        si

        // modifiers

        bool pre(Modifier.NODE modifier) is
            return false;
        si

        void visit(Modifier.NODE modifier) is
        si

        bool pre(Modifier.LIST modifiers) is
            return false;
        si

        void visit(Modifier.LIST modifiers) is
        si        

        // definitions

        bool pre(Definition.NODE definition) is
            return false;
        si

        void visit(Definition.NODE definition) is
        si

        bool pre(Definition.LIST definitions) is
            return false;
        si

        void visit(Definition.LIST definitions) is
        si

        bool pre(Definition.IMPORT import_) is
            return false;
        si

        void visit(Definition.IMPORT import_) is
        si        
        
        bool pre(Definition.NAMESPACE namespace_) is
            return false;
        si

        void visit(Definition.NAMESPACE namespace_) is
        si        

        bool pre(Definition.USE use_) is
            return false;
        si

        void visit(Definition.USE use_) is
        si

        bool pre(Definition.CLASS class_) is
            return false;
        si

        void visit(Definition.CLASS class_) is
        si

        bool pre(Definition.INTERFACE interface_) is
            return false;
        si

        void visit(Definition.INTERFACE interface_) is
        si        

        bool pre(Definition.ENUM enum_) is
            return false;
        si

        void visit(Definition.ENUM enum_) is
        si

        bool pre(Definition.ENUM_MEMBER enum_member) is
            return false;
        si

        void visit(Definition.ENUM_MEMBER enum_member) is
        si        

        bool pre(Definition.FUNCTION function) is
            return false;
        si

        void visit(Definition.FUNCTION function) is
        si

        bool pre(Definition.FUNCTION_GROUP functions) is
            return false;
        si

        void visit(Definition.FUNCTION_GROUP functions) is
        si        

        bool pre(Definition.PROPERTY property) is
            return false;
        si

        void visit(Definition.PROPERTY property) is
        si

        bool pre(Definition.INDEXER indexer) is
            return false;
        si

        void visit(Definition.INDEXER indexer) is
        si        

        // variables
        
        bool pre(Variable.NODE variable) is
            return false;
        si

        void visit(Variable.NODE variable) is
        si

        bool pre(Variable.LIST variables) is
            return false;
        si

        void visit(Variable.LIST variables) is
        si

        // types

        bool pre(Type.NODE type) is
            return false;
        si

        void visit(Type.NODE type) is
        si

        bool pre(Type.INFER infer) is
            return false;
        si

        void visit(Type.INFER type) is
        si        

        bool pre(Type.BUILT_IN built_in) is
            return false;
        si

        void visit(Type.BUILT_IN built_in) is
        si        

        bool pre(Type.STRUCTURED structured) is
            return false;
        si

        void visit(Type.STRUCTURED structured) is
        si

        bool pre(Type.ARRAY array) is
            return false;
        si

        void visit(Type.ARRAY array) is
        si

        bool pre(Type.POINTER pointer) is
            return false;
        si

        void visit(Type.POINTER pointer) is
        si

        bool pre(Type.REFERENCE reference) is
            return false;
        si

        void visit(Type.REFERENCE reference) is
        si

        bool pre(Type.NAMED named) is
            return false;
        si

        void visit(Type.NAMED named) is
        si

        bool pre(Type.LIST types) is
            return false;
        si

        void visit(Type.LIST types) is
        si

        bool pre(Type.GENERIC generic) is
            return false;
        si

        void visit(Type.GENERIC generic) is
        si

        bool pre(Type.FUNCTION function) is
            return false;
        si

        void visit(Type.FUNCTION function) is
        si

        bool pre(Type.FUNCTION_GROUP functions) is
            return false;
        si

        void visit(Type.FUNCTION_GROUP functions) is
        si
                
        bool pre(Type.TUPLE tuple) is
            return false;
        si

        void visit(Type.TUPLE tuple) is
        si

        bool pre(Type.NAMED_TUPLE_ELEMENT element) is
            return false;
        si

        void visit(Type.NAMED_TUPLE_ELEMENT element) is
        si

        // expressions

        bool pre(Expression.NODE expression) is
            return false;
        si

        void visit(Expression.NODE expression) is
        si

        bool pre(Expression.IDENTIFIER identifier) is
            return false;
        si

        void visit(Expression.IDENTIFIER identifier) is
        si

        bool pre(Expression.Literal.NODE literal) is
            return false;
        si

        void visit(Expression.Literal.NODE literal) is
        si                        

        bool pre(Expression.Literal.STRING string) is
            return false;
        si

        void visit(Expression.Literal.STRING string) is
        si

        bool pre(Expression.Literal.CHARACTER character) is
            return false;
        si

        void visit(Expression.Literal.CHARACTER character) is
        si
                
        bool pre(Expression.VARIABLE variable) is
            return false;
        si

        void visit(Expression.VARIABLE variable) is
        si

        bool pre(Expression.Literal.NONE none) is
            return false;
        si

        void visit(Expression.Literal.NONE none) is
        si

        bool pre(Expression.NULL null_) is
            return false;
        si        

        void visit(Expression.NULL null_) is
        si                

        bool pre(Expression.SELF self) is
            return false;
        si        

        void visit(Expression.SELF self) is
        si        

        bool pre(Expression.SUPER super_) is
            return false;
        si        

        void visit(Expression.SUPER super_) is
        si        

        bool pre(Expression.NEW new_) is
            return false;
        si

        void visit(Expression.NEW new_) is
        si

        bool pre(Expression.CAST cast_) is
            return false;
        si

        void visit(Expression.CAST cast_) is
        si        

        bool pre(Syntax.Tree.Expression.FUNCTION function) is
            return false;
        si

        void visit(Syntax.Tree.Expression.FUNCTION function) is
        si        

        bool pre(Expression.TUPLE tuple) is
            return false;
        si

        void visit(Expression.TUPLE tuple) is
        si

        bool pre(Expression.SEQUENCE sequence) is
            return false;
        si

        void visit(Expression.SEQUENCE sequence) is
        si                           

        bool pre(Expression.LIST list) is
            return false;
        si

        void visit(Expression.LIST list) is
        si        

        bool pre(Expression.CALL call) is
            return false;
        si

        void visit(Expression.CALL call) is
        si

        bool pre(Expression.MEMBER member) is
            return false;
        si

        void visit(Expression.MEMBER member) is
        si

        bool pre(Expression.INDEX index) is
            return false;
        si

        void visit(Expression.INDEX index) is
        si        

        bool pre(Expression.HAS_VALUE has_value) is
            return false;
        si

        void visit(Expression.HAS_VALUE has_value) is
        si

        bool pre(Expression.UNARY unary) is
            return false;
        si

        void visit(Expression.UNARY unary) is
        si

        bool pre(Expression.BINARY binary) is
            return false;
        si

        void visit(Expression.BINARY binary) is
        si

        // statements

        bool pre(Statement.NODE statement) is
            return false;
        si

        void visit(Statement.NODE statement) is
        si

        bool pre(Statement.LIST statements) is
            return false;
        si

        void visit(Statement.LIST statements) is
        si

        bool pre(Statement.LET l) is
            return false;
        si

        void visit(Statement.LET l) is
        si

        bool pre(Statement.VAR v) is
            return false;
        si

        void visit(Statement.VAR v) is
        si
               
        bool pre(Statement.ASSIGNMENT assign) is
            return false;
        si

        void visit(Statement.ASSIGNMENT assign) is
        si
        
        bool pre(Statement.EXPRESSION expression) is
            return false;
        si

        void visit(Statement.EXPRESSION expression) is
        si

        bool pre(Statement.RETURN return_) is
            return false;
        si

        void visit(Statement.RETURN return_) is
        si

        bool pre(Statement.THROW throw_) is
            return false;
        si

        void visit(Statement.THROW throw_) is
        si

        bool pre(Statement.IF if_) is
            return false;
        si

        void visit(Statement.IF if_) is
        si

        bool pre(Statement.CASE case_) is
            return false;
        si

        void visit(Statement.CASE case_) is
        si

        bool pre(Statement.CASE_MATCH case_match) is
            return false;
        si

        void visit(Statement.CASE_MATCH case_match) is
        si

        bool pre(Statement.TRY try_) is
            return false;
        si

        void visit(Statement.TRY try_) is
        si

        bool pre(Statement.CATCH catch_) is
            return false;
        si

        void visit(Statement.CATCH catch_) is
        si        

        bool pre(Statement.DO do_) is
            return false;
        si

        void visit(Statement.DO do_) is
        si

        bool pre(Statement.FOR for_) is
            return false;
        si

        void visit(Statement.FOR for_) is
        si

        bool pre(Statement.LABELLED labelled) is
            return false;
        si

        void visit(Statement.LABELLED labelled) is
        si

        bool pre(Statement.BREAK break_) is
            return false;
        si

        void visit(Statement.BREAK break_) is
        si

        bool pre(Statement.CONTINUE continue_) is
            return false;
        si

        void visit(Statement.CONTINUE continue_) is
        si

        // function body

        bool pre(Body.NODE body) is
            return false;
        si

        void visit(Body.NODE body) is
        si

        bool pre(Body.EXPRESSION expression) is
            return false;
        si

        void visit(Body.EXPRESSION expression) is
        si

        bool pre(Body.BLOCK block) is
            return false;
        si

        void visit(Body.BLOCK block) is
        si
    si
si

namespace Syntax is
    use System;
    use Generic;

    use Tree;

    class REWRITER isa Visitor is
        Dict<NODE,NODE> _map;
        
        void init(Dict<NODE,NODE> map) is
            super.init();

            this._map = map;
        si

        void apply(NODE node) is
            node.walk(this);
        si

        // node

        bool pre(NODE node) is
            return false;
        si

        void visit(NODE node) is
        si

        // identifiers

        bool pre(Identifier.NODE identifier) is
            identifier.rewrite(_map);
            return false;
        si

        void visit(Identifier.NODE identifier) is

        si

        bool pre(Identifier.QUALIFIED identifier) is
            identifier.rewrite(_map);
            return false;
        si

        void visit(Identifier.QUALIFIED identifier) is
        si

        // modifiers

        bool pre(Modifier.NODE modifier) is
            modifier.rewrite(_map);
            return false;
        si

        void visit(Modifier.NODE modifier) is
        si

        bool pre(Modifier.LIST modifiers) is
            modifiers.rewrite(_map);
            return false;
        si

        void visit(Modifier.LIST modifiers) is
        si        

        // definitions

        bool pre(Definition.NODE definition) is
            definition.rewrite(_map);
            return false;
        si

        void visit(Definition.NODE definition) is
        si

        bool pre(Definition.LIST definitions) is
            definitions.rewrite(_map);
            return false;
        si

        void visit(Definition.LIST definitions) is
        si

        bool pre(Definition.IMPORT import_) is
            import_.rewrite(_map);
            return false;
        si

        void visit(Definition.IMPORT import_) is
        si        
        
        bool pre(Definition.NAMESPACE namespace_) is
            namespace_.rewrite(_map);
            return false;
        si

        void visit(Definition.NAMESPACE namespace_) is
        si        

        bool pre(Definition.USE use_) is
            use_.rewrite(_map);
            return false;
        si

        void visit(Definition.USE use_) is
        si

        bool pre(Definition.CLASS class_) is
            class_.rewrite(_map);
            return false;
        si

        void visit(Definition.CLASS class_) is
        si

        bool pre(Definition.INTERFACE interface_) is
            interface_.rewrite(_map);
            return false;
        si

        void visit(Definition.INTERFACE interface_) is
        si        

        bool pre(Definition.ENUM enum_) is
            enum_.rewrite(_map);
            return false;
        si

        void visit(Definition.ENUM enum_) is
        si

        bool pre(Definition.ENUM_MEMBER enum_member) is
            enum_member.rewrite(_map);
            return false;
        si

        void visit(Definition.ENUM_MEMBER enum_member) is
        si        

        bool pre(Definition.FUNCTION function) is
            function.rewrite(_map);
            return false;
        si

        void visit(Definition.FUNCTION function) is
        si

        bool pre(Definition.FUNCTION_GROUP functions) is
            functions.rewrite(_map);
            return false;
        si

        void visit(Definition.FUNCTION_GROUP functions) is
        si
        
        bool pre(Definition.PROPERTY property) is
            property.rewrite(_map);
            return false;
        si

        void visit(Definition.PROPERTY property) is
        si

        bool pre(Definition.INDEXER indexer) is
            indexer.rewrite(_map);
            return false;
        si

        void visit(Definition.INDEXER indexer) is
        si        

        // variables
        
        bool pre(Variable.NODE variable) is
            variable.rewrite(_map);
            return false;
        si

        void visit(Variable.NODE variable) is
        si

        bool pre(Variable.LIST variables) is
            variables.rewrite(_map);
            return false;
        si

        void visit(Variable.LIST variables) is
        si

        // types

        bool pre(Type.NODE type) is
            type.rewrite(_map);
            return false;
        si

        void visit(Type.NODE type) is
        si

        bool pre(Type.INFER infer) is
            infer.rewrite(_map);
            return false;
        si

        void visit(Type.INFER type) is
        si        

        bool pre(Type.BUILT_IN built_in) is
            built_in.rewrite(_map);
            return false;
        si

        void visit(Type.BUILT_IN built_in) is
        si        

        bool pre(Type.STRUCTURED structured) is
            structured.rewrite(_map);
            return false;
        si

        void visit(Type.STRUCTURED structured) is
        si

        bool pre(Type.ARRAY array) is
            array.rewrite(_map);
            return false;
        si

        void visit(Type.ARRAY array) is
        si

        bool pre(Type.POINTER pointer) is
            pointer.rewrite(_map);
            return false;
        si

        void visit(Type.POINTER pointer) is
        si

        bool pre(Type.REFERENCE reference) is
            reference.rewrite(_map);
            return false;
        si

        void visit(Type.REFERENCE reference) is
        si

        bool pre(Type.NAMED named) is
            named.rewrite(_map);
            return false;
        si

        void visit(Type.NAMED named) is
        si

        bool pre(Type.LIST types) is
            types.rewrite(_map);
            return false;
        si

        void visit(Type.LIST types) is
        si

        bool pre(Type.GENERIC generic) is
            generic.rewrite(_map);
            return false;
        si

        void visit(Type.GENERIC generic) is
        si

        bool pre(Type.FUNCTION function) is
            function.rewrite(_map);
            return false;
        si

        void visit(Type.FUNCTION function) is
        si

        bool pre(Type.FUNCTION_GROUP functions) is
            functions.rewrite(_map);
            return false;
        si

        void visit(Type.FUNCTION_GROUP functions) is
        si
                
        bool pre(Type.TUPLE tuple) is
            tuple.rewrite(_map);
            return false;
        si

        void visit(Type.TUPLE tuple) is
        si

        bool pre(Type.NAMED_TUPLE_ELEMENT element) is
            element.rewrite(_map);
            return false;
        si

        void visit(Type.NAMED_TUPLE_ELEMENT element) is
        si

        // expressions

        bool pre(Expression.NODE expression) is
            expression.rewrite(_map);
            return false;
        si

        void visit(Expression.NODE expression) is
        si

        bool pre(Expression.IDENTIFIER identifier) is
            identifier.rewrite(_map);
            return false;
        si

        void visit(Expression.IDENTIFIER identifier) is
        si

        bool pre(Expression.Literal.NODE literal) is
            literal.rewrite(_map);
            return false;
        si

        void visit(Expression.Literal.NODE literal) is
        si                        

        bool pre(Expression.Literal.STRING string) is
            string.rewrite(_map);
            return false;
        si

        void visit(Expression.Literal.STRING string) is
        si

        bool pre(Expression.Literal.CHARACTER character) is
            character.rewrite(_map);
            return false;
        si

        void visit(Expression.Literal.CHARACTER character) is
        si
                
        bool pre(Expression.VARIABLE variable) is
            variable.rewrite(_map);
            return false;
        si

        void visit(Expression.VARIABLE variable) is
        si

        bool pre(Expression.Literal.NONE none) is
            none.rewrite(_map);
            return false;
        si

        void visit(Expression.Literal.NONE none) is
        si

        /*
        bool pre(Expression.SELF self) is
            self.rewrite(_map);
            return false;
        si

        void visit(Expression.SELF self) is
        si

        bool pre(Expression.SUPER super_) is
            super_.rewrite(_map);
            return false;
        si

        void visit(Expression.SUPER super_) is
        si
        */        

        bool pre(Expression.NEW new_) is
            new_.rewrite(_map);
            return false;
        si

        void visit(Expression.NEW new_) is
        si

        bool pre(Expression.CAST cast_) is
            cast_.rewrite(_map);
            return false;
        si

        void visit(Expression.CAST cast_) is
        si        

        bool pre(Expression.ISA isa_) is
            isa_.rewrite(_map);
            return false;
        si

        void visit(Expression.ISA isa_) is
        si        

        bool pre(Syntax.Tree.Expression.FUNCTION function) is
            function.rewrite(_map);
            return false;
        si

        void visit(Syntax.Tree.Expression.FUNCTION function) is
        si        

        bool pre(Expression.TUPLE tuple) is
            tuple.rewrite(_map);
            return false;
        si

        void visit(Expression.TUPLE tuple) is
        si

        bool pre(Expression.SEQUENCE sequence) is
            sequence.rewrite(_map);
            return false;
        si

        void visit(Expression.SEQUENCE sequence) is
        si                           

        bool pre(Expression.LIST list) is
            list.rewrite(_map);
            return false;
        si

        void visit(Expression.LIST list) is
        si        

        bool pre(Expression.CALL call) is
            call.rewrite(_map);
            return false;
        si

        void visit(Expression.CALL call) is
        si

        bool pre(Expression.MEMBER member) is
            member.rewrite(_map);
            return false;
        si

        void visit(Expression.MEMBER member) is
        si

        bool pre(Expression.INDEX index) is
            index.rewrite(_map);
            return false;
        si

        void visit(Expression.INDEX index) is
        si        

        bool pre(Expression.HAS_VALUE has_value) is
            has_value.rewrite(_map);
            return false;
        si

        void visit(Expression.HAS_VALUE has_value) is
        si

        bool pre(Expression.UNARY unary) is
            unary.rewrite(_map);
            return false;
        si

        void visit(Expression.UNARY unary) is
        si

        bool pre(Expression.BINARY binary) is
            binary.rewrite(_map);
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

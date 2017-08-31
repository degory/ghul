namespace Syntax is namespace Process is
    use System;
    use Generic;

    use Source;
    use Tree;

    class DECLARE_SYMBOLS isa ScopeVisitorBase is
        void init(
            SCOPES scopes,
            NAMESPACES namespaces)
        is
            super.init(scopes, namespaces);
        si

        public void apply(NODE node) is
            node.walk(this);
        si

        // modifiers

        /*
        void visit(Modifier.NODE modifier) is
            log("modifier", modifier);
        si

        void visit(Modifier.LIST modifiers) is
            log("modifiers", modifiers);
        si
        */        

        // definitions

        bool pre(Definition.NAMESPACE namespace_) is
            if !is_global_context then
                _logger.error(function.location, "cannot declare namespace here");
            fi

            enter_uses(namespace_);

            push_namespace(namespace_.name);
        si        

        void visit(Definition.NAMESPACE namespace_) is
            pop_namespace(namespace_.name);

            pop_uses(namespace_);
        si   

        bool pre(Definition.USE use_) is
            // push_use(use_);
        si

        void visit(Definition.USE use_) is
            // pop_use(use_);
        si

        bool pre(Definition.CLASS class_) is
            push_scope(
                class_,
                current_scope.declare_class(class_.location, class_.name.name)
            );
        si

        void visit(Definition.CLASS class_) is
            pop_scope(class_);
        si

        bool pre(Definition.INTERFACE interface_) is
            push_scope(
                interface_, 
                current_scope.declare_trait(interface_.location, interface_.name.name)
            );
        si        

        void visit(Definition.INTERFACE interface_) is
            pop_scope(interface_);
        si

        bool pre(Definition.ENUM enum_) is
            push_scope(
                enum_,
                current_scope.declare_enum(enum_.location, enum_.name.name)
            );
        si

        void visit(Definition.ENUM enum_) is
            pop_scope(enum_);
        si

        bool pre(Definition.ENUM_MEMBER enum_member) is
            current_scope.declare_enum_member(
                enum_.location,
                new Symbol.ENUM_MEMBER(enum_member.name)
            );
        si

        bool pre(Definition.FUNCTION function) is
            push_scope(
                function,
                current_scope.declare_function(
                    function.location,
                    function.name.name
                )
            );
        si

        void visit(Definition.FUNCTION function) is
            pop_scope(function);
        si

        bool pre(Definition.PROPERTY property) is
            push_scope(
                property,
                current_scope.declare_property(
                    property.location,
                    property.nane.name
                )            
            );
        si

        void visit(Definition.PROPERTY property) is
            pop_scope(property);
        si

        bool pre(Definition.INDEXER indexer) is
            String name;

            if indexer.name != null then
                name = indexer.name;
            else
                name = "[]";
            fi

            push_scope(
                indexer,
                current_scope.declare_indexer(
                    indexer.location,
                    name
                )
            );
        si        

        void visit(Definition.INDEXER indexer) is
            pop_scope(indexer);
        si        

        // variables
        
        void visit(Variable.NODE variable) is
            current_scope.declare_variable(variable.location, variable.name.name);
        si

        // expressions
                
        void visit(Expression.VARIABLE variable) is
            // ???
        si

        void visit(Syntax.Tree.Expression.FUNCTION function) is
            // ???
        si        

        // statements

        bool pre (Statement.IF if_) is
            push_scope(if_);
        si

        void visit(Statement.IF if_) is
            pop_scope(if_);
        si

        bool pre(Statement.CASE case_) is
            push_scope(case_);
        si

        void visit(Statement.CASE case_) is
            pop_scope(case_);
        si

        bool pre(Statement.CASE_MATCH case_match) is
            push_scope(case_match);
        si

        void visit(Statement.CASE_MATCH case_match) is
            pop_scope(case_match);
        si

        bool pre(Statement.TRY try_) is
            push_scope(try_);
        si

        void visit(Statement.TRY try_) is
            pop_scope(try_);
        si

        bool pre(Statement.CATCH catch_) is
            push_scope(catch_);
        si

        void visit(Statement.CATCH catch_) is
            pop_scope(catch_);
        si        

        bool pre(Statement.DO do_) is
            push_scope(do_);
        si

        void visit(Statement.DO do_) is
            pop_scope(do_);
        si

        bool pre(Statement.FOR for_) is
            push_scope(for_);
        si

        void visit(Statement.FOR for_) is
            pop_scope(for_);
        si

        bool pre(Statement.LABELLED labelled) is
            // note: the label for a labelled statement does not point at a named scope:
            current_scope.declare_label(labelled.location, labelled.label.name);
        si
        
        void visit(Statement.LABELLED labelled) is
        si

        // function body

        bool pre(Body.NODE body) is
            push_scope(body);
        si

        void visit(Body.NODE body) is
            pop_scope(body);
        si

        bool pre(Body.EXPRESSION expression) is
            push_scope(expression);
        si

        void visit(Body.EXPRESSION expression) is
            pop_scope(expression);
        si

        bool pre(Body.BLOCK block) is
            push_scope(block);
        si

        void visit(Body.BLOCK block) is
            pop_scope(block);
        si
    si
si si

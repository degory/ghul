namespace Syntax is namespace Process is
    use System;
    use Generic;

    use Logging;
    use Source;
    use Tree;

    class DECLARE_SYMBOLS isa ScopeVisitorBase is
        void init(
            LOGGER logger,
            SYMBOL_TABLE symbol_table,
            NAMESPACES namespaces)
        is
            super.init(logger, symbol_table, namespaces);
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
            declare_and_enter_namespace(namespace_.name);
        si        

        void visit(Definition.NAMESPACE namespace_) is
            leave_namespace(namespace_.name);
        si   

        bool pre(Definition.USE use_) is
            // push_use(use_);
        si

        void visit(Definition.USE use_) is
            // pop_use(use_);
        si

        bool pre(Definition.CLASS class_) is
            associate_and_enter_scope(
                class_,
                current_declaration_context.declare_class(class_.location, class_.name.name)
            );
        si

        void visit(Definition.CLASS class_) is
            // dump_symbol_table(class_);

            leave_scope(class_);
        si

        bool pre(Definition.INTERFACE interface_) is
            associate_and_enter_scope(
                interface_, 
                current_declaration_context.declare_trait(interface_.location, interface_.name.name)
            );
        si        

        void visit(Definition.INTERFACE interface_) is
            // dump_symbol_table(interface_);

            leave_scope(interface_);
        si

        bool pre(Definition.ENUM enum_) is
            associate_and_enter_scope(
                enum_,
                current_declaration_context.declare_enum(enum_.location, enum_.name.name)
            );
        si

        void visit(Definition.ENUM enum_) is
            leave_scope(enum_);
        si

        bool pre(Definition.ENUM_MEMBER enum_member) is
            current_declaration_context.declare_enum_member(
                enum_member.location,
                enum_member.name.name
            );
        si

        bool pre(Definition.FUNCTION function) is
            associate_and_enter_scope(
                function,
                current_declaration_context.declare_function(
                    function.location,
                    function.name.name
                )
            );
        si

        void visit(Definition.FUNCTION function) is
            leave_scope(function);
        si

/*
        bool pre(Definition.PROPERTY property) is
            associate_and_enter_scope(
                property,
                current_scope.declare_property(
                    property.location,
                    property.nane.name
                )            
            );
        si

        void visit(Definition.PROPERTY property) is
            leave_scope(property);
        si

        bool pre(Definition.INDEXER indexer) is
            String name;

            if indexer.name != null then
                name = indexer.name;
            else
                name = "[]";
            fi

            associate_and_enter_scope(
                indexer,
                current_scope.declare_indexer(
                    indexer.location,
                    name
                )
            );
        si        

        void visit(Definition.INDEXER indexer) is
            leave_scope(indexer);
        si        
*/
        // variables
        
        void visit(Variable.NODE variable) is
            current_declaration_context.declare_variable(variable.location, variable.name.name);
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
            create_and_enter_block_scope(if_);
        si

        void visit(Statement.IF if_) is
            leave_scope(if_);
        si

        bool pre(Statement.CASE case_) is
            create_and_enter_block_scope(case_);
        si

        void visit(Statement.CASE case_) is
            leave_scope(case_);
        si

        bool pre(Statement.CASE_MATCH case_match) is
            create_and_enter_block_scope(case_match);
        si

        void visit(Statement.CASE_MATCH case_match) is
            leave_scope(case_match);
        si

        bool pre(Statement.TRY try_) is
            create_and_enter_block_scope(try_);
        si

        void visit(Statement.TRY try_) is
            leave_scope(try_);
        si

        bool pre(Statement.CATCH catch_) is
            create_and_enter_block_scope(catch_);
        si

        void visit(Statement.CATCH catch_) is
            leave_scope(catch_);
        si        

        bool pre(Statement.DO do_) is
            create_and_enter_block_scope(do_);
        si

        void visit(Statement.DO do_) is
            leave_scope(do_);
        si

        bool pre(Statement.FOR for_) is
            create_and_enter_block_scope(for_);
        si

        void visit(Statement.FOR for_) is
            leave_scope(for_);
        si

        bool pre(Statement.LABELLED labelled) is
            // note: the label for a labelled statement does not point at a named scope:
            current_declaration_context.declare_label(labelled.location, labelled.label.name);
        si
        
        void visit(Statement.LABELLED labelled) is
        si

        // function body

        bool pre(Body.NODE body) is
            create_and_enter_block_scope(body);
        si

        void visit(Body.NODE body) is
            leave_scope(body);
        si

        bool pre(Body.EXPRESSION expression) is
            create_and_enter_block_scope(expression);
        si

        void visit(Body.EXPRESSION expression) is
            leave_scope(expression);
        si

        bool pre(Body.BLOCK block) is
            create_and_enter_block_scope(block);
        si

        void visit(Body.BLOCK block) is
            leave_scope(block);
        si
    si
si si

namespace Syntax is namespace Process is
    use System;
    use Generic;

    use Tree;

    class ScopedVisitor isa ScopeVisitorBase is
        void init(
            SYMBOL_TABLE symbol_table,
            NAMESPACES namespaces)
        is
            super.init(
                symbol_table,
                namespaces
            );
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

        bool pre(Definition.NAMESPACE namespace_) is
            enter_uses(namespace_);

            enter_namespace(namespace_.name);
        si        

        void visit(Definition.NAMESPACE namespace_) is
            leave_namespace(namespace_.name);

            leave_uses(namespace_);
        si   
        
        /*
        void visit(Definition.USE use_) is
            // TODO: insert into current scope:
        si
        */

        bool pre(Definition.CLASS class_) is
            enter_scope(class_);
        si

        void visit(Definition.CLASS class_) is
            leave_scope(class_);
        si

        bool pre(Definition.INTERFACE interface_) is
            enter_scope(interface_);
        si

        void visit(Definition.INTERFACE interface_) is
            leave_scope(interface_);
        si        

        bool pre(Definition.ENUM enum_) is
            enter_scope(enum_);
        si

        void visit(Definition.ENUM enum_) is
            leave_scope(enum_);
        si

        bool pre(Definition.FUNCTION function) is
            enter_scope(function);
        si

        void visit(Definition.FUNCTION function) is
            leave_scope(function);
        si

        bool pre(Definition.PROPERTY property) is
            enter_scope(property);
        si

        void visit(Definition.PROPERTY property) is
            leave_scope(property);
        si

        bool pre(Definition.INDEXER indexer) is
            enter_scope(indexer);
        si        

        void visit(Definition.INDEXER indexer) is
            leave_scope(indexer);
        si        

        // statements

        bool pre (Statement.IF if_) is
            enter_scope(if_);
        si

        void visit(Statement.IF if_) is
            leave_scope(if_);
        si

        bool pre(Statement.CASE case_) is
            enter_scope(case_);
        si

        void visit(Statement.CASE case_) is
            leave_scope(case_);
        si

        bool pre(Statement.CASE_MATCH case_match) is
            enter_scope(case_match);
        si

        void visit(Statement.CASE_MATCH case_match) is
            leave_scope(case_match);
        si

        bool pre(Statement.TRY try_) is
            enter_scope(try_);
        si

        void visit(Statement.TRY try_) is
            leave_scope(try_);
        si

        bool pre(Statement.CATCH catch_) is
            enter_scope(catch_);
        si

        void visit(Statement.CATCH catch_) is
            leave_scope(catch_);
        si        

        bool pre(Statement.DO do_) is
            enter_scope(do_);
        si

        void visit(Statement.DO do_) is
            leave_scope(do_);
        si

        bool pre(Statement.FOR for_) is
            enter_scope(for_);
        si

        void visit(Statement.FOR for_) is
            leave_scope(for_);
        si

        bool pre(Statement.LABELLED labelled) is
            enter_scope(labelled);
        si
        
        void visit(Statement.LABELLED labelled) is
            leave_scope(labelled);
        si

        // function body

        bool pre(Body.NODE body) is
            enter_scope(body);
        si

        void visit(Body.NODE body) is
            leave_scope(body);
        si

        bool pre(Body.EXPRESSION expression) is
            enter_scope(expression);
        si

        void visit(Body.EXPRESSION expression) is
            leave_scope(expression);
        si

        bool pre(Body.BLOCK block) is
            enter_scope(block);
        si

        void visit(Body.BLOCK block) is
            leave_scope(block);
        si
    si
si si

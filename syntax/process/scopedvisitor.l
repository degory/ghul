namespace Syntax is namespace Process is
    use System;
    use Generic;

    use Tree;

    class ScopedVisitor isa ScopeVisitorBase is
        void init(SCOPES scopes) is
            super.init(scopes);
        si

        private void log(String name, NODE node) is
            IO.Std.err.println("what to do with this?: % % %" % Object{this, name, Object.dump(node)});
        si

        // node
        void visit(NODE node) is
            log("node", node);
        si

        // modifiers

        void visit(Modifier.NODE modifier) is
            log("modifier", modifier);
        si

        void visit(Modifier.LIST modifiers) is
            log("modifiers", modifiers);
        si        

        // definitions        
        bool pre(Definition.NAMESPACE namespace_) is
            enter(namespace_);
        si        

        void visit(Definition.NAMESPACE namespace_) is
            pop(namespace_);
        si        

        void visit(Definition.USE use_) is
            // TODO: insert into current scope:
        si

        bool pre(Definition.CLASS class_) is
            enter(class_);
        si

        void visit(Definition.CLASS class_) is
            pop(class_);
        si

        bool pre(Definition.INTERFACE interface_) is
            enter(interface_);
        si

        void visit(Definition.INTERFACE interface_) is
            pop(interface_);
        si        

        bool pre(Definition.ENUM enum_) is
            IO.Std.err.println("SV: pre-enum, before enter: " + Object.dump(enum_));
            enter(enum_);
            IO.Std.err.println("SV: pre-enum, after enter: " + Object.dump(enum_));
        si

        void visit(Definition.ENUM enum_) is
            IO.Std.err.println("SV: visit-enum, before pop: " + Object.dump(enum_));
            pop(enum_);
            IO.Std.err.println("SV: visit-enum, after pop: " + Object.dump(enum_));
        si

        bool pre(Definition.FUNCTION function) is
            enter(function);
        si

        void visit(Definition.FUNCTION function) is
            pop(function);
        si

        bool pre(Definition.PROPERTY property) is
            enter(property);
        si

        void visit(Definition.PROPERTY property) is
            pop(property);
        si

        bool pre(Definition.INDEXER indexer) is
            enter(indexer);
        si        

        void visit(Definition.INDEXER indexer) is
            pop(indexer);
        si        

        // statements

        bool pre (Statement.IF if_) is
            enter(if_);
        si

        void visit(Statement.IF if_) is
            pop(if_);
        si

        bool pre(Statement.CASE case_) is
            enter(case_);
        si

        void visit(Statement.CASE case_) is
            pop(case_);
        si

        bool pre(Statement.CASE_MATCH case_match) is
            enter(case_match);
        si

        void visit(Statement.CASE_MATCH case_match) is
            pop(case_match);
        si

        bool pre(Statement.TRY try_) is
            enter(try_);
        si

        void visit(Statement.TRY try_) is
            pop(try_);
        si

        bool pre(Statement.CATCH catch_) is
            enter(catch_);
        si

        void visit(Statement.CATCH catch_) is
            pop(catch_);
        si        

        bool pre(Statement.DO do_) is
            enter(do_);
        si

        void visit(Statement.DO do_) is
            pop(do_);
        si

        bool pre(Statement.FOR for_) is
            enter(for_);
        si

        void visit(Statement.FOR for_) is
            pop(for_);
        si

        bool pre(Statement.LABELLED labelled) is
            enter(labelled);
        si
        
        void visit(Statement.LABELLED labelled) is
            pop(labelled);
        si

        // function body

        bool pre(Body.NODE body) is
            enter(body);
        si

        void visit(Body.NODE body) is
            pop(body);
        si

        bool pre(Body.EXPRESSION expression) is
            enter(expression);
        si

        void visit(Body.EXPRESSION expression) is
            pop(expression);
        si

        bool pre(Body.BLOCK block) is
            enter(block);
        si

        void visit(Body.BLOCK block) is
            pop(block);
        si
    si
si si

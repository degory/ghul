namespace Syntax is namespace Process is
    use System;
    use Generic;

    use Source;
    use Tree;

    class DECLARE_SYMBOLS isa ScopeVisitorBase is
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

        NODE get_or_create_aggregate_namespace(Identifier.NODE identifier, List<NODE> results) is
            if identifier == null then
               return null;
            fi

            var parent = get_or_create_aggregate_namespace(identifier.parent, results);

            IO.Std.err.println("create aggregate ns:" + identifier);
            IO.Std.err.println("parent aggregate is:" + parent);

            var aggregate_namespace = this[identifier];

            if aggregate_namespace != null then
                IO.Std.err.println("existing aggregate is:" + aggregate_namespace);

                return aggregate_namespace;
            fi

            aggregate_namespace =
                new Definition.NAMESPACE(
                    LOCATION.dummy,
                    identifier,
                    new Definition.LIST(
                        LOCATION.dummy,
                        new Definition.NODE[0]
                    )
                );

            IO.Std.err.println("created aggregate ns:" + aggregate_namespace);

            SCOPE parent_scope;

            if parent != null then            
                parent_scope = this[parent];

                IO.Std.err.println("parent scope is: " + parent_scope);

                assert(parent_scope != null, "expected namespace " + parent + " to have an associated scope");
            fi

            IO.Std.err.println("adding " + aggregate_namespace + " with parent scope " + parent_scope);

            add(aggregate_namespace, parent_scope);
             
            results.add(aggregate_namespace);

            return aggregate_namespace;
        si

        void declare_namespaces(Identifier.NODE identifier, Iterator<NODE> namespaces) is
            var parent = identifier.parent;

            if parent != null then
                declare_namespaces(parent, namespaces);
            fi

            assert(namespaces.hasMoreElements());

            var namespace_ = namespaces.nextElement();

            IO.Std.err.println("declare aggregate namespace: " + identifier.name + " as " + namespace_);
            declare(identifier.name, namespace_);
        si

        bool pre(Definition.NAMESPACE namespace_) is
            IO.Std.err.println("pre namespace: " + namespace_);

            var aggregate_namespaces = new Vector<NODE>();

            get_or_create_aggregate_namespace(
                namespace_.name,
                aggregate_namespaces
            );

            push(namespace_);

            declare_namespaces(
                namespace_.name,
                aggregate_namespaces.Iterator
            );

            IO.Std.err.println("entering namespace, scope is: " + top);
            
            // push(namespace_.name.name, aggregate_namespace);
        si        

        void visit(Definition.NAMESPACE namespace_) is
            pop(namespace_);
        si   

        void visit(Definition.USE use_) is
            // TODO: insert into current scope:
        si

        bool pre(Definition.CLASS class_) is
            push(class_.name.name, class_);
        si

        void visit(Definition.CLASS class_) is
            pop(class_);
        si

        bool pre(Definition.INTERFACE interface_) is
            push(interface_.name.name, interface_);
        si        

        void visit(Definition.INTERFACE interface_) is
            pop(interface_);
        si        

        bool pre(Definition.ENUM enum_) is
            push(enum_.name.name, enum_);
        si

        void visit(Definition.ENUM enum_) is
            pop(enum_);
        si

        bool pre(Definition.ENUM_MEMBER enum_member) is
            declare(enum_member.name.name, enum_member);
        si

        bool pre(Definition.FUNCTION function) is
            push(function.name.name, function);
        si

        void visit(Definition.FUNCTION function) is
            pop(function);
        si

        bool pre(Definition.PROPERTY property) is
            push(property.name.name, property);
        si

        void visit(Definition.PROPERTY property) is
            pop(property);
        si

        bool pre(Definition.INDEXER indexer) is
            if indexer.name != null then
                push(indexer.name.name, indexer);
            else
                push(indexer);
            fi
        si        

        void visit(Definition.INDEXER indexer) is
            pop(indexer);
        si        

        // variables
        
        void visit(Variable.NODE variable) is
            declare(variable.name.name, variable);
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
            push(if_);
        si

        void visit(Statement.IF if_) is
            pop(if_);
        si

        bool pre(Statement.CASE case_) is
            push(case_);
        si

        void visit(Statement.CASE case_) is
            pop(case_);
        si

        bool pre(Statement.CASE_MATCH case_match) is
            push(case_match);
        si

        void visit(Statement.CASE_MATCH case_match) is
            pop(case_match);
        si

        bool pre(Statement.TRY try_) is
            push(try_);
        si

        void visit(Statement.TRY try_) is
            pop(try_);
        si

        bool pre(Statement.CATCH catch_) is
            push(catch_);
        si

        void visit(Statement.CATCH catch_) is
            pop(catch_);
        si        

        bool pre(Statement.DO do_) is
            push(do_);
        si

        void visit(Statement.DO do_) is
            pop(do_);
        si

        bool pre(Statement.FOR for_) is
            push(for_);
        si

        void visit(Statement.FOR for_) is
            pop(for_);
        si

        bool pre(Statement.LABELLED labelled) is
            push(labelled.label.name, labelled);
        si
        
        void visit(Statement.LABELLED labelled) is
            pop(labelled);
        si

        // function body

        bool pre(Body.NODE body) is
            push(body);
        si

        void visit(Body.NODE body) is
            pop(body);
        si

        bool pre(Body.EXPRESSION expression) is
            push(expression);
        si

        void visit(Body.EXPRESSION expression) is
            pop(expression);
        si

        bool pre(Body.BLOCK block) is
            push(block);
        si

        void visit(Body.BLOCK block) is
            pop(block);
        si
    si
si si

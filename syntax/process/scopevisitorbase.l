namespace Syntax is
    use System;
    use Generic;

    use Source;
    use Tree;



    class ScopeVisitorBase isa Visitor is
        SCOPES _scopes;
        NAMESPACES _namespaces;
        
        get Scope current_scope is
            return _scopes.top;
        si

/*
        get NODE[String name] is
            return _scopes[name];
        si

        get NODE[Identifier.NODE identifier] is
            return find_definition(identifier);
        si
*/
        void init(
            SCOPES scopes,
            NAMESPACES namespaces)
        is
            super.init();

            _scopes = scopes;
            _namespaces = namespaces;

            _contexts = new Vector<CONTEXT>();
            push(CONTEXT.GLOBAL);
        si

        Scope scope_for(NODE node) is
            return _scopes[node];
        si

        NODE find_definition(Identifier.NODE identifier) is
            var parent = identifier.parent;
            
            if parent != null then
                IO.Std.err.println("find defintion for " + identifier.name + " in parent " + parent + "...");
                var parent_node = find_definition(parent);

                if parent_node == null then
                    IO.Std.err.println("scope not found: " + parent);
                    return null;
                fi

                var parent_scope = this[parent_node];

                if parent_scope == null then
                   IO.Std.err.println("not a searchable scope: " + parent_node);
                   return null;
                fi

                IO.Std.err.println("find defintion for " + identifier.name + " in parent scope " + parent_scope + "...");
                   
                return parent_scope[identifier.name];
            else
                return this[identifier.name];
            fi
        si

        void enter_uses(Definition.NAMESPACE namespace_) is
            foreach var u; namespace_.body.uses do
                foreach var i; u do
                    var n = find_definition(i);

                    if n != null then
                        // IO.Std.err.println("" + i + " resolves to " + n + ": should use this namespace");
                        enter(n);
                    else
                        IO.Std.err.println("used namespace not found: " + i);
                    fi
                od
            od
        si

        void pop_uses(Definition.NAMESPACE namespace_) is
            foreach var u; namespace_.body.uses.ReverseIterator do
                foreach var i; u.ReverseIterator do
                    var n = find_definition(i);

                    if n != null then
                        IO.Std.err.println("" + i + " resolves to " + n + ": should un-use this namespace");                        
                        pop(n);
                    fi
                od
            od
        si
        
        void add(NODE node, SCOPE parent) is
            _scopes.add(node, parent);
        si

        void push_scope(Scope scope) is
            _scopes.push(scope);
        si

        void push(Symbol.BASE symbol, NODE node) is
            _scopes.push(symbol, node);
        si
        
        void enter(NODE node) is
            _scopes.enter(node);
        si

        void push_namespace(Identifier.NODE identifier) is
            _namespaces.push(identifier);
        si

        void enter_namespace(Identifier.NODE identifier) is
            _namespaces.enter(identifier);
        si

        void pop_namespace(Identifier.NODE identifier) is
            _namespaces.pop(identifier);
        si        

        void declare(Symbol.BASE symbol, NODE node) is
            _scopes.declare(symbol, node);
        si

        void push(CONTEXT context) is
            _contexts.add(context);
        si

        void pop(CONTEXT context) is
            assert(_contexts.Top == context);

            _contexts.pop();
        si

        SCOPE pop(NODE node) is
            return _scopes.pop(node);
        si
    si
si

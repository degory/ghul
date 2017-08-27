namespace Syntax is
    use System;
    use Generic;

    use Source;
    use Tree;

    class ScopeVisitorBase isa Visitor is
        SCOPES _scopes;
        NAMESPACES _namespaces;
        
        get SCOPE top is
            return _scopes.top;
        si

        get SCOPE[NODE node] is
            return _scopes[node];
        si

        get NODE[String name] is
            return _scopes[name];
        si

        get NODE[Identifier.NODE identifier] is
            return find_definition(identifier);
        si

        void init(
            SCOPES scopes,
            NAMESPACES namespaces)
        is
            super.init();

            _scopes = scopes;
            _namespaces = namespaces;
        si

        NODE find_definition(Identifier.NODE identifier) is
            var parent = identifier.parent;
            
            if parent != null then
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
                   
                return parent_scope[identifier.name];
            else
                return this[identifier.name];
            fi
        si

        void enter_uses(Definition.NAMESPACE namespace_) is
            IO.Std.err.println("enter uses ...");
            
            foreach var u; namespace_.body.uses do
                IO.Std.err.println("enter use: " + u);
                foreach var i; u do
                    enter_namespace(i);
                od
            od
        si

        void pop_uses(Definition.NAMESPACE namespace_) is
            IO.Std.err.println("exit uses ...");
            foreach var u; namespace_.body.uses.ReverseIterator do
                IO.Std.err.println("exit use: " + u);
                foreach var i; u.ReverseIterator do
                    pop_namespace(i);
                od
            od
        si
        
        void add(NODE node, SCOPE parent) is
            _scopes.add(node, parent);
        si

        void push(NODE node) is
            _scopes.push(node);
        si

        void push(LOCATION location, String name, NODE node) is
            _scopes.push(location, name, node);
        si

        void push(Identifier.NODE identifier, NODE node) is
            _scopes.push(identifier, node);
        si
        
        void enter(NODE node) is
            _scopes.enter(node);
        si

        void push_namespace(LOCATION location, String name) is
            _namespaces.push(location, name);
        si

        void push_namespace(Identifier.NODE identifier) is
            _namespaces.push(identifier);
        si

        void enter_namespace(LOCATION location, String name) is
            _namespaces.enter(location, name);
        si

        void enter_namespace(Identifier.NODE identifier) is
            _namespaces.enter(identifier);
        si

        void pop_namespace(LOCATION location, String name) is
            _namespaces.pop(location, name);
        si

        void pop_namespace(Identifier.NODE identifier) is
            _namespaces.pop(identifier);
        si        

        void declare(LOCATION location, String name, NODE node) is
            _scopes.declare(location, name, node);
        si        

        void declare(Identifier.NODE identifier, NODE node) is
            _scopes.declare(identifier, node);
        si

        SCOPE pop(NODE node) is
            return _scopes.pop(node);
        si
    si
si

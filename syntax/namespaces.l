namespace Syntax is
    use System;
    use Generic;

    use Source;
    use Tree;

    class NAMESPACES is
        SCOPES _scopes;

        Map<String, NODE> _namespaces;
        Vector<String> _prefixes;

        String get_qualified_name(String name) is
            return _prefixes.Top + '.' + name;
        si

        void init(SCOPES scopes) is
            _scopes = scopes;
            _namespaces = new Map<String, NODE>(65521);
            _prefixes = new Vector<String>();
            _prefixes.add(""); // global scope
        si

        void push(String name) is
            var qualified_name = get_qualified_name(name);

            var node = find_or_add_namespace(qualified_name);

            var existing = _scopes.top[name];

            if existing == null then
                _scopes.push(name, node);                
            else
                assert(existing == node, "Already defined as something other than a namespace: " + name);
                _scopes.enter(node);
            fi
            
            _prefixes.add(qualified_name);
        si

        void enter(String name) is
            var qualified_name = get_qualified_name(name);

            var node = find_namespace(qualified_name);

            assert(node != null, "No pre-existing aggregate namespace found for: " + name);

            _scopes.enter(node);

            _prefixes.add(qualified_name);
        si

        void pop(String name) is
            var node = find_namespace(_prefixes.Top);

            assert(node != null, "could not find aggregate namespace " + _prefixes.Top);

            _prefixes.pop();
            _scopes.pop(node);
        si

        NODE find_or_add_namespace(String qualified_name) is
            var result = _namespaces[qualified_name];

            if result == null then
                // create a new dummy namespace node to
                // represent the aggregation of all namespaces
                // that share the same fully qualified name.
                // This node will be bound to a singe common
                // scope

                result = 
                    new Definition.NAMESPACE(
                        LOCATION.dummy,
                        new Identifier.NODE(
                            LOCATION.dummy,
                            qualified_name
                        ),
                        new Definition.LIST(
                            LOCATION.dummy,
                            new Definition.NODE[0]
                        )
                    );

                _namespaces[qualified_name] = result;
            fi

            return result;
        si        

        NODE find_namespace(String qualified_name) is
            var result = _namespaces[qualified_name];
            assert(result != null, "expected aggregate namespace " + qualified_name + " to already exist");
            return result;
        si
    si
si
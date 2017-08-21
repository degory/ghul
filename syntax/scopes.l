namespace Syntax is
    use System;
    use Generic;

    use Logging;
    use Source;
    use Tree;

    class SCOPES is
        LOGGER _logger;
        Map<NODE, SCOPE> _scopes;

        Vector<SCOPE> _stack;

        get SCOPE top is
            return _stack.Top;
        si

        get SCOPE[NODE node] is
            return _scopes[node];
        si

        get NODE[String name] is 
            return top[name];
        si

        void init(LOGGER logger) is
            _logger = logger;
            _stack = new Vector<SCOPE>(50);
            _scopes = new Map<NODE, SCOPE>(65521);

            _stack.add(new SCOPE(_logger));
        si

        bool is_defined_in_current_scope(String name) is
            return top[name] != null;
        si

        SCOPE add(NODE node, SCOPE parent) is
            var scope = new SCOPE(_logger, parent);

            _scopes[node] = scope;

            return scope;
        si

        void enter(NODE node) is
            var scope = _scopes[node];
            
            assert(scope != null, "enter: expected to find an existing scope for " + node);

            _stack.add(scope);
        si

        void push(NODE node) is
            assert(_scopes[node] == null, "replacing existing scope for " + node + " " + _scopes[node]);

            var scope = add(node, top);

            _stack.add(scope);
        si

        void push(LOCATION location, String name, NODE node) is
            declare(location, name, node);

            push(node);
        si

        void push(Identifier.NODE identifier, NODE node) is
            declare(identifier, node);

            push(node);
        si

        void declare(LOCATION location, String name, NODE node) is
            top.declare(location, name, node);
        si

        void declare(Identifier.NODE identifier, NODE node) is
            top.declare(identifier, node);
        si
        
        SCOPE pop(NODE node) is
            var expected = _scopes[node];

            var result = _stack.pop();
            
            assert(result == expected, "pop: expecting " + expected + " vs stack top " + result);

            return result;
        si
    si
si

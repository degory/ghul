namespace Syntax is
    use System;
    use Generic;

    use Tree;

    class SCOPES is
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

        void init() is
            super.init();
            _stack = new Vector<SCOPE>(50);
            _scopes = new Map<NODE, SCOPE>(65521);

            _stack.add(new SCOPE(null));
        si

        SCOPE add(NODE node, SCOPE parent) is
            var scope = new SCOPE(parent);

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

        void push(String name, NODE node) is
            declare(name, node);

            push(node);
        si

        void declare(String name, NODE node) is
            top.declare(name, node);
        si

        SCOPE pop(NODE node) is
            var expected = _scopes[node];

            var result = _stack.pop();
            
            assert(result == expected, "pop: expecting " + expected + " vs stack top " + result);

            return result;
        si
    si
si

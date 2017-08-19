namespace Syntax is
    use System;
    use Generic;

    use Tree;

    class SCOPES is
        Map<NODE, SCOPE> _scopes;

        Vector<SCOPE> _stack;

        get SCOPE top is
            IO.Std.err.println("scopes top: " + _stack);
            IO.Std.err.println("scopes top returning: " + _stack.Top);            
            return _stack.Top;
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

        void enter(NODE node) is
            var scope = _scopes[node];

            assert(scope != null);

            _stack.add(scope);
        si

        void push(NODE node) is
            assert(_scopes[node] == null);

            var scope = new SCOPE(top);
        
            _scopes[node] = scope;

            _stack.add(scope);
        si

        void push(String name, NODE node) is
            IO.Std.err.println("scopes push: " + name + "," + node);
            declare(name, node);

            push(node);
        si

        void declare(String name, NODE node) is
            IO.Std.err.println("scopes declare: " + name + "," + node);            
            top.declare(name, node);
        si

        SCOPE pop(NODE node) is
            var expected = _scopes[node];

            var result = _stack.pop();

            assert(result == expected);

            return result;
        si
    si
si
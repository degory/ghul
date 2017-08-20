namespace Syntax is
    use System;
    use Generic;

    use Tree;

    class ScopeVisitorBase isa Visitor is
        SCOPES _scopes;
        
        get SCOPE top is
            return _scopes.top;
        si

        get SCOPE[NODE node] is
            return _scopes[node];
        si

        get NODE[String name] is
            return _scopes[name];
        si

        void init(SCOPES scopes) is
            super.init();

            _scopes = scopes;
        si

        void push(NODE node) is
            IO.Std.err.println("" + Object.dump(this) + " push: " + Object.dump(node));
            _scopes.push(node);
        si

        void push(String name, NODE node) is
            IO.Std.err.println("" + Object.dump(this) + " push: " + name + ", " + Object.dump(node));
            _scopes.push(name, node);
        si

        void enter(NODE node) is
             IO.Std.err.println("" + Object.dump(this) + " enter: " + Object.dump(node));
            _scopes.enter(node);
        si

        void declare(String name, NODE node) is
            IO.Std.err.println("declare:" + name + " as " + Object.dump(node));
            _scopes.declare(name, node);
        si

        SCOPE pop(NODE node) is
            IO.Std.err.println("" + Object.dump(this) + " pop: " + Object.dump(node));
            return _scopes.pop(node);
        si
    si
si

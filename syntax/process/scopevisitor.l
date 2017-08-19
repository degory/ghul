namespace Syntax is
    use System;
    use Generic;

    use Tree;

    class ScopeVisitor isa Visitor is
        SCOPES _scopes;
        
        get SCOPE top is
            return _scopes.top;
        si

        void init(SCOPES scopes) is
            super.init();

            _scopes = scopes;
        si

        void push(NODE node) is
            _scopes.push(node);
        si

        void push(String name, NODE node) is
            _scopes.push(name, node);
        si

        void declare(String name, NODE node) is
            _scopes.declare(name, node);
        si

        SCOPE pop(NODE node) is
            return _scopes.pop(node);
        si
    si
si

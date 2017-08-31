namespace Syntax is
    use System;
    use Generic;

    use Logging;
    use Source;
    use Tree;

    class SYMBOL_TABLE is
        LOGGER _logger;

        Map<NODE, Scope> _scopes;
        Vector<Scope> _stack;

        get Scope current_scope is
            if _stack.Length > 0 then
                return _stack.Top;
            else
                return null;
            fi
        si

        void init(LOGGER logger) is
            _logger = logger;
            _stack = new Vector<Scope>(50);
            _scopes = new Map<NODE, Scope>(65521);

            enter_scope(
                new Symbol.NAMESPACE(LOCATION.dummy, "", null, ".")
            );
        si

        Scope scope_for(NODE node) is
            return _scopes[node];
        si

        void associate_node_with_scope(NODE node, Scope scope) is
            _scopes[node] = scope;
        si

        void enter_scope(Tree.NODE node) is
            var scope = _scopes[node];

            if scope == null then
                _logger.fatal(node.location, "no scope found for " + node);                              
            fi

            enter_scope(scope);
        si

        void enter_scope(Scope scope) is
            _stack.add(scope);
        si        

        void leave_scope(Tree.NODE node) is
            var scope = _scopes[node];

            if scope == null then
                _logger.fatal(node.location, "no scope found for " + node);                
            fi

            leave_scope(scope);
        si

        void leave_scope(Scope scope) is
            assert(current_scope == scope, "scope stack corrupt");

            _stack.pop();
        si
    si
si

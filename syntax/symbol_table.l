namespace Syntax is
    class SYMBOL_TABLE is
        LOGGER _logger;

        Map<NODE, Scope> _scopes;
        Vector<Scope> _stack;

        get Scope current_scope is
            return _stack.Top;
        si

        void init(LOGGER logger) is
            _logger = logger;
            _stack = new Vector<Scope>(50);
            _scopes = new Map<NODE, Scope>(65521);

            _stack.add(new GLOBAL_SCOPE(_logger));
        si
        
        void push_scope(Tree.NODE node, Scope scope) is
            _scopes[node] = scope;
            push_scope(scope);
        si

        void push_scope(Scope scope) is
            _stack.add(scope);
        si

        void enter_scope(Tree.NODE node) is
            var scope = _scopes[node];

            if scope == null then
                _logger.fatal(node.location, "no scope found for " + node);                
            fi

            push_scope(scope);
        si

        void pop_scope(Tree.NODE node) is
            var scope = _scopes[node];

            if scope == null then
                _logger.fatal(node.location, "no scope found for " + node);                
            fi

            pop_scope(scope);
        si

        void pop_scope(Scope scope) is
            assert(current_scope == scope, "scope stack corrupt");
        si
    si
si

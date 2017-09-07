namespace Syntax is namespace Process is
    use System;
    use Generic;

    use Logging;
    use Source;
    use Tree;

    class RESOLVE_USES isa ScopeVisitorBase is
        LOGGER _logger;
        SYMBOL_TABLE _symbol_table;

        void init(
            LOGGER logger,
            SYMBOL_TABLE symbol_table,
            NAMESPACES namespaces)
        is
            super.init(logger, symbol_table, namespaces);
            this._logger = logger;
            this._symbol_table = symbol_table;
        si

        public void apply(NODE node) is
            node.walk(this);
        si

        // definitions

        bool pre(Definition.NAMESPACE namespace_) is            
            enter_namespace(namespace_.name);

            foreach var u; namespace_.body.uses do
                _logger._trace("use", "existing use scope for " + u + ": " + scope_for(u));

                var use_scope = cast USE_SCOPE(scope_for(u));
        
                foreach var i; u do
                    _logger._trace("use", "used identifier is " + i);

                    var used_symbol = find_enclosing(i);

                    if used_symbol == null then
                        _logger._trace("use", "used identifier " + i + " is not defined in " + _symbol_table);

                        _logger.error(i.location, "used identifier " + i + " is not defined ");                        
                    elif isa Symbol.NAMESPACE(used_symbol) then
                        use_scope.add_scope(cast Symbol.NAMESPACE(used_symbol));
                        _logger._trace("use", "used namespace for " + i + " is: " + used_symbol);
                    else
                        _logger._trace("use", "used symbol for " + i + " is: " + used_symbol);
                        use_scope.add_symbol(used_symbol);
                    fi                    
                od

                enter_scope(use_scope);
            od            
        si        

        void visit(Definition.NAMESPACE namespace_) is
            leave_uses(namespace_);

            leave_namespace(namespace_.name);
        si   
    si
si si

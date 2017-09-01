namespace Syntax is namespace Process is
    use System;
    use Generic;

    use Logging;
    use Source;
    use Tree;

    class RESOLVE_USES isa ScopeVisitorBase is
        LOGGER _logger;

        void init(
            LOGGER logger,
            SYMBOL_TABLE symbol_table,
            NAMESPACES namespaces)
        is
            super.init(logger, symbol_table, namespaces);
            this._logger = logger;
        si

        public void apply(NODE node) is
            node.walk(this);
        si

        // definitions

        bool pre(Definition.NAMESPACE namespace_) is
            enter_namespace(namespace_.name);
        si        

        void visit(Definition.NAMESPACE namespace_) is
            leave_namespace(namespace_.name);
        si   

        bool pre(Definition.USE use_) is
            var use_scope = new USE_SCOPE();

            _logger._trace("use", "new use scope is: " + use_scope);
    
            foreach var i; use_ do
                var used_symbol = find_enclosing(i);

                if used_symbol == null then
                    IO.Std.err.println("used symbol is not defined: " + used_symbol);
                elif isa Symbol.NAMESPACE(used_symbol) then
                    use_scope.add_scope(cast Symbol.NAMESPACE(used_symbol));
                    _logger._trace("use", "used namespace is: " + used_symbol);
                else
                    use_scope.add_symbol(used_symbol);
                fi
            od

            associate_and_enter_scope(use_, use_scope);            
        si

        void visit(Definition.USE use_) is
            // pop_use(use_);
        si

    si
si si

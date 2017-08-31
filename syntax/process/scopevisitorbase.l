namespace Syntax is
    use System;
    use Generic;

    use Source;
    use Tree;

    class ScopeVisitorBase isa Visitor is
        SYMBOL_TABLE _symbol_table;
        NAMESPACES _namespaces;
        
        get Scope current_scope is
            return _symbol_table.current_scope;
        si

        void init(
            SYMBOL_TABLE symbol_table,
            NAMESPACES namespaces)
        is
            super.init();

            _symbol_table = symbol_table;
            _namespaces = namespaces;
        si

        Scope scope_for(NODE node) is
            return _symbol_table.scope_for(node);
        si

        Symbol find_symbol(Identifier.NODE identifier) is
            return current_scope.find_enclosing(identifier.name);
        si

        void enter_uses(Definition.NAMESPACE namespace_) is
            foreach var u; namespace_.body.uses do
                foreach var i; u do
                    var n = find_definition(i);

                    if n != null then
                        // IO.Std.err.println("" + i + " resolves to " + n + ": should use this namespace");
                        enter(n);
                    else
                        IO.Std.err.println("used namespace not found: " + i);
                    fi
                od
            od
        si

        void pop_uses(Definition.NAMESPACE namespace_) is
            foreach var u; namespace_.body.uses.ReverseIterator do
                foreach var i; u.ReverseIterator do
                    var n = find_definition(i);

                    if n != null then
                        IO.Std.err.println("" + i + " resolves to " + n + ": should un-use this namespace");                        
                        pop(n);
                    fi
                od
            od
        si
        
        void add(NODE node, SCOPE parent) is
            _symbol_table.add(node, parent);
        si

        void push_scope(Scope scope) is
            _symbol_table.push(scope);
        si

        void push(Symbol.BASE symbol, NODE node) is
            _symbol_table.push(symbol, node);
        si
        
        void enter(NODE node) is
            _symbol_table.enter(node);
        si

        void push_namespace(Identifier.NODE identifier) is
            _namespaces.push(identifier);
        si

        void enter_namespace(Identifier.NODE identifier) is
            _namespaces.enter(identifier);
        si

        void pop_namespace(Identifier.NODE identifier) is
            _namespaces.pop(identifier);
        si        

        void declare(Symbol.BASE symbol, NODE node) is
            _symbol_table.declare(symbol, node);
        si

        void push(CONTEXT context) is
            _contexts.add(context);
        si

        void pop(CONTEXT context) is
            assert(_contexts.Top == context);

            _contexts.pop();
        si

        SCOPE pop(NODE node) is
            return _symbol_table.pop(node);
        si
    si
si

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

        Symbol.BASE find_member(Identifier.NODE identifier) is
            var parent = identifier.parent;

            if parent != null then
                var parent_symbol = find_member(parent);

                if parent_symbol != null then
                    return parent_symbol.find_member(identifier.name);
                else
                    return null;
                fi
            else
                return current_scope.find_member(identifier.name);
            fi
        si

        Symbol.BASE find_enclosing(Identifier.NODE identifier) is
            var parent = identifier.parent;

            if parent != null then
                var parent_symbol = find_enclosing(parent);

                if parent_symbol != null then
                    return parent_symbol.find_enclosing(identifier.name);
                else
                    return null;
                fi
            else
                return current_scope.find_enclosing(identifier.name);
            fi
        si

        void enter_uses(Definition.NAMESPACE namespace_) is
            foreach var u; namespace_.body.uses do
                foreach var i; u do
                    var n = find_enclosing(i);

                    if n != null then
                        if isa Symbol.NAMESPACE(n) then
                        // IO.Std.err.println("" + i + " resolves to " + n + ": should use this namespace");
                            enter_scope(cast Symbol.NAMESPACE(n));
                        else 
                            IO.Std.err.println("not a namespace: " + i);
                        fi
                    else
                        IO.Std.err.println("used namespace not found: " + i);
                    fi
                od
            od
        si

        void leave_uses(Definition.NAMESPACE namespace_) is
            foreach var u; namespace_.body.uses.ReverseIterator do
                foreach var i; u.ReverseIterator do
                    var n = find_enclosing(i);

                    if n != null then
                        if isa Symbol.NAMESPACE(n) then
                            // IO.Std.err.println("" + i + " resolves to " + n + ": should un-use this namespace");                        
                            leave_scope(cast Symbol.NAMESPACE(n));
                        else
                            IO.Std.err.println("not a namespace: " + i);
                        fi
                    fi
                od
            od
        si

        void create_and_enter_block_scope(NODE node) is
            var scope = new BLOCK_SCOPE();

            associate_and_enter_scope(node, scope);
        si

        void associate_and_enter_scope(NODE node, Symbol.BASE symbol) is
            associate_and_enter_scope(node, cast Scope(symbol));
        si

        void associate_and_enter_scope(NODE node, Scope scope) is        
            associate_node_with_scope(node, scope);
            enter_scope(scope);
        si

        void associate_node_with_scope(NODE node, Scope scope) is        
            _symbol_table.associate_node_with_scope(node, scope);
        si
        
        void enter_scope(NODE node) is
            _symbol_table.enter_scope(node);
        si

        void enter_scope(Scope scope) is
            _symbol_table.enter_scope(scope);
        si

        void leave_scope(NODE node) is
            _symbol_table.leave_scope(node);
        si

        void leave_scope(Scope scope) is
            _symbol_table.leave_scope(scope);
        si

/*
        void declare(Symbol.BASE symbol, NODE node) is
            _symbol_table.current_scope.declare(symbol, node);
        si
*/
        void declare_and_enter_namespace(Identifier.NODE identifier) is
            _namespaces.declare_and_enter_namespace(identifier.location, identifier.name);
        si

        void enter_namespace(Identifier.NODE identifier) is
            _namespaces.enter_namespace(identifier.location, identifier.name);
        si

        void leave_namespace(Identifier.NODE identifier) is
            _namespaces.leave_namespace(identifier.location, identifier.name);
        si        
    si
si

namespace Syntax is
    use System;
    use Generic;

    use Logging;
    use Source;
    use Tree;

    class ScopeVisitorBase isa Visitor is
        LOGGER _logger;
        SYMBOL_TABLE _symbol_table;
        NAMESPACES _namespaces;
        
        get Scope current_scope is
            return _symbol_table.current_scope;
        si

        get NamespaceContext current_namespace_context is
            return _symbol_table.current_namespace_context;
        si

        get DeclarationContext current_declaration_context is
            return _symbol_table.current_declaration_context;
        si

        void init(
            LOGGER logger,
            SYMBOL_TABLE symbol_table,
            NAMESPACES namespaces)
        is
            super.init();

            _logger = logger;
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
                var result = current_scope.find_member(identifier.name);

                if result == null then
                    IO.Std.err.println("indentifier " + identifier + " not found in scope " + current_scope);
                fi

                return result;
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
                var result = current_scope.find_enclosing(identifier.name);

                if result == null then
                    IO.Std.err.println("indentifier " + identifier + " not found in scope " + current_scope);
                fi

                return result;
            fi
        si

        void create_and_enter_block_scope(NODE node) is
            var scope = new BLOCK_SCOPE(current_scope);

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

        void dump_symbol_table(NODE node) is
            IO.Std.err.println("after " + Object.dump(node));
            IO.Std.err.println(_symbol_table);
        si
    si
si

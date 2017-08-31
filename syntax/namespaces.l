namespace Syntax is
    use System;
    use Generic;

    use Logging;
    use Source;
    use Tree;

    class NAMESPACES is
        LOGGER _logger;
        SYMBOL_TABLE _symbol_table;

        Map<String, Symbol.NAMESPACE> _namespaces;
        
        get String current_prefix is
            if _symbol_table.current_scope == null then
                return "";
            else
                var ns = _symbol_table.current_scope;

                assert(isa Symbol.NAMESPACE(ns), "expected current scope to be a namespace");

                return cast Symbol.NAMESPACE(ns).qualified_name;
            fi
        si

        String get_qualified_name(String name) is
            return current_prefix + '.' + name;
        si

        void init(LOGGER logger, SYMBOL_TABLE symbol_table) is
            _logger = logger;
            _symbol_table = symbol_table;
            _namespaces = new Map<String, Symbol.NAMESPACE>(65521);
        si

        void declare_and_enter_namespace(LOCATION location, String name) is
            var qualified_name = get_qualified_name(name);

            var ns = find_or_add_namespace(name, qualified_name);

            var existing = _symbol_table.current_scope.find_direct(name);

            if existing == null then
                _symbol_table.current_scope.add_namespace(location, name, ns);
            else
                if existing != ns then
                    _logger.error(location, "redefining symbol " + name + " as a namespace, originally defined at " + existing.location);
                    _logger.error(existing.location, "symbol " + name + " is redefined as namespace at " + location);
                fi
            fi

            _symbol_table.enter_scope(ns);              
        si

        void enter_namespace(LOCATION location, String name) is
            var qualified_name = get_qualified_name(name);

            var ns = find_namespace(qualified_name);

            assert(ns != null, "No pre-existing aggregate namespace found for: " + name);

            _symbol_table.enter_scope(ns);
        si

        void leave_namespace(LOCATION location, String name) is
            var ns = find_namespace(current_prefix);

            assert(ns != null, "could not find aggregate namespace " + name);

            _symbol_table.leave_scope(ns);
        si

        Symbol.NAMESPACE find_or_add_namespace(String name, String qualified_name) is
            var result = _namespaces[qualified_name];

            if result == null then
                result = new Symbol.NAMESPACE(LOCATION.dummy, name, _symbol_table.current_scope, qualified_name);

                _namespaces[qualified_name] = result;
            fi

            return result;
        si        

        Symbol.NAMESPACE find_namespace(String qualified_name) is
            var result = _namespaces[qualified_name];
            assert(result != null, "expected aggregate namespace " + qualified_name + " to already exist");
            return result;
        si
    si
si
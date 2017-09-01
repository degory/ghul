namespace Syntax is
    use System;
    use Generic;

    use IoC;
    use Logging;
    use Source;

    interface Scope is
        // look in this scope only and nowhere else:
        Symbol.BASE find_direct(String name);

        // look in this scope and any class or trait ancestors:
        Symbol.BASE find_member(String name);

        // look in:
        // - this scope
        // - any class or trait ancestors
        // - any used namespaces
        // - any namespaces enclosing the current class
        Symbol.BASE find_enclosing(String name);
    si

    interface DeclarationContext is
        Scope declare_class(LOCATION location, String name);
        Scope declare_trait(LOCATION location, String name);
        Scope declare_enum(LOCATION location, String name);
        void declare_enum_member(LOCATION location, String name);
        Scope declare_function(LOCATION location, String name);
        void declare_variable(LOCATION location, String name);
        void declare_label(LOCATION location, String name);
    si

    interface NamespaceContext is
        void add_namespace(LOCATION location, String name, Symbol.NAMESPACE namespace_);
    si

    class USE_SCOPE do Scope is
        SortedMap<String, Symbol.BASE> _used_symbols;
        Vector<Scope> _used_scopes;

        void init() is 
            _used_scopes = new Vector<Scope>();
        si

        Symbol.BASE find_direct(String name) is
            var result = _used_symbols[name];

            if result != null then
                return result;
            fi

            foreach var scope; _used_scopes do
                result = scope.find_direct(name);

                if result != null then
                    return result;
                fi
            od

            return null;
        si

        Symbol.BASE find_member(String name) is
            return find_direct(name);
        si

        Symbol.BASE find_enclosing(String name) is
            return find_direct(name);
        si
        
        void add_scope(Scope scope) is
            _used_scopes.add(scope);
        si

        void add_symbol(Symbol.BASE symbol) is
            _used_symbols[symbol.name] = symbol;
        si
    si

    class BLOCK_SCOPE do Scope, DeclarationContext is
        Scope _enclosing;
        Dict<String, Symbol.BASE> _symbols;

        void init() is
            init(null);
        si

        void init(Scope enclosing) is
            this._enclosing = enclosing;
            _symbols = new SortedMap<String, Symbol.BASE>();
        si

        Symbol.BASE find_direct(String name) is
            return _symbols[name];
        si

        Symbol.BASE find_member(String name) is
            LOGGER.trace("find-symbol", Object.dump(this) + " find member: " + name);
            throw new NotImplementedException("cannot search for member " + name + " in block scope");
        si

        Symbol.BASE find_enclosing(String name) is
            LOGGER.trace("find-symbol", Object.dump(this) + " find enclosing: " + name);
            var result = find_direct(name);

            if result != null then
                LOGGER.trace("find-symbol", Object.dump(this) + " find enclosing: " + name + " success");
                return result;
            elif _enclosing != null then
                LOGGER.trace("find-symbol", Object.dump(this) + " find enclosing: " + name + " try enclosing...");
                return _enclosing.find_enclosing(name);
            else
                LOGGER.trace("find-symbol", Object.dump(this) + " find enclosing: " + name + " no result...");
                return null;
            fi
        si

        Scope declare_undefined(LOCATION location, String kind, String name) is
            CONTAINER.instance.logger.error(location, "cannot declare " + kind + " here");

            return new Symbol.UNDEFINED(location, name);
        si

        Scope declare_class(LOCATION location, String name) is
            return declare_undefined(location, "class", name);
        si

        Scope declare_trait(LOCATION location, String name) is
            return declare_undefined(location, "trait", name);
        si

        Scope declare_enum(LOCATION location, String name) is
            return declare_undefined(location, "enum", name);
        si

        void declare_enum_member(LOCATION location, String name) is
            declare_undefined(location, "enum member", name);
        si

        Scope declare_function(LOCATION location, String name) is
            declare_undefined(location, "function", name);
        si

        void add_namespace(LOCATION location, String name, Symbol.NAMESPACE namespace_) is
            declare_undefined(location, "namespace", name);            
        si

        void declare_label(LOCATION location, String name) is
            var label = new Symbol.LABEL(location, name);

            declare(location, label);
        si

        void declare_variable(LOCATION location, String name) is 
            var variable = new Symbol.LOCAL_VARIABLE(location, name);

            declare(location, variable);
        si

        void declare(LOCATION location, Symbol.BASE symbol) is
            var name = symbol.name;

            var existing = find_direct(symbol.name);

            if existing != null then
                CONTAINER.instance.logger.error(location, "redefining symbol " + name + " originally defined at " + existing.location);
                CONTAINER.instance.logger.error(existing.location, "symbol " + name + " is redefined at " + location);
            fi            

            _symbols[name] = symbol;
        si        
        
        String toString() is
            return this.ClassName + " " + _symbols;
        si
    si
si
namespace Syntax is
    use System;
    use Generic;

    use Logging;
    use Source;

    interface Scope is
        // look in this scope only any nowhere else:
        Symbol.BASE find_direct(String name);

        // look in this scope and any class or trait ancestors:
        Symbol.BASE find_member(String name);

        // look in:
        // - this scope
        // - any class or trait ancestors
        // - any used namespaces
        // - any namespaces enclosing the current class
        Symbol.BASE find_anywhere(String name);

        Symbol.BASE declare_class(LOCATION location, String name);
        Symbol.BASE declare_trait(LOCATION location, String name);
        Symbol.BASE declare_enum(LOCATION location, String name);
        Symbol.BASE declare_enum_member(LOCATION location, String name);
        Symbol.BASE declare_function(LOCATION location, String name);
        Symbol.BASE declare_variable(LOCATION location, String name);
    si

    class BLOCK_SCOPE do Scope is
        LOGGER _logger;
        Scope _enclosing;
        Dict<String, Symbol.BASE> _symbols;

        void init(LOGGER logger, Scope enclosing) is
            this._logger = logger;
            this._enclosing = enclosing;
            _symbols = new SortedMap<String, Symbol.BASE>();
        si

        void init(LOGGER logger) is
            init(logger, null);
        si

        Symbol.BASE find_direct(String name) is
            return _symbols[name];
        si

        Symbol.BASE find_member(String name) is
            throw new NotImplementedException("cannot search for member " + name + " in block scope");
        si

        Symbol.BASE find_anywhere(String name) is
            var result = find_direct[name];

            if result != null then
                return result;
            elif _enclosing != null then
                return _enclosing.find_anywhere(name);
            else
                return null;
            fi
        si      

        Symbol.BASE declare_undefined(LOCATION location, String kind, String name) is
            _logger.error(name.location, "cannot declare " + kind + " here");

            return new Symbol.UNDEFINED(name);
        si

        Symbol.BASE declare_class(LOCATION location, String name) is
            declare_undefined(location, "class", name);
        si

        Symbol.BASE declare_trait(LOCATION location, String name) is
            declare_undefined(location, "trait", name);
        si

        Symbol.BASE declare_enum(LOCATION location, String name) is
            declare_undefined(location, "enum", name);
        si

        Symbol.BASE declare_enum_member(LOCATION location, String name) is
            declare_undefined(location, "enum member", name);
        si

        Symbol.BASE declare_function(LOCATION location, String name) is
            declare_undefined(location, "function", name);
        si

        Symbol.BASE declare_variable(LOCATION location, String name) is
            var existing = find_direct(name);

            if existing != null then
                _logger.error(location, "redefining symbol " + name + " originally defined at " + node.location);
                _logger.error(node.location, "symbol " + name + " is redefined at " + location);

                return;
            fi            

            _symbols[name] = symbol;
        si 
        
        String toString() is
            return this.ClassName + " " + _symbols;
        si
    si
si
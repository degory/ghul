namespace Syntax is namespace Symbol is
    use System;

    enum ACCESS is
        PRIVATE,
        PUBLIC,
        PROTECTED
    si

    class BASE is
        protected String _name;
        protected Type.TYPE _type;

        get String name is
            return _name;
        si

        get ACCESS access is
            return ACCESS.PUBLIC;
        si

        void init(String name, Tree.Type.NODE type) is
            _name = name;
            _type = type;
        si

        BASE find_direct(String name) is
            return null;
        si

        BASE find(String name) is
            return null;
        si
    si

    class Scoped isa BASE do Scope is
        SortedMap<String, BASE> _symbols;

        void init() is
            _symbols = new SortedMap<String, BASE>();
        si

        BASE find_direct(String name) is
            return _symbols[name];            
        si

        BASE find(String name) is
            return find_direct(name);
        si

        void declare(LOCATION location, BASE symbol) is
            var existing = find_direct(symbol.name);

            if existing != null then
                _logger.error(location, "redefining symbol " + name + " originally defined at " + node.location);
                _logger.error(node.location, "symbol " + name + " is redefined at " + location);

                return;
            fi            

            _symbols[symbol.name] = symbol;
        si        

        BASE declare_undefined(LOCATION location, String kind, String name) is
            _logger.error(name.location, "cannot declare " + kind + " here");

            return new Symbol.UNDEFINED(name);
        si

        BASE declare_class(LOCATION location, String name) is
            return declare_undefined(location, "class", name);
        si

        BASE declare_trait(LOCATION location, String name) is
            return declare_undefined(location, "trait", name);
        si

        BASE declare_enum(LOCATION location, String name) is
            return declare_undefined(location, "enum", name);
        si

        BASE declare_enum_member(LOCATION location, String name) is
            return declare_undefined(location, "enum member", name);
        si

        BASE declare_function(LOCATION location, String name) is
            return declare_undefined(location, "function", name);
        si

        BASE declare_variable(LOCATION location, String name) is
            return declare_undefined(location, "variable", name);
        si

        BASE declare_function_group(LOCATION location, Function function) is
            var existing = _symbols[function.name];

            if existing != null then
                if !isa Symbol.FUNCTION_GROUP(exiting) then
                    _logger.error(location, "redefining symbol " + name + " originally defined at " + node.location);
                    _logger.error(node.location, "symbol " + name + " is redefined at " + location);
                fi

                function_group = cast Symbol.FUNCTION_GROUP(existing);
            else
                function_group = new Symbol.FUNCTION_GROUP(LOCATION.dummy);

                _symbols[function.name] = function_group;                
            fi

            function_group.add(function);

            return function;
        si
    si

    class ScopedWithParentScope isa Scoped is
        Scope _parent_scope;

        void init(String name, Scope parent_scope) is
            super.init(name);

            _parent_scope = parent_scope;
        si

        BASE find(String name) is
            var result = find_direct(name);

            if result != null then 
                return result;
            elif _parent_scope != null then
                return _parent_scope.find(name);
            else
                return null;
            fi
        si
    si

    class ScopedWithInheritedScopes isa Scoped is
        Scope _parent_scope;
        Vector<Scope> _inherited_scopes;

        void init(String name, Scope parent_scope) is
            super.init(name);

            _parent_scope = parent_scope;
            _inherited_scopes = new Vector<Scope>();
        si

        BASE find(String name) is
            var result = find_direct(name);

            if result != null then 
                return result;
            elif _parent_scope != null then
                return _parent_scope.find(name);
            else
                return null;
            fi
        si

        void find_all(String name, FUNCTION_GROUP result) is

        si
    si
        
    class NAMESPACE isa ScopedWithParentScope is
        void init(String name, Scope parent_scope) is
            super.init(name, parent_scope);
        si

        BASE declare_class(LOCATION location, String name) is
            var result = new Symbol.CLASS(name, this);

            declare(location, result);

            return result;
        si

        BASE declare_trait(LOCATION location, String name) is
            var result = new Symbol.TRAIT(name, this);

            declare(location, result);

            return result;
        si

        BASE declare_enum(LOCATION location, String name) is
            var result = new Symbol.ENUM(name);

            declare(location, result);

            return result;
        si

        BASE declare_function(LOCATION location, String name) is
            var result = new Symbol.GLOBAL_FUNCTION(name);

            declare_function_group(location, result);

            return result;
        si

        BASE declare_variable(LOCATION location, String name) is
            var result = new Symbol.GLOBAL_VARIABLE(name);

            declare(location, result);

            return result;
        si
    si

    class CLASS isa ScopedWithParentScope is
        void init(String name, Scope parent_scope) is
            super.init(name, parent_scope);
        si

        BASE declare_enum(LOCATION location, String name) is
            var result = new Symbol.ENUM(name);

            declare(location, result);

            return result;
        si

        BASE declare_function(LOCATION location, String name) is
            var result = new Symbol.INSTANCE_FUNCTION(name);

            declare_function_group(location, result);

            return result;
        si

        BASE declare_variable(LOCATION location, String name) is
            var result = new Symbol.INSTANCE_VARIABLE(name);

            declare(location, result);

            return result;
        si
        
    si

    class TRAIT isa ScopedWithParentScope is
        void init(String name, Scope parent_scope) is
            super.init(name, parent_scope);
        si
        
        BASE declare_enum(LOCATION location, String name) is
            var result = new Symbol.ENUM(name);

            declare(location, result);

            return result;
        si

        BASE declare_function(LOCATION location, String name) is
            var result = new Symbol.INSTANCE_FUNCTION(name);

            declare(location, result);

            return result;
        si
    si

    class Function isa ScopedWithParentScope is
        void init(String name, Scope parent_scope) is
            super.init(name, parent_scope);
        si
        
        void init(String name, Tree.Type.NODE type) is
            super.init(name, type);
        si

        BASE declare_variable(LOCATION location, String name) is
            var result = new Symbol.LOCAL_VARIABLE(name);

            declare(location, result);

            return result;
        si        
    si        

    class GLOBAL_FUNCTION isa Function is
        void init(String name, Scope parent_scope) is
            super.init(name, parent_scope);
        si
    si

    class INSTANCE_FUNCTION isa Function is
        void init(String name, Scope parent_scope) is
            super.init(name, parent_scope);
        si
    si

    class FUNCTION_GROUP isa BASE is

    si    

    class Variable isa BASE is
        void init(String name) is
            super.init(name);
        si
    si

    class LOCAL_VARIABLE isa BASE is
        void init(String name) is
            super.init(name);
        si
    si

    class GLOBAL_VARIABLE isa BASE is
        void init(String name) is
            super.init(name);
        si
    si

    class INSTANCE_VARIABLE isa BASE is
        void init(String name) is
            super.init(name);
        si
    si
si si
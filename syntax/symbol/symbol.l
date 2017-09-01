namespace Syntax is namespace Symbol is
    use System;
    use Generic;

    use IoC;
    use Logging;
    use Source;

    enum ACCESS is
        PRIVATE,
        PUBLIC,
        PROTECTED
    si

    class BASE is
        public LOCATION location;

        protected String _name;
        // protected Type.TYPE _type;

        get String name is
            return _name;
        si

        get ACCESS access is
            return ACCESS.PUBLIC;
        si

        void init(LOCATION location, String name) is
            this.location = location;
            _name = name;
        si

        BASE find_direct(String name) is
            LOGGER.trace("find-symbol", ClassName + " " + this.name +  " find direct: " + name + ": not a scope");            
            return null;
        si

        BASE find_member(String name) is
            LOGGER.trace("find-symbol", ClassName + " " + this.name +  " find member: " + name + ": not a scope");            
            return null;
        si

        BASE find_enclosing(String name) is
            LOGGER.trace("find-symbol", ClassName + " " + this.name +  " find enclosing: " + name + ": not a scope");            
            return null;
        si

        String toString() is
            return Class.Name + " " + name + " @ " + location; 
        si
    si

    // Bodge...
    class Scoped isa BASE do Scope, DeclarationContext is
        // SortedMap<String, BASE> _symbols;
        Map<String, BASE> _symbols;

        void init(LOCATION location, String name) is
            super.init(location, name);
            // _symbols = new SortedMap<String, BASE>();
            _symbols = new Map<String, BASE>();
        si

        BASE find_direct(String name) is
            LOGGER.trace("find-symbol", ClassName + " " + this.name + " find direct: " + name + "...");            
            return _symbols[name];            
        si

        void declare(LOCATION location, BASE symbol) is
            var existing = find_direct(symbol.name);

            if existing != null then
                CONTAINER.instance.logger.error(location, "redefining symbol " + name + " originally defined at " + existing.location);
                CONTAINER.instance.logger.error(existing.location, "symbol " + name + " is redefined at " + location);

                return;
            fi            

            _symbols[symbol.name] = symbol;
        si        

        UNDEFINED declare_undefined(LOCATION location, String kind, String name) is
            CONTAINER.instance.logger.error(location, "cannot declare " + kind + " here");

            return new UNDEFINED(location, name);
        si

        void add_namespace(LOCATION location, String name, NAMESPACE namespace_) is
            declare_undefined(location, "namespace", name);
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
            return declare_undefined(location, "function", name);
        si

        void declare_variable(LOCATION location, String name) is
            declare_undefined(location, "variable", name);
        si

        void declare_label(LOCATION location, String name) is
            declare_undefined(location, "label", name);
        si        

        void declare_function_group(LOCATION location, Function function) is
            var existing = find_direct(function.name);

            Symbol.FUNCTION_GROUP function_group;

            if existing != null then
                if !isa Symbol.FUNCTION_GROUP(existing) then
                    CONTAINER.instance.logger.error(location, "redefining symbol " + name + " originally defined at " + existing.location);
                    CONTAINER.instance.logger.error(existing.location, "symbol " + name + " is redefined at " + location);
                fi

                function_group = cast Symbol.FUNCTION_GROUP(existing);
            else
                function_group = new Symbol.FUNCTION_GROUP(LOCATION.dummy, function.name);

                _symbols[function.name] = function_group;                
            fi

            function_group.add(function);
        si

        String toString() is
            var result = new StringBuffer();

            result
                .append(Class.Name)
                .append(" ")
                .append(name)
                .append(location)
                .append(":\n");

            foreach var s; _symbols.Pairs do
                result
                    .append(s)
                    .append("\n");
            od

            return result;
        si        
    si

    class UNDEFINED isa BASE do Scope, DeclarationContext is
        void init(LOCATION location, String name) is
            super.init(location, name);
        si

        UNDEFINED declare_undefined(LOCATION location, String kind, String name) is
            CONTAINER.instance.logger.error(location, "cannot declare " + kind + " here");

            return new UNDEFINED(location, name);
        si

        void add_namespace(LOCATION location, String name, NAMESPACE namespace_) is
            declare_undefined(location, "namespace", name);
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
            return declare_undefined(location, "function", name);
        si

        void declare_variable(LOCATION location, String name) is
            declare_undefined(location, "variable", name);
        si

        void declare_label(LOCATION location, String name) is
            declare_undefined(location, "label", name);
        si        
    si    

    class ScopedWithEnclosingScope isa Scoped is
        Scope _enclosing_scope;

        void init(LOCATION location, String name, Scope enclosing_scope) is
            super.init(location, name);

            _enclosing_scope = enclosing_scope;
        si

        BASE find_enclosing_only(String name) is
            LOGGER.trace("find-symbol", ClassName + " " + this.name +  " find enclosing only: " + name + "...");            

            if _enclosing_scope != null then
                var result = _enclosing_scope.find_enclosing(name);
                if result != null then
                    LOGGER.trace("find-symbol", ClassName + " " + this.name +  " find enclosing only: " + name + ": result is " + Object.dump(result));            
                else
                    LOGGER.trace("find-symbol", ClassName + " " + this.name +  " find enclosing only: " + name + ": no result");            
                fi

                return result;                
            fi

            LOGGER.trace("find-symbol", ClassName + " " + this.name +  " find enclosing only: " + name + ": no enclosing scope");            
            return null;
        si
        
        BASE find_enclosing(String name) is
            LOGGER.trace("find-symbol", ClassName + " " + this.name +  " find enclosing: " + name + "...");            
            
            var result = find_direct(name);

            if result != null then 
                LOGGER.trace("find-symbol", ClassName + " " + this.name +  " find enclosing: " + name + ": result is " + Object.dump(result));            
                
                return result;
            else
                return find_enclosing_only(name);
            fi
        si
    si

    class ScopedWithInheritedScopes isa ScopedWithEnclosingScope is
        protected Vector<Scope> _inherited_scopes;

        void init(LOCATION location, String name, Scope enclosing_scope) is
            super.init(location, name, enclosing_scope);

            _inherited_scopes = new Vector<Scope>();
        si

        BASE find_member(String name) is
            LOGGER.trace("find-symbol", ClassName + " " + this.name +  " find member: " + name + "...");            
            
            var result = find_direct(name);

            if result != null then
                LOGGER.trace("find-symbol", ClassName + " " + this.name +  " find member: " + name + ": result is " + Object.dump(result));            
                return result;
            fi

            result = find_member_only(name);

            if result != null then
                LOGGER.trace("find-symbol", ClassName + " " + this.name +  " find member: " + name + ": result is " + Object.dump(result));            
                return result;
            fi

            LOGGER.trace("find-symbol", ClassName + " " + this.name +  " find member: " + name + " no result");            
            return null;
        si

        BASE find_enclosing(String name) is
            var result = find_direct(name);

            if result != null then
                LOGGER.trace("find-symbol", ClassName + " " + this.name +  " find enclosing: " + name + ": result is " + Object.dump(result));            
                return result;
            fi

            result = find_member_only(name);

            if result != null then
                LOGGER.trace("find-symbol", ClassName + " " + this.name +  " find enclosing: " + name + ": result is " + Object.dump(result));            
                return result;
            fi

            result = find_enclosing_only(name);

            if result != null then
                LOGGER.trace("find-symbol", ClassName + " " + this.name +  " find enclosing: " + name + ": result is " + Object.dump(result));            
                return result;
            fi

            LOGGER.trace("find-symbol", ClassName + " " + this.name +  " find enclosing: " + name + " no result");            
            return null;
        si

        BASE find_member_only(String name) is
            LOGGER.trace("find-symbol", ClassName + " " + this.name +  " find member only: " + name + "..."); 

            foreach var i; _inherited_scopes do
                var result = i.find_member(name);
                if result != null then
                    LOGGER.trace("find-symbol", ClassName + " " + this.name +  " find member only: " + name + ": result is " + Object.dump(result)); 
                    return result;
                fi
            od

            LOGGER.trace("find-symbol", ClassName + " " + this.name +  " find member only: " + name + " no result"); 
            return null;
        si
    si
        
    class NAMESPACE isa ScopedWithEnclosingScope do NamespaceContext is
        public String qualified_name;

        void init(LOCATION location, String name, Scope enclosing_scope, String qualified_name) is
            super.init(location, name, enclosing_scope);
            this.qualified_name = qualified_name;
        si

        void add_namespace(LOCATION location, String name, Symbol.NAMESPACE namespace_) is
            declare(location, namespace_);
        si

        Scope declare_class(LOCATION location, String name) is
            var result = new Symbol.CLASS(location, name, this);

            declare(location, result);

            return result;
        si

        Scope declare_trait(LOCATION location, String name) is
            var result = new Symbol.TRAIT(location, name, this);

            declare(location, result);

            return result;
        si

        Scope declare_enum(LOCATION location, String name) is
            var result = new Symbol.ENUM(location, name);

            declare(location, result);

            return result;
        si

        Scope declare_function(LOCATION location, String name) is
            var result = new Symbol.GLOBAL_FUNCTION(location, name, this);

            declare_function_group(location, result);

            return result;
        si

        void declare_variable(LOCATION location, String name) is
            var result = new Symbol.GLOBAL_VARIABLE(location, name);

            declare(location, result);
        si        
    si

    class ENUM isa Scoped is
        void init(LOCATION location, String name) is
            super.init(location, name);
        si

        void declare_enum_member(LOCATION location, String name) is
            var result = new Symbol.ENUM_MEMBER(location, name);

            declare(location, result);
        si        
    si

    class ENUM_MEMBER isa BASE is
        void init(LOCATION location, String name) is
            super.init(location, name);
        si
    si

    class LABEL isa BASE is
        void init(LOCATION location, String name) is
            super.init(location, name);
        si
    si    
    
    class CLASS isa ScopedWithInheritedScopes is
        void init(LOCATION location, String name, Scope enclosing_scope) is
            super.init(location, name, enclosing_scope);
        si

        Scope declare_enum(LOCATION location, String name) is
            var result = new Symbol.ENUM(location, name);

            declare(location, result);

            return result;
        si

        Scope declare_function(LOCATION location, String name) is
            var result = new Symbol.INSTANCE_FUNCTION(location, name, this);

            declare_function_group(location, result);

            return result;
        si

        void declare_variable(LOCATION location, String name) is
            var result = new Symbol.INSTANCE_VARIABLE(location, name);

            declare(location, result);
        si
    si

    class TRAIT isa ScopedWithInheritedScopes is
        void init(LOCATION location, String name, Scope enclosing_scope) is
            super.init(location, name, enclosing_scope);
        si
        
        Scope declare_enum(LOCATION location, String name) is
            var result = new Symbol.ENUM(location, name);

            declare(location, result);

            return result;
        si

        Scope declare_function(LOCATION location, String name) is
            var result = new Symbol.INSTANCE_FUNCTION(location, name, this);

            declare_function_group(location, result);

            return result;
        si
    si

    class Function isa ScopedWithEnclosingScope is
        void init(LOCATION location, String name, Scope enclosing_scope) is
            super.init(location, name, enclosing_scope);
        si
        
        void declare_variable(LOCATION location, String name) is
            var result = new Symbol.LOCAL_VARIABLE(location, name);

            declare(location, result);
        si        
    si        

    class GLOBAL_FUNCTION isa Function is
        void init(LOCATION location, String name, Scope parent_scope) is
            super.init(location, name, parent_scope);
        si
    si

    class INSTANCE_FUNCTION isa Function is
        void init(LOCATION location, String name, Scope parent_scope) is
            super.init(location, name, parent_scope);
        si
    si

    class FUNCTION_GROUP isa BASE is
        Vector<Function> _functions;

        void init(LOCATION location, String name) is
            super.init(location, name);
            _functions = new Vector<Function>();
        si

        void add(Function function) is
            _functions.add(function);
        si

        String toString() is
            return Class.Name + " " + name + " @ " + location + " (" + _functions + ")";
        si        
    si    

    class Variable isa BASE is
        void init(LOCATION location, String name) is
            super.init(location, name);
        si
    si

    class LOCAL_VARIABLE isa BASE is
        void init(LOCATION location, String name) is
            super.init(location, name);
        si
    si

    class GLOBAL_VARIABLE isa BASE is
        void init(LOCATION location, String name) is
            super.init(location, name);
        si
    si

    class INSTANCE_VARIABLE isa BASE is
        void init(LOCATION location, String name) is
            super.init(location, name);
        si
    si
si si
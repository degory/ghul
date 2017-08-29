namespace Syntax is
    use System;
    use Generic;

    use Logging;
    use Source;
    use Tree;

    class SCOPE is
        LOGGER _logger;
        SCOPE _parent;
        Dict<String, NODE> _symbols;

        get NODE[String name] is
            var result = _symbols[name];

            if result != null then
                return result;
            elif _parent != null then
                return _parent[name];
            else
                return null;
            fi
        si

        void init(LOGGER logger, SCOPE parent) is
            this._logger = logger;
            this._parent = parent;
            _symbols = new SortedMap<String, NODE>();
        si

        void init(LOGGER logger) is
            init(logger, null);
        si
        
        void declare(LOCATION location, String name, NODE node) is
            Definition.FUNCTION_GROUP function_group;
            var existing = _symbols[name];

            if isa Definition.FUNCTION(node) then
                if existing != null then
                    function_group = cast Definition.FUNCTION_GROUP(existing);
                else
                    function_group = new Definition.FUNCTION_GROUP(LOCATION.dummy);
                fi

                function_group.add(cast Definition.FUNCTION(node));

                node = function_group;
            else
                if existing != null then
                    _logger.error(location, "redefining symbol " + name + " originally defined at " + node.location);
                    _logger.error(node.location, "symbol " + name + " is redefined at " + location);

                    return;
                fi
            fi

            _symbols[name] = node;
        si

        void declare(Identifier.NODE identifier, NODE node) is
            declare(identifier.location, identifier.name, node);
        si
        
        String toString() is
            return this.ClassName + " " + _symbols;
        si
    si
si
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
            if _symbols[name] != null then
                _logger.error(location, "redefining symbol " + name + " originally defined at " + node.location);
                _logger.error(node.location, "symbol " + name + " is redefined at " + location);
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
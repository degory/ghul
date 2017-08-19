namespace Syntax is
    use System;
    use Generic;

    use Tree;

    class SCOPE is
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

        void declare(String name, NODE node) is
            assert(_symbols[name] == null);

            _symbols[name] = node;
        si

        void init(SCOPE parent) is
            this._parent = parent;
            _symbols = new SortedMap<String, NODE>();
        si
    si
si
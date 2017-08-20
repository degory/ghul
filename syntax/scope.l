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
            if _symbols[name] != null then
                IO.Std.err.println("redefining symbol: " + name + " as " + Object.dump(node));
            fi

            _symbols[name] = node;
        si

        void init(SCOPE parent) is
            this._parent = parent;
            _symbols = new SortedMap<String, NODE>();
        si
        
        String toString() is
            return Object.dump(this) + " " + _symbols;
        si
    si
si
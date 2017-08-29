namespace Syntax is namespace Process is
    use System;
    use Generic;

    use Tree;

    class Test isa Visitor is
        Map<String, NODE> _symbols;
	    Map<NODE, NODE> _map;

        void init() is
            super.init();

	    _symbols = new Map<String, NODE>();
	    _map = new Map<NODE, NODE>();
        si

        get String result is
            return
                _symbols.toString() + "\n" +
                _map.toString();
        si

        void visit(Identifier.NODE identifier) is
            var replacement = _symbols[identifier.name];

            if replacement == null then
                _symbols[identifier.name] = identifier;
            elif replacement != identifier then
                IO.Std.err.println("Map %: % -> %" % Object{identifier.name, Object.dump(identifier), Object.dump(replacement)});
                _map[identifier] = replacement;
            fi
        si
    si
si si

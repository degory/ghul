namespace Syntax is namespace Process is
    use System;
    use Generic;

    use Tree;

    class Test isa Visitor is
        Map<String, NODE> _symbols;
	Map<NODE, NODE> _map;

        void init() is
            super.init();

            IO.Std.err.println("new all-visitor...");

	    _symbols = new Map<String, NODE>();
	    _map = new Map<NODE, NODE>();
        si

        get String result is
            return
                _symbols.toString() + "\n" +
                _map.toString();
        si

        void visit(Identifier.NODE identifier) is
            IO.Std.err.println("look up name: " + identifier.name);
            var replacement = _symbols[identifier.name];

            if replacement == null then
                IO.Std.err.println("First time: " + identifier.name);
                _symbols[identifier.name] = identifier;
            elif replacement != identifier then
                IO.Std.err.println("Seen before: " + identifier.name);
                
                IO.Std.err.println("Map %: % -> %" % Object{identifier.name, Object.dump(identifier), Object.dump(replacement)});
                _map[identifier] = replacement;
            fi
        si
    si
si si

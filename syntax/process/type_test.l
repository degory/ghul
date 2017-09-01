namespace Syntax is namespace Process is
    use System;
    use Generic;

    use Logging;
    use Tree;

    class TYPE_TEST isa ScopedVisitor is
        LOGGER _logger;

        void init(LOGGER logger, SYMBOL_TABLE symbol_table, NAMESPACES namespaces) is
            super.init(logger, symbol_table, namespaces);

            _logger = logger;
        si

        void apply(NODE node) is
            node.walk(this);
        si

        bool pre(Type.NAMED named) is
            return false;
        si

        void visit(Type.NAMED named) is
            var symbol = find_enclosing(named.name);

            if symbol != null then
                IO.Std.err.println("type " + named + " => " + symbol);
            else
                _logger.warn(named.location, "named type not found");
            fi
        si

        bool pre(Type.LIST types) is
            return false;
        si

        void visit(Type.LIST types) is
        si

        bool pre(Type.GENERIC generic) is            
            return false;
        si

        void visit(Type.GENERIC generic) is
            var symbol = find_enclosing(generic.name);

            if symbol != null then
                IO.Std.err.println("type " + generic + " => " + symbol);
            else
                _logger.warn(generic.location, "named type not found");
            fi
        si

        bool pre(Type.NAMED_TUPLE_ELEMENT element) is
            return false;
        si

        void visit(Type.NAMED_TUPLE_ELEMENT element) is
        si
    si
si si

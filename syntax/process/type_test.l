namespace Syntax is namespace Process is
    use System;
    use Generic;

    use Logging;
    use Tree;

    class TYPE_TEST isa ScopedVisitor is
        LOGGER _logger;
        SYMBOL_TABLE _symbol_table;

        void init(LOGGER logger, SYMBOL_TABLE symbol_table, NAMESPACES namespaces) is
            super.init(logger, symbol_table, namespaces);

            _logger = logger;
            _symbol_table = symbol_table;

            _logger._trace("experiment", "initialized: " + this);
        si

        void apply(NODE node) is
            node.walk(this);
        si

        bool pre(Definition.CLASS class_) is
            super.pre(class_);

            _logger._trace("experiment", "enter class " + class_.name + ", symbol table is " + _symbol_table.dump_stack());
            _logger._trace("experiment", "top scope stack is\n" + _symbol_table.current_scope.dump_stack());
        si

        bool pre(Type.NAMED named) is
            return false;
        si

        void visit(Type.NAMED named) is
            var symbol = find_enclosing(named.name);

            if symbol != null then
                _logger._trace("experiment", "type " + named + " => " + symbol);
            else
                _logger.warn(named.location, "named type " + named.name + " not found");
                _logger._trace("experiment", "" + _symbol_table);
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
                _logger._trace("experiment", "type " + generic + " => " + symbol);
            else
                _logger.warn(generic.location, "named type " + generic.name + " not found");
            fi
        si

        bool pre(Type.NAMED_TUPLE_ELEMENT element) is
            return false;
        si

        void visit(Type.NAMED_TUPLE_ELEMENT element) is
        si
    si
si si

namespace Syntax is namespace Process is
    use System;
    use Generic;

    use Logging;
    use Tree;

    class INFER_TYPES isa ScopedVisitor is
        LOGGER _logger;
        Map<NODE,NODE> _map;

        void init(LOGGER logger, SYMBOL_TABLE symbol_table, NAMESPACES namespaces) is
            super.init(symbol_table, namespaces);

            _logger = logger;
            _map = new Map<NODE,NODE>();
        si

        void apply(NODE root) is
            root.walk(this);
        si
    si
si si
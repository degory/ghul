namespace Syntax is namespace Process is
    use System;
    use Generic;

    use Logging;
    use Tree;

    class SCOPE_TEST isa ScopedVisitor is
        LOGGER _logger;

        void init(LOGGER logger, SYMBOL_TABLE symbol_table, NAMESPACES namespaces) is
            super.init(symbol_table, namespaces);

            _logger = logger;
        si

        void visit(Identifier.QUALIFIED identifier) is
            var symbol = find_member(identifier);

            if symbol != null then
                IO.Std.err.println("" + identifier + " => " + symbol);
            else
                _logger.error(identifier.location, "symbol not defined: " + identifier);
            fi
        si

        void visit(Identifier.NODE identifier) is
            var symbol = find_enclosing(identifier);

            if symbol != null then
                IO.Std.err.println("" + identifier + " => " + symbol);
            else
                _logger.error(identifier.location, "symbol not defined: " + identifier);
            fi            
        si

        bool pre(Expression.MEMBER member) is
            IO.Std.err.println("Cannot search for member: " + member);

            return true;            
        si
    si
si si

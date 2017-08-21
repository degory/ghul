namespace Syntax is namespace Process is
    use System;
    use Generic;

    use Logging;
    use Tree;

    class SCOPE_TEST isa ScopedVisitor is
        LOGGER _logger;

        void init(LOGGER logger, SCOPES scopes, NAMESPACES namespaces) is
            super.init(scopes, namespaces);

            _logger = logger;
        si

        void visit(Identifier.QUALIFIED identifier) is
            var definition = this[identifier];

            if definition != null then
                IO.Std.err.println("" + identifier + " => " + definition);
            else
                _logger.error(identifier.location, "symbol not defined: " + identifier);
            fi
        si

        void visit(Identifier.NODE identifier) is
            var definition = this[identifier];

            if definition != null then
                IO.Std.err.println("" + identifier + " => " + definition);
            else
                _logger.error(identifier.location, "symbol not defined: " + identifier);
            fi            
        si
    si
si si

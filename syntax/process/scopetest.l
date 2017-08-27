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
            IO.Std.err.println("search for qualified: " + identifier);

            var definition = this[identifier];

            if definition != null then
                IO.Std.err.println("" + identifier + " => " + definition);
            else
                _logger.error(identifier.location, "symbol not defined: " + identifier);
            fi
        si

        void visit(Identifier.NODE identifier) is
            IO.Std.err.println("search for unqualified: " + identifier);

            var definition = this[identifier];

            if definition != null then
                IO.Std.err.println("" + identifier + " => " + definition);
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

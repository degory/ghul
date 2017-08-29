namespace Syntax is namespace Process is
    use System;
    use Generic;

    use Logging;
    use Tree;

    class INFER_TYPES isa ScopedVisitor is
        LOGGER _logger;
        Map<NODE,NODE> _map;

        void init(LOGGER logger, SCOPES scopes, NAMESPACES namespaces) is
            super.init(scopes, namespaces);

            _logger = logger;
            _map = new Map<NODE,NODE>();
        si

        void apply(NODE root) is
            root.walk(this);
        si

        void visit(Identifier.QUALIFIED identifier) is
            var definition = this[identifier];

            if definition != null then
                IO.Std.err.println("" + identifier + " => " + definition);
                _map[identifier] = definition;
            else
                _logger.error(identifier.location, "symbol not defined: " + identifier);
            fi
        si

        void visit(Identifier.NODE identifier) is
            var definition = this[identifier];

            if definition != null then
                IO.Std.err.println("" + identifier + " => " + definition);
                _map[identifier] = definition;                
            else
                _logger.error(identifier.location, "symbol not defined: " + identifier);
            fi            
        si

        void visit(Expression.MEMBER member) is
            var t = _map[member.left];

            IO.Std.err.println("member: " + member + " => " + t);
        si 
    si
si si
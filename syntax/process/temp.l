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

/*
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
*/
        void visit(Variable.NODE variable) is
            if isa Type.INFER(variable.type) then
                if variable.initializer != null then
                    if variable.initializer.type == null then
                        _logger.error(variable.location, "initializer has no type");
                    else
                        variable.type = variable.initializer.type;
                    fi
                fi
            fi
        si 

        void visit(Expression.IDENTIFIER identifier) is
            var definition = this[identifier.identifier];

            if definition != null then
                IO.Std.err.println("expression identifier " + identifier + " (" + Object.dump(identifier.identifier) + ") => " + definition);

                var t = _map[definition];
                if t != null then
                    _map[identifier] = t;
                    IO.Std.err.println("expression identifier " + identifier + " (" + Object.dump(identifier.identifier) + ") => " + t);
                else
                    IO.Std.err.println("expression identifier " + identifier + " (" + Object.dump(identifier.identifier) + ") => unknown type");
                fi                 
            else
                _logger.error(identifier.location, "symbol not defined: " + identifier);
            fi            
        si

        void visit(Expression.CALL call) is
            var function = _map[call.function];
            if function == null then
                IO.Std.err.println("no type available for " + call.function);
                return;
            fi

            IO.Std.err.println("function is " + Object.dump(function));

            var arguments = new Vector<NODE>();

            foreach var a; call.arguments do
                IO.Std.err.println("argument is " + Object.dump(a));
                arguments.add(_map[a]);
            od

            if isa Definition.FUNCTION_GROUP(function) then
                var function_group = cast Definition.FUNCTION_GROUP(function);

                _map[call] = function_group.functions[0].type;
            elif isa Type.FUNCTION(function) then
                _map[call] = cast Type.FUNCTION(function).result;
            fi

            IO.Std.err.println("call " + function + "(" + arguments + ") => " + _map[call]);
        si

        void visit(Expression.MEMBER member) is
            var t = _map[member.left];

            IO.Std.err.println("member: " + member + " => " + t);
        si 
    si
si si
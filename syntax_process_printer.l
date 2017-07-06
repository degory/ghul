namespace Syntax is
    namespace Process is
        use System;
        use Tree;
        use Tree.Definition;
        use Tree.Type;

        class PRINTER isa Visitor is
            StringBuffer _result;

            void init() is
                super.init();
                
                _result = new StringBuffer();
            si

            get String result is
                return _result;
            si

            void apply(NODE node) is
                node.accept(this);
            si

            // Identifiers

            void visit(IDENTIFIER identifier) is
                _result.append(identifier.name);
            si

            void visit(QUALIFIED_IDENTIFIER identifier) is
                identifier.parent.accept(this);
                _result.append('.');
                identifier.accept(this);
            si

            // definitions

            void visit(VARIABLE variable) is
                variable.identifier.accept(this);

                // FIXME: not OOP
                if !isa Type.INFER(variable.type) then
                    _result.append(": ");
                    variable.type.accept(this);
                fi

                if variable.initializer != null then
                    _result.append(" = ");
                    variable.initializer.accept(this);
                fi
            si

            void visit(VARIABLE_LIST variables) is
                var first = true;

                foreach var v; variables do
                    if !first then _result.append(", "); fi

                    v.accept(this);

                    first = false;
                od
            si

            void visit(LET l) is
                _result.append("let ");
                l.variables.accept(this);
                _result.append(";");
            si

            void visit(VAR v) is
                _result.append("var ");
                v.variables.accept(this);
                _result.append(";");
            si

            void visit(DEFINITION_LIST definitions) is
                foreach var d; definitions do
                    d.accept(this);
                    _result.append('\n');
                od
            si

            // types

            void visit(BUILT_IN type) is
                _result.append(type.name);
            si

            void visit(ARRAY array) is
                _result.append("[]");
                array.element.accept(this);
            si

            void visit(POINTER pointer) is
                _result.append("ptr ");
                pointer.element.accept(this);
            si

            void visit(REFERENCE reference) is
                _result.append("ref ");
                reference.element.accept(this);
            si

            void visit(NAMED named) is
                named.name.accept(this);
            si

            void visit(GENERIC generic) is
                generic.name.accept(this);
                _result.append('[');

                var seen_any = false;
                foreach var a; generic.arguments do
                    if seen_any then
                        _result.append(',');
                    fi

                    a.accept(this);

                    seen_any = true;
                od

                _result.append(']');
            si

            // expression 

            void visit(Expression.NONE none) is
                _result.append("none");
            si

            void visit(Expression.IDENTIFIER identifier) is
                identifier.identifier.accept(this);
            si

            void visit(Expression.UNARY unary) is
                _result.append(Expression.OPERATION_NAMES[unary.operation]);

                unary.right.accept(this);
            si

            void visit(Expression.BINARY binary) is
                binary.left.accept(this);

                _result.append(Expression.OPERATION_NAMES[binary.operation]);
                
                binary.right.accept(this);
            si            
        si
    si
si
    

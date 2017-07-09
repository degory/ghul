namespace Syntax is
    namespace Process is
        use System;
        use Tree;

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
                
                _result
                    .append('.')
                    .append(identifier.name);
            si

            // definitions

            void visit(Definition.VARIABLE variable) is
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

            void visit(Definition.VARIABLE_LIST variables) is
                var first = true;

                foreach var v; variables do
                    if !first then _result.append(", "); fi

                    v.accept(this);

                    first = false;
                od
            si

            void visit(Definition.LET l) is
                _result.append("let ");
                l.variables.accept(this);
                _result.append(";");
            si

            void visit(Definition.VAR v) is
                _result.append("var ");
                v.variables.accept(this);
                _result.append(";");
            si

            void visit(Definition.DEFINITION_LIST definitions) is
                foreach var d; definitions do
                    d.accept(this);
                    _result.append('\n');
                od
            si

            // types

            void visit(Type.BUILT_IN type) is
                _result.append(type.name);
            si

            void visit(Type.ARRAY array) is
                array.element.accept(this);
                _result.append("[]");
            si

            void visit(Type.POINTER pointer) is
                pointer.element.accept(this);
                _result.append(" ptr");
            si

            void visit(Type.REFERENCE reference) is
                reference.element.accept(this);
                _result.append(" ref");
            si

            void visit(Type.NAMED named) is
                named.name.accept(this);
            si

            void visit(Type.GENERIC generic) is
                generic.name.accept(this);
                _result.append('[');

                generic.arguments.accept(this);

                _result.append(']');
            si

            void visit(Type.FUNCTION function) is
                _result.append("(");

                function.arguments.accept(this);

                _result.append(")");

                if !isa Type.INFER(function.result) then
                    _result.append(" -> ");
                    function.result.accept(this);
                fi
            si

            void visit(Type.TUPLE tuple) is
                _result.append("(");

                tuple.elements.accept(this);

                _result.append(")");
            si

            void visit(Type.NAMED_TUPLE_ELEMENT element) is
                element.name.accept(this);
                _result.append(": ");
                element.type.accept(this);
            si      

            void visit(Type.TYPE_LIST types) is
                var seen_any = false;
                foreach var t; types.Iterator do
                    if seen_any then
                        _result.append(',');
                    fi

                    t.accept(this);

                    seen_any = true;
                od
            si

            // expression 

            void visit(Expression.NONE none) is
                _result.append("none");
            si

            void visit(Expression.IDENTIFIER identifier) is
                identifier.identifier.accept(this);
            si

            void visit(Expression.VARIABLE variable) is
                variable.identifier.accept(this);

                if !isa Type.INFER(variable.type) then
                    _result.append(": ");

                    variable.type.accept(this);
                fi

                if variable.initializer != null then
                    _result.append( " = ");

                    variable.initializer.accept(this);
                fi
            si

            void visit(Syntax.Tree.Expression.FUNCTION function) is
                function.arguments.accept(this);

                if !isa Type.INFER(function.type) then
                    _result.append(" -> ");

                    function.type.accept(this);
                fi

                _result.append(" => ");

                function.body.accept(this);
            si

            void visit(Expression.TUPLE tuple) is
                _result.append('(');

                tuple.elements.accept(this);

                _result.append(')');
            si

            void visit(Expression.LIST list) is
                _result.append('[');

                list.elements.accept(this);

                _result.append(']');
            si            

            void visit(Expression.CALL call) is
                call.function.accept(this);

                _result.append('(');

                call.arguments.accept(this);

                _result.append(')');
            si            

            void visit(Expression.MEMBER member) is
                member.left.accept(this);

                _result.append('.');

                member.identifier.accept(this);
            si

            void visit(Expression.INDEX index) is
                index.left.accept(this);

                _result.append('[');

                index.index.accept(this);

                _result.append(']');
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

            void visit(Expression.EXPRESSION_LIST expressions) is
                var seen_any = false;
                foreach var e; expressions do
                    if seen_any then
                        _result.append(',');
                    fi

                    e.accept(this);

                    seen_any = true;
                od
            si             
        si
    si
si
    

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

            void visit(Identifier.NODE identifier) is
                _result.append(identifier.name);
            si

            void visit(Identifier.QUALIFIED identifier) is
                identifier.parent.accept(this);
                
                _result
                    .append('.')
                    .append(identifier.name);
            si

            // definitions

            void visit(Variable.NODE variable) is
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

            void visit(Variable.LIST variables) is
                var first = true;

                foreach var v; variables do
                    if !first then _result.append(", "); fi

                    v.accept(this);

                    first = false;
                od
            si

            void visit(Definition.LIST definitions) is
                foreach var d; definitions do
                    d.accept(this);
                    _result.append('\n');
                od
            si

            void visit(Definition.CLASS class_) is
                _result.append("class ");

                class_.name.accept(this);

                if class_.arguments != null then 
                    _result.append('[');
                    class_.arguments.accept(this);
                    _result.append(']');
                fi

                if class_.ancestors != null then                    
                    _result.append(": ");

                    class_.ancestors.accept(this);
                fi

                _result.append(" is\n");
                class_.body.accept(this);
                _result.append("si\n");
            si
    
            void visit(Definition.INTERFACE interface_) is
                _result.append("class ");
                interface_.name.accept(this);

                if interface_.arguments != null then 
                    _result.append('[');
                    interface_.arguments.accept(this);
                    _result.append(']');
                fi

                if interface_.ancestors != null then
                    _result.append(": ");

                    interface_.ancestors.accept(this);
                fi

                _result.append(" is\n");
                interface_.body.accept(this);
                _result.append("si\n");
            si        

            void visit(Definition.FUNCTION function) is
                function.name.accept(this);
                _result.append('(');
                function.arguments.accept(this);
                _result.append(')');

                if !isa Type.INFER(function.type) then
                    _result.append(" -> ");
                    function.type.accept(this);
                fi

                _result.append(' ');

                if function.body != null then
                    function.body.accept(this);
                fi
            si

            void visit(Definition.PROPERTY property) is
                property.name.accept(this);

                if !isa Type.INFER(property.type) then
                    _result.append(": ");
                    property.type.accept(this);
                fi

                if property.getter_body != null then
                    property.getter_body.accept(this);

                    if property.setter_body != null then
                        _result.append(",");
                    fi
                fi

                if property.setter_body != null then
                    _result.append(" = ");
                    property.setter_argument.accept(this);

                    property.setter_body.accept(this);
                fi
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

            void visit(Type.LIST types) is
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

                function.body.accept(this);
            si

            void visit(Expression.TUPLE tuple) is
                _result.append('(');

                tuple.elements.accept(this);

                _result.append(')');
            si

            void visit(Expression.LITERAL literal) is
                _result.append(literal.value);
            si                        

            void visit(Expression.LIST_LITERAL list) is
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

            void visit(Expression.LIST expressions) is
                var seen_any = false;
                foreach var e; expressions do
                    if seen_any then
                        _result.append(',');
                    fi

                    e.accept(this);

                    seen_any = true;
                od
            si

            // Statements

            void visit(Statement.LIST list) is
                foreach var s; list.Iterator do
                    s.accept(this);
                    _result.append("\n");
                od
            si

            void visit(Statement.ASSIGNMENT assign) is
                assign.left.accept(this);
                _result.append(" = ");
                assign.right.accept(this);
                _result.append(";");
            si

            void visit(Statement.EXPRESSION expression) is
                expression.accept(this);
                _result.append(";");
            si

            void visit(Statement.LET l) is
                _result.append("let ");
                l.variables.accept(this);
                _result.append(";");
            si

            void visit(Statement.VAR v) is
                _result.append("var ");
                v.variables.accept(this);
                _result.append(";");
            si

            // function body

            void visit(Body.EXPRESSION expression) is
                _result.append(" => ");
                expression.expression.accept(this);
            si

            void visit(Body.BLOCK block) is
                _result.append("is\n");
                block.statements.accept(this);
                _result.append("si\n");
            si            
        si
    si
si
    

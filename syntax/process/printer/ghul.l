namespace Syntax is namespace Process is namespace Printer is
    use System;
    use Tree;

    class GHUL isa BASE is
        void init() is
            super.init();
        si

        // definitions

        void visit(Variable.NODE variable) is
            variable.identifier.accept(this);

            // FIXME: not OOP
            if !isa Type.INFER(variable.type) then
                append(": ");                    
                variable.type.accept(this);
            fi

            if variable.initializer != null then
                append(" = ");
                variable.initializer.accept(this);
            fi
        si

        void visit(Definition.NAMESPACE namespace_) is
            dent_append("namespace ");

            namespace_.name.accept(this);

            append(" is\n");

            in();
            namespace_.body.accept(this);
            out();

            dent_append("si\n");
        si            

        void visit(Definition.CLASS class_) is
            dent_append("class ");

            class_.name.accept(this);

            if class_.arguments != null then 
                append('[');
                class_.arguments.accept(this);
                append(']');
            fi

            if class_.ancestors != null then                    
                append(": ");

                class_.ancestors.accept(this);
            fi

            append(" is\n");

            in();
            class_.body.accept(this);
            out();

            dent_append("si\n");
        si

        void visit(Definition.INTERFACE interface_) is
            dent_append("interface ");
            interface_.name.accept(this);

            if interface_.arguments != null then 
                append('[');
                interface_.arguments.accept(this);
                append(']');
            fi

            if interface_.ancestors != null then
                append(": ");

                interface_.ancestors.accept(this);
            fi

            append(" is\n");

            in();
            interface_.body.accept(this);
            out();

            dent_append("si\n");
        si           

        void visit(Definition.FUNCTION function) is
            dent();

            function.name.accept(this);
            append('(');
            function.arguments.accept(this);
            append(')');

            if !isa Type.INFER(function.type) then
                append(" -> ");
                function.type.accept(this);
            fi

            if function.body != null then
                function.body.accept(this);
            fi
        si

        void visit(Definition.PROPERTY property) is
            dent();

            property.name.accept(this);

            if !isa Type.INFER(property.type) then
                append(": ");
                property.type.accept(this);
            fi

            if property.getter_body != null then
                property.getter_body.accept(this);

                if property.setter_body != null then
                    append(",");
                fi
            fi

            if property.setter_body != null then
                append(" = ");
                property.setter_argument.accept(this);

                property.setter_body.accept(this);
            fi
        si

        void visit(Definition.INDEXER indexer) is
            dent();

            if indexer.name != null then
                indexer.name.accept(this);
            fi

            append('[');
            indexer.index_argument.accept(this);
            append(']');

            if !isa Type.INFER(indexer.type) then
                append(": ");
                indexer.type.accept(this);
            fi

            if indexer.getter_body != null then
                indexer.getter_body.accept(this);

                if indexer.setter_body != null then
                    append(",");
                fi
            fi

            if indexer.setter_body != null then
                append(" = ");
                indexer.setter_argument.accept(this);

                indexer.setter_body.accept(this);
            fi
        si
        
                    
        // types

        void visit(Type.MODIFIER modifier) is
            if !isa Type.INFER(modifier.element) then
                modifier.element.accept(this);
                append(' ');
            fi
            
            append(modifier.name);
        si

        void visit(Type.GENERIC generic) is
            generic.name.accept(this);
            append('[');

            generic.arguments.accept(this);

            append(']');
        si

        void visit(Type.FUNCTION function) is
            append("(");

            function.arguments.accept(this);

            append(")");

            if !isa Type.INFER(function.result) then
                append(" -> ");
                function.result.accept(this);
            fi
        si

        void visit(Type.TUPLE tuple) is
            append("(");

            tuple.elements.accept(this);

            append(")");
        si

        void visit(Type.NAMED_TUPLE_ELEMENT element) is
            element.name.accept(this);
            append(": ");
            element.type.accept(this);
        si      

        // expression 

        void visit(Expression.VARIABLE variable) is
            variable.identifier.accept(this);

            if !isa Type.INFER(variable.type) then
                append(": ");

                variable.type.accept(this);
            fi

            if variable.initializer != null then
                append( " = ");

                variable.initializer.accept(this);
            fi
        si

        void visit(Syntax.Tree.Expression.FUNCTION function) is
            function.arguments.accept(this);

            if !isa Type.INFER(function.type) then
                append(" -> ");

                function.type.accept(this);
            fi

            function.body.accept(this);
        si

        void visit(Expression.LIST_LITERAL list) is
            append('[');

            list.elements.accept(this);

            append(']');

            if !isa Tree.Type.INFER(list.type) then
                append(": ");
                list.type.accept(this);
            fi
        si            

        void visit(Expression.HAS_VALUE has_value) is
            has_value.left.accept(this);
            append("?");
        si        

        // Statements

        void visit(Statement.LET l) is
            dent_append("let ");
            l.variables.accept(this);
            append(";");
            nl();
        si

        void visit(Statement.FOR for_) is
            dent_append("for ");

            for_.variable.accept(this);

            append(" in ");

            for_.expression.accept(this);

            append(" do\n");

            in();
            for_.body.accept(this);
            out();

            dent_append("od"); 
            nl();
        si

        // function body

        void visit(Body.EXPRESSION expression) is
            append(" => ");
            expression.expression.accept(this);
        si

        void visit(Body.BLOCK block) is
            append(" is\n");
            in();
            block.statements.accept(this);
            out();
            dent_append("si");
        si            
    si
si si si
    

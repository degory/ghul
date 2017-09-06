namespace Syntax is namespace Process is namespace Printer is
    use System;
    use Tree;

    class GHUL isa BASE is
        void init() is
            super.init(false);
        si

        // definitions

        void visit(Variable.NODE variable) is
            variable.name.accept(this);

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

        void visit(Definition.IMPORT import_) is
            dent();

            append("import ");

            var seen_any = false;
            foreach var i; import_.imports do
                if seen_any then
                    append(", ");
                fi

                i.accept(this);

                seen_any = true;
            od

            append(';');

            nl();            
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

        void visit(Definition.USE use_) is
            dent();

            append("use ");

            var seen_any = false;
            foreach var u; use_.uses do
                if seen_any then
                    append(", ");
                fi

                u.accept(this);

                seen_any = true;
            od

            append(';');

            nl();            
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

            class_.modifiers.accept(this);

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

            interface_.modifiers.accept(this);            

            append(" is\n");

            in();
            interface_.body.accept(this);
            out();

            dent_append("si\n");
        si       

        void after_body(Body.NODE node) is
            if node == null || !node.is_block then
                append(";\n");
            else
                append("\n");
            fi
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
                
                function.modifiers.accept(this);
            elif !function.modifiers.is_empty then
                function.modifiers.accept(this);
            fi

            if function.body != null then                
                append(' ');
                function.body.accept(this);
            fi

            after_body(function.body);
        si

        void append_member_type_and_modifiers(
            Type.NODE type,
            Modifier.LIST modifiers
        ) is
            if !isa Type.INFER(type) then
                append(": ");
                type.accept(this);
                append(" ");
                modifiers.accept(this);
            elif !modifiers.is_empty then
                modifiers.accept(this);
            fi
        si

        bool indent_property(bool has_getter, bool has_setter) is
            if has_getter && has_setter != null then
                in();
                nl();
                dent();

                return true;
            elif has_getter || has_setter != null then
                append(" ");
            fi

            return false;            
        si

        void visit(Definition.PROPERTY property) is
            dent();

            property.name.accept(this);

            append_member_type_and_modifiers(property.type, property.modifiers);

            var out_again = indent_property(property.getter_body != null, property.setter_body != null);

            if property.getter_body != null then
                property.getter_body.accept(this);

                if property.setter_body != null then
                    append(",\n");
                    dent();
                else
                    after_body(property.getter_body);                
                fi           
            else
                append(' ');
            fi

            if property.setter_body != null then
                append("= ");
                property.setter_argument.accept(this);

                property.setter_body.accept(this);
                after_body(property.setter_body);           
            fi

            if out_again then
                out();
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

            append_member_type_and_modifiers(indexer.type, indexer.modifiers);

            var out_again = indent_property(indexer.getter_body != null, indexer.setter_body != null);

            if indexer.getter_body != null then
                indexer.getter_body.accept(this);

                if indexer.setter_body != null then
                    append(",\n");
                    dent();
                else
                    after_body(indexer.getter_body);                
                fi
            else
                append(' ');
            fi

            if indexer.setter_body != null then
                append("= ");
                indexer.setter_argument.accept(this);
                append(' ');

                indexer.setter_body.accept(this);
                after_body(indexer.setter_body);
            fi

            if out_again then
                out();
            fi                        
        si
        
                    
        // types

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

        void visit(Expression.NULL null_) is
            append("null");
        si        
        
        void visit(Expression.SELF self_) is
            append("self");
        si        

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

        void visit(Expression.SEQUENCE sequence) is
            append('[');

            sequence.elements.accept(this);

            append(']');

            if !isa Tree.Type.INFER(sequence.type) then
                append(": ");
                sequence.type.accept(this);
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

            dent_append("od\n"); 
        si

        // function body

        void visit(Body.EXPRESSION expression) is
            append("=> ");
            expression.expression.accept(this);
        si

        void visit(Body.BLOCK block) is
            append("is\n");
            in();
            block.statements.accept(this);
            out();
            dent_append("si");
        si            
    si
si si si
    

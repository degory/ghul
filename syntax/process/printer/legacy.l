namespace Syntax is namespace Process is namespace Printer is
    use System;

    use Logging;
    use Source;
    use Tree;

    class LEGACY isa BASE is
        LOGGER _logger;

        void init(LOGGER logger) is
            super.init(true);

            IO.Std.err.println("initialized legacy printer");

            IO.Std.err.flush();

            _logger = logger;
        si

        void error(LOCATION location, String message) is
            _logger.error(location, message);
        si

        void apply(NODE node) is
            node.accept(this);
        si

        void append(LOCATION location, Type.NODE type) is
            if !isa Type.INFER(type) then
                type.accept(this);
            else
                _logger.warn(location, "legacy compiler cannot infer type here, assuming void");
                append("void");
            fi
        si

        // Identifiers

        void append_name(String name) is
            var c = name[0];

            if 
                (c >= 'a' && c <= 'z') ||
                (c >= 'A' && c <= 'Z') ||
                c == '_'
            then
                append(name);
            else
                append("operator");
                append(name);
            fi
        si

        // definitions

        void visit(Variable.NODE variable) is
            // FIXME: not OOP
            if !isa Type.INFER(variable.type) then
                variable.type.accept(this);
                append(' ');
            else
                append("var ");
            fi

            variable.name.accept(this);

            if variable.initializer != null then
                append(" = ");
                variable.initializer.accept(this);
            fi
        si

        void visit(Definition.IMPORT import_) is
            foreach var i; import_.imports do
                dent();

                append("import ");

                i.accept(this);

                append(';');

                nl();            
            od
        si        
        
        void visit(Definition.NAMESPACE namespace_) is
            dent();

            var seen_any = false;

            foreach var ns; namespace_.name do
                if seen_any then
                    append(' ');
                fi

                append("namespace ");
                append(ns);
                append(" is");

                seen_any = true;
            od

            nl();
            in();
            namespace_.body.accept(this);
            out();

            seen_any = false;

            foreach var ns; namespace_.name do
                if seen_any then
                    append(' ');
                fi

                append("si");

                seen_any = true;
            od            

            nl();
        si

        void visit(Definition.USE use_) is
            foreach var u; use_.uses do
                dent();

                append("use ");

                u.accept(this);

                append(';');

                nl();            
            od
        si        

        void visit(Definition.CLASS class_) is
            dent_append("class ");

            class_.name.accept(this);

            if class_.arguments != null then 
                append('<');
                class_.arguments.accept(this);
                append('>');
            fi

            if class_.ancestors != null then
                var count = 0;;

                foreach var ancestor; class_.ancestors do

                    // FIXME: this is a bodge - can't accurately map ghul syntax on to L here
                    // without a symbol table:
                    if count == 0 then
                        append(" isa ");
                    elif count == 1 then
                        append(" do ");
                    else
                        append(", ");
                    fi

                    ancestor.accept(this);

                    count = count + 1;
                od
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
                append('<');
                interface_.arguments.accept(this);
                append('>');
            fi

            if interface_.ancestors != null then
                append("do ");

                interface_.ancestors.accept(this);
            fi

            append(" is\n");
            in();
            interface_.body.accept(this);
            out();
            dent_append("si\n");
        si

        void append_newline_after_body(Body.NODE body) is
            if !body.is_block then
                // non-block body doesn't add a newline, but we always want one:
                nl();
            fi
        si

        void visit(Definition.FUNCTION function) is
            dent();

            if function.modifiers != null then
                function.modifiers.accept(this);
                append(' ');
            fi

            append(function.location, function.type);

            append(' ');
            
            function.name.accept(this);
            append('(');
            function.arguments.accept(this);
            append(')');

            if function.body != null then
                append(' ');
                function.body.accept(this);
                nl();
            fi
        si

        void append_getter_modifiers(Modifier.LIST modifiers, Identifier.NODE name) is
            if modifiers.is_explicit_access then
                modifiers.access_modifier.accept(this);
                append(' ');
            elif name != null && name.name.startsWith('_') then
                append("private ");
            fi

            if modifiers.storage_class != null then
                modifiers.storage_class.accept(this);
                append(' ');
            fi
        si

        void append_setter_modifiers(Modifier.LIST modifiers) is
            if modifiers.is_explicit_access then
                modifiers.access_modifier.accept(this);
                append(' ');
            else
                append("private ");
            fi

            if modifiers.storage_class != null then
                modifiers.storage_class.accept(this);
                append(' ');
            fi                    
        si

        void append_backing_field_modifiers(Modifier.LIST modifiers) is
            append("private ");

            if modifiers.storage_class != null then
                modifiers.storage_class.accept(this);
                append(' ');
            fi
        si

        void visit(Definition.PROPERTY property) is
            // FIXME: not sure how this would work for interfaces
            if property.getter_body != null || property.setter_body != null then

                if property.getter_body != null then
                    dent();

                    append_getter_modifiers(property.modifiers, property.name);

                    append("get ");

                    append(property.location, property.type);

                    append(' ');

                    property.name.accept(this);

                    append(' ');
        
                    property.getter_body.accept(this);
                    nl();
                fi

                if property.setter_body != null then
                    dent();

                    append_setter_modifiers(property.modifiers);

                    append("set ");

                    append(property.location, property.type);

                    append(' ');

                    property.name.accept(this);

                    append(' ');
                    
                    append(" = ");
                    property.setter_argument.accept(this);
                    append(' ');

                    property.setter_body.accept(this);
                    nl();
                fi
            elif !property.name.name.startsWith('_') && !property.modifiers.is_private then
                // auto property:

                dent();

                append_backing_field_modifiers(property.modifiers);
                
                append(property.location, property.type);
                
                append(" _");
                property.name.accept(this);
                append(";\n");

                dent();

                append_getter_modifiers(property.modifiers, property.name);

                append("get ");
                append(property.location, property.type);
                append(" ");
                property.name.accept(this);
                append(" is return _");
                property.name.accept(this);
                append("; si\n");

                dent();

                append_setter_modifiers(property.modifiers);
                
                append("set ");
                append(property.location, property.type);
                append(" ");
                property.name.accept(this);
                append(" = __value is _");
                property.name.accept(this);
                append(" = __value; si\n");                
            else 
                dent();

                property.modifiers.accept(this);

                append(property.location, property.type);
                
                append(" ");
                property.name.accept(this);
                append(";\n");
            fi
        si

        void visit(Definition.INDEXER indexer) is
            if indexer.getter_body != null || indexer.setter_body != null then
                if indexer.getter_body != null then
                    dent();
                    append_getter_modifiers(indexer.modifiers, indexer.name);
                    
                    append("get ");

                    append(indexer.location, indexer.type);

                    if indexer.name != null then
                        append(' ');

                        indexer.name.accept(this);
                    fi

                    append("[");

                    indexer.index_argument.accept(this);

                    append("]");
        
                    indexer.getter_body.accept(this);
                    nl();
                fi

                if indexer.setter_body != null then
                    dent();

                    append_setter_modifiers(indexer.modifiers);

                    append("set ");

                    append(indexer.location, indexer.type);

                    if indexer.name != null then
                        append(' ');

                        indexer.name.accept(this);
                    fi

                    append("[");

                    indexer.index_argument.accept(this);

                    append("] =");

                    indexer.setter_argument.accept(this);
        
                    indexer.setter_body.accept(this);
                    nl();
                fi
            else
                error(indexer.location, "indexer must have at at least read or assign body");
            fi
        si
                            
        // types

        void visit(Type.BUILT_IN type) is
            append(type.name);
        si

        void visit(Type.ARRAY array) is
            array.element.accept(this);
            append("[]");
        si

        void visit(Type.POINTER pointer) is
            pointer.element.accept(this);
            append(" ptr");
        si

        void visit(Type.REFERENCE reference) is
            reference.element.accept(this);
            append(" ref");
        si

        void visit(Type.NAMED named) is
            named.name.accept(this);
        si

        void visit(Type.GENERIC generic) is
            generic.name.accept(this);
            append('<');

            generic.arguments.accept(this);

            append('>');
        si

        void visit(Type.FUNCTION function) is
            append(function.location, function.result);

            append(" proc(");

            function.arguments.accept(this);

            append(")");
        si

        void visit(Type.TUPLE tuple) is
            append("(");

            tuple.elements.accept(this);

            append(")");
        si

/*
        void visit(Type.NAMED_TUPLE_ELEMENT element) is
            error(element.location, "legacy compiler does not support tuples");
        si      
*/
        void visit(Type.LIST types) is
            var seen_any = false;
            foreach var t; types.Iterator do
                if seen_any then
                    append(',');
                fi

                t.accept(this);

                seen_any = true;
            od
        si

        // expression 

        void visit(Expression.NULL null_) is
            append("null");
        si        

        void visit(Expression.SELF self_) is
            append("this");
        si

        void visit(Expression.NEW new_) is
            location(new_);
            append("new ");

            if isa Tree.Type.ARRAY(new_.type) then
                cast Tree.Type.ARRAY(new_.type).element.accept(this);
                append('[');
                new_.arguments.elements.accept(this);
                append(']');
            else
                new_.type.accept(this);
                new_.arguments.accept(this);
            fi
        si        

        void visit(Expression.UNARY unary) is
            location(unary);

            append(unary.operation.name);
            append(' ');

            unary.right.accept(this);
        si

        void visit(Expression.BINARY binary) is
            location(binary);

            binary.left.accept(this);
            append(' ');
            append(binary.operation.name);
            append(' ');            
            binary.right.accept(this);
        si

        void visit(Expression.VARIABLE variable) is
            if !isa Type.INFER(variable.type) then
                variable.type.accept(this);
                append(' ');
            else
                _logger.error(variable.location, "legacy compiler cannot infer type here");
            fi

            variable.identifier.accept(this);

            if variable.initializer != null then
                append(" = ");

                variable.initializer.accept(this);
            fi
        si
        
        /*
        void visit(Expression.VARIABLE variable) is
            error(variable.location, "legacy compiler does not support tuples");
        si
        */

        void visit(Syntax.Tree.Expression.FUNCTION function) is
            append(function.location, function.type);

            append(" proc");

            function.arguments.accept(this);

            append(" ");

            function.body.accept(this);
        si

        void visit(Expression.SEQUENCE sequence) is
            if !isa Tree.Type.INFER(sequence.type) then
                sequence.type.accept(this);
            fi        

            append('{');

            sequence.elements.accept(this);

            append('}');
        si            

        void visit(Expression.HAS_VALUE has_value) is
            append("((");
            has_value.left.accept(this);
            append(")!=null)");
        si

        // Statements

        void visit(Statement.LET l) is
            // dent_append("var ");
            l.variables.accept(this);
            append(";");
            nl();
        si

        void visit(Statement.CASE_MATCH match) is
            dent();

            if match.expression != null then
                append("is ");

                match.expression.accept(this);

                append(":\n");
            else
                append("default:\n");
            fi

            in();
            match.statements.accept(this);
            out();
        si

        void visit(Statement.FOR for_) is
            dent_append("foreach ");

            for_.variable.accept(this);

            append("; ");

            for_.expression.accept(this);

            append(" do\n");

            in();
            for_.body.accept(this);
            out();

            dent_append("od\n"); 
        si

        // function body

        void visit(Body.EXPRESSION expression) is
            append(" is return ");
            expression.expression.accept(this);
            append("; si");
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
    

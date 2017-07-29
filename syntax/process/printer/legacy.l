namespace Syntax is namespace Process is namespace Printer is
    use System;

    use Logging;
    use Source;
    use Tree;

    class LEGACY isa BASE is
        LOGGER _logger;

        void init(LOGGER logger) is
            super.init();

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
                error(location, "legacy compiler cannot infer type here");
            fi
        si

        // Identifiers


        // definitions

        void visit(Variable.NODE variable) is
            // FIXME: not OOP
            if !isa Type.INFER(variable.type) then
                variable.type.accept(this);
                append(' ');
            fi

            variable.identifier.accept(this);

            if variable.initializer != null then
                append(" = ");
                variable.initializer.accept(this);
            fi
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

        void visit(Definition.FUNCTION function) is
            dent();

            append(function.location, function.type);

            append(' ');
            
            function.name.accept(this);
            append('(');
            function.arguments.accept(this);
            append(')');

            if function.body != null then
                append(' ');
                function.body.accept(this);
            fi
        si

        void visit(Definition.PROPERTY property) is
            // FIXME: not sure how this would work for interfaces
            if property.getter_body != null || property.setter_body != null then
                if property.getter_body != null then
                    dent_append("get ");

                    append(property.location, property.type);

                    append(' ');

                    property.name.accept(this);

                    append(' ');
        
                    property.getter_body.accept(this);
                fi

                if property.setter_body != null then
                    dent_append("set ");

                    append(property.location, property.type);

                    append(' ');

                    property.name.accept(this);

                    append(' ');
                    
                    append(" = ");
                    property.setter_argument.accept(this);
                    append(' ');

                    property.setter_body.accept(this);
                fi
            else
                // auto property:
                dent();
                append(property.location, property.type);
                append(" _");
                property.name.accept(this);
                append(";\n");

                dent();
                append("private set ");
                append(property.location, property.type);
                append(" ");
                property.name.accept(this);
                append(" = ");
                property.setter_argument.accept(this);
                append("is _");
                property.name.accept(this);
                append(" = ");
                property.setter_argument.accept(this);
                append("; si\n");

                dent();
                append("get ");
                append(property.location, property.type);
                append(" ");
                property.name.accept(this);
                append("is return _");
                property.name.accept(this);
                append("; si\n");
            fi
        si

        void visit(Definition.INDEXER indexer) is
            if indexer.getter_body != null || indexer.setter_body != null then
                if indexer.getter_body != null then
                    dent_append("get ");

                    append(indexer.location, indexer.type);

                    if indexer.name != null then
                        append(' ');

                        indexer.name.accept(this);
                    fi

                    append("[");

                    indexer.index_argument.accept(this);

                    append("] ");
        
                    indexer.getter_body.accept(this);
                fi

                if indexer.setter_body != null then
                    dent_append("set ");

                    append(indexer.location, indexer.type);

                    if indexer.name != null then
                        append(' ');

                        indexer.name.accept(this);
                    fi

                    append("[");

                    indexer.index_argument.accept(this);

                    append("] = ");

                    indexer.setter_argument.accept(this);
        
                    indexer.setter_body.accept(this);
                fi
            else
                error(indexer.location, "indexer must have at at least read or assign body");
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

        void visit(Type.NAMED_TUPLE_ELEMENT element) is
            error(element.location, "legacy compiler does not support tuples");
        si      

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

        void visit(Expression.VARIABLE variable) is
            error(variable.location, "legacy compiler does not support tuples");
        si

        void visit(Syntax.Tree.Expression.FUNCTION function) is
            append(function.location, function.type);

            append(" proc");

            function.arguments.accept(this);

            append(" ");

            function.body.accept(this);
        si

        void visit(Expression.LIST_LITERAL list) is
            if !isa Tree.Type.INFER(list.type) then
                list.type.accept(this);
            fi        

            append('{');

            list.elements.accept(this);

            append('}');
        si            

        void visit(Expression.HAS_VALUE has_value) is
            append("((");
            has_value.left.accept(this);
            append(")!=null)");
        si

        // Statements

        void visit(Statement.LET l) is
            dent();
            append("var ");
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
            dent();
            append("foreach ");

            for_.variable.accept(this);

            append("; ");

            for_.expression.accept(this);

            append(" do\n");

            in();
            for_.body.accept(this);
            out();

            append("od\n"); 
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
            dent();
            append("si");
        si            
    si
si si si
    

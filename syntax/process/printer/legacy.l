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

        void print(LOCATION location, Type.NODE type) is
            if !isa Type.INFER(type) then
                type.accept(this);
            else
                _logger.warn(location, "legacy compiler cannot infer type here, assuming void");
                print("void");
            fi
        si

        // Identifiers

        void print_name(String name) is
            var c = name[0];

            if 
                (c >= 'a' && c <= 'z') ||
                (c >= 'A' && c <= 'Z') ||
                c == '_'
            then
                print(name);
            else
                print("operator");
                print(name);
            fi
        si

        // definitions

        void visit(Variable.NODE variable) is
            // FIXME: not OOP
            if !isa Type.INFER(variable.type) then
                variable.type.accept(this);
                print(' ');
            else
                print("var ");
            fi

            variable.name.accept(this);

            if variable.initializer != null then
                print(" = ");
                variable.initializer.accept(this);
            fi
        si

        void visit(Definition.IMPORT import_) is
            foreach var i; import_.imports do
                print("import ");

                i.accept(this);

                println(";");
            od
        si        
        
        void visit(Definition.NAMESPACE namespace_) is
            var seen_any = false;

            foreach var ns; namespace_.name do
                if seen_any then
                    print(' ');
                fi

                print("namespace ");
                print(ns);
                print(" is");

                seen_any = true;
            od

            println();
            indent();
            namespace_.body.accept(this);
            outdent();

            seen_any = false;

            foreach var ns; namespace_.name do
                if seen_any then
                    print(' ');
                fi

                print("si");

                seen_any = true;
            od            

            println();
        si

        void visit(Definition.USE use_) is
            foreach var u; use_.uses do
                print("use ");

                u.accept(this);

                println(";");
            od
        si        

        void visit(Definition.CLASS class_) is
            print("class ");

            class_.name.accept(this);

            if class_.arguments != null then 
                print('<');
                class_.arguments.accept(this);
                print('>');
            fi

            if class_.ancestors != null then
                var count = 0;;

                foreach var ancestor; class_.ancestors do

                    // FIXME: this is a bodge - can't accurately map ghul syntax on to L here
                    // without a symbol table:
                    if count == 0 then
                        print(" isa ");
                    elif count == 1 then
                        print(" do ");
                    else
                        print(", ");
                    fi

                    ancestor.accept(this);

                    count = count + 1;
                od
            fi

            println(" is");
            indent();
            class_.body.accept(this);
            outdent();
            println("si");
        si

        void visit(Definition.INTERFACE interface_) is
            print("interface ");
            interface_.name.accept(this);

            if interface_.arguments != null then
                print('<');
                interface_.arguments.accept(this);
                print('>');
            fi

            if interface_.ancestors != null then
                print("do ");

                interface_.ancestors.accept(this);
            fi

            println(" is");
            indent();
            interface_.body.accept(this);
            outdent();
            println("si");
        si

        void print_newline_after_body(Body.NODE body) is
            if !body.is_block then
                // non-block body doesn't add a newline, but we always want one:
                println();
            fi
        si

        void visit(Definition.FUNCTION function) is
            if function.modifiers != null then
                function.modifiers.accept(this);
                print(' ');
            fi

            print(function.location, function.type);

            print(' ');
            
            function.name.accept(this);
            print('(');
            function.arguments.accept(this);
            print(')');

            if function.body != null then
                print(' ');
                function.body.accept(this);
                println();
            fi
        si

        void print_getter_modifiers(Modifier.LIST modifiers, Identifier.NODE name) is
            if modifiers.is_explicit_access then
                modifiers.access_modifier.accept(this);
                print(' ');
            elif name != null && name.name.startsWith('_') then
                print("private ");
            fi

            if modifiers.storage_class != null then
                modifiers.storage_class.accept(this);
                print(' ');
            fi
        si

        void print_setter_modifiers(Modifier.LIST modifiers) is
            if modifiers.is_explicit_access then
                modifiers.access_modifier.accept(this);
                print(' ');
            else
                print("private ");
            fi

            if modifiers.storage_class != null then
                modifiers.storage_class.accept(this);
                print(' ');
            fi                    
        si

        void print_backing_field_modifiers(Modifier.LIST modifiers) is
            print("private ");

            if modifiers.storage_class != null then
                modifiers.storage_class.accept(this);
                print(' ');
            fi
        si

        void visit(Definition.PROPERTY property) is
            // FIXME: not sure how this would work for interfaces
            if property.getter_body != null || property.setter_body != null then

                if property.getter_body != null then
                    print_getter_modifiers(property.modifiers, property.name);

                    print("get ");

                    print(property.location, property.type);

                    print(' ');

                    property.name.accept(this);

                    print(' ');
        
                    property.getter_body.accept(this);

                    println();
                fi

                if property.setter_body != null then
                    print_setter_modifiers(property.modifiers);

                    print("set ");

                    print(property.location, property.type);

                    print(' ');

                    property.name.accept(this);

                    print(' ');
                    
                    print(" = ");
                    property.setter_argument.accept(this);
                    print(' ');

                    property.setter_body.accept(this);
                    println();
                fi
            elif !property.name.name.startsWith('_') && !property.modifiers.is_private then
                // auto property:

                print_backing_field_modifiers(property.modifiers);
                
                print(property.location, property.type);
                
                print(" _");
                property.name.accept(this);
                println(";");

                print_getter_modifiers(property.modifiers, property.name);

                print("get ");
                print(property.location, property.type);
                print(" ");
                property.name.accept(this);
                print(" is return _");
                property.name.accept(this);
                println("; si");

                print_setter_modifiers(property.modifiers);
                
                print("set ");
                print(property.location, property.type);
                print(" ");
                property.name.accept(this);
                print(" = __value is _");
                property.name.accept(this);
                println(" = __value; si");                
            else 
                property.modifiers.accept(this);

                print(property.location, property.type);
                
                print(" ");
                property.name.accept(this);
                println(";");
            fi
        si

        void visit(Definition.INDEXER indexer) is
            if indexer.getter_body != null || indexer.setter_body != null then
                if indexer.getter_body != null then
                    print_getter_modifiers(indexer.modifiers, indexer.name);
                    
                    print("get ");

                    print(indexer.location, indexer.type);

                    if indexer.name != null then
                        print(' ');

                        indexer.name.accept(this);
                    fi

                    print("[");

                    indexer.index_argument.accept(this);

                    print("]");
        
                    indexer.getter_body.accept(this);
                    println();
                fi

                if indexer.setter_body != null then
                    print_setter_modifiers(indexer.modifiers);

                    print("set ");

                    print(indexer.location, indexer.type);

                    if indexer.name != null then
                        print(' ');

                        indexer.name.accept(this);
                    fi

                    print("[");

                    indexer.index_argument.accept(this);

                    print("] =");

                    indexer.setter_argument.accept(this);
        
                    indexer.setter_body.accept(this);
                    println();
                fi
            else
                error(indexer.location, "indexer must have at at least read or assign body");
            fi
        si
                            
        // types

        void visit(Type.BUILT_IN type) is
            print(type.name);
        si

        void visit(Type.ARRAY array) is
            array.element.accept(this);
            print("[]");
        si

        void visit(Type.POINTER pointer) is
            pointer.element.accept(this);
            print(" ptr");
        si

        void visit(Type.REFERENCE reference) is
            reference.element.accept(this);
            print(" ref");
        si

        void visit(Type.NAMED named) is
            named.name.accept(this);
        si

        void visit(Type.GENERIC generic) is
            generic.name.accept(this);
            print('<');

            generic.arguments.accept(this);

            print('>');
        si

        void visit(Type.FUNCTION function) is
            print(function.location, function.result);

            print(" proc(");

            function.arguments.accept(this);

            print(")");
        si

        void visit(Type.TUPLE tuple) is
            print("(");

            tuple.elements.accept(this);

            print(")");
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
                    print(',');
                fi

                t.accept(this);

                seen_any = true;
            od
        si

        // expression 

        void visit(Expression.NULL null_) is
            print("null");
        si        

        void visit(Expression.SELF self_) is
            print("this");
        si

        void visit(Expression.NEW new_) is
            location(new_);
            print("new ");

            if isa Tree.Type.ARRAY(new_.type) then
                cast Tree.Type.ARRAY(new_.type).element.accept(this);
                print('[');
                new_.arguments.elements.accept(this);
                print(']');
            else
                new_.type.accept(this);
                new_.arguments.accept(this);
            fi
        si        

        void visit(Expression.UNARY unary) is
            location(unary);

            print(unary.operation.name);
            print(' ');

            unary.right.accept(this);
        si

        void visit(Expression.BINARY binary) is
            location(binary);

            binary.left.accept(this);
            print(' ');
            print(binary.operation.name);
            print(' ');            
            binary.right.accept(this);
        si

        void visit(Expression.VARIABLE variable) is
            if !isa Type.INFER(variable.type) then
                variable.type.accept(this);
                print(' ');
            else
                _logger.error(variable.location, "legacy compiler cannot infer type here");
            fi

            variable.identifier.accept(this);

            if variable.initializer != null then
                print(" = ");

                variable.initializer.accept(this);
            fi
        si
        
        /*
        void visit(Expression.VARIABLE variable) is
            error(variable.location, "legacy compiler does not support tuples");
        si
        */

        void visit(Syntax.Tree.Expression.FUNCTION function) is
            print(function.location, function.type);

            print(" proc");

            function.arguments.accept(this);

            print(" ");

            function.body.accept(this);
        si

        void visit(Expression.SEQUENCE sequence) is
            if !isa Tree.Type.INFER(sequence.type) then
                sequence.type.accept(this);
            fi        

            print('{');

            sequence.elements.accept(this);

            print('}');
        si            

        void visit(Expression.HAS_VALUE has_value) is
            print("((");
            has_value.left.accept(this);
            print(")!=null)");
        si

        // Statements

        void visit(Statement.LET l) is
            // print("var ");
            l.variables.accept(this);
            println(";");
        si

        void visit(Statement.CASE_MATCH match) is
            if match.expressions != null then
                print("is ");

                match.expressions.accept(this);

                println(":");
            else
                println("default:");
            fi

            indent();
            match.statements.accept(this);
            outdent();
        si

        void visit(Statement.FOR for_) is
            print("foreach ");

            for_.variable.accept(this);

            print("; ");

            for_.expression.accept(this);

            println(" do");

            indent();
            for_.body.accept(this);
            outdent();

            println("od"); 
        si

        // function body

        void visit(Body.EXPRESSION expression) is
            print(" is return ");
            expression.expression.accept(this);
            print("; si");
        si

        void visit(Body.BLOCK block) is
            println("is");
            indent();
            block.statements.accept(this);
            outdent();
            print("si");
        si            
    si
si si si
    

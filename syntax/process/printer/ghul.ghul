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
                print(": ");                    
                variable.type.accept(this);
            fi

            if variable.initializer != null then
                print(" = ");
                variable.initializer.accept(this);
            fi
        si

        void visit(Definition.IMPORT import_) is
            print("import ");

            var seen_any = false;
            foreach var i; import_.imports do
                if seen_any then
                    print(", ");
                fi

                i.accept(this);

                seen_any = true;
            od

            println(";");
        si        
        
        void visit(Definition.NAMESPACE namespace_) is
            print("namespace ");

            namespace_.name.accept(this);

            println(" is");

            indent();
            namespace_.body.accept(this);
            outdent();

            println("si");
        si            

        void visit(Definition.USE use_) is
            print("use ");

            var seen_any = false;
            foreach var u; use_.uses do
                if seen_any then
                    print(", ");
                fi

                u.accept(this);

                seen_any = true;
            od

            println(";");
        si        

        void visit(Definition.CLASS class_) is
            print("class ");

            class_.name.accept(this);

            if class_.arguments != null then 
                print("[");
                class_.arguments.accept(this);
                print("]");
            fi

            if class_.ancestors != null then                    
                print(": ");

                class_.ancestors.accept(this);
            fi

            class_.modifiers.accept(this);

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
                print("[");
                interface_.arguments.accept(this);
                print("]");
            fi

            if interface_.ancestors != null then
                print(": ");

                interface_.ancestors.accept(this);
            fi

            interface_.modifiers.accept(this);            

            println(" is");

            indent();
            interface_.body.accept(this);
            outdent();

            println("si");
        si       

        void after_body(Body.NODE node) is
            if node == null || !node.is_block then
                print(";");
            fi

            println();
        si

        void visit(Definition.FUNCTION function) is
            function.name.accept(this);
            
            print("(");
            function.arguments.accept(this);
            print(")");

            if !isa Type.INFER(function.type) then
                print(" -> ");
                function.type.accept(this);
                
                function.modifiers.accept(this);
            elif !function.modifiers.is_empty then
                function.modifiers.accept(this);
            fi

            if function.body != null then                
                print(" ");
                function.body.accept(this);
            fi

            after_body(function.body);
        si

        void print_member_type_and_modifiers(
            Type.NODE type,
            Modifier.LIST modifiers
        ) is
            if !isa Type.INFER(type) then
                print(": ");
                type.accept(this);
                print(" ");
                modifiers.accept(this);
            elif !modifiers.is_empty then
                modifiers.accept(this);
            fi
        si

        bool indent_property(bool has_getter, bool has_setter) is
            if has_getter && has_setter != null then
                println();
                indent();

                return true;
            elif has_getter || has_setter != null then
                print(" ");
            fi

            return false;            
        si

        void visit(Definition.PROPERTY property) is
            property.name.accept(this);

            print_member_type_and_modifiers(property.type, property.modifiers);

            var out_again = indent_property(property.getter_body != null, property.setter_body != null);

            if property.getter_body != null then
                property.getter_body.accept(this);

                if property.setter_body != null then
                    println(",");
                else
                    after_body(property.getter_body);                
                fi           
            else
                print(" ");
            fi

            if property.setter_body != null then
                print("= ");
                property.setter_argument.accept(this);

                property.setter_body.accept(this);
                after_body(property.setter_body);           
            fi

            if out_again then
                outdent();
            fi            
        si

        void visit(Definition.INDEXER indexer) is
            if indexer.name != null then
                indexer.name.accept(this);
            fi

            print("[");
            indexer.index_argument.accept(this);
            print("]");

            print_member_type_and_modifiers(indexer.type, indexer.modifiers);

            var out_again = indent_property(indexer.getter_body != null, indexer.setter_body != null);

            if indexer.getter_body != null then
                indexer.getter_body.accept(this);

                if indexer.setter_body != null then
                    println(",");
                else
                    after_body(indexer.getter_body);                
                fi
            else
                print(' ');
            fi

            if indexer.setter_body != null then
                print("= ");
                indexer.setter_argument.accept(this);
                print(' ');

                indexer.setter_body.accept(this);
                after_body(indexer.setter_body);
            fi

            if out_again then
                outdent();
            fi                        
        si
        
                    
        // types

        void visit(Type.GENERIC generic) is
            generic.name.accept(this);
            print('[');

            generic.arguments.accept(this);

            print(']');
        si

        void visit(Type.FUNCTION function) is
            print("(");

            function.arguments.accept(this);

            print(")");

            if !isa Type.INFER(function.result) then
                print(" -> ");
                function.result.accept(this);
            fi
        si

        void visit(Type.TUPLE tuple) is
            print("(");

            tuple.elements.accept(this);

            print(")");
        si

        void visit(Type.NAMED_TUPLE_ELEMENT element) is
            element.name.accept(this);
            print(": ");
            element.type.accept(this);
        si      

        // expression 

        void visit(Expression.NULL null_) is
            print("null");
        si        
        
        void visit(Expression.SELF self_) is
            print("self");
        si        

        void visit(Expression.VARIABLE variable) is
            variable.identifier.accept(this);

            if !isa Type.INFER(variable.type) then
                print(": ");

                variable.type.accept(this);
            fi

            if variable.initializer != null then
                print( " = ");

                variable.initializer.accept(this);
            fi
        si

        void visit(Syntax.Tree.Expression.FUNCTION function) is
            function.arguments.accept(this);

            if !isa Type.INFER(function.type) then
                print(" -> ");

                function.type.accept(this);
            fi

            function.body.accept(this);
        si

        void visit(Expression.SEQUENCE sequence) is
            print('[');

            sequence.elements.accept(this);

            print(']');

            if !isa Tree.Type.INFER(sequence.type) then
                print(": ");
                sequence.type.accept(this);
            fi
        si

        void visit(Expression.HAS_VALUE has_value) is
            has_value.left.accept(this);
            print("?");
        si        

        // Statements

        void visit(Statement.LET l) is
            print("let ");
            l.variables.accept(this);
            println(";");
        si

        void visit(Statement.FOR for_) is
            println("for ");

            for_.variable.accept(this);

            print(" in ");

            for_.expression.accept(this);

            println(" do");

            indent();
            for_.body.accept(this);
            outdent();

            println("od"); 
        si

        // function body

        void visit(Body.EXPRESSION expression) is
            print("=> ");
            expression.expression.accept(this);
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
    

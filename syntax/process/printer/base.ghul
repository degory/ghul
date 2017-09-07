namespace Syntax is namespace Process is namespace Printer is
    use System;
    use Tree;

    use Source;

    class BASE isa StrictVisitor is
        int _indent;
        int _depth;

        bool _run_on;

        bool _indent_needed;

        bool _want_locations;

        int _current_line;

        StringBuffer _result;

        void init(bool want_locations) is
            super.init();

            _want_locations = want_locations;

            _depth = 0;
            _indent = 2;
            
            _result = new StringBuffer();

            _current_line = 1;
        si

        get String result is
            return _result;
        si

        void println(String string) is
            print(string);
            println();
        si        
        
        void print(String string) is
            print_indent();
            _result.append(string);
        si        

        void print(char c) is
            print_indent();
            _result.append(c);
        si

        void println() is
            _current_line = _current_line + 1;
            _indent_needed = true;
            _result.append('\n');
        si
        
        void indent() is
            _depth = _depth + 1;
        si

        void outdent() is
            _depth = _depth - 1;
        si

        void print_indent() is
            if _indent_needed then
                for var i = 0; i < _indent * _depth; i = i + 1 do
                    _result.append(' ');
                od

                _indent_needed = false;
            fi
        si

        void location(NODE node) is
            location(node.location);
        si

        void location(LOCATION location) is
            var new_line = location.start_line;

            if new_line != _current_line then                
                _current_line = new_line;

                if _want_locations then
                    print("#" + _current_line + " ");
                fi
            fi
        si

        void print(NODE node) is
            node.accept(this);
        si

        // Identifiers

        void print_name(String name) is
            print(name);
        si

        void visit(Identifier.NODE identifier) is
            location(identifier);
            print_name(identifier.name);
        si

        void visit(Identifier.QUALIFIED identifier) is
            location(identifier);
            identifier.parent.accept(this);
            
            print('.');
            print_name(identifier.name);
        si

        // modifiers

        void visit(Modifier.NODE modifier) is
            location(modifier);
            print(modifier.name);
        si

        void visit(Modifier.LIST modifiers) is
            location(modifiers);
            if modifiers.access_modifier != null then
                modifiers.access_modifier.accept(this);
                print(' ');
            fi

            if modifiers.storage_class != null then
                modifiers.storage_class.accept(this);
                print(' ');
            fi
        si

        // definitions

        void visit(Variable.LIST variables) is
            location(variables);
            var first = true;

            foreach var v; variables do
                if !first then print(", "); fi

                v.accept(this);

                first = false;
            od
        si

        void visit(Definition.LIST definitions) is
            location(definitions);
            foreach var d; definitions do
                d.accept(this);
            od
        si

        void visit(Definition.ENUM enum_) is
            location(enum_);

            print("enum ");

            enum_.name.accept(this);
            println(" is");

            indent();

            var seen_any = false;

            foreach var member; enum_.members do
                if seen_any then
                    println(",");
                fi

                member.accept(this);

                seen_any = true;
            od

            println();

            outdent();

            println("si");
        si

        void visit(Definition.ENUM_MEMBER member) is
            location(member);
            
            member.name.accept(this);

            if member.initializer != null then
                print(" = ");

                member.initializer.accept(this);
            fi
        si

        void visit(Definition.FUNCTION_GROUP functions) is
            println("function group ");
            indent();
            foreach var f; functions.functions do
                f.accept(this);
            od
            outdent();
        si                           

        // types
        void visit(Type.INFER type) is
            print("infer");
        si

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

        void visit(Type.FUNCTION_GROUP functions) is
            print("function group ");
            foreach var f; functions.functions do
                f.accept(this);
                print(' ');
            od
        si

        void visit(Type.NAMED named) is
            location(named);
            named.name.accept(this);
        si

        void visit(Type.TUPLE tuple) is
            location(tuple);
            print("(");

            tuple.elements.accept(this);

            print(")");
        si

        void visit(Type.NAMED_TUPLE_ELEMENT element) is
            location(element);
            element.name.accept(this);
            print(": ");
            element.type.accept(this);
        si      

        void visit(Type.LIST types) is
            location(types);
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

        void visit(Expression.Literal.NONE none) is
            location(none);            
            print("none");
        si

        void visit(Expression.IDENTIFIER identifier) is
            location(identifier);
            identifier.identifier.accept(this);
        si

        void visit(Expression.SUPER super_) is
            location(super_);            
            print("super");
        si

        void visit(Expression.NEW new_) is
            location(new_);
            print("new ");

            new_.type.accept(this);
            new_.arguments.accept(this);
        si

        void visit(Expression.CAST cast_) is
            location(cast_);
            print("cast ");

            cast_.type.accept(this);

            print('(');
            cast_.right.accept(this);
            print(')');
        si

        void visit(Expression.ISA isa_) is
            location(isa_);
            print("isa ");

            isa_.type.accept(this);

            print('(');
            isa_.right.accept(this);
            print(')');
        si        

        void visit(Expression.TUPLE tuple) is
            location(tuple);            
            print('(');

            tuple.elements.accept(this);

            print(')');
        si

        void visit(Expression.CALL call) is
            location(call);
            call.function.accept(this);

            print('(');

            call.arguments.accept(this);

            print(')');
        si            

        void visit(Expression.MEMBER member) is
            location(member);
            member.left.accept(this);

            print('.');

            member.identifier.accept(this);
        si

        void visit(Expression.INDEX index) is
            location(index);
            index.left.accept(this);

            print('[');

            index.index.accept(this);

            print(']');
        si

        void visit(Expression.UNARY unary) is
            location(unary);

            unary.operation.accept(this);
            print(' ');

            unary.right.accept(this);
        si

        void visit(Expression.BINARY binary) is
            location(binary);

            binary.left.accept(this);
            print(' ');
            binary.operation.accept(this);
            print(' ');            
            binary.right.accept(this);
        si

        void visit(Expression.LIST expressions) is
            location(expressions);
            
            var seen_any = false;
            foreach var e; expressions do
                if seen_any then
                    print(',');
                fi

                e.accept(this);

                seen_any = true;
            od
        si

        void visit(Expression.Literal.NODE literal) is
            location(literal);
            
            print(literal.value);
        si

        void print_escape_char(char c) is            
            var ci = cast int(c);

            if ci == 9 then
                print("\t");
            elif ci == 10 then
                print("\n");
            elif ci == 13 then
                print("\r");
            elif ci < 32 then
                print("\\");

                var b = new StringBuffer(5);
                b.append(ci, 8);

                print(b);
            elif ci == 34 then
                print("\\");
                print(cast char(34));
            elif ci == 39 then
                print("\'");
            elif ci == 92 then
                print("\\\\");
            else
                print(c);
            fi
        si                

        void visit(Expression.Literal.STRING string) is
            location(string);
            
            // VS Code wigs out over L char escape sequences for some reason
            print(cast char(34));
            foreach var c; string.value do
                print_escape_char(c);
            od

            print(cast char(34));
        si

        void visit(Expression.Literal.CHARACTER character) is
            location(character);
            
            print("'");
            print_escape_char(character.value[0]);
            print("'");
        si

        // Statements

        void visit(Statement.LIST list) is
            location(list);
            
            foreach var s; list.Iterator do
                s.accept(this);
            od
        si

        void visit(Statement.ASSIGNMENT assign) is
            location(assign);

            assign.left.accept(this);
            print(" = ");
            assign.right.accept(this);
            println(";");
        si

        void visit(Statement.EXPRESSION expression) is
            location(expression);

            expression.expression.accept(this);
            println(";");
        si

        void visit(Statement.VAR v) is
            location(v);

            v.variables.accept(this);
            println(";");
        si

        void visit(Statement.RETURN r) is
            location(r);

            print("return");

            if r.expression != null then
                print(' ');
                r.expression.accept(this);
            fi

            println(";");
        si

        void visit(Statement.THROW t) is
            location(t);

            print("throw");

            if t.expression != null then
                print(' ');
                t.expression.accept(this);
            fi

            println(";");
        si        

        void visit(Statement.IF i) is
            location(i);
            
            var is_first = true;
            var seen_else = false;

            assert(i != null);
            assert(i.branches != null);

            foreach var b; i.branches do
                location(b);

                assert(!seen_else);

                if b.condition != null then
                    if is_first then
                        print("if ");
                    else
                        print("elif ");
                    fi

                    b.condition.accept(this);

                    println(" then");
                else
                    seen_else = true;

                    println("else");                    
                fi

                indent();
                b.body.accept(this);
                outdent();

                is_first = false;
            od

            println("fi");            
        si

        void visit(Statement.CASE case_) is
            location(case_);
            
            print("case ");

            case_.expression.accept(this);

            println();

            foreach var m; case_.matches do
                m.accept(this);
            od

            println("esac");
        si

        void visit(Statement.CASE_MATCH match) is
            location(match);
            
            if match.expressions != null then
                print("when ");

                match.expressions.accept(this);

                println(":");
            else
                println("default");
            fi

            indent();
            match.statements.accept(this);
            outdent();
        si

        void visit(Statement.TRY try_) is
            location(try_);
            
            println("try");

            indent();

            try_.body.accept(this);

            outdent();

            foreach var c; try_.catches do
                c.accept(this);
            od

            if try_.finally_ != null then
                println("finally");
                indent();
                try_.finally_.accept(this);
                outdent();
            fi

            println("yrt");
        si

        void visit(Statement.CATCH catch_) is
            location(catch_);
            
            print("catch ");

            catch_.variable.accept(this);

            println();

            indent();

            catch_.body.accept(this);

            outdent();
        si            

        void visit(Statement.DO do_) is
            location(do_);
            
            if do_.condition != null then
                print("while ");
                do_.condition.accept(this);
                print(" ");
            fi    

            println("do");
            indent();
            do_.body.accept(this);
            outdent();

            println("od"); 
        si

        void visit(Statement.LABELLED labelled) is
            location(labelled);

            labelled.label.accept(this);

            print(": ");

            labelled.statement.accept(this);
        si

        void visit(Statement.BREAK break_) is
            location(break_);
            
            print("break");
            if break_.label != null then
                print(' ');
                break_.label.accept(this);
            fi

            println(";");
        si

        void visit(Statement.CONTINUE continue_) is
            location(continue_);
            
            print("continue");
            if continue_.label != null then
                print(' ');
                continue_.label.accept(this);
            fi

            println(";");
        si            

        // function body
    si
si si si
    

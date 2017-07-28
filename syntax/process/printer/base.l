namespace Syntax is namespace Process is namespace Printer is
    use System;
    use Tree;

    class BASE isa Visitor is
        int _indent;
        int _depth;

        bool _run_on;

        StringBuffer _result;

        void init() is
            super.init();
            
            _result = new StringBuffer();
        si

        get String result is
            return _result;
        si

        StringBuffer append(String string) is
            return _result.append(string);
        si

        StringBuffer append(char c) is
            return _result.append(c);
        si

        void in() is
            _depth = _depth + 1;
        si

        void out() is
            _depth = _depth - 1;
        si

        void dent() is
            if _run_on then
                _run_on = false;
                return;
            fi

            foreach var i; 0.._depth do
                foreach var j; 0.._indent do
                    append(' ');
                od
            od
        si

        void run_on() is
            _run_on = true;
        si

        void nl() is
            append('\n');
        si

        StringBuffer dent_append(String string) is
            dent();
            return append(string);
        si

        void apply(NODE node) is
            node.accept(this);
        si

        // Identifiers

        void visit(Identifier.NODE identifier) is
            append(identifier.name);
        si

        void visit(Identifier.QUALIFIED identifier) is
            identifier.parent.accept(this);
            
            _result
                .append('.')
                .append(identifier.name);
        si

        // definitions

        void visit(Variable.LIST variables) is
            var first = true;

            foreach var v; variables do
                if !first then append(", "); fi

                v.accept(this);

                first = false;
            od
        si

        void visit(Definition.LIST definitions) is
            foreach var d; definitions do
                d.accept(this);
                append('\n');
            od
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

        void visit(Definition.ENUM enum_) is
            dent();

            append("enum ");

            enum_.name.accept(this);
            append(" is\n");

            in();

            var seen_any = false;

            foreach var member; enum_.members do
                if seen_any then
                    append(",\n");
                fi

                member.accept(this);

                seen_any = true;
            od

            out();

            dent();

            append("si\n");
        si

        void visit(Definition.ENUM_MEMBER member) is
            dent();
            
            member.name.accept(this);

            if member.initializer != null then
                append(" = ");

                member.initializer.accept(this);
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

        void visit(Expression.NONE none) is
            append("none");
        si

        void visit(Expression.IDENTIFIER identifier) is
            identifier.identifier.accept(this);
        si

        void visit(Expression.NEW new_) is
            append("new ");

            new_.type.accept(this);
            new_.arguments.accept(this);
        si

        void visit(Expression.CAST cast_) is
            append("cast ");

            cast_.type.accept(this);

            append('(');
            cast_.right.accept(this);
            append(')');
        si

        void visit(Expression.TUPLE tuple) is
            append('(');

            tuple.elements.accept(this);

            append(')');
        si

        void visit(Expression.LITERAL literal) is
            append(literal.value);
        si                        

        void visit(Expression.CALL call) is
            call.function.accept(this);

            append('(');

            call.arguments.accept(this);

            append(')');
        si            

        void visit(Expression.MEMBER member) is
            member.left.accept(this);

            append('.');

            member.identifier.accept(this);
        si

        void visit(Expression.INDEX index) is
            index.left.accept(this);

            append('[');

            index.index.accept(this);

            append(']');
        si

        void visit(Expression.UNARY unary) is
            append(Expression.OPERATION_NAMES[unary.operation]);

            unary.right.accept(this);
        si

        void visit(Expression.BINARY binary) is
            binary.left.accept(this);

            append(Expression.OPERATION_NAMES[binary.operation]);
            
            binary.right.accept(this);
        si

        void visit(Expression.LIST expressions) is
            var seen_any = false;
            foreach var e; expressions do
                if seen_any then
                    append(',');
                fi

                e.accept(this);

                seen_any = true;
            od
        si

        // Statements

        void visit(Statement.LIST list) is
            foreach var s; list.Iterator do
                s.accept(this);
            od
        si

        void visit(Statement.ASSIGNMENT assign) is
            dent();

            assign.left.accept(this);
            append(" = ");
            assign.right.accept(this);
            append(";");

            nl();
        si

        void visit(Statement.EXPRESSION expression) is
            dent();

            expression.expression.accept(this);
            append(";");

            nl();
        si

        void visit(Statement.VAR v) is
            dent();

            append("var ");
            v.variables.accept(this);
            append(";");

            nl();
        si

        void visit(Statement.RETURN r) is
            dent();

            append("return");

            if r.expression != null then
                append(' ');
                r.expression.accept(this);
            fi

            append(";");

            nl();
        si

        void visit(Statement.IF i) is
            dent();
            append("if ");
            i.condition.accept(this);
            append(" then\n");

            in();

            i.then_branch.accept(this);

            if i.else_branch != null then
                out();
                dent();
                append("else\n");
                in();

                i.else_branch.accept(this);
            elif i.elif_branch != null then
                // FIXME: this is a bodge!
                append("el");

                run_on();

                i.elif_branch.accept(this);
            fi

            out();

            dent_append("fi\n");                
        si

        void visit(Statement.CASE case_) is
            dent();
            append("case ");

            case_.expression.accept(this);

            append("\n");

            foreach var m; case_.matches do
                m.accept(this);
            od

            dent();
            append("esac\n");
        si

        void visit(Statement.CASE_MATCH match) is
            dent();

            if match.expression != null then
                append("when ");

                match.expression.accept(this);

                append(":\n");
            else
                append("default:\n");
            fi

            in();
            match.statements.accept(this);
            out();
        si

        void visit(Statement.TRY try_) is
            dent();
            append("try\n");

            in();

            try_.body.accept(this);

            out();

            foreach var c; try_.catches do
                c.accept(this);
            od

            if try_.finally_ != null then
                dent_append("finally\n");
                in();
                try_.finally_.accept(this);
                out();
            fi

            dent();
            append("esac\n");
        si

        void visit(Statement.CATCH catch_) is
            dent_append("catch ");

            catch_.variable.accept(this);

            append("\n");

            in();

            catch_.body.accept(this);

            out();
        si            

        void visit(Statement.DO do_) is
            dent();

            if do_.condition != null then
                append("while ");
                do_.condition.accept(this);
                append(" ");
            fi    

            append("do\n");
            in();
            do_.body.accept(this);
            out();

            dent_append("od\n"); 
        si

        void visit(Statement.LABELLED labelled) is
            dent();

            labelled.label.accept(this);

            append(": ");

            run_on();

            labelled.statement.accept(this);
        si

        void visit(Statement.BREAK break_) is
            dent();
            append("break");
            if break_.label != null then
                append(' ');
                break_.label.accept(this);
            fi

            nl();
        si

        void visit(Statement.CONTINUE continue_) is
            dent();
            append("continue");
            if continue_.label != null then
                append(' ');
                continue_.label.accept(this);
            fi

            nl();
        si            

        // function body
    si
si si si
    

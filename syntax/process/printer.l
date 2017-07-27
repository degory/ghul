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

            void visit(Definition.NAMESPACE namespace_) is
                _result.append("namespace ");

                namespace_.name.accept(this);

                _result.append(" is\n");
                namespace_.body.accept(this);
                _result.append("si\n");
            si            

            void visit(Definition.USE use_) is
                _result.append("use ");

                var seen_any = false;
                foreach var u; use_.uses do
                    if seen_any then
                        _result.append(", ");
                    fi

                    _result.append(u);

                    seen_any = true;
                od

                _result.append(";");
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

            void visit(Definition.ENUM enum_) is
                _result.append("enum ");

                enum_.name.accept(this);
                _result.append(" is\n");

                var seen_any = false;

                foreach var member; enum_.members do
                    if seen_any then
                        _result.append(",\n");
                    fi

                    member.accept(this);

                    seen_any = true;
                od

                _result.append("\nsi\n");
            si

            void visit(Definition.ENUM_MEMBER member) is
                member.name.accept(this);

                if member.initializer != null then
                    _result.append(" = ");

                    member.initializer.accept(this);
                fi
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
                    _result.append(' ');
                    property.getter_body.accept(this);

                    if property.setter_body != null then
                        _result.append(",");
                    fi
                fi

                if property.setter_body != null then
                    _result.append(" = ");
                    property.setter_argument.accept(this);
                    _result.append(' ');

                    property.setter_body.accept(this);
                fi
            si

            void visit(Definition.INDEXER indexer) is
                if indexer.name != null then
                    indexer.name.accept(this);
                fi

                _result.append("[");
                indexer.index_argument.accept(this);
                _result.append("]");

                if !isa Type.INFER(indexer.type) then
                    _result.append(": ");
                    indexer.type.accept(this);
                fi

                if indexer.getter_body != null then
                    _result.append(' ');
                    indexer.getter_body.accept(this);

                    if indexer.setter_body != null then
                        _result.append(",");
                    fi
                fi

                if indexer.setter_body != null then
                    _result.append(" = ");
                    indexer.setter_argument.accept(this);
                    _result.append(' ');

                    indexer.setter_body.accept(this);
                fi
            si
            
                        
            // types

            void visit(Type.MODIFIER modifier) is
                if !isa Type.INFER(modifier.element) then
                    modifier.element.accept(this);
                    _result.append(' ');
                fi
                
                _result.append(modifier.name);
            si

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

            void visit(Expression.NEW new_) is
                _result.append("new ");

                new_.type.accept(this);
                new_.arguments.accept(this);
            si

            void visit(Expression.CAST cast_) is
                _result.append("cast ");

                cast_.type.accept(this);

                _result.append('(');
                cast_.right.accept(this);
                _result.append(')');
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

                if !isa Tree.Type.INFER(list.type) then
                    _result.append(": ");
                    list.type.accept(this);
                fi
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

            void visit(Expression.HAS_VALUE has_value) is
                has_value.left.accept(this);

                _result.append('?');
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
                expression.expression.accept(this);
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

            void visit(Statement.RETURN r) is
                _result.append("return");

                if r.expression != null then
                    _result.append(' ');
                    r.expression.accept(this);
                fi

                _result.append(";");
            si

            void visit(Statement.IF i) is
                _result.append("if ");

                i.condition.accept(this);

                _result.append(" then\n");

                i.then_branch.accept(this);

                if i.else_branch != null then
                    _result.append("else\n");

                    i.else_branch.accept(this);
                elif i.elif_branch != null then
                    // FIXME: this is a bodge!
                    _result.append("el");

                    i.elif_branch.accept(this);
                fi

                _result.append("fi\n");                
            si

            void visit(Statement.CASE case_) is
                _result.append("case ");

                case_.expression.accept(this);

                _result.append("\n");

                foreach var m; case_.matches do
                    m.accept(this);
                od

                _result.append("esac\n");
            si

            void visit(Statement.CASE_MATCH match) is
                if match.expression != null then
                    _result.append("when ");

                    match.expression.accept(this);

                    _result.append(":\n");
                else
                    _result.append("default:\n");
                fi

                match.statements.accept(this);
            si

            void visit(Statement.TRY try_) is
                _result.append("try\n");

                try_.body.accept(this);

                _result.append("\n");

                foreach var c; try_.catches do
                    c.accept(this);
                od

                if try_.finally_ != null then
                    _result.append("finally\n");
                    try_.finally_.accept(this);
                fi

                _result.append("esac\n");
            si

            void visit(Statement.CATCH catch_) is
                _result.append("catch ");

                catch_.variable.accept(this);

                _result.append("\n");

                catch_.body.accept(this);
            si            

            void visit(Statement.DO do_) is
                if do_.condition != null then
                    _result.append("while ");
                    do_.condition.accept(this);
                    _result.append(" ");
                fi    

                _result.append("do\n");

                do_.body.accept(this);

                _result.append("od\n"); 
            si

            void visit(Statement.FOR for_) is
                _result.append("for ");

                for_.variable.accept(this);

                _result.append(" in ");

                for_.expression.accept(this);

                _result.append(" do\n");

                for_.body.accept(this);

                _result.append("od\n"); 
            si

            void visit(Statement.LABELLED labelled) is
                labelled.label.accept(this);

                _result.append(": ");

                labelled.statement.accept(this);
            si

            void visit(Statement.BREAK break_) is
                _result.append("break");
                if break_.label != null then
                    _result.append(' ');
                    break_.label.accept(this);
                fi
            si

            void visit(Statement.CONTINUE continue_) is
                _result.append("continue");
                if continue_.label != null then
                    _result.append(' ');
                    continue_.label.accept(this);
                fi
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
    

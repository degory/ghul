namespace Syntax is
    namespace Tree is
        namespace Process is
            use System;
            use Definition;
            use Type;

            class PRINTER isa Visitor is
                StringBuffer result;

                void init() is
                    result = new StringBuffer();
                si

                void apply(NODE node) is
                    node.accept(this);
                si

                void visit(IDENTIFIER identifier) is
                    result.append(identifier.name);
                si

                void visit(QUALIFIED_IDENTIFIER identifier) is
                    identifier.parent.accept(this);
                    result.append('.');
                    identifier.accept(this);
                si

                void visit(VARIABLE variable) is
                    variable.identifier.accept(this);
                    result.append(' ');
                    /*
                    if variable.type != Type.INFER then
                        result.append(": ");
                        variable.type.accept(this);
                    fi
                    */
                si

                void visit(VARIABLE_LIST variables) is
                    var first = true;
/*
                    foreach var v; variables do
                        if !first then result.append(", "); fi

                        v.accept(this);

                        first = false;
                    od
*/
                si

                void visit(LET l) is
                    result.append("let ");
                    l.variables.accept(this);
                    result.append(";");
                si

                void visit(VAR v) is
                    result.append("var ");
                    v.variables.accept(this);
                    result.append(";");
                si

                void visit(DEFINITION_LIST definitions) is
                    foreach var d; definitions do
                        d.accept(this);
                        result.append('\n');
                    od
                si
            si
        si
    si
si
    

namespace Syntax is namespace Process is
    use System;
    use Generic;

    use Tree;

    class SCOPE_TEST isa ScopedVisitor is
        void init(SCOPES scopes) is
            super.init(scopes);
        si

        void visit(Identifier.QUALIFIED identifier) is
            var definition = this[identifier];

            if definition != null then
                IO.Std.err.println("" + identifier + " => " + definition);
            else
                IO.Std.err.println("" + identifier + " not defined");
            fi
        si

        void visit(Identifier.NODE identifier) is
            var definition = this[identifier];

            if definition != null then
                IO.Std.err.println("" + identifier + " => " + definition);
            else
                IO.Std.err.println("" + identifier + " not defined");
            fi            
        si
    si
si si

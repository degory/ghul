namespace Syntax is namespace Process is
    use System;
    use Generic;

    use Logging;
    use Tree;

    class REWRITE_STRUCTURED_TYPES_AS_CLASSES isa Visitor is
        MAP _map;
        
        void init() is
            super.init();

            _map = new MAP();
        si

        void apply(NODE root) is
            root.walk(this);

            var rewriter = new REWRITER(_map);
            rewriter.apply(root);
        si

        void replace(
            NODE node,
            String name,
            Type.NODE element
        )
        is
            var n =
                new Type.GENERIC(
                    node.location,
                    new Identifier.NODE(
                        node.location,
                        name
                    ),
                    new Type.LIST(
                        node.location,
                        Type.NODE{element}
                    )
                );

            _map[node] = n;
        si

        void replace(
            NODE node,
            String name,
            Iterable<Type.NODE> elements
        )
        is                
            var n =
                new Type.GENERIC(
                    node.location,
                    new Identifier.NODE(
                        node.location,
                        name
                    ),
                    new Type.LIST(
                        node.location,
                        elements
                    )
                );

            _map[node] = n;
        si
        
        void visit(Type.ARRAY array) is
            replace(
                array,
                "array",
                array.element
            );
        si

        void visit(Type.POINTER pointer) is
            replace(
                pointer,
                "pointer",
                pointer.element
            );
        si

        void visit(Type.REFERENCE reference) is
            replace(
                reference,
                "reference",
                reference.element
            );
        si
        
        /*
        void visit(Type.NULLABLE nullable) is
            replace(
                nullable,
                "nullable",
                nullable.element
            );
        si
        */

        void visit(Type.FUNCTION function) is
            var elements = new Vector<Type.NODE>();

            foreach var t; function.arguments do
                elements.add(t);
            od

            elements.add(function.result);

            replace(
                function,
                "function",
                elements
            );
        si
        
        void visit(Type.TUPLE tuple) is
            var elements = new Vector<Type.NODE>();

            foreach var t; tuple.elements do
                elements.add(t);
            od

            replace(
                tuple,
                "tuple",
                elements
            );
        si
    si
si si
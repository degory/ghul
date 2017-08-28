namespace Syntax is namespace Process is
    use System;

    use Source;
    use Tree;

    class REWRITE_OPERATORS_AS_CALLS isa Visitor is
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
            Expression.NODE left,
            Expression.NODE right
        )
        is
            var op_location =
                new LOCATION(
                    node.location.file_name,
                    left.location.end_line,
                    left.location.end_column,
                    right.location.start_line,
                    right.location.start_column
                );
                
            var n =
                new Expression.CALL(
                    node.location,
                    new Expression.IDENTIFIER(
                        op_location,
                        new Identifier.NODE(
                            op_location,
                            name
                        )
                    ),
                    new Expression.LIST(
                        left.location..right.location,
                        Expression.NODE{left,right}
                    )
                );

            _map[node] = n;
        si

        void replace(
            NODE node,
            String name,
            Expression.NODE right
        )
        is
            var op_location =
                new LOCATION(
                    node.location.file_name,
                    node.location.start_line,
                    node.location.start_column,
                    right.location.start_line,
                    right.location.start_column
                );
                
            var n =
                new Expression.CALL(
                    node.location,
                    new Expression.IDENTIFIER(
                        op_location,
                        new Identifier.NODE(
                            op_location,
                            name
                        )
                    ),
                    new Expression.LIST(
                        right.location,
                        Expression.NODE{right}
                    )
                );

            _map[node] = n;
        si

        /*
        bool pre(Expression.NEW new_) is
            return false;
        si

        void visit(Expression.NEW new_) is
        si

        bool pre(Expression.CAST cast_) is
            return false;
        si

        void visit(Expression.CAST cast_) is
        si

        bool pre(Expression.CALL call) is
            return false;
        si

        void visit(Expression.CALL call) is
        si

        bool pre(Expression.MEMBER member) is
            return false;
        si

        void visit(Expression.MEMBER member) is
        si
        */

        bool pre(Expression.INDEX index) is
            return false;
        si

        void visit(Expression.INDEX index) is
            replace(
                index,
                "[]",
                index.left,
                index.index
            );               
        si

        /*
        bool pre(Expression.HAS_VALUE has_value) is
            return false;
        si

        void visit(Expression.HAS_VALUE has_value) is
        si
        */

        bool pre(Expression.UNARY unary) is
            return false;
        si

        void visit(Expression.UNARY unary) is
            replace(
                unary,
                unary.operation.name,
                unary.right
            );
        si

        bool pre(Expression.BINARY binary) is
            return false;
        si

        void visit(Expression.BINARY binary) is
            replace(
                binary,
                binary.operation.name,
                binary.left,
                binary.right
            );
        si
    si
si si

namespace Syntax is namespace Parser is namespace Expression is
    use System;
    use Generic;

    use Source;

    enum PRECEDENCE is
        NONE,
        MIN,
        BOOLEAN,
        RELATIONAL,
        RANGE,
        SHIFT,
        BITWISE,
        ADDITION,
        MULTIPLICATION,
        MEMBER,
        PRIMARY
    si    

    class NODE isa BASE<Tree.Expression.NODE> is
        Dict<Lexical.TOKEN, PRECEDENCE> precedence;
        Dict<Lexical.TOKEN, Tree.Expression.OPERATION> operation;

        // Parser<Tree.Expression.PRIMARY> expression_primary_parser;
        Parser<Tree.Expression.NODE> expression_secondary_parser;
        // Parser<Tree.Expression.TUPLE> expression_tuple_parser;
        // Parser<Tree.Expression.LITERAL> expression_literal_parser;
        // Parser<Tree.Type.NODE> type_parser;

        void init(
            // Parser<Tree.Expression.PRIMARY> expression_primary_parser,
            Parser<Tree.Expression.NODE> expression_secondary_parser
            // Parser<Tree.Expression.TUPLE> expression_tuple_parser,
            // Parser<Tree.Expression.LITERAL> expression_literal_parser
        ) is
            super.init();

            // this.primary_parser = primary_parser;
            this.expression_secondary_parser = expression_secondary_parser;
            // this.tuple_parser = tuple_parser;
            // this.literal_parser = literal_parser;

            precedence = new Map<Lexical.TOKEN, PRECEDENCE>();

            precedence[Lexical.TOKEN.DOT] = PRECEDENCE.MEMBER;
            precedence[Lexical.TOKEN.SQUARE_OPEN] = PRECEDENCE.MEMBER;
            precedence[Lexical.TOKEN.PAREN_OPEN] = PRECEDENCE.MEMBER;

            precedence[Lexical.TOKEN.STAR] = PRECEDENCE.MULTIPLICATION;
            precedence[Lexical.TOKEN.SLASH] = PRECEDENCE.MULTIPLICATION;
            precedence[Lexical.TOKEN.PERCENT] = PRECEDENCE.MULTIPLICATION;

            precedence[Lexical.TOKEN.PLUS] = PRECEDENCE.ADDITION;
            precedence[Lexical.TOKEN.MINUS] = PRECEDENCE.ADDITION;

            precedence[Lexical.TOKEN.AND] = PRECEDENCE.BITWISE;
            precedence[Lexical.TOKEN.OR] = PRECEDENCE.BITWISE;

            precedence[Lexical.TOKEN.RANGE] = PRECEDENCE.RANGE;

            operation = new Map<Lexical.TOKEN, Tree.Expression.OPERATION>();

            operation[Lexical.TOKEN.DOT] = Tree.Expression.OPERATION.MEMBER;
            operation[Lexical.TOKEN.SQUARE_OPEN] = Tree.Expression.OPERATION.INDEX;
            operation[Lexical.TOKEN.PAREN_OPEN] = Tree.Expression.OPERATION.CALL;

            operation[Lexical.TOKEN.SLASH] = Tree.Expression.OPERATION.DIVIDE;
            operation[Lexical.TOKEN.STAR] = Tree.Expression.OPERATION.MULTIPLY;
            operation[Lexical.TOKEN.PERCENT] = Tree.Expression.OPERATION.MODULUS;

            operation[Lexical.TOKEN.PLUS] = Tree.Expression.OPERATION.ADD;
            operation[Lexical.TOKEN.MINUS] = Tree.Expression.OPERATION.SUBTRACT;

            operation[Lexical.TOKEN.AND] = Tree.Expression.OPERATION.AND;
            operation[Lexical.TOKEN.OR] = Tree.Expression.OPERATION.OR;                

            operation[Lexical.TOKEN.RANGE] = Tree.Expression.OPERATION.RANGE;
        si

        get String description is
            return "expression";
        si

        Tree.Expression.NODE parse(CONTEXT context) is
            return parse(
                context,
                expression_secondary_parser.parse(context),
                PRECEDENCE.MIN
            );
        si

        Tree.Expression.NODE parse(
            CONTEXT context,
            Tree.Expression.NODE left,
            PRECEDENCE min_precedence
        )
        is
            do
                var left_precedence = precedence[context.current.token];

                if left_precedence < min_precedence then break; fi

                var op = operation[context.current.token];

                context.next_token();

                Tree.Expression.NODE right = expression_secondary_parser.parse(context);
                
                do
                    var right_precedence = precedence[context.current.token];

                    if right_precedence <= left_precedence then
                        break;
                    fi

                    right = parse(context, right, right_precedence);
                od

                left = new Tree.Expression.BINARY(
                    left.location..right.location,
                    op,
                    left,
                    right
                );
            od

            return left;
        si
    si
si si si
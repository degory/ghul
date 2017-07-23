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

        Parser<Tree.Expression.NODE> expression_secondary_parser;

        void init(
            Parser<Tree.Expression.NODE> expression_secondary_parser
        ) is
            super.init();

            this.expression_secondary_parser = expression_secondary_parser;

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
            precedence[Lexical.TOKEN.HAT] = PRECEDENCE.BITWISE;

            precedence[Lexical.TOKEN.RANGE] = PRECEDENCE.RANGE;

            precedence[Lexical.TOKEN.SHIFT_LEFT] = PRECEDENCE.SHIFT;
            precedence[Lexical.TOKEN.SHIFT_RIGHT] = PRECEDENCE.SHIFT;

            precedence[Lexical.TOKEN.EQ] = PRECEDENCE.RELATIONAL;
            precedence[Lexical.TOKEN.NE] = PRECEDENCE.RELATIONAL;
            precedence[Lexical.TOKEN.EQ_OBJ] = PRECEDENCE.RELATIONAL;
            precedence[Lexical.TOKEN.NE_OBJ] = PRECEDENCE.RELATIONAL;
            precedence[Lexical.TOKEN.LT] = PRECEDENCE.RELATIONAL;
            precedence[Lexical.TOKEN.LE] = PRECEDENCE.RELATIONAL;
            precedence[Lexical.TOKEN.GT] = PRECEDENCE.RELATIONAL;
            precedence[Lexical.TOKEN.GE] = PRECEDENCE.RELATIONAL;

            precedence[Lexical.TOKEN.AND_THEN] = PRECEDENCE.BOOLEAN;
            precedence[Lexical.TOKEN.OR_ELSE] = PRECEDENCE.BOOLEAN;            

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
            operation[Lexical.TOKEN.HAT] = Tree.Expression.OPERATION.XOR;              

            operation[Lexical.TOKEN.RANGE] = Tree.Expression.OPERATION.RANGE;

            operation[Lexical.TOKEN.SHIFT_LEFT] = Tree.Expression.OPERATION.SHIFT_LEFT;
            operation[Lexical.TOKEN.SHIFT_RIGHT] = Tree.Expression.OPERATION.SHIFT_RIGHT;

            operation[Lexical.TOKEN.EQ] = Tree.Expression.OPERATION.EQUAL;
            operation[Lexical.TOKEN.NE] = Tree.Expression.OPERATION.NOT_EQUAL;
            operation[Lexical.TOKEN.EQ_OBJ] = Tree.Expression.OPERATION.EQUAL_OBJ;
            operation[Lexical.TOKEN.NE_OBJ] = Tree.Expression.OPERATION.NOT_EQUAL_OBJ;
            operation[Lexical.TOKEN.LT] = Tree.Expression.OPERATION.LESS;
            operation[Lexical.TOKEN.LE] = Tree.Expression.OPERATION.LESS_OR_EQUAL;
            operation[Lexical.TOKEN.GT] = Tree.Expression.OPERATION.GREATER;
            operation[Lexical.TOKEN.GE] = Tree.Expression.OPERATION.GREATER_OR_EQUAL;

            operation[Lexical.TOKEN.AND_THEN] = Tree.Expression.OPERATION.AND_THEN;
            operation[Lexical.TOKEN.OR_ELSE] = Tree.Expression.OPERATION.OR_ELSE;
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
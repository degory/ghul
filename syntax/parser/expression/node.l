namespace Syntax is namespace Parser is namespace Expression is
    use System;
    use Generic;

    use Source;

    enum PRECEDENCE is
        NONE,
        MIN,
        UNDEFINED,
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
        Dict<String, PRECEDENCE> _precedence;

        Parser<Tree.Expression.NODE> expression_secondary_parser;

        void init(
            Parser<Tree.Expression.NODE> expression_secondary_parser
        ) is
            super.init();

            this.expression_secondary_parser = expression_secondary_parser;

            _precedence = new Map<String, PRECEDENCE>();

            _precedence["*"] = PRECEDENCE.MULTIPLICATION;
            _precedence["/"] = PRECEDENCE.MULTIPLICATION;
            _precedence["%"] = PRECEDENCE.MULTIPLICATION;

            _precedence["+"] = PRECEDENCE.ADDITION;
            _precedence["-"] = PRECEDENCE.ADDITION;

            _precedence["&"] = PRECEDENCE.BITWISE;
            _precedence["|"] = PRECEDENCE.BITWISE;
            _precedence["^"] = PRECEDENCE.BITWISE;

            _precedence[".."] = PRECEDENCE.RANGE;

            _precedence["<<"] = PRECEDENCE.SHIFT;
            _precedence[">>"] = PRECEDENCE.SHIFT;

            _precedence["=="] = PRECEDENCE.RELATIONAL;
            _precedence["!="] = PRECEDENCE.RELATIONAL;
            _precedence["=~"] = PRECEDENCE.RELATIONAL;
            _precedence["!~"] = PRECEDENCE.RELATIONAL;
            _precedence["<"] = PRECEDENCE.RELATIONAL;
            _precedence[">"] = PRECEDENCE.RELATIONAL;
            _precedence[">="] = PRECEDENCE.RELATIONAL;
            _precedence["<="] = PRECEDENCE.RELATIONAL;

            _precedence["&&"] = PRECEDENCE.BOOLEAN;
            _precedence["||"] = PRECEDENCE.BOOLEAN;            
        si

        get String description is
            return "expression";
        si

        PRECEDENCE precedence(CONTEXT context) is            
            var result = _precedence[context.current.string];

            if result == PRECEDENCE.NONE then
                context.error(context.current.location, "operator '" + context.current.string + "' has unknown precedence");

                return PRECEDENCE.UNDEFINED;
            fi

            return result;
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
                var left_precedence = precedence(context);

                if left_precedence < min_precedence then break; fi

                var op = new Tree.Identifier.NODE(
                    context.location,
                    context.current.string
                );

                context.next_token();

                Tree.Expression.NODE right = expression_secondary_parser.parse(context);
                
                do
                    var right_precedence = precedence(context);

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
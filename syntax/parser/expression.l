namespace Syntax is
    namespace Parser is
        use System;
        use Generic;

        use Source;

        class EXPRESSION isa PARSER<Tree.EXPRESSION> is

            Dict<Lexical.TOKEN, Expression.PRECEDENCE> precedence;
            Dict<Lexical.TOKEN, Tree.Expression.OPERATION> operation;

            void init() is
                super.init();

                precedence = new Map<Lexical.TOKEN, Expression.PRECEDENCE>();

                precedence[Lexical.TOKEN.DOT] = Expression.PRECEDENCE.MEMBER;
                precedence[Lexical.TOKEN.SQUARE_OPEN] = Expression.PRECEDENCE.MEMBER;
                precedence[Lexical.TOKEN.PAREN_OPEN] = Expression.PRECEDENCE.MEMBER;

                precedence[Lexical.TOKEN.STAR] = Expression.PRECEDENCE.MULTIPLICATION;
                precedence[Lexical.TOKEN.SLASH] = Expression.PRECEDENCE.MULTIPLICATION;
                precedence[Lexical.TOKEN.PERCENT] = Expression.PRECEDENCE.MULTIPLICATION;

                precedence[Lexical.TOKEN.PLUS] = Expression.PRECEDENCE.ADDITION;
                precedence[Lexical.TOKEN.MINUS] = Expression.PRECEDENCE.ADDITION;

                precedence[Lexical.TOKEN.AND] = Expression.PRECEDENCE.BITWISE;
                precedence[Lexical.TOKEN.OR] = Expression.PRECEDENCE.BITWISE;


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
            si

            get String description is
                return "expression";
            si

            Tree.EXPRESSION parse(CONTEXT context) is
                return parse(
                    context,
                    context.parse_expression_secondary(),
                    Expression.PRECEDENCE.MIN
                );
            si

            Tree.EXPRESSION parse(
                CONTEXT context,
                Tree.EXPRESSION left,
                Expression.PRECEDENCE min_precedence
            )
            is
                do
                    var left_precedence = precedence[context.current_token];

                    if left_precedence < min_precedence then break; fi

                    var op = operation[context.current_token];

                    context.next_token();

                    Tree.EXPRESSION right = context.parse_expression_secondary();
                    
                    do
                        var right_precedence = precedence[context.current_token];

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

            Tree.Expression.EXPRESSION_LIST parse_expression_list(CONTEXT context) is
                var start = context.location;

                var expressions = new Vector<Tree.EXPRESSION>();

                do
                    context.allow_tuple_element = true;
                    var expression = context.parse_expression();
                    context.allow_tuple_element = false;

                    expressions.add(expression);

                    if context.current_token != Lexical.TOKEN.COMMA then
                        return new Tree.Expression.EXPRESSION_LIST(start..expression.location, expressions);
                    fi

                    context.next_token();
                od
            si          
        si

        namespace Expression is
            enum PRECEDENCE is
                NONE,
                MIN,
                BOOLEAN,
                RELATIONAL,
                SHIFT,
                BITWISE,
                ADDITION,
                MULTIPLICATION,
                MEMBER,
                PRIMARY
            si

            class PRIMARY isa PARSER<Tree.Expression.PRIMARY> is
                void init() is
                    super.init();

                    add_parser(
                        Tree.Expression.PRIMARY proc(CONTEXT context) is
                            return new Tree.Expression.UNARY(
                                context.location,
                                Tree.Expression.OPERATION.SUBTRACT,
                                this.parse(context)
                            );
                        si,
                        Lexical.TOKEN.MINUS
                    );

                    add_parser(
                        Tree.Expression.PRIMARY proc(CONTEXT context) is
                            var start = context.location;

                            var identifier = parse_identifier(context);

                            // FIXME:
                            if context.allow_tuple_element && !isa Tree.QUALIFIED_IDENTIFIER(identifier.identifier) then
                                context.allow_tuple_element = false;
                                
                                var end = identifier.location;
                                
                                Tree.TYPE type;
                                Tree.EXPRESSION initializer;

                                if context.current_token == Lexical.TOKEN.COLON then
                                    context.next_token();

                                    type = context.parse_type();
                                    end = type.location;
                                fi

                                if context.current_token == Lexical.TOKEN.ASSIGN then
                                    context.next_token();

                                    initializer = context.parse_expression();
                                    end = initializer.location;
                                fi

                                if initializer != null then
                                    if type == null then
                                        type = new Tree.Type.INFER(context.location);
                                    fi
                                fi

                                if type != null then
                                    return new Tree.Expression.VARIABLE(
                                        start..end,
                                        identifier.identifier,
                                        type,
                                        initializer
                                    );
                                fi
                            fi

                            return identifier;
                        si,
                        Lexical.TOKEN.IDENTIFIER
                    );

                    add_parser(
                        Tree.Expression.PRIMARY proc(CONTEXT context) is
                            var start = context.location;

                            context.next_token();

                            var elements = context.parse_expression_list();
                            var end = context.location;

                            context.next_token(Lexical.TOKEN.SQUARE_CLOSE);

                            return new Tree.Expression.LIST(
                                start..end,
                                elements
                            );
                        si,
                        Lexical.TOKEN.SQUARE_OPEN
                    );
                    
                    add_parser(
                        Tree.Expression.PRIMARY proc(CONTEXT context) is
                            return context.parse_expression_tuple();
                        si,
                        Lexical.TOKEN.PAREN_OPEN
                    );              

                    add_parser(
                        Tree.Expression.PRIMARY proc(CONTEXT context) is
                            return context.parse_expression_literal();
                        si,
                        {
                            Lexical.TOKEN.INT_LITERAL,
                            Lexical.TOKEN.STRING_LITERAL,
                            Lexical.TOKEN.NONE
                        }
                    );                    
                si

                Tree.Expression.IDENTIFIER parse_identifier(CONTEXT context) is
                    return new Tree.Expression.IDENTIFIER(
                        context.location,
                        context.parse_unqualified_identifier()
                    );                            
                si

                get String description is
                    return "definition";
                si                
            si

            class SECONDARY isa PARSER<Tree.EXPRESSION> is
                void init() is  
                    super.init();
                si

                get String description is
                    return "secondary expression";
                si
                
                Tree.EXPRESSION parse(CONTEXT context) is
                    var start = context.location;
                    Tree.EXPRESSION result = context.parse_expression_primary();

                    do
                        case context.current_token
                        is Lexical.TOKEN.PAREN_OPEN:
                            context.next_token();
                            Tree.Expression.EXPRESSION_LIST arguments;

                            if context.current_token != Lexical.TOKEN.PAREN_CLOSE then
                                arguments = context.parse_expression_list();
                           else
                                arguments = new Tree.Expression.EXPRESSION_LIST(context.location, new Vector<Tree.EXPRESSION>());
                            fi

                            result = new Tree.Expression.CALL(start..context.location, result, arguments);
                            
                            context.next_token(Lexical.TOKEN.PAREN_CLOSE, syntax_error_message);

                        is Lexical.TOKEN.SQUARE_OPEN:
                            context.next_token();
                            var index = context.parse_expression();

                            result = new Tree.Expression.INDEX(start..context.location, result, index);
                            context.next_token(Lexical.TOKEN.SQUARE_CLOSE, syntax_error_message);

                        is Lexical.TOKEN.DOT:
                            context.next_token();

                            var member = context.parse_expression_identifier();
                            
                            result = new Tree.Expression.MEMBER(start..member.location, result, member);

                        is Lexical.TOKEN.ARROW_THIN, Lexical.TOKEN.ARROW_FAT:
                            if
                                isa Tree.Expression.TUPLE(result) || 
                                isa Tree.Expression.IDENTIFIER(result)
                            then
                                Tree.TYPE type;
                                Tree.Expression.TUPLE arguments;

                                if context.current_token == Lexical.TOKEN.ARROW_THIN then
                                    context.next_token();
                                    type = context.parse_type();
                                else
                                    type = new Tree.Type.INFER(start..result.location);
                                fi

                                if context.next_token(Lexical.TOKEN.ARROW_FAT) then
                                    if isa Tree.Expression.TUPLE(result) then
                                        arguments = cast Tree.Expression.TUPLE(result);
                                    else
                                        var elements = new Vector<Tree.EXPRESSION>();
                                        elements.add(result);
                                        arguments = new Tree.Expression.TUPLE(
                                            start..result.location,
                                            new Tree.Expression.EXPRESSION_LIST(
                                                start..result.location,
                                                elements
                                            )
                                        );
                                    fi

                                    var body = context.parse_expression();

                                    return new Tree.Expression.FUNCTION(
                                        start..body.location,
                                        arguments,
                                        type,
                                        body
                                    );
                                fi
                            fi

                            unexpected_token(context);
                            return new Tree.Expression.NONE(
                                start..context.location
                            );

                        default:
                            return result;

                        esac
                    od
                si
            si

            class TUPLE isa PARSER<Tree.Expression.TUPLE> is
                void init() is
                    super.init();
                si

                get String description is
                    return "tuple";
                si                

                Tree.Expression.TUPLE parse(CONTEXT context) is                    
                    var start = context.location;
                    if context.next_token(Lexical.TOKEN.PAREN_OPEN, syntax_error_message) then
                        Tree.Expression.EXPRESSION_LIST expressions;

                        if context.current_token != Lexical.TOKEN.PAREN_CLOSE then
                            expressions = context.parse_expression_list();
                        else
                            expressions = new Tree.Expression.EXPRESSION_LIST(context.location, new Vector<Tree.EXPRESSION>());
                        fi
                        
                        context.next_token(Lexical.TOKEN.PAREN_CLOSE, syntax_error_message);

                        return new Tree.Expression.TUPLE(start..context.location, expressions);
                    fi                    
                si
            si

            class LITERAL isa PARSER<Tree.Expression.LITERAL> is
                void init() is
                    super.init();

                    add_parser(
                        Tree.Expression.LITERAL proc(CONTEXT context) is                            
                            return new Tree.Expression.NONE(context.location_and_next());
                        si,
                        Lexical.TOKEN.NONE
                    );
                si    

                get String description is
                    return "literal";
                si
                          
            si
        si
    si
si
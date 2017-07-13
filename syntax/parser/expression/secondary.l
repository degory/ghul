
namespace Syntax is namespace Parser is namespace Expression is
    use System;
    use Generic;

    use Source;
    
    class SECONDARY isa BASE<Tree.Expression.NODE> is
        Parser<Tree.Identifier.NODE> identifier_parser;

        Parser<Tree.Type.NODE> type_parser;

        Parser<Tree.Expression.NODE> expression_parser;
        Parser<Tree.Expression.PRIMARY> expression_primary_parser;
        Parser<Tree.Expression.LIST> expression_list_parser;

        Parser<Tree.Body.NODE> body_parser;

        void init(
            Parser<Tree.Identifier.NODE> identifier_parser,            
            Parser<Tree.Type.NODE> type_parser,
            Parser<Tree.Expression.NODE> expression_parser,
            Parser<Tree.Expression.PRIMARY> expression_primary_parser,
            Parser<Tree.Expression.LIST> expression_list_parser,
            Parser<Tree.Body.NODE> body_parser
        )
        is  
            super.init();

            this.identifier_parser = identifier_parser;
            this.type_parser = type_parser;
            this.expression_parser = expression_parser;
            this.expression_primary_parser = expression_primary_parser;
            this.expression_list_parser = expression_list_parser;
            this.body_parser = body_parser;
        si

        get String description is
            return "secondary expression";
        si
        
        Tree.Expression.NODE parse(CONTEXT context) is
            var start = context.location;
            Tree.Expression.NODE result = expression_primary_parser.parse(context);

            do
                case context.current.token
                is Lexical.TOKEN.PAREN_OPEN:
                    context.next_token();
                    Tree.Expression.LIST arguments;

                    if context.current.token != Lexical.TOKEN.PAREN_CLOSE then
                        arguments = expression_list_parser.parse(context);
                    else
                        arguments = new Tree.Expression.LIST(context.location, new Vector<Tree.Expression.NODE>());
                    fi

                    result = new Tree.Expression.CALL(start..context.location, result, arguments);
                    
                    context.next_token(Lexical.TOKEN.PAREN_CLOSE, syntax_error_message);

                is Lexical.TOKEN.SQUARE_OPEN:
                    context.next_token();
                    var index = expression_parser.parse(context);

                    result = new Tree.Expression.INDEX(start..context.location, result, index);
                    context.next_token(Lexical.TOKEN.SQUARE_CLOSE, syntax_error_message);

                is Lexical.TOKEN.DOT:
                    context.next_token();
 
                    var member = identifier_parser.parse(context);
                    
                    result = new Tree.Expression.MEMBER(start..member.location, result, member);

                is Lexical.TOKEN.ARROW_THIN, Lexical.TOKEN.ARROW_FAT, Lexical.TOKEN.IS:
                    if
                        isa Tree.Expression.TUPLE(result) || 
                        isa Tree.Expression.IDENTIFIER(result)
                    then
                        Tree.Type.NODE type;
                        Tree.Expression.TUPLE arguments;

                        if context.current.token == Lexical.TOKEN.ARROW_THIN then
                            context.next_token();
                            type = type_parser.parse(context);
                        else
                            type = new Tree.Type.INFER(start..result.location);
                        fi

                        if context.expect_token({ Lexical.TOKEN.ARROW_FAT, Lexical.TOKEN.IS })                        
                        then
                            if isa Tree.Expression.TUPLE(result) then
                                arguments = cast Tree.Expression.TUPLE(result);
                            else
                                var elements = new Vector<Tree.Expression.NODE>();
                                elements.add(result);
                                arguments = new Tree.Expression.TUPLE(
                                    start..result.location,
                                    new Tree.Expression.LIST(
                                        start..result.location,
                                        elements
                                    )
                                );
                            fi

                            var body = body_parser.parse(context);

                            return new Tree.Expression.FUNCTION(
                                start..body.location,
                                arguments,
                                type,
                                body
                            );
                        fi
                    fi

                    other_token(context);
                    return new Tree.Expression.NONE(
                        start..context.location
                    );

                default:
                    return result;

                esac
            od
        si
    si
si si si 
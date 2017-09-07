namespace Syntax is namespace Parser is namespace Type is
    use System;
    use Generic;

    use Source;

    class NODE isa BASE<Tree.Type.NODE> is
        Parser<Tree.Identifier.NODE> identifier_qualified_parser;
        Parser<Tree.Type.LIST> type_list_parser;

        get String description is
            return "type";
        si                                

        void init(
            Parser<Tree.Identifier.NODE> identifier_qualified_parser,
            Parser<Tree.Type.LIST> type_list_parser
        ) is 
            super.init();

            this.identifier_qualified_parser = identifier_qualified_parser;
            this.type_list_parser = type_list_parser;

            add_parser(
                Tree.Type.NODE proc(CONTEXT context) is
                    var start = context.location;

                    var identifier = identifier_qualified_parser.parse(context);

                    if !isa Tree.Identifier.QUALIFIED(identifier) && context.current.token == Lexical.TOKEN.COLON then
                        context.next_token();

                        var type = parse(context);

                        return new Tree.Type.NAMED_TUPLE_ELEMENT(start..type.location, identifier, type);
                    fi

                    if context.current.token == Lexical.TOKEN.SQUARE_OPEN then
                        context.next_token();

                        var types = type_list_parser.parse(context);

                        var result = new Tree.Type.GENERIC(start..context.location, identifier, types);
                        context.next_token(Lexical.TOKEN.SQUARE_CLOSE, syntax_error_message);

                        return result;
                    else
                        return new Tree.Type.NAMED(identifier.location, identifier);
                    fi
                si,
                Lexical.TOKEN.IDENTIFIER
            );

            add_parser(
                Tree.Type.NODE proc(CONTEXT context) is
                    // could be function or tuple

                    var start = context.location;

                    context.next_token();

                    Tree.Type.LIST types;

                    if context.current.token != Lexical.TOKEN.PAREN_CLOSE then
                        types = type_list_parser.parse(context);
                    else
                        types = new Tree.Type.LIST(start, new Tree.Type.NODE[0]);
                    fi

                    var end = context.location;

                    context.next_token(Lexical.TOKEN.PAREN_CLOSE, syntax_error_message);
                    
                    if context.current.token == Lexical.TOKEN.ARROW_THIN then
                        context.next_token();

                        var result = parse(context);
                        end = result.location;

                        return new Tree.Type.FUNCTION(
                            start..end,                            
                            types,
                            result
                        ); 
                        
                    else 
                        if !types.Iterator.hasMoreElements() then
                            context.error(start..end, "tuple has no elements");
                            return new Tree.Type.UNDEFINED(start..end);
                        else
                            return new Tree.Type.TUPLE(
                                start..end,
                                types
                            );
                        fi
                    fi
                si,
                Lexical.TOKEN.PAREN_OPEN
            );
        si

        Tree.Type.NODE parse(CONTEXT context) is
            var result = super.parse(context);

            return parse_structured(context, result);
        si

        Tree.Type.NODE parse_structured(CONTEXT context, Tree.Type.NODE element) is
            var result = element;

            do
                case context.current.token
                is Lexical.TOKEN.ARRAY_DEF:
                    result = new Tree.Type.ARRAY(result.location..context.location, result);
                    context.next_token();
                
                is Lexical.TOKEN.REF:
                    result = new Tree.Type.REFERENCE(result.location..context.location, result);
                    context.next_token();

                is Lexical.TOKEN.PTR:
                    result = new Tree.Type.POINTER(result.location..context.location, result);
                    context.next_token();

                is Lexical.TOKEN.ARROW_THIN:
                    context.next_token();
                    // FIXME: this will be right associative, which may not be what we want:
                    var return_type = parse(context);

                    var arguments = new Tree.Type.LIST(element.location, Tree.Type.NODE{element});

                    result = new Tree.Type.FUNCTION(result.location..return_type.location, arguments, return_type);

                default:
                    return result;
                esac
            od
        si

        Tree.Type.NODE other_token(CONTEXT context) is
            super.other_token(context);

            return new Tree.Type.UNDEFINED(context.location);
        si            
    si
si si si

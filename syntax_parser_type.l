import glist;
import gvector;

namespace Syntax is
    namespace Parser is
        use System;
        use Generic;

        use Source;

        class TYPE isa PARSER<Tree.TYPE> is
            void init() is 
                super.init();

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        return new Tree.Type.VOID(context.location_and_next());
                    si,
                    Lexical.TOKEN.VOID);

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        return new Tree.Type.BOOL(context.location_and_next());
                    si,
                    Lexical.TOKEN.BOOL);

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        return new Tree.Type.BYTE(context.location_and_next());
                    si, 
                    Lexical.TOKEN.BYTE);

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        return new Tree.Type.CHAR(context.location_and_next());
                    si,
                    Lexical.TOKEN.CHAR);
 
                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        return new Tree.Type.INT(context.location_and_next());
                    si,
                    Lexical.TOKEN.INT); 

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        context.next_token();
                        return new Tree.Type.WORD(context.location_and_next());
                    si,
                    Lexical.TOKEN.WORD); 

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        var start = context.location;

                        var identifier = context.parse_identifier();

                        if context.current_token == Lexical.TOKEN.SQUARE_OPEN then
                            context.next_token();

                            var types = parse_type_list(context);

                            var result = new Tree.Type.GENERIC(start..context.location, identifier, types);
                            context.next_token(Lexical.TOKEN.SQUARE_CLOSE);

                            return result;
                        else
                            return new Tree.Type.NAMED(identifier.location, identifier);
                        fi
                    si,
                    Lexical.TOKEN.IDENTIFIER
                );

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        // could be function or tuple

                        var start = context.location;

                        context.next_token();

                        Tree.Type.TYPE_LIST types;

                        if context.current_token != Lexical.TOKEN.PAREN_CLOSE then
                            types = parse_type_list(context);
                        else
                            types = new Tree.Type.TYPE_LIST(start, new Tree.TYPE[0]);
                        fi

                        var end = context.location;

                        context.next_token(Lexical.TOKEN.PAREN_CLOSE);
                        
                        if context.current_token == Lexical.TOKEN.ARROW_THIN then
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

            Tree.TYPE parse(CONTEXT context) is
                var result = super.parse(context);

                return parse_structured(context, result);
            si

            Tree.TYPE parse_structured(CONTEXT context, Tree.TYPE element) is
                var result = element;

                do
                    case context.current_token
                    is Lexical.TOKEN.ARRAY_DEF:
                        result = new Tree.Type.ARRAY(result.location..context.location, result);
                        context.next_token();
                    
                    is Lexical.TOKEN.REF:
                        result = new Tree.Type.REFERENCE(result.location..context.location, result);
                        context.next_token();

                    is Lexical.TOKEN.PTR:
                        result = new Tree.Type.POINTER(result.location..context.location, result);
                        context.next_token();

                    default:
                        return result;
                    esac
                od
            si

            Tree.Type.TYPE_LIST parse_type_list(CONTEXT context) is                
                var elements = new Vector<Tree.TYPE>();

                var start = context.location;
                LOCATION end = null;

                do
                    var element = parse(context);
                    elements.add(element);

                    end = element.location;

                    if context.current_token != Lexical.TOKEN.COMMA then break; fi

                    context.next_token();
                od

                return new Tree.Type.TYPE_LIST(start..end, elements);
            si
        si
    si
si

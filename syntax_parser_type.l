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

            List<Tree.TYPE> parse_type_list(CONTEXT context) is                
                var result = new Vector<Tree.TYPE>();

                do
                    var element = parse(context);
                    result.add(element);

                    if context.current_token != Lexical.TOKEN.COMMA then break; fi

                    context.next_token();
                od

                return result;
            si
        si
    si
si

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
                        context.next_token();
                        var element = this.parse(context);
                        return new Tree.Type.ARRAY(start..element.location, element);
                    si,
                    Lexical.TOKEN.ARRAY_DEF
                );

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        var start = context.location;
                        context.next_token();
                        var element = this.parse(context);
                        return new Tree.Type.POINTER(start..element.location, element);
                    si,
                    Lexical.TOKEN.PTR
                );

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        var start = context.location;
                        context.next_token();
                        var element = this.parse(context);
                        return new Tree.Type.REFERENCE(start..element.location, element);
                    si,
                    Lexical.TOKEN.REF
                );

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        var start = context.location;

                        IO.Std.err.flush();

                        var identifier = context.parse_identifier();

                        if context.current_token == Lexical.TOKEN.LT then
                            context.next_token();

                            var types = parse_type_list(context);

                            var result = new Tree.Type.GENERIC(start..context.location, identifier, types);
                            context.next_token(Lexical.TOKEN.GT);

                            return result;
                        else
                            return new Tree.Type.NAMED(identifier.location, identifier);
                        fi
                    si,
                    Lexical.TOKEN.IDENTIFIER
                );
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

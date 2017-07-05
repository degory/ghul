import glist;
import gvector;

namespace Syntax is
    namespace Parser is
        use System;
        use Generic;

        class TYPE isa PARSER<Tree.TYPE> is
            void init() is 
                super.init();

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        context.next_token();
                        return new Tree.Type.VOID(context.location);
                    si,
                    Lexical.TOKEN.VOID);

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        context.next_token();
                        return new Tree.Type.BOOL(context.location);
                    si,
                    Lexical.TOKEN.BOOL);

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        context.next_token();
                        return new Tree.Type.BYTE(context.location);
                    si, 
                    Lexical.TOKEN.BYTE);

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        context.next_token();
                        return new Tree.Type.CHAR(context.location);
                    si,
                    Lexical.TOKEN.CHAR);
 
                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        context.next_token();
                        return new Tree.Type.INT(context.location);
                    si,
                    Lexical.TOKEN.INT); 

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        context.next_token();
                        return new Tree.Type.WORD(context.location);
                    si,
                    Lexical.TOKEN.WORD); 

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        IO.Std.err.println("parse array...");                        
                        var start = context.location;
                        context.next_token();
                        var element = this.parse(context);
                        return new Tree.Type.ARRAY(start..element.location, element);
                    si,
                    Lexical.TOKEN.ARRAY_DEF
                );

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        IO.Std.err.println("parse ptr...");
                        var start = context.location;
                        context.next_token();
                        var element = this.parse(context);
                        return new Tree.Type.POINTER(start..element.location, element);
                    si,
                    Lexical.TOKEN.PTR
                );

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        IO.Std.err.println("parse ref...");
                        var start = context.location;
                        IO.Std.err.println("parse ref from: " + start);                        
                        context.next_token();
                        var element = this.parse(context);
                        return new Tree.Type.REFERENCE(start..element.location, element);
                    si,
                    Lexical.TOKEN.REF
                );

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is                        
                        IO.Std.err.println("parse generic...");
                        var start = context.location;
                        IO.Std.err.println("parse generic from: " + start);
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
                    result.add(parse(context));

                    if context.current_token != Lexical.TOKEN.COMMA then break; fi

                    context.next_token();
                od

                return result;
            si
        si
    si
si

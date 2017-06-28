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
                        return Tree.Type.BUILT_IN.VOID;
                    si,
                    Lexical.TOKEN.VOID);

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        context.next_token();
                        return Tree.Type.BUILT_IN.BOOL;
                    si,
                    Lexical.TOKEN.BOOL);

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        context.next_token();
                        return Tree.Type.BUILT_IN.BYTE;
                    si, 
                    Lexical.TOKEN.BYTE);

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        context.next_token();
                        return Tree.Type.BUILT_IN.CHAR;
                    si,
                    Lexical.TOKEN.CHAR);
 
                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        context.next_token();
                        return Tree.Type.BUILT_IN.INT;
                    si,
                    Lexical.TOKEN.INT); 

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        context.next_token();
                        return Tree.Type.BUILT_IN.WORD;
                    si,
                    Lexical.TOKEN.WORD); 

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        context.next_token();
                        return new Tree.Type.ARRAY(this.parse(context));
                    si,
                    Lexical.TOKEN.ARRAY_DEF
                );

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        context.next_token();
                        return new Tree.Type.POINTER(this.parse(context));
                    si,
                    Lexical.TOKEN.POINTER
                );

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        context.next_token();
                        return new Tree.Type.REFERENCE(this.parse(context));
                    si,
                    Lexical.TOKEN.REFERENCE
                );

                add_parser(
                    Tree.TYPE proc(CONTEXT context) is
                        var identifier = context.parse_identifier();

                        if context.current_token == Lexical.TOKEN.LT then
                            context.next_token();

                            var result = new Tree.Type.GENERIC(identifier, parse_type_list(context));
                            context.expect_token(Lexical.TOKEN.GT);

                            return result;
                        else
                            return new Tree.Type.NAMED(identifier);
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

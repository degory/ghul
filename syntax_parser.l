import gmap;
import glist;
import gvector;

namespace Syntax is
    namespace Parser is
        use System;
        use Generic;

        interface Parser<T> is
            T parse(CONTEXT context);
        si

        class PARSER<T> do Parser<T> is
            Generic.Map<Lexical.TOKEN,T proc(CONTEXT)> parsers;
            String expected_tokens;

            void init() is
                parsers = new Generic.Map<Lexical.TOKEN, T proc(CONTEXT)>();
            si

            void add_parser(T proc(CONTEXT) p, Lexical.TOKEN token) is
                parsers[token] = p;
            si
           
            void add_parser(T proc(CONTEXT) p, List<Lexical.TOKEN> tokens) is
                foreach var t; tokens do
                    add_parser(p, t);
                od
            si

            T parse(CONTEXT context) is
                var p = parsers[context.current_token]; 

                if p != null then
                    return p(context);
                else
                    return unexpected_token(context);
                fi

            si

            T unexpected_token(CONTEXT context) is
                if expected_tokens == null then
                    populate_expected_tokens();
                fi                    

                context.error(context.location, "syntax error: expected % but found %" % { expected_tokens, context.current_token });
            si

            private void populate_expected_tokens() is
                var buffer = new StringBuffer();

                foreach var k; parsers.keys() do
                    buffer
                        .append(k.box)
                        .append(' ');
                od

                expected_tokens = buffer;
            si
        si
    si
si

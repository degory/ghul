import tokenizer;
import gmap;
import glist;
import gvector;

import tokenizer;
import ast;
import parser_type;
import parser_identifier;

namespace Syntax is
    namespace Parse is
        use System;
        use Generic;

        class CONTEXT is
            public Lexical.TOKENIZER tokenizer;

            // FIXME: without generic methods and/or reflection, it's tricky to do this in a nice open/closed way:
            public TYPE type_parser;
            public IDENTIFIER identifier_parser;
            public TUPLE tuple_parser;          

            bool next_token() is
                return tokenizer.next_token();
            si                    

            get Lexical.TOKEN current_token is
                return tokenizer.current_token;
            si
        si

        interface Parser<T> is
            T parse(CONTEXT context);
        si

        class PARSER<T> do Parser<T> is
            Generic.Map<Lexical.TOKEN,T proc(CONTEXT)> parsers;

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
                    IO.Std.err.println("unexpected token: " + context.current_token);
                fi
            si
        si
    si
si

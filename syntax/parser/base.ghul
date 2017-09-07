
namespace Syntax is namespace Parser is
    use System;
    use Generic;

    interface Parser<T> is
        T parse(CONTEXT context);
    si
    
    class BASE<T> do Parser<T> is
        Vector<Lexical.TOKEN> _expected_tokens;

        Generic.Map<Lexical.TOKEN,T proc(CONTEXT)> parsers;

        get Iterable<Lexical.TOKEN> expected_tokens is
            if _expected_tokens == null then
                populate_expected_tokens();
            fi                    

            return _expected_tokens;
        si

        void init() is
            parsers = new Generic.Map<Lexical.TOKEN, T proc(CONTEXT)>();
        si

        get String description is
            return null;
        si

        get String syntax_error_message is
            var d = description;

            if d != null then
                return "in " + d;
            else
                return "syntax error";
            fi
        si

        void add_parser(T proc(CONTEXT) p, Lexical.TOKEN token) is
            if parsers[token] != null then
                throw new Exception("% already has a parser (%)" % Object{token, p});
            fi

            parsers[token] = p;
        si
        
        void add_parser(T proc(CONTEXT) p, Iterable<Lexical.TOKEN> tokens) is
            foreach var t; tokens do
                add_parser(p, t);
            od
        si

        T parse(CONTEXT context) is
            var p = parsers[context.current.token]; 

            if p != null then
                return p(context);
            else
                return other_token(context);
            fi
        si

        T other_token(CONTEXT context) is
            context.error(context.location, "%: expected % but found %" 
                % Object{
                    syntax_error_message,
                    Lexical.TOKEN_NAMES[expected_tokens],
                    context.current_token_name
                }
            );            
        si

        private void populate_expected_tokens() is
            var et = new Vector<Lexical.TOKEN>();

            foreach var k; parsers.keys() do
                et.add(k);                        
            od

            assert(et.Length > 0, "should have at least one expected token");

            _expected_tokens = et;
        si
    si
si si

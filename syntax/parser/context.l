namespace Syntax is
    namespace Parser is
        use System;
        use Generic;

        use Logging;
        use Source;

        class CONTEXT is
            LOCATION last_error_location;
            String last_error_message;

            public bool allow_tuple_element;

            public Lexical.TOKENIZER tokenizer;

            public LOGGER logger;
            
            void init(Lexical.TOKENIZER tokenizer, LOGGER logger) is
                this.tokenizer = tokenizer;
                this.logger = logger;

                this.tokenizer.next();

                last_error_location = this.location;
                last_error_message = "";
            si

            bool next_token() is
                var result = tokenizer.next();

/*
                if current.token == Lexical.TOKEN.IDENTIFIER then
                    IO.Std.err.println(" " + current.string);
                else 
                    IO.Std.err.println(" " + Lexical.TOKEN_NAMES[current.token]);
                fi
*/

                return result;
            si

            get Lexical.TOKEN_PAIR current is
                return tokenizer.current;
            si

            void write_token(Lexical.TOKEN_PAIR token) is
                tokenizer.write_token(token);
                next_token();
            si

            void write_tokens(Iterable<Lexical.TOKEN_PAIR> tokens) is
                tokenizer.write_tokens(tokens);
                next_token();
            si

            LOCATION location_and_next() is
                // CQS eat me
                var result = location;

                next_token();

                return result;
            si

            void skip_token(List<Lexical.TOKEN> tokens, String message) is
                var start = location;

                do
                    if is_end_of_file then
                        error(start..location, "%: expected %" % Object{message, Lexical.TOKEN_NAMES[current_token]});
                        return;
                    elif tokens.contains(current_token) then
                        error(start..location, "%: expected %" % Object{message, Lexical.TOKEN_NAMES[current_token]});
                        
                        next_token();
                        return;
                    else
                        next_token();
                    fi
                od
            si

            void skip_token(Lexical.TOKEN token, String message) is
                var t = new Vector<Lexical.TOKEN>();
                t.add(token);                
                skip_token(t, message);
            si

            get LOCATION location is
                return tokenizer.current.location;
            si

            get Lexical.TOKEN current_token is
                return tokenizer.current.token;
            si

            get String current_string is
                return tokenizer.current.string;
            si

            get bool is_end_of_file is
                return tokenizer.is_end_of_file;
            si

            public bool expect_token(Lexical.TOKEN token, String message) is
                if current_token != token then
                    error(
                        location,
                        "%: expected % but found %"
                            % Object{message, Lexical.TOKEN_NAMES[token], Lexical.TOKEN_NAMES[current_token]});
                    return false;
                else
                    return true;
                fi
            si

            public bool expect_token(Lexical.TOKEN token) is
                return expect_token(token, "syntax error");
            si

            public bool expect_token(List<Lexical.TOKEN> tokens, String message) is
                if !tokens.contains(current_token) then
                    error(
                        location,
                        "%: expected % but found %"
                            % Object{message, Lexical.TOKEN_NAMES[tokens], Lexical.TOKEN_NAMES[current_token]});
                    return false;
                else
                    return true;
                fi
            si

            public bool expect_token(List<Lexical.TOKEN> tokens) is
                return expect_token(tokens, "syntax error");
            si

            public bool next_token(Lexical.TOKEN token, String message) is
                if expect_token(token, message) then
                    next_token();

                    return true;
                fi
            si

            public bool next_token(List<Lexical.TOKEN> tokens, String message) is
                if expect_token(tokens, message) then
                    next_token();

                    return true;
                fi
            si

            public bool next_token(Lexical.TOKEN token) is
                return next_token(token, "syntax error");
            si

            public bool next_token(List<Lexical.TOKEN> tokens) is
                return next_token(tokens, "syntax error");
            si            

            public void error(LOCATION location, String message) is
                if location !~ last_error_location || message !~ last_error_message then
                    last_error_location = location;
                    last_error_message = message;

                    logger.error(location, message);
                elif !is_end_of_file then
                    // FIXME: better error recovery
                    next_token();
                else
                    throw new Exception("give up");
                fi
            si
        si
    si
si

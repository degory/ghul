namespace Syntax is
    namespace Parser is
        use System;
        use Generic;

        use Logging;
        use Source;

        class CONTEXT is
            LOCATION last_error_location;
            String last_error_message;

            Vector<Lexical.TOKEN_PAIR> speculative_parse_tokens;

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

                if speculative_parse_tokens != null then
                    speculative_parse_tokens.add(current);
                fi

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

            void mark() is
                assert(speculative_parse_tokens == null, "cannot start nested speculative parse");

                speculative_parse_tokens = new Vector<Lexical.TOKEN_PAIR>();

                speculative_parse_tokens.add(current);
            si

            void commit() is
                assert(speculative_parse_tokens != null, "cannot commit: not in speculative parse");

                speculative_parse_tokens = null;
            si

            void backtrack() is
                assert(speculative_parse_tokens != null, "cannot backtrack: not in speculative parse");

                write_tokens(speculative_parse_tokens);

                speculative_parse_tokens = null;
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

            get String current_token_name is
                var result = Lexical.TOKEN_NAMES[current_token];

                if result == null then
                    result = "unknown";
                fi

                if current_string != null && current_string !~ result then
                    result = result + ' ' + current_string;
                fi

                return result;
            si

            public bool expect_token(Lexical.TOKEN token, String message) is
                if current_token != token then
                    error(
                        location,
                        "%: expected % but found %"
                            % Object{message, Lexical.TOKEN_NAMES[token], current_token_name});
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
                            % Object{message, Lexical.TOKEN_NAMES[tokens], current_token_name});
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

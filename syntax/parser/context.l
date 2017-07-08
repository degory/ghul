namespace Syntax is
    namespace Parser is
        use System;
        use Generic;

        use Logging;
        use Source;

        class CONTEXT is
            void init(Lexical.TOKENIZER tokenizer, LOGGER logger) is
                this.tokenizer = tokenizer;
                this.logger = logger;

                this.tokenizer.next();                
            si

            // FIXME: without generic methods and/or reflection, it's tricky to do this in a nice open/closed way:
            static TYPE type_parser = new TYPE();
            static IDENTIFIER identifier_parser = new IDENTIFIER();
            static DEFINITION definition_parser = new DEFINITION();
            static EXPRESSION expression_parser = new EXPRESSION();
            static Expression.LITERAL expression_literal_parser = new Expression.LITERAL();
            static Expression.PRIMARY expression_primary_parser = new Expression.PRIMARY();
            static Expression.SECONDARY expression_secondary_parser = new Expression.SECONDARY();
            static Expression.TUPLE expression_tuple_parser = new Expression.TUPLE();

            public Lexical.TOKENIZER tokenizer;

            public LOGGER logger;

            bool next_token() is
                return tokenizer.next();
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
                logger.error(location, message);
            si

            public Tree.TYPE parse_type() is
                return type_parser.parse(this);
            si

            public Tree.IDENTIFIER parse_qualified_identifier() is
                return identifier_parser.parse(this);
            si

            public Tree.IDENTIFIER parse_unqualified_identifier() is
                return identifier_parser.parse_unqualified_identifier(this);
            si            

            public Tree.DEFINITION parse_definition() is
                return definition_parser.parse(this);
            si

            public Tree.EXPRESSION parse_expression() is
                return expression_parser.parse(this);
            si

            public Tree.Expression.LITERAL parse_expression_literal() is
                return expression_literal_parser.parse(this);
            si

            public Tree.Expression.IDENTIFIER parse_expression_identifier() is
                return expression_primary_parser.parse_identifier(this);
            si

            public Tree.Expression.EXPRESSION_LIST parse_expression_list() is
                return expression_parser.parse_expression_list(this);
            si

            public Tree.Expression.PRIMARY parse_expression_primary() is
                return expression_primary_parser.parse(this);
            si

            public Tree.EXPRESSION parse_expression_secondary() is
                return expression_secondary_parser.parse(this);
            si

            public Tree.Expression.TUPLE parse_expression_tuple() is
                return expression_tuple_parser.parse(this);
            si
        si
    si
si

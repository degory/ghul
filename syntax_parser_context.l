namespace Syntax is
    namespace Parser is
        use System;
        use Logging;

        class CONTEXT is
            void init(Lexical.TOKENIZER tokenizer, LOGGER logger) is
                this.tokenizer = tokenizer;
                this.logger = logger;
            si

            // FIXME: without generic methods and/or reflection, it's tricky to do this in a nice open/closed way:
            static TYPE type_parser = new TYPE();
            static IDENTIFIER identifier_parser = new IDENTIFIER();
            static DEFINITION definition_parser = new DEFINITION();
            static EXPRESSION expression_parser = new EXPRESSION();

            public Lexical.TOKENIZER tokenizer;

            public LOGGER logger;

            bool next_token() is
                return tokenizer.next_token();
            si     

            get LOCATION location is
                return new LOCATION(
                    tokenizer.current_file,

                    tokenizer.current_line,
                    0,
                    tokenizer.current_line,
                    0
                );                    
            si

            get Lexical.TOKEN current_token is
                return tokenizer.current_token;
            si

            get String current_string is
                return tokenizer.current_string;
            si

            public bool expect_token(Lexical.TOKEN token) is
                if current_token != token then
                    error(
                        location,
                        "syntax error: expected % but found %"
                            % Object{token, current_token});
                fi
            si

            public bool next_token(Lexical.TOKEN token) is
                if expect_token(token) then
                    next_token();
                fi
            si

            public void error(LOCATION location, String message) is
                logger.error(location, message);
            si

            public Tree.TYPE parse_type() is
                return type_parser.parse(this);
            si

            public Tree.IDENTIFIER parse_identifier() is
                return identifier_parser.parse(this);
            si

            public Tree.DEFINITION parse_definition() is
                return definition_parser.parse(this);
            si

            public Tree.EXPRESSION parse_expression() is
                return expression_parser.parse(this);
            si
        si
    si
si

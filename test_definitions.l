import imports;

namespace Test is
    use System;
    use Logging;
    
    class Main is
        void init() is
            try 
                IO.Std.err.FlushOnPrintln = true;

                var args = Arguments.ProgramArguments.Iterator;

                args.nextElement();

                foreach var s; args do
                    var tokenizer = new Lexical.TOKENIZER(
                        s,
                        IO.File.openRead(s)
                    );

                    var logger = new LOGGER();                    

                    var context = new Syntax.Parser.CONTEXT(
                        tokenizer,
                        logger
                    );

                    var i = 0;

                    while !context.is_end_of_file do
                        // IO.Std.err.printlcn("not end of file, next token is: " + Lexical.TOKEN_NAMES[context.current_token]);

                        var definition = context.parse_definition();

                        if definition != null then
                            logger.info(definition.location, "read definition %" % Object{definition});
                            context.next_token(Lexical.TOKEN.SEMICOLON);
                        else
                            context.skip_token(Lexical.TOKEN.SEMICOLON);
                        fi

                        i = i + 1;
                    od
                od
            catch Exception e
                IO.Std.err.println(e);            
            yrt
        si
    si
si


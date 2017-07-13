import imports;

namespace Test is
    use System;
    use Logging;
    
    class Main is
        void init() is
            try 
                var container = new IoC.CONTAINER();

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
                        var definition = container.definition_parser.parse(context);

                        if definition != null then
                            logger.info(definition.location, "read definition " + Object.dump(definition));
                            logger.info(definition.location, "read definition \"%\"" % Object{definition});
                            context.next_token(Lexical.TOKEN.SEMICOLON, "in definition statement");
                        else
                            context.skip_token(Lexical.TOKEN.SEMICOLON, "in definition statement");
                        fi

                        i = i + 1;
                    od

                    logger.info(context.location, "finished");
                od
            catch Exception e
                IO.Std.err.println(e);            
            yrt
        si
    si
si


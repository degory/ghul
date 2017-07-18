import imports;

namespace Test is
    use System;
    use Logging;
    
    class Main is
        void init() is
            var any_errors = false;

            try 
                var container = new IoC.CONTAINER();

                IO.Std.err.FlushOnPrintln = true;

                var args = Arguments.ProgramArguments.Iterator;

                args.nextElement();

                foreach var s; args do
                    IO.Std.err.println("will parse: " + s + "...");

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
                        fi

                        i = i + 1;
                    od

                    logger.info(context.location, "finished");

                    any_errors = any_errors || logger.any_errors;
                od

                IO.Std.err.println("exiting");
                IO.Std.err.flush();

                native.exit(cast int(any_errors));
            catch Exception e
                IO.Std.err.println(e);
                native.exit(1);
            yrt
        si
    si
si


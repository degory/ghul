import imports;

namespace Test is
    use System;
    use Logging;
    
    class Main is
        void init() is
            var want_legacy = false;
            var any_errors = false;

            try 
                var logger = new LOGGER();                    
            
                var container = new IoC.CONTAINER();

                IO.Std.err.FlushOnPrintln = true;

                var args = Arguments.ProgramArguments.Iterator;

                args.nextElement();

                foreach var s; args do
                    if s =~ "-L" then
                        want_legacy = true;
                    elif s =~ "-G" then
                        want_legacy = false;
                    else

                        IO.Std.err.println("will parse: " + s + "...");

                        var tokenizer = new Lexical.TOKENIZER(
                            s,
                            IO.File.openRead(s)
                        );

                        var context = new Syntax.Parser.CONTEXT(
                            tokenizer,
                            logger
                        );

                        var i = 0;

                        while !context.is_end_of_file do
                            var definition = container.definition_parser.parse(context);

                            if definition != null then
                                logger.info(definition.location, "read definition " + Object.dump(definition));

                                Syntax.Process.Printer.BASE printer;

                                if want_legacy then
                                    printer = new Syntax.Process.Printer.LEGACY(logger);
                                else
                                    printer = new Syntax.Process.Printer.GHUL();
                                fi

                                printer.print(definition);

                                IO.Std.err.println(printer.result);

                                if want_legacy then
                                    var out_file_name = s.substring(0, s.Length-5) + ".l";
                                    var writer = IO.File.openWrite(out_file_name);

                                    writer.print(printer.result);

                                    writer.close();
                                fi
                            fi

                            i = i + 1;
                        od

                        logger.info(context.location, "finished");

                        any_errors = any_errors || logger.any_errors;
                    fi
                od

                if any_errors then
                    IO.Std.err.println("FAILED");                    
                else
                    IO.Std.err.println("success");
                fi

                IO.Std.err.flush();

                native.exit(cast int(any_errors));
            catch Exception e
                IO.Std.err.println(e);
                native.exit(1);
            yrt
        si
    si
si


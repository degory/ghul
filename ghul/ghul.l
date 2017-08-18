import imports;

namespace Ghul is
    use System;
    use Generic;

    use Logging;
    
    class Main is
        static bool is_legacy(String file_name) is
            return file_name.endsWith(".l");
        si

        static bool is_ghul(String file_name) is
            return file_name.endsWith(".ghul");
        si

        static String legacy_source_file_name(String file_name) is
            if !is_ghul(file_name) then
                throw new Exception("not a ghul source file: " + file_name);
            fi

            return file_name.substring(0, file_name.Length - 5) + ".lo";
        si

        void init() is
            var want_legacy = false;
            var any_errors = false;

            var to_build = new Vector<String>({"lc"});

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
                    elif is_legacy(s) then
                        to_build.add(s);
                    elif is_ghul(s) then
                        IO.Std.err.println("will parse: " + s + "...");

                        var legacy_output = legacy_source_file_name(s);

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

                                // var all = new Syntax.All();
                                var test = new Syntax.Process.Test();

                                definition.walk(test);

                                IO.Std.err.println(test.result);

                                Syntax.Process.Printer.BASE printer;

                                if want_legacy then
                                    printer = new Syntax.Process.Printer.LEGACY(logger);
                                else
                                    printer = new Syntax.Process.Printer.GHUL();
                                fi

                                printer.print(definition);

                                IO.Std.err.println(printer.result);

                                if want_legacy then
                                    to_build.add(legacy_output);
                                    
                                    var writer = IO.File.openWrite(legacy_output);

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

                if !any_errors then
                    if to_build.Length > 1 then
                        var process = new Util.Process();

                        var result = process.run("/usr/bin/lc", to_build.Array, Arguments.ProgramEnvironment, true);

                        native.exit(result);
                    else
                        native.exit(0);
                    fi
                else
                    native.exit(1);
                fi
            catch Exception e
                IO.Std.err.println(e);
                native.exit(1);
            yrt
        si
    si
si


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
            var ignore_errors = false;
            var want_experiments = false;

            var to_build = new Vector<String>({"lc"});

            try 
                var container = IoC.CONTAINER.instance;
                var logger = container.logger;

                var symbol_table = new Syntax.SYMBOL_TABLE(logger);
                var namespaces = new Syntax.NAMESPACES(logger, scopes);
            
                IO.Std.err.FlushOnPrintln = true;

                var args = Arguments.ProgramArguments.Iterator;

                args.nextElement();

                foreach var s; args do
                    if s =~ "-L" then
                        want_legacy = true;
                    elif s =~ "-G" then
                        want_legacy = false;
                    elif s =~ "-E" then
                        ignore_errors = true;
                    elif s =~ "-X" then
                        want_experiments = true;
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
                                definition.walk(new Syntax.Process.EXPAND_NAMESPACES());

                                if want_experiments then
                                    new Syntax.Process.REWRITE_OPERATORS_AS_CALLS()
                                        .apply(definition);

                                    new Syntax.Process.REWRITE_STRUCTURED_TYPES_AS_CLASSES()
                                        .apply(definition);
                                fi

                                new Syntax.Process.DECLARE_SYMBOLS(scopes, namespaces)
                                    .apply(definition);

                                if want_experiments then
                                    new Syntax.Process.INFER_TYPES(logger, scopes, namespaces)
                                        .apply(definition);
                                fi

                                // definition.walk(new Syntax.Process.SCOPE_TEST(logger, scopes, namespaces));

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
                                    
                                    var writer = IO.File.openCreate(legacy_output);

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

                if ignore_errors || !any_errors then
                    if to_build.Length > 1 then
                        to_build.add("-o");
                        to_build.add("binary");

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


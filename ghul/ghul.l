import imports;

namespace Ghul is
    use System;
    use Generic;

    use IoC;
    use Logging;
    
    class BUILD_FLAGS is
        public bool is_legacy;
        public bool want_legacy;
        public bool want_experiments;
        public bool ignore_errors;
        public String legacy_object_name;

        void init() is
        si

        BUILD_FLAGS copy() is
            return cast BUILD_FLAGS(clone());
        si
    si

    class WORK_ITEM is
        public BUILD_FLAGS build_flags;

        public Syntax.Tree.Definition.NODE definition;

        void init(BUILD_FLAGS build_flags, Syntax.Tree.Definition.NODE definition) is
            this.build_flags = build_flags;
            this.definition = definition;
        si
    si

    class COMPILER is
        CONTAINER container;
        LOGGER logger;
        Syntax.SYMBOL_TABLE symbol_table;
        Syntax.NAMESPACES namespaces;

        Vector<WORK_ITEM> work_items;

        Vector<void proc(WORK_ITEM)> passes;

        Vector<String> results;

        void init() is
            container = IoC.CONTAINER.instance;
            logger = container.logger;

            symbol_table = new Syntax.SYMBOL_TABLE(logger);
            namespaces = new Syntax.NAMESPACES(logger, symbol_table);

            work_items = new Vector<WORK_ITEM>();
            results = new Vector<String>();

            passes = new Vector<void proc(WORK_ITEM)>();

            passes.add(void proc(WORK_ITEM)(this.declare_symbols_pass));
            passes.add(void proc(WORK_ITEM)(this.resolve_uses_pass));
            passes.add(void proc(WORK_ITEM)(this.experiments_pass));
            passes.add(void proc(WORK_ITEM)(this.write_objects_pass));
        si

        void parse(String path, BUILD_FLAGS build_flags) is
            var tokenizer = new Lexical.TOKENIZER(
                path,
                IO.File.openRead(path)
            );

            var context = new Syntax.Parser.CONTEXT(
                tokenizer,
                logger
            );

            while !context.is_end_of_file do
                var definition = container.definition_parser.parse(context);

                if definition != null then
                    work_items.add(new WORK_ITEM(build_flags, definition));
                fi
            od
        si     

        Iterable<String> build() is
            foreach var pass; passes do
                foreach var i; work_items do
                    pass(i);
                od
            od

            return results;
        si

        void declare_symbols_pass(WORK_ITEM work_item) is
            var flags = work_item.build_flags;
            var definition = work_item.definition;

            new Syntax.Process.EXPAND_NAMESPACES()
                .apply(definition);

            if flags.want_experiments then
                new Syntax.Process.REWRITE_OPERATORS_AS_CALLS()
                    .apply(definition);

                new Syntax.Process.REWRITE_STRUCTURED_TYPES_AS_CLASSES()
                    .apply(definition);
            fi

            new Syntax.Process.DECLARE_SYMBOLS(logger, symbol_table, namespaces)
                .apply(definition);
        si

        void resolve_uses_pass(WORK_ITEM work_item) is
            var flags = work_item.build_flags;
            var definition = work_item.definition;
            
            new Syntax.Process.RESOLVE_USES(logger, symbol_table, namespaces)
                .apply(definition);
        si

        void experiments_pass(WORK_ITEM work_item) is
            var flags = work_item.build_flags;
            var definition = work_item.definition;

            if flags.want_experiments then
                new Syntax.Process.TYPE_TEST(logger, symbol_table, namespaces)
                    .apply(definition);
            fi
        si            

        void write_objects_pass(WORK_ITEM work_item) is
            var flags = work_item.build_flags;
            var definition = work_item.definition;

            Syntax.Process.Printer.BASE printer;

            if flags.want_legacy then
                printer = new Syntax.Process.Printer.LEGACY(logger);
            else
                printer = new Syntax.Process.Printer.GHUL();
            fi

            printer.print(definition);

            IO.Std.err.println(printer.result);

            if flags.want_legacy then
                results.add(flags.legacy_object_name);
                
                var writer = IO.File.openCreate(flags.legacy_object_name);

                writer.print(printer.result);

                writer.close();
            fi
        si

        void build(WORK_ITEM work_item) is
        si
    si

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
            var flags = new BUILD_FLAGS();
            var compiler = new COMPILER();

            try 
                var container = IoC.CONTAINER.instance;
                var logger = container.logger;
            
                IO.Std.err.FlushOnPrintln = true;

                var args = Arguments.ProgramArguments.Iterator;

                var legacy_source_files = new Vector<String>();

                args.nextElement();

                foreach var s; args do
                    if s =~ "-L" then
                        flags.want_legacy = true;
                    elif s =~ "-G" then
                        flags.want_legacy = false;
                    elif s =~ "-E" then
                        flags.ignore_errors = true;
                    elif s =~ "-X" then
                        flags.want_experiments = true;
                    elif s =~ "-T" then
                        LOGGER.enable_trace = true;
                        logger.trace_channels.add(args.nextElement().split(','));

                    elif is_legacy(s) then
                        legacy_source_files.add(s);
                    elif is_ghul(s) then
                        IO.Std.err.println("will parse: " + s + "...");

                        flags.legacy_object_name = legacy_source_file_name(s);

                        compiler.parse(s, flags.copy());

                        IO.Std.err.println("after parse: " + s + "...");                        
                    fi
                od

                var to_build = new Vector<String>({"/usr/bin/lc"});

                to_build.add(compiler.build());

                if logger.any_errors then
                    IO.Std.err.println("FAILED");                    
                else
                    IO.Std.err.println("success");
                fi

                IO.Std.err.flush();

                if flags.ignore_errors || !logger.any_errors then
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


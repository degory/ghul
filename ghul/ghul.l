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

        void init() is
        si

        BUILD_FLAGS copy() is
            return cast BUILD_FLAGS(clone());
        si
    si

    class WORK_ITEM is
        public BUILD_FLAGS build_flags;

        public String legacy_object_file_name;

        public Syntax.Tree.Definition.NODE definition;

        void init(
            BUILD_FLAGS build_flags,
            String legacy_object_file_name,
            Syntax.Tree.Definition.NODE definition
        )
        is
            this.build_flags = build_flags;
            this.legacy_object_file_name = legacy_object_file_name;
            this.definition = definition;
        si
    si

    class Pass is
        String _description;

        void init(
            String description        )
        is
            this._description = description;
        si

        void apply(WORK_ITEM work_item) is
            throw new NotImplementedException();
        si

        String toString() is
            return _description;
        si
    si

    class PASS isa Pass is
        void proc(WORK_ITEM) _apply;

        void init(
            String description,
            void proc(WORK_ITEM) apply
        )
        is
            super.init(description);
            this._apply = apply;
        si

        void apply(WORK_ITEM work_item) is
            _apply(work_item);
        si
    si
    
    class SOURCE_FILE_CATEGORIZER is
        static bool is_legacy(String file_name) is
            return file_name.endsWith(".l");
        si

        static bool is_ghul(String file_name) is
            return file_name.endsWith(".ghul");
        si
    si

    class LEGACY_OBJECT_FILE_NAME_GENERATOR is
        SortedMap<String,int> _object_number;

        void init() is
            _object_number = new SortedMap<String,int>();
        si

        String new_object_file_name_for(String file_name) is
            if !SOURCE_FILE_CATEGORIZER.is_ghul(file_name) then
                throw new Exception("not a ghul source file: " + file_name);
            fi

            var result = file_name.substring(0, file_name.Length - 5);
            var on = _object_number[result];
            _object_number[result] = on + 1;
            
            return result + "." + on + ".lo";
        si
    si

    class LEGACY_COMPILER_FLAGS is
        Vector<String> _flags;

        get Iterable<String> flags is
            return _flags;
        si

        void init() is
            _flags = new Vector<String>();
            
            var env = Util.ProgramEnvironment.Map["LFLAGS"];

            if env == null || env =~ "" then
                IO.Std.err.println("No LFLAGS set");
       
                return;
            fi

            IO.Std.err.println("LFLAGS is " + env);

            foreach var f; env.split(' ') do
                var flag = f.trim();
                if flag !~ "" then
                    _flags.add(flag);
                fi
            od
        si
    si

    class COMPILER is
        CONTAINER container;
        LOGGER logger;

        LEGACY_OBJECT_FILE_NAME_GENERATOR legacy_object_file_name_generator;

        Syntax.SYMBOL_TABLE symbol_table;
        Syntax.NAMESPACES namespaces;

        Vector<WORK_ITEM> work_items;

        Vector<Pass> passes;

        Vector<String> results;

        void init() is
            container = IoC.CONTAINER.instance;
            logger = container.logger;

            legacy_object_file_name_generator = new LEGACY_OBJECT_FILE_NAME_GENERATOR();

            symbol_table = new Syntax.SYMBOL_TABLE(logger);
            namespaces = new Syntax.NAMESPACES(logger, symbol_table);

            work_items = new Vector<WORK_ITEM>();
            results = new Vector<String>();

            passes = new Vector<Pass>();

            add_pass("declare-symbols", void proc(WORK_ITEM)(this.declare_symbols_pass));
            add_pass("resolve-uses", void proc(WORK_ITEM)(this.resolve_uses_pass));
            add_pass("experiments", void proc(WORK_ITEM)(this.experiments_pass));
            add_pass("write-objects", void proc(WORK_ITEM)(this.write_objects_pass));
        si

        void add_pass(String description, void proc(WORK_ITEM) apply) is
            passes.add(new PASS(description, apply));
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

                logger._trace("parse", "parsed " + path + " as " + definition);

                if definition != null then
                    work_items.add(
                        new WORK_ITEM(
                            build_flags,
                            legacy_object_file_name_generator.new_object_file_name_for(path),
                            definition
                        )
                    );
                fi
            od
        si     

        Iterable<String> build() is
            foreach var pass; passes do
                logger._trace("pass", "start pass " + pass);
                foreach var i; work_items do
                    logger._trace("pass", "running pass " + pass + " on " + i.definition.location);
                    pass.apply(i);
                    logger._trace("pass", "completed pass " + pass + " on " + i.definition.location);
                od

                logger._trace("pass", "completed pass " + pass);                
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
                results.add(work_item.legacy_object_file_name);
                
                var writer = IO.File.openCreate(work_item.legacy_object_file_name);

                writer.print(printer.result);

                writer.close();
            fi
        si

        void build(WORK_ITEM work_item) is
        si
    si

    class Main is
        void init() is
            try 
                var container = IoC.CONTAINER.instance;
                var logger = container.logger;

                var legacy_compiler_flags = new LEGACY_COMPILER_FLAGS();
                var flags = new BUILD_FLAGS();
                var compiler = new COMPILER();            
            
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

                    elif SOURCE_FILE_CATEGORIZER.is_legacy(s) then
                        legacy_source_files.add(s);
                    elif SOURCE_FILE_CATEGORIZER.is_ghul(s) then
                        compiler.parse(s, flags.copy());
                    fi
                od

                var to_build = new Vector<String>({"/usr/bin/lc"});

                to_build.add(compiler.build());

                to_build.add(legacy_source_files);

                if logger.any_errors then
                    IO.Std.err.println("FAILED");                    
                else
                    IO.Std.err.println("success");
                fi

                IO.Std.err.flush();

                if flags.ignore_errors || !logger.any_errors then
                    if to_build.Length > 1 then
                        to_build.add(legacy_compiler_flags.flags);

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


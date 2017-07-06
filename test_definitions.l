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

                    for var done = false; !done; do
                        var definition = context.parse_definition();

                        context.next_token(Lexical.TOKEN.SEMICOLON);    

                        if definition != null then
                            IO.Std.err.println("%: %" % Object{definition.location, definition});

                            var printer = new Syntax.Process.PRINTER();

                            definition.accept(printer);

                            IO.Std.err.println(printer.result);
                        else
                            done = true;
                        fi
                    od
                od
            catch Exception e
                IO.Std.err.println(e);                
            yrt
        si
    si
si


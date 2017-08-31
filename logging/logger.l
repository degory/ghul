namespace Logging is
    use System;

    use Source;

    class LOGGER is
        int error_count;

        IO.Writer writer;

        get bool any_errors is
            return error_count > 0;
        si

        void init() is
            super.init();

            this.writer = IO.Std.err;
        si

        void write(LOCATION location, String severity, String message) is
            writer.write(
                "%: %,%..%,%: %: %\n" % Object{
                    location.file_name,

                    location.start_line,
                    location.start_column,
                    location.end_line,
                    // FIXME: VS code seems to expect +1 here - are we needlessly adjusting in prev_char?
                    location.end_column + 1, 

                    severity,
                    message
                }
            );
        si

        void fatal(
            LOCATION location,
            String message
        )
        is
            write(location, "error", message);
            
            throw new Exception("fatal error");
        si

        void error(
            LOCATION location,
            String message
        )
        is
            write(location, "error", message);

            error_count = error_count + 1;

            if error_count >= 100 then
                throw new Exception("too many errors");
            fi
        si

        void warn(
            LOCATION location,
            String message
        )
        is
            write(location, "warn", message);
        si

        void info(
            LOCATION location,
            String message
        )
        is
            write(location, "info", message);
        si        
    si
si

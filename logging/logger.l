namespace Logging is
    use System;
    use Generic;

    use Source;

    class LOGGER is
        static bool _enable_trace;
        Set<String> _trace_channels;
        
        int error_count;

        IO.Writer writer;

        get bool any_errors is
            return error_count > 0;
        si

        void init() is
            super.init();

            _enable_trace = true;
            _trace_channels = new Set<String>({"find-symbol", "namespace"});

            this.writer = IO.Std.err;
        si

        void _trace(String channel, String message) is
            if _enable_trace && _trace_channels.contains(channel) then
                writer.write("trace: " + channel + ": " + message + "\n");
            fi
        si

        static void trace(String channel, String message) is
            if _enable_trace then
                IoC.CONTAINER.instance.logger._trace(channel, message);
            fi
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

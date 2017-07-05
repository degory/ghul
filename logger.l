namespace Logging is
    use System;

    use Source;

    class LOGGER is
        IO.Writer writer;

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
                    location.end_column,

                    severity,
                    message
                }
            );
        si

        void error(
            LOCATION location,
            String message
        )
        is
            write(location, "error", message);
        si

        void warn(
            LOCATION location,
            String message
        )
        is
            write(location, "warn", message);
        si
    si
si

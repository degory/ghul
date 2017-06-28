namespace Logging is
    use System;

    class LOGGER is
        IO.Writer writer;

        void init() is
            super.init();

            this.writer = IO.Std.err;
        si

        void write(Syntax.LOCATION location, String severity, String message) is
            writer.write(location.file_name);
            writer.write(": ");
            writer.write(location.start_line);
            writer.write(": ");
            writer.write(severity);
            writer.write(": ");
            writer.write(message);
            writer.write('\n');
        si

        void error(
            Syntax.LOCATION location,
            String message
        )
        is
            write(location, "error", message);
        si

        void warn(
            Syntax.LOCATION location,
            String message
        )
        is
            write(location, "warn", message);
        si
    si
si

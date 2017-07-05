namespace Syntax is
    use System;

    class LOCATION is
        const int SHIFT = 12;
        const int MASK = 0xFFF;

        public String file_name;

        // line << 12 + column - easier to compare
        int start;
        int end;

        void init(
            String file_name,

            int start_line,
            int start_column,
     
            int end_line,
            int end_column
        )
        is
            // IO.Std.err.println("new location % %,%..%,%" % Object{ file_name, start_line, start_column, end_line, end_column });

            this.file_name = file_name;

            if
                start_line <= 0 || start_column <= 0 ||
                end_line < 0 || end_column < 0
            then
                throw new BoundsException("invalid location %,%..%,%" % Object{ start_line, start_column, end_line, end_column });
            fi

            start = (start_line << SHIFT) | start_column;
            end = (end_line << SHIFT) | end_column;

            if end == 0 then
                end = start;
            elif end < start then
                var t = end;
                end = start;
                start = t;
            fi

            IO.Std.err.println("location normalised to %" % Object{ this });
        si

        private void init(
            String file_name,
            int start,
            int end
        )
        is
            this.file_name = file_name;
            this.start = start;
            this.end = end;
        si

        get int start_line is
            return start >> SHIFT;
        si

        get int start_column is
            return start & MASK;
        si

        get int end_line is
            return end >> SHIFT;
        si

        get int end_column is
            return end & MASK;
        si

        String toString() is
            return "% %,%..%,%" % Object{file_name, start_line, start_column, end_line, end_column};
        si

        LOCATION operator..(LOCATION with) is
            IO.Std.err.println("extend location % - %" % Object{this, with});

            int new_start, new_end;

            if start < with.start then
                new_start = start;
            else
                new_start = with.start;
            fi

            if end > with.end then
                new_end = end;
            else
                new_end = with.end;
            fi

            return new LOCATION(file_name, new_start, new_end);
        si                
    si
si

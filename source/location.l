
namespace Source is
    use System;

    class LOCATION is
        const int SHIFT = 12;
        const int MASK = 0xFFF;

        static LOCATION _dummy;

        static get LOCATION dummy is
            if _dummy == null then
                _dummy = new LOCATION("internal", 1, 1, 1, 1);
            fi
            
            return _dummy;
        si

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
            this.file_name = file_name;

            if
                start_line <= 0 || start_column < 0 ||
                end_line < 0 || end_column < 0
            then
                throw new BoundsException("invalid location %,%..%,%" % Object{ start_line, start_column, end_line, end_column });
            fi

            start = pair(start_line, start_column);
            end = pair(end_line, end_column);

            if end == 0 then
                end = start;
            elif end < start then
                var t = end;
                end = start;
                start = t;
            fi
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
            return line_of(start);
        si

        get int start_column is
            return column_of(start);
        si

        get int end_line is
            return line_of(end);
        si

        get int end_column is
            return column_of(end);
        si

        bool operator=~(LOCATION other) is
            if this == other then
                return true;
            else
                return this.start == other.start && this.end == other.end && this.file_name =~ other.file_name;
            fi
        si

        static int pair(int line, int column) is
            return (line << SHIFT) | column;
        si

        static int line_of(int line_column) is
            return line_column >> SHIFT;
        si

        static int column_of(int line_column) is
            return line_column & MASK;
        si

        bool contains(int line_column) is
            return
                this.start <= line_column &&
                this.end >= line_column;
        si

        bool contains(int line, int column) is
            return
                this.start_line <= line &&
                this.end_line >= line &&
                this.start_column <= column &&
                this.end_column >= column;
        si

        bool contains(LOCATION l) is
            return
                this.file_name =~ l.file_name &&
                this.contains(l.start) &&
                this.contains(l.end);
        si

        bool overlaps(LOCATION l) is
            return
                this.file_name == l.file_name &&
                    (this.contains(l.start) ||
                    this.contains(l.end));
        si

        String toString() is
            return "% %,%..%,%" % {file_name, start_line, start_column, end_line, end_column};
        si

        LOCATION operator..(LOCATION with) is
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

    class LOCATION_CURSOR is
        String _file_name;

        int _previous_line;
        int _previous_column;

        int _start_line;
        int _start_column;

        int _current_line;
        int _current_column;

        void init(String file_name) is
            _file_name = file_name;
            
            _previous_line = 1;
            _previous_column = 0;

            _start_line = 1;
            _start_column = 0;

            _current_line = 1;
            _current_column = 0;
        si

        void jump(int line, int column) is
            _start_line = line;
            _start_column = column;

            _current_line = line;
            _current_column = column;
        si

        void save() is
            _previous_line = _current_line;
            _previous_column = _current_column;
        si

        void restore() is
            _current_line = _previous_line;
            _current_column = _previous_column;
        si

        void start() is
            _start_line = _current_line;
            _start_column = _current_column;
        si

        void next_column() is
            _current_column = _current_column + 1;
        si

        void next_line() is
            _current_column = 0;
            _current_line = _current_line + 1;
        si

        get LOCATION location is
            return new LOCATION(
                _file_name,

                _start_line,
                _start_column,

                _current_line,
                _current_column
            );
        si
    si
si

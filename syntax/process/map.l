namespace Syntax is namespace Process is
    use Generic;

    use Source;
    use Tree;
    
    class MAP isa SortedMap<NODE,NODE> is
        static NODE _delete;

        void init() is
            super.init();

            if _delete == null then
                _delete = new NODE(LOCATION.dummy);
            fi
        si

        get NODE[NODE n] is
            if n == null then
                return null;
            fi
            
            var result = super[n];

            if result == _delete then
                return null;
            elif result == null then
                IO.Std.err.println("no rewrite for " + n);
                return n;
            else
                IO.Std.err.println("get rewrite " + n + " as " + result);

                return result;
            fi        
        si

        set NODE[NODE n] = m is
            var prev = super[n];

            if prev != null && prev != n then
                if prev == _delete then
                    IO.Std.err.println("replacing previously deleted value at " + n + " with " + m);
                else
                    IO.Std.err.println("replacing previously updated value " + prev + " at " + n + " with " + m);
                fi
            fi

            IO.Std.err.println("will rewrite " + n + " as " + m);

            super[n] = m;
        si

        void delete(NODE n) is
            this[n] = _delete;
        si
    si
si si
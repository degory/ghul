namespace System is
    class Coalesce<T> is
        static T c(T v1, T v2) is
            if v1 != null then
                return v1;
            else
                return v2;
            fi
        si

        static T c(T v1, T v2, T v3) is
            if v1 != null then
                return v1;
            elif v2 != null then
                return v2;
            else
                return v3;
            fi
        si

        static T c(T v1, T v2, T v3, T v4) is
            if v1 != null then
                return v1;
            elif v2 != null then
                return v2;
            elif v3 != null then
                return v3;
            else
                return v4;
            fi
        si

        static T c(T[] values) is
            foreach var v; values do
                if v != null then
                    return v;
                fi
            od

            return null;
        si
    si
si

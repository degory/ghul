import glist;

namespace Syntax is
    use System;
    use Generic;

    use Source;

    namespace Tree is
        class NODE is
            static int _next_id;
            int _id;

            public LOCATION location;            

            public get int id is
                return _id;
            si

            static get int next_id is
                var result = _next_id;
                _next_id = _next_id + 1;
                return result;
            si

            void init(LOCATION location) is
                _id = next_id;
                this.location = location;
            si

            int hash() is
                return id;
            si

            void invalidate(Iterable<Deletable<NODE>> from) is
                foreach var d; from do
                    d.delete(this);
                od

                _id = next_id;
            si

            bool operator=~(NODE other) is
                return _id == other._id;
            si

            int operator>(NODE other) is
                return _id - other._id;
            si

            void accept(Visitor visitor) is
                visitor.visit(this);
            si

            void walk(Visitor visitor) is
                accept(visitor);
            si

            String toString() is
                var printer = new Process.Printer.GHUL();

                accept(printer);

                return printer.result;
            si
        si
    si
si

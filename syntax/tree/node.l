import glist;

namespace Syntax is
    use System;
    use Generic;

    use Source;

    namespace Tree is
        class NODE is
            public LOCATION location;

            void init(LOCATION location) is
                this.location = location;
            si

            void accept(Visitor visitor) is
                visitor.visit(this);
            si

            public String toString() is
                var printer = new Process.Printer.GHUL();

                accept(printer);

                return printer.result;
            si
          si
    si
si

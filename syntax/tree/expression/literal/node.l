namespace Syntax is namespace Tree is namespace Expression is namespace Literal is
    use System;

    use Source;

    class NODE isa Expression.NODE is
        public String value;

        void init(
            LOCATION location,
            String value
        )
        is
            super.init(location);

            this.value = value;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si                
    si
si si si si

namespace Syntax is namespace Tree is namespace Body is
    use System;

    use Source;

    class NODE isa Tree.NODE is
        get bool is_block is
            return false;
        si

        void init(LOCATION location)
        is
            super.init(location);
        si

        void accept(Visitor visitor) is
            visitor.pre(this);

            visitor.visit(this);
        si
    si
si si si

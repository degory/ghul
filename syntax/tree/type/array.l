namespace Syntax is namespace Tree is namespace Type is 
    use Source;

    class ARRAY isa STRUCTURED is
        void init(LOCATION location, NODE element) is super.init(location, element); si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si
    si
si si si
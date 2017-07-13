namespace Syntax is namespace Parser is
    use Generic;

    class LAZY_PARSER<T> do Parser<T> is
        private Lazy<Parser<T>> _parser;

        set Parser<T> proc() create = value is
            this._parser = new Lazy<Parser<T>>(value);
        si

        void init() is
            super.init();
        si

        T parse(CONTEXT context) is
            return  _parser.value.parse(context);
        si
    si
si si

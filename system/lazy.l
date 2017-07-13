
namespace Generic is
    use System;

    class Lazy<T> is
        private T _value;
        private bool _has_value;

        private T proc() _create;
        private Exception _exception;

        void init(T proc() create) is
            this._create = create;
        si

        get T value is
            if _has_value then
                return _value;
            elif _exception != null then
                throw _exception;
            else
                try 
                    if _create == null then
                        throw new NullPointerException("cannot create " + this + " from null create proc");
                    fi
                
                    _value = _create();

                    _has_value = true;
                catch Exception e
                    _exception = e;

                    throw e;
                yrt

                return value;
            fi
        si
    si
si
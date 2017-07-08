namespace Syntax is
    namespace Tree is // FIXME
        use System;
        
        class Transformer is
            NODE visit(NODE node) is
                throw new NotImplementedException("Transformer % does not define a visit method for node %" % Object{this, node});
            si
        
            TYPE visit(TYPE type) is
                throw new NotImplementedException("Transformer % does not define a visit method for type %" % Object{this, type});
            si

            EXPRESSION visit(EXPRESSION expression) is
                throw new NotImplementedException("Transformer % does not define a visit method for expression %" % Object{this, expression});
            si

            IDENTIFIER visit(IDENTIFIER identifier) is
                throw new NotImplementedException("Transformer % does not define a visit method for identifier %" % Object{this, identifier});
            si

            DEFINITION visit(DEFINITION definition) is
                throw new NotImplementedException("Transformer % does not define a visit method for definition %" % Object{this, definition});
            si
        si
    si
si

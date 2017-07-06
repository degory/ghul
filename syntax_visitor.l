namespace Syntax is
    use System;

    use Tree;
    use Tree.Definition;
    use Tree.Type;

    class Visitor is
        void init() is
            super.init();
        si

        // node

        void visit(NODE node) is
            throw new NotImplementedException("Visitor % does not define a visit method for node %" % Object{this, node});
        si

        // identifiers

        void visit(IDENTIFIER identifier) is
            throw new NotImplementedException("Visitor % does not define a visit method for identifier %" % Object{this, identifier});
        si

        void visit(QUALIFIED_IDENTIFIER identifier) is
            throw new NotImplementedException("Visitor % does not define a visit method for identifier %" % Object{this, identifier});
        si

        // definitions

        void visit(VARIABLE variable) is
            throw new NotImplementedException("Visitor % does not define a visit method for variable %" % Object{this, variable});
        si

        void visit(VARIABLE_LIST variables) is
            throw new NotImplementedException("Visitor % does not define a visit method for % variable list %" % Object{this, variables});
        si

        void visit(LET l) is
            throw new NotImplementedException("Visitor % does not define a visit method for let %" % Object{this, l});
        si

        void visit(VAR v) is
            throw new NotImplementedException("Visitor % does not define a visit method for var %" % Object{this, v});
        si

        void visit(DEFINITION definition) is
            throw new NotImplementedException("Visitor % does not define a visit method for definition %" % Object{this, definition});
        si

        void visit(DEFINITION_LIST definitions) is
            throw new NotImplementedException("Visitor % does not define a visit method for definition list %" % Object{this, definitions});
        si

        // types

        void visit(TYPE type) is
            throw new NotImplementedException("Visitor % does not define a visit method for type %" % Object{this, type});
        si

        void visit(BUILT_IN built_in) is
            throw new NotImplementedException("Visitor % does not define a visit method for built in %" % Object{this, built_in});
        si        

        void visit(STRUCTURED structured) is
            throw new NotImplementedException("Visitor % does not define a visit method for structured %" % Object{this, structured});
        si

        void visit(ARRAY array) is
            throw new NotImplementedException("Visitor % does not define a visit method for array %" % Object{this, array});
        si

        void visit(POINTER pointer) is
            throw new NotImplementedException("Visitor % does not define a visit method for pointer %" % Object{this, pointer});
        si

        void visit(REFERENCE reference) is
            throw new NotImplementedException("Visitor % does not define a visit method for reference %" % Object{this, reference});
        si

        void visit(NAMED named) is
            throw new NotImplementedException("Visitor % does not define a visit method for named %" % Object{this, named});
        si

        void visit(GENERIC generic) is
            throw new NotImplementedException("Visitor % does not define a visit method for generic %" % Object{this, generic});
        si        
        
        // expressions

        void visit(EXPRESSION expression) is
            throw new NotImplementedException("Visitor % does not define a visit method for expression %" % Object{this, expression});
        si

        void visit(Expression.IDENTIFIER identifier) is
            throw new NotImplementedException("Visitor % does not define a visit method for identifier %" % Object{this, identifier});
        si
        
        void visit(Expression.NONE none) is
            throw new NotImplementedException("Visitor % does not define a visit method for none %" % Object{this, none});
        si

        void visit(Expression.UNARY unary) is
            throw new NotImplementedException("Visitor % does not define a visit method for unary %" % Object{this, unary});
        si

        void visit(Expression.BINARY binary) is
            throw new NotImplementedException("Visitor % does not define a visit method for binary %" % Object{this, binary});
        si
    si
si

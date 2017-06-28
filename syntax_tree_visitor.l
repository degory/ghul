namespace Syntax is
    namespace Tree is
        use System;
        use Definition;
        use Type;

        class Visitor is
            void visit(NODE node) is
                throw new NotImplementedException();
            si
        
            void visit(TYPE type) is
                throw new NotImplementedException();
            si

            void visit(EXPRESSION expression) is
                throw new NotImplementedException();
            si

            void visit(IDENTIFIER identifier) is
                throw new NotImplementedException();
            si

            void visit(QUALIFIED_IDENTIFIER identifier) is
                throw new NotImplementedException();
            si

            void visit(VARIABLE variable) is
                throw new NotImplementedException();
            si

            void visit(VARIABLE_LIST variables) is
                throw new NotImplementedException();
            si

            void visit(LET l) is
                throw new NotImplementedException();
            si

            void visit(VAR v) is
                throw new NotImplementedException();
            si

            void visit(DEFINITION definition) is
                throw new NotImplementedException();
            si

            void visit(DEFINITION_LIST definitions) is
                throw new NotImplementedException();
            si
        si
    si
si

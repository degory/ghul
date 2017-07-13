
namespace Syntax is namespace Parser is namespace Body is
    use System;

    class NODE isa BASE<Tree.Body.NODE> is
        Parser<Tree.Expression.NODE> expression_parser;
        Parser<Tree.Statement.NODE> statement_parser;
        Parser<Tree.Statement.LIST> statement_list_parser;

        get String description is
            return "function body";
        si                

        void init(
            Parser<Tree.Expression.NODE> expression_parser,
            Parser<Tree.Statement.NODE> statement_parser,
            Parser<Tree.Statement.LIST> statement_list_parser
        )
        is
            super.init();

            this.expression_parser = expression_parser;
            this.statement_parser = statement_parser;
            this.statement_list_parser = statement_list_parser;

            add_parser(
                Tree.Body.NODE proc(CONTEXT context) is
                    context.next_token(Lexical.TOKEN.ARROW_FAT);
                    
                    var expression = expression_parser.parse(context);

                    return new Tree.Body.EXPRESSION(
                        expression.location,
                        expression
                    );

                si,
                Lexical.TOKEN.ARROW_FAT
            );

            add_parser(
                Tree.Body.NODE proc(CONTEXT context) is
                    var start = context.location;

                    context.next_token(Lexical.TOKEN.IS);

                    var statement_list = statement_list_parser.parse(context);

                    var end = context.location;

                    context.next_token(Lexical.TOKEN.SI);

                    return new Tree.Body.BLOCK(
                        start..end,
                        statement_list
                    );
                si,
                Lexical.TOKEN.IS
            );
        si

        Tree.Body.NODE other_token(CONTEXT context) is
            return null;
        si
    si
si si si
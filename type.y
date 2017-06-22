%glr-parser
%define api.value.type { void * }
%{
#include <stdio.h>
#include "forward.h"
%}

%token FIRST           0

%token ARRAY_DEF       1 
%token BOOL	       2
%token BYTE	       3
%token CHAR	       4
%token INT 	       5
%token LONG 	       6
%token WORD 	       7
%token POINTER 	       8
%token REFERENCE       9

%token ADD 	      10
%token AND 	      11
%token ASSERT 	      12
%token ASSIGN	      13
%token AT	      14
%token BOOL_AND	      15
%token BOOL_NOT	      16
%token BOOL_OR	      17
%token BREAK	      18
%token CASE	      19
%token CAST	      20
%token CATCH	      21
%token CLASS	      22 
%token CLOSE_GENERIC  23
%token CLOSE_PAREN    24
%token CLOSE_SQUARE   25
%token COLON	      26
%token COMMA	      27
%token CONST	      28
%token CONST_CHAR     29
%token CONST_CSTRING  30
%token CONST_DOUBLE   31
%token CONST_FALSE    32
%token CONST_INT      33
%token CONST_NULL     34
%token CONST_STRING   35
%token CONST_TRUE     36
%token CONTINUE	      37
%token DEFAULT	      38
%token DIV	      39
%token DO	      40
%token DOT	      41
%token ELIF	      42
%token ELSE	      43
%token SI	      44
%token END_BLOCK      45
%token SEMICOLON      46
%token ENUM	      47
%token END_OF_INPUT   48
%token EQ	      49
%token ESAC	      50
%token EXTENDS	      51
%token FI	      52
%token FINALLY	      53
%token FOR	      54
%token FOREACH	      55
%token GE	      56
%token GET	      57
%token GT	      58
%token IDENTIFIER     59
%token IF	      60
%token IMPORT	      61
%token IS	      62
%token LE	      63
%token LT	      64
%token METHOD	      65
%token MOD	      66
%token MUL	      67
%token NAMESPACE      68
%token NATIVE	      69
%token NE	      70
%token NEW	      71
%token NEWLINE	      72
%token NOT	      73
%token OBJ_EQ	      74
%token OBJ_NE	      75
%token OD	      76
%token OF	      77
%token OPEN_GENERIC   78
%token OPEN_PAREN     79
%token OPEN_SQUARE    80
%token OR	      81
%token PRAGMA	      82
%token PRIVATE	      83
%token PROTECTED      84
%token PUBLIC	      85
%token QUESTION	      86
%token RETURN	      87
%token SET	      88
%token SHIFT_LEFT     89
%token SHIFT_RIGHT    90
%token START_BLOCK    91
%token STATIC	      92
%token STRUCT	      93
%token SUB	      94
%token SUPER	      95
%token SWITCH	      96
%token THEN	      97
%token THIS	      98
%token THREAD	      99
%token THROW	     100
%token TRY	     101
%token UNKNOWN	     102
%token UNTIL	     103
%token USE	     104
%token VAR	     105
%token VECTOR	     106
%token VOID	     107
%token WHILE	     108
%token XOR	     109
%token YRT	     110
%token DO_WHILE      111
%token IMPLEMENTS    112
%token INTERFACE     113
%token PROC          114
%token ISA           115
%token OPERATOR	     116
%token RANGE	     117
%token ARROW         118
%token LET           119

%token PREC_0        200
%token PREC_1        201
%token PREC_2        202
%token PREC_3        203
%token PREC_4        204

%token CALL	     250
%token TUPLE	     251

%right DOT

%left TUPLE
%left CALL

%left MUL DIV MOD
%left ADD SUB
%left RANGE

%start ROOT

%%
ROOT : function_body ;

definition : 
   | LET optionally_typed_identifier_list ASSIGN expression
   | VAR optionally_typed_identifier_list
   | VAR optionally_typed_identifier_list ASSIGN expression
   ;

identifier : IDENTIFIER { Syntax_IDENTIFIER_create("test"); };

qualified_identifier :
    identifier
    | qualified_identifier[qid] DOT identifier { Syntax_QUALIFIED_IDENTIFIER_create($qid, $identifier); }
    ;

/*
identifier_list : 
    identifier
    | identifier_list COMMA identifier
    ;
*/

type_list :
    type
    | type_list COMMA type
    ;

type : 
    qualified_identifier { Syntax_Type_NAMED_create($qualified_identifier); }
    | built_in_type
    | structured_type
    ;

built_in_type:
    VOID { Syntax_Type_VOID_create(); }
    | BOOL { Syntax_Type_BOOL_create(); }
    | BYTE { Syntax_Type_BYTE_create(); }
    | CHAR { Syntax_Type_CHAR_create(); }
    | INT { Syntax_Type_INT_create(); }
    | WORD { Syntax_Type_WORD_create(); }
    | LONG { Syntax_Type_LONG_create(); }
    ;

structured_type :
    array_type
    | pointer_type
    | reference_type
    | function_type
    | tuple_type
    ;

array_type:	
    ARRAY_DEF type { $$ = Syntax_Type_ARRAY_create($type); }
    ;

pointer_type:
    POINTER type { Syntax_Type_POINTER_create($type); }
    ;

reference_type:	
    REFERENCE type { Syntax_Type_REFERENCE_create($type); }
    ;

function_type:
    OPEN_PAREN type_list CLOSE_PAREN ARROW type
    | OPEN_PAREN CLOSE_PAREN ARROW type
    ;

tuple_type:
    OPEN_PAREN typed_identifier_list CLOSE_PAREN
    | OPEN_PAREN type_list CLOSE_PAREN
    | OPEN_PAREN CLOSE_PAREN
    ;
	
typed_identifier :
    identifier COLON type ;

optionally_typed_identifier :
    qualified_identifier 
    | typed_identifier
    ;

typed_identifier_list :
    typed_identifier
    | typed_identifier_list COMMA typed_identifier
    ;

optionally_typed_identifier_list :
    optionally_typed_identifier
    | optionally_typed_identifier_list COMMA optionally_typed_identifier
    ;

////////////////////////////

tuple :
    OPEN_PAREN expression_list CLOSE_PAREN // %prec TUPLE
    | OPEN_PAREN CLOSE_PAREN // %prec TUPLE
    ;

thing :
    // optionally_typed_identifier
    qualified_identifier
    | tuple
    | OPEN_PAREN optionally_typed_identifier_list CLOSE_PAREN ARROW expression
    // | tuple ARROW expression
    ;

call_expression :
    thing
    | thing OPEN_PAREN expression_list CLOSE_PAREN // %prec CALL
    | thing OPEN_PAREN CLOSE_PAREN // %prec CALL
    ;

mul_expression :
    call_expression
    | mul_expression MUL call_expression
    | mul_expression DIV call_expression
    | mul_expression MOD call_expression
    ;

add_expression :
    mul_expression
    | add_expression ADD mul_expression
    | add_expression SUB mul_expression
    ;

range_expression :
    add_expression
    | range_expression RANGE add_expression 
    ;

expression :
    range_expression
    ;

expression_list :
    expression
    | expression_list COMMA expression
    ;

function_body :
    statement_list
    | // empty
    ;

statement_list :
    statement
    | statement_list statement
    ;

statement :
    definition_statement
    | assignment_statement
    ;

definition_statement :
    definition SEMICOLON;

assignment_statement :
    assignment SEMICOLON;

assignment :
    identifier ASSIGN expression;

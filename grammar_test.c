#include <stdio.h>
#include "type.tab.h"

extern int yydebug;

static int index = 0;

static int canned[] = {
  LET, IDENTIFIER, COLON, INT, ASSIGN, IDENTIFIER, ADD, IDENTIFIER, SEMICOLON
};

int yylex(void) {
  yydebug = 1;
  fprintf(stderr, "yylex -> %d\n", canned[index]);

  return canned[index++];
}

extern int yyparse(void);

void yyerror (char const *s)
{
  fprintf (stderr, "%s\n", s);
}



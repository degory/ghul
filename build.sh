bison -x -v -d type.y
../llc/lc -FN -FB ast.l

gcc -c -DYYDEBUG=1 type.tab.c
gcc -c forward.c
gcc -c grammar_test.c

../llc/lc -FN -FB ast.l
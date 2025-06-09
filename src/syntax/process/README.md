# AST passes

The files in this directory implement visitors over the syntax tree.  Many are
true compilation phases (declaration, type checking, code generation) while
others provide features for the editor such as completions and signature help.

Older experimental visitors remain for reference; unused ones are marked in the
source.  Check `Driver.Main` and `Analysis.ANALYSER` to see which passes are
currently invoked.


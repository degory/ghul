# Compiler driver and analyser

The compiler can be run either in compilation mode or analysis mode

The compiler driver deals with:

- Parsing command line arguments, including source files and options
- Directing the parser to generate syntax trees from source files
- Running selected passes over the syntax trees

The analyser services requests from Visual Studio Code when the compiler is running in analysis mode

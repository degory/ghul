# Intermediate Representation

The compiler targets CIL assembly language and relies on ILAsm to convert the assembly language it generates into a bytecode assembly (DLL).

These classes provide a very thin wrapper around CIL assembly language. The `IR.Value` classes generally represent things,
such as arithmetic operations, that can be loaded onto the CIL VM evaluation stack.
When a tree of `IR.Value` objects is generated via the `gen()` method, CIL assembly language text is generated
corresponding to the expression or block the `IR.Value` represents.

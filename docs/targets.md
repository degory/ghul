# ghūl: compilation targets

Read this when you are building for WebAssembly or native executables. It continues sections of [GHUL.md](../GHUL.md), the language reference, under the same headings; GHUL.md is loaded with every session and this file is not.

## compilation targets

A third target, `llvm`, is for a native executable. A build for it type-checks the program against ghul-core and ghul-runtime as a `wasm` build does, writes an LLVM module, and links it into a statically linked executable with the `ghul-llvm` tool, which has to be on the path or named by `GHUL_LLVM`; `--llvm-output <path>` also keeps the module's text, and with `--llvm-no-link` as well that text is all the build writes, `--llvm-program-only` keeps in that text only the functions compiled from the program's own sources, and `--debug` adds line tables and variables, so a debugger and a crash's backtrace name ghūl files, lines and variables. `--optimise <0-3>` sets the optimisation level, 2 by default, and 0 for a `--debug` build that names no level. A library build writes the module's text and links nothing. Its code generation is in its early stages: it lowers functions over the scalar types, `bigint`, strings and string interpolation, values displayed with `$` and interpolation where their type has no text of its own, type objects from `typeof` and `get_type`, shallow copies with `memberwise_clone` and identity hashing with `Collections.ReferenceEqualityComparer`, arrays, structs and tuples held in place with their methods, optional value types, classes with their fields, constructors, static members and static constructors, virtual and trait calls, type tests and casts, scalars and structs boxed as objects with their own methods, unions, generic types and functions compiled once for each instantiation, generators, asynchronous functions and `await`, function values, and exceptions thrown, caught and cleaned up after with `finally`, with local variables, `ref` arguments to locals and array elements, loops over ranges and otherwise, conditionals, integer division checked as on .NET, and calls, the host operations such as writing to the console, and an `entry` taking the command-line arguments as a `string[]`. It reports anything else as `code generation for <construct> is not supported on the llvm target`, but only in code the program reaches: an executable compiles what its entry point calls, so a construct elsewhere in a library goes unreported. A namespace named `llvm` at the root of the program is an error on this target, reported as `a namespace named llvm not supported on the llvm target`, since LLVM keeps the names starting `llvm.` for its own intrinsics; a namespace of that name nested inside another, such as `Outer.llvm`, is accepted.

On the llvm target an exception nothing catches is reported with the frames it was thrown through, innermost first, one `   at <name>` line each after the `Unhandled exception.` line. The wasm target does the same in a build with `--debug`, where a throw goes through the loader so the exception records its stack; without it a throw stays inside the module, which is several times cheaper, and the report carries no frames. A trap the engine raises, such as an integer division by zero, has its frames either way. On the llvm target a crash is reported the same way: a stack that runs out as `Stack overflow.`, and any other fault, a bus error, an arithmetic fault or an illegal instruction as `Fatal error.` and the signal, after the program's output is flushed, and the process then ends with the signal. A frame is named as the linker names the function, and on the llvm target a build with `--debug` adds its file and line; at the default optimisation level a function inlined into another does not appear as a frame of its own. A stack that the llvm optimiser has turned into a loop does not run out, and so is never reported.

A `wasm` build loads no .NET assemblies. What they supply on .NET comes from two libraries compiled into the module from source: ghul-core, which gives the built-in types their members and declares the collections, and ghul-runtime, which supplies the pipes and the rest of `Ghul`. The `ghul` command-line tool builds a project for the `wasm` or `llvm` target, fetching those libraries for either; a project lists the targets it builds for in its `ghul-project.json` manifest, and a .NET project is built with the .NET SDK instead:

```sh
ghul new hello --target llvm,wasm
cd hello
ghul run --target wasm
```

## conditional compilation

`@IF.<name>()` written before a definition or a statement keeps it only when `<name>` is on, and `@IF.not.<name>()` keeps it only when it is off. The target's own name is on for its build and the other targets' names are off, so `@IF.dotnet()`, `@IF.wasm()` and `@IF.llvm()` give each target a declaration of its own. `@IF.source_core()` is on for every target whose core library is compiled from source, `wasm` and `llvm`, and off for `dotnet`, so a declaration that only needs there to be no .NET base class library is written once:

```ghul
use IO.Std.write_line

entry() is
    write_line(target_name())

    @IF.wasm()
    write_line("a statement kept only for wasm")
si

@IF.dotnet()
target_name() -> string => "dotnet"

@IF.wasm()
target_name() -> string => "wasm"
```

`--define <name>` turns any other name on, and a name nothing turns on is off. A `--define` of a target's name, or of `source_core`, has no effect: the target being built decides those. What is left out is never compiled, so it can name things the build does not have, a .NET API in a `@IF.dotnet()` declaration for instance. To leave a whole file out of one target, write the `@IF` on its namespace.

## foreign functions

`@extern(module, name)` written before a body-less global function or static method declares a function the program is linked with rather than defines. The ghūl signature is the whole declaration: no C prototype is read and there is no separate interface description. A call is a call into the named symbol, and a declaration may not have a body, be generic, or be an instance member.

```ghul
@extern("libc", "abs")
absolute(value: int) -> int

@extern("libc", "strlen")
length_of(text: string) -> word
```

What the module and name mean depends on the target, so a declaration that differs between targets is written with `@IF.<target>()`:

| target | module | name |
|--------|--------|------|
| dotnet | the library, as `DllImport` takes it | the entry point |
| llvm | the library that supplies the symbol; empty for what the C library or libghul already holds | the C symbol, spelled exactly |
| wasm | must be empty | a function the program's caller supplies |

On .NET an `@extern` is the `DllImport` it stands for, with the platform's default marshalling. On llvm it is a C ABI call, and the program links statically against musl, so a library it names has to be available as a static archive built for musl. `--native-input <path>` adds an object file or archive to the link, `--native-library <name>` links `lib<name>.a`, and `--native-library-path <dir>` adds a directory to search for it; each can be repeated. A symbol the link cannot find is a link error, not a compile error, and a library that is named but never reached by a call is not linked.

What may cross is what the machine lays out the same way on both sides. The scalars `bool`, `char`, `byte`, `ubyte`, `short`, `ushort`, `int`, `uint`, `long`, `ulong`, `word`, `uword`, `single` and `double` cross as the C types of the same width, and a `string` argument is a NUL-terminated UTF-8 copy made for the call and released after it. Pointers and `ref` arguments cross on .NET only. Anything else, such as a class, a tuple, an array or a function, is reported at the declaration. A foreign function that keeps the pointer it was given after it returns is in undefined behaviour, as with any marshalled call.

A function answering a string says who owns the text with a named argument, on llvm; a string answer is rejected on .NET, and on wasm needs no argument: `result = "copy"` copies text the callee keeps (as `getenv` answers), and `result = "take"` copies text the callee allocated with the C library's `malloc` and then releases it with `free`. A null answer is the absent string, so the return type is `string?`.

```ghul
@extern("libc", "getenv", result = "copy")
environment_variable(name: string) -> string?

@extern("libc", "strdup", result = "take")
duplicate(text: string) -> string?
```

Foreign code allocates with the C library's own `malloc` and `free`, and the garbage collector neither sees nor scans that memory. A ghūl object can hold a pointer into it, and the program that does so owns the release. The reverse does not hold: memory a foreign library allocated cannot be relied on to keep a ghūl object alive, which is why no object or array crosses and nothing can be registered for the library to call back into.

On wasm the module must be empty and the name is looked up in `options.externs`, the object the loader's `run` takes: each declared name must be a function in it, and a program that declares one the caller does not supply fails to start, naming it. Numbers cross as JavaScript numbers except `long` and `ulong`, which are BigInts, and a string crosses as a string, as a result as well as an argument. Every `@extern` function the program declares is imported, whether or not it is called.

## what differs on the wasm target

A .NET API that the core library does not declare does not exist on the `wasm` target, so a program that calls one is told the name is not found, as it would be for any other missing name. A construct the `wasm` target cannot carry at all is reported where it is written: a pointer type as `pointer types not supported on the wasm target`, and an `IL.` pragma, which names a fact about an assembly, as `pragma IL.name not supported on the wasm target`. A construct the target will carry but cannot generate code for yet is reported at the function holding it, as `code generation for <construct> is not supported on the wasm target`.

Not yet supported on the `wasm` target:

- `decimal`, which the `llvm` target does not support either
- an interpolated number formatted other than by the standard formats `D`, `E`, `F`, `G`, `N`, `R` and `X` or a custom pattern of `0`, `#`, `.` and `,`, and an interpolated enum given any format

A program run by Node reads and writes the real file system through `File`, `Directory` and the readers and writers over a file, as a .NET program does. In a page, which has no file system to reach, they work on a file system held in memory, which starts empty and holds what the program writes, and each file written is handed to the page. Under Node too, a caller of the loader that supplies the program's files, or a sink for the files it writes, keeps them in memory. `Path` works as it does on .NET, and standard input and output are read and written as on .NET.

Reflection on the `wasm` target is a subset of .NET's, with the same names and meanings: a `Type`'s fields, properties, constructors, base type, generic arguments and attributes; `FieldInfo`, `PropertyInfo`, `ConstructorInfo` and `ParameterInfo`; `Activator.create_instance`; `Nullable.get_underlying_type`; and an enum's names and values through `System.Enum`. Fields and properties are reported as declared, so an auto-property `x` is the property `x` and its backing field `$x`. The attribute the compiler marks a union with, among its `get_custom_attributes`, lists the union's variants on both targets. The compiler describes the program's types only when built with `--rtti`, which costs code for each type; reflecting on a type in a build without it throws `NotSupportedException`. `--rtti` is not yet supported on the `llvm` target.

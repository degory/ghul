# bcl-subset

Lists every external type an assembly references, grouped by the assembly
that declares it, with the members referenced through each type. Run it over
the compiler to see the base class library subset the compiler depends on,
which is what a core library has to supply before the compiler can be built
on it.

```sh
dotnet build tools/bcl-subset/bcl-subset.ghulproj
dotnet tools/bcl-subset/bin/Debug/net10.0/bcl-subset.dll <assembly.dll>
```

Output is one line per type, under a heading per assembly:

```
## System.Collections: 13 types
System.Collections.Generic.List`1 (15): .ctor, Add, AddRange, Clear, ...
```

It reads the metadata directly, so the assembly's references do not need to
be resolvable and nothing is loaded. A member reached through a generic
instantiation is credited to the generic type it instantiates; a member of a
nested type is credited to `Outer/Inner`. Member references whose parent is
an array, a pointer or a type parameter are counted in the final line but
not attributed, since they name no type.

Every type the metadata names appears, so a type used only in a signature or
as a local variable's type is listed with an empty member list.

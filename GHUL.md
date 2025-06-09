# ghūl Programming Language: Tutorial and Quick Reference

## Introduction to ghūl

**ghūl** (pronounced “ghoul” and always styled with a lower case 'g') is a statically-typed, general-purpose programming language that runs on the .NET platform. Created as an experimental project by a single developer, ghūl’s design philosophy is to explore language design while remaining *fairly conventional* in capability. It strives to be expressive enough for real-world development – in fact, the ghūl compiler itself is written in ghūl. Key goals include strong compile-time **type safety**, integration of **functional** and **object-oriented** programming paradigms, and seamless interop with existing .NET libraries.

ghūl’s syntax is distinctive yet familiar. It is influenced by Algol 68 and Pascal, using **keywords to delimit code blocks** instead of braces or significant indentation. Many keywords come in pairs with a **closing keyword that mirrors the opening keyword**. For example, a function or class body begins with `is` and ends with `si` (the reverse of “is”). Similarly, conditional blocks use `if` ... `fi` instead of `{ }`. This leads to a clear structure without curly braces. Naming conventions also differ from C# – ghūl uses `snake_case` for variable, function, and property names; `PascalCase` for namespace and trait names; and `MACRO_CASE` for concrete type names like classes, structs, and enums.

Despite some quirky syntax, experienced .NET developers will find many familiar concepts. ghūl supports **anonymous functions with closures**, **classes with inheritance and polymorphism**, **interfaces (called traits)**, **generics**, structured **error handling** with exceptions, and a rich type system. The language targets .NET 8, producing normal .NET assemblies and NuGet packages, so you can use .NET’s framework types and libraries. .NET classes, interfaces, and collections are directly usable in ghūl (with slight naming adjustments to fit ghūl conventions). For instance, `System.Console` appears as `IO.Std` in ghūl, so you can call `IO.Std.write_line(...)` to print to the console. Overall, ghūl’s goal is to blend functional and OO features in a concise syntax, while leveraging the .NET ecosystem.

## Modules and Imports

ghūl organizes code into **namespaces** (analogous to C# namespaces or modules). Use the `namespace` keyword to declare a namespace, followed by the namespace name and an `is ... si` block containing its definitions. For example:

```ghul
namespace MyApp.Utilities is
    // definitions (types, functions, etc.) go here
    class HELPER is
        ...
    si
    function_x() => ...
si
```

Namespaces may be nested (you can define a `namespace Inner is ... si` inside another) or declared in a dotted form (e.g. `namespace Outer.Inner is ... si` achieves the same nesting). All definitions inside the namespace belong to that namespace, and you refer to them with qualified names (e.g. `Outer.Inner.function_x()`).

Multiple source files can contribute to the *same* namespace. ghūl treats each `namespace Name is ... si` block as an instance of that namespace; all such instances across your project are aggregated into one combined namespace scope. This means that if two files declare `namespace DataModels is ... si`, types defined in one file’s `DataModels` are visible in the other without qualification. (If a file has no namespace declarations at all, the compiler wraps its contents in an implicit, file-private namespace. However, in multi-file projects you’ll typically use explicit namespaces so code can be shared.)

To **import** names from a namespace, ghūl provides a `use` statement. `use` brings a symbol or an entire namespace into scope so you can refer to it without qualification. For example:

```ghul
use MyApp.Utilities.HELPER;    // import a specific class
use IO.Std;                   // import only the Std type (System.Console) as 'Std'
use IO.Std.write_line;        // import the static 'write_line' method for unqualified use
use IO;                       // import everything in the IO namespace (including Std)
use LetsCallItConsole = IO.Std; // import Std but rename it to LetsCallItConsole
```

- `use IO.Std;` imports only the `Std` type, so you can use `Std.write_line(...)`.
- `use IO.Std.write_line;` imports the static `write_line` method, so you can call `write_line(...)` directly.
- `use IO;` imports all public symbols from the `IO` namespace, including `Std`.
- `use LetsCallItConsole = IO.Std;` imports `Std` as `LetsCallItConsole`.

After `use IO.Std.write_line;`, you can call `write_line("Hello")` directly instead of `IO.Std.write_line` or `Std.write_line`. Using `use NamespaceName;` imports all public symbols from that namespace. Using `use Namespace.Symbol;` imports a specific item. This mechanism is analogous to C#’s `using` directive or F#’s `open`. Importantly, a `use` applies only within the current namespace block/file – it does not globally modify other files or other namespace sections in the same file. If you split a namespace across multiple blocks, each block needs its own `use` statements for any external symbols it relies on.

## Types and Type Definitions

ghūl is strongly typed and offers several ways to define your own types: **classes**, **structs**, **traits**, **unions**, and **enums**. All these types are declared at the global scope (inside a namespace, but not inside other types). Here’s an overview of each:

* **Classes:** A class defines a *reference type* with support for single inheritance and trait implementation. The syntax is `class Name [ : Superclass, Trait1, Trait2, ... ] is ... si`. The class body can declare properties, methods, and constructors. For example:

  ```ghul
  class PERSON is
      name: string;
      age: int;

      init(name: string, age: int) is   // constructor
          self.name = name;
          self.age = age;
      si

      describe() -> string => "{name} is {age} years old";
  si
  ```

  In this example, `PERSON` has two fields and a constructor `init` that initializes them. Within methods, `self` refers to the instance (like `this` in C#). A class can optionally extend a single superclass and implement any number of traits (interfaces). Instances of a class are created by calling a **constructor expression**: writing the class name like a function call. For instance, `let p = PERSON("Alice", 30);` calls the matching `init` constructor to produce a `PERSON` object. By default, class instances are compared by reference (identity) unless you override equality. Classes are named in `MACRO_CASE` if concrete, or `PascalCase` if abstract.

* **Structs:** A struct defines a *value type* (like .NET struct) which holds its data directly. Struct syntax is similar to classes: `struct NAME [ : Trait1, Trait2, ... ] is ... si`. Structs cannot inherit from a class (they have no superclass), but they can implement traits. For example:

  ```ghul
  struct POINT is
      x: double;
      y: double;

      init(x: double, y: double) is    // struct constructor
          self.x = x;
          self.y = y;
      si
  si
  ```

  Each `POINT` value contains its own `x` and `y`. Struct instances are constructed the same way as classes (e.g. `let origin = POINT(0.0D, 0.0D);`). Unlike classes, copying a struct *copies all its fields* (no pointers to a single heap object) and the `==` operator on structs performs **memberwise equality** by default. In the example above, two `POINT(0.0, 0.0)` instances would be `==` because their contents match. Structs are useful for lightweight data records. Like classes, they can define methods and multiple constructors (`init` overloads), and are written in `MACRO_CASE`.

* **Traits:** Traits in ghūl are analogous to interfaces in other languages. A trait defines a set of methods and/or properties that can be implemented by classes or structs. Trait syntax: `trait Name [ : ParentTrait1, ... ] is ... si`. Inside a trait, you declare method signatures or properties without bodies (these are implicitly abstract). For example:

  ```ghul
  trait Printable is
      print();         // abstract method (no body)
  si
  ```

  This trait requires a `print()` method. Any class or struct that **inherits** from (implements) `Printable` must provide a concrete `print` method. Traits support trait inheritance as well (one trait can extend another, requiring all parent trait members to be implemented too). Trait names use `PascalCase`. In ghūl, a class can extend at most one class but **implement multiple traits**, enabling a form of multiple inheritance of interfaces. Traits are purely abstract; their methods have no implementations (current ghūl requires you to leave trait method bodies empty). Example implementation:

  ```ghul
  class BOOK: Printable is
      title: string;
      author: string;

      init(title: string, author: string) is
          self.title = title;
          self.author = author;
      si

      print() is    // implementing Printable.print()
          IO.Std.write_line("Title: {title}, Author: {author}");
      si
  si
  ```

  Here `BOOK` implements `Printable` by providing a `print()` method. Any `BOOK` can be used where a `Printable` is expected. (Traits from .NET assemblies are mapped to ghūl traits as well. For example, a .NET interface `IDisposable` would appear as trait `Disposable` in ghūl.)

* **Unions:** A union type (discriminated union or sum type) represents a choice between multiple variants, each of which may carry different data. The syntax is `union Name is Variant1(Type1, ...); Variant2(Type2, ...); ... si`. Each variant has a name (by convention in MACRO\_CASE) and an optional payload. For example:

  ```ghul
  union Result is
      SUCCESS(value: string);
      ERROR(code: int, message: string);
  si
  ```

  This defines a `Result` type that can be either `SUCCESS` with a `string` value, or `ERROR` with an `int` code and `string` message. At any given time, a `Result` instance is in one of these variants. To **construct** a union, you qualify the variant with the union name, e.g. `Result.SUCCESS("ok")` or `Result.ERROR(404, "Not found")`. Under the hood, a union is a reference type (like a class) but with a tag indicating the active variant. ghūl automatically provides *tag check properties* – boolean properties named like `is_variantname` – to test which variant is active. For instance, given `let r = Result.ERROR(404, "Not found")`, `r.is_error` would be true and `r.is_success` false. After checking a variant, you can access its payload via a similarly named property: for example, `r.error.code` and `r.error.message` give the fields of the `ERROR` variant. (If a variant has exactly one field, accessing `r.variant` returns that field directly. Variants with no fields are just constants – you only check the tag.) To illustrate usage:

  ```ghul
  let outcome = Result.SUCCESS("All good");
  if outcome.is_success then
      IO.Std.write_line("Yay: {outcome.success}");   // prints the success value
  elif outcome.is_error then
      IO.Std.write_line("Error {outcome.error.code}: {outcome.error.message}");
  fi
  ```

  Unions enable algebraic data types similar to F# discriminated unions or Rust enums with data. ghūl doesn’t yet support pattern-matching syntax on unions (see **Pattern Matching** below), so code uses `if/elif` or `case` checks on the tag properties as shown. Union type names use `PascalCase`, and variant names use `MACRO_CASE`.

  *Common use case:* A generic `Option[T]` union is provided (or can be user-defined) to represent optional values. For example, one could define:

  ```ghul
  union Option[T] is 
      SOME(value: T); 
      NONE; 
  si
  ```

  Then `Option.SOME[int](42)` represents an `int` present, and `Option.NONE` represents no value. You would check `opt.is_some` or `opt.is_none` before using `opt.some`. This pattern is analogous to `System.Nullable<T>` or `Option` in F#, but works for any type and avoids nulls in APIs.

* **Enums:** An enum is a simpler kind of tagged type for constants. Enums in ghūl are similar to C-style enums: they define a fixed set of named constants of an integral type. Syntax: `enum NAME is MEMBER1, MEMBER2, ... si`. Optionally you can assign specific integer values to each member. For example:

  ```ghul
  enum SUIT is
      HEARTS,
      DIAMONDS,
      CLUBS,
      SPADES
  si
  ```

  defines an enum `SUIT` with four values. By default, the first member is 0, next is 1, etc., unless you explicitly assign values. Enum members are accessed as `SUIT.HEARTS`, etc., and can be cast to or from their underlying int value. Enums and their members should be named in `MACRO_CASE`. They are primarily useful for simple state flags or options. (Under the hood, .NET enums appear similarly in ghūl, just following the naming convention.)

**Properties and Methods:** Classes, structs, and traits can contain **properties** and **methods** in their bodies. A **property** is declared like `name: Type` and can optionally include a getter and/or setter implementation. For example, a property with custom setter:

```ghul
class COUNTER is
    _count: int;  // backing field

    count: int => _count,             // getter returns _count
        = new_value is               // setter (runs on assignment)
            assert new_value >= 0 else "Count must be non-negative";
            _count = new_value;
        si
si
```

Here `count` is a property of type int. The syntax `count: int => _count` defines a getter that returns `_count`, and the `= new_value is ... si` part defines a setter that performs an assertion and then sets the backing field. If no getter/setter is provided, ghūl will auto-generate one: a public property with no explicit getter/setter gets a hidden backing field and default getter (and if not marked protected, no public setter). By default, properties in ghūl are **readable publicly** but **writable only within the defining type** (protected set) – unless marked with a leading underscore `_` to indicate intended privacy. Methods are declared just like free functions but inside a class/struct/trait. They should be in `snake_case` and can use `self` to access the instance. For example, `print()` in the `BOOK` class above is a method implementation. Constructors are simply methods named `init` – when you call `TypeName(...)`, the appropriate `init` overload is invoked to construct the object.

## Functions and Pattern Matching

**Function declarations** in ghūl start with an optional return type, the function name, and a parenthesized parameter list. After that, you provide either a **single-expression body** introduced by `=>`, or a **block body** enclosed by `is ... si`. For example:

```ghul
// A function with a single-expression body:
add(a: int, b: int) -> int => a + b;

// A function with a block body:
multiply(a: int, b: int) -> int is
    let result = a * b;
    return result;
si
```

In the first case, the expression `a + b` is returned as the result of `add`. In the second, we use an explicit `return`. ghūl requires an explicit return statement in block bodies to yield a value (unless the function returns `void`). If a non-void function exits without hitting any `return`, it will return the default value of its return type (e.g. 0 for int, null for reference types). You can also omit the return *type* if the function returns `void` (unit type) – for instance, `log_message(msg: string) is ...` defaults to void return. All function parameters must have an explicitly declared type (the compiler does not infer types for parameters). Function names use snake\_case.

ghūl functions are **first-class citizens**: you can create function values on the fly and pass them around. The **function literal** syntax uses `=>` as well. For example, `(x: int) => x * 2` evaluates to a function that doubles an integer. You can assign it to a variable (`let f = (i: int) => i * 2;`) and call `f(10)` which would yield 20. Functions can be stored in data structures or passed as arguments to other functions just like any other value. In a function type, the notation `A -> B` is used to denote a function from type `A` to type `B`. For instance, `int -> int` is the type of a function taking an int and returning an int. Below is a quick example of higher-order functions:

```ghul
let twice = (x: int) => x * 2;
let apply_twice(f: int -> int, i: int) => f(f(i));

apply_twice(twice, 5);   // returns 20
```

Here, `twice` is a function literal capturing no external state, and `apply_twice` accepts a function `f` and applies it twice to an integer. ghūl supports **closures** (function literals can capture variables from their surrounding scope). Recursive and mutually recursive functions are also supported – for named functions, recursion works as usual; for anonymous functions, ghūl provides a special `rec` keyword to refer to the function from inside itself (see the factorial example below).

*Example – recursion in an anonymous function:*

```ghul
// Factorial using an anonymous recursive function:
let factorial = (n: int) rec => if n == 0 then 1 else n * rec(n - 1) fi;
IO.Std.write_line("5! = {factorial(5)}");  // outputs "5! = 120"
```

In this example, `(n: int) rec => ...` creates a function that can call itself by using `rec(...)` as though it were its own name.

### Pattern Matching (or lack thereof)

Unlike F# or Rust, ghūl **does not yet have a full pattern-matching expression** for deconstructing data (this feature is planned but marked TODO). In current ghūl, you typically use explicit conditionals or a `case` statement to distinguish union variants or other conditions. We saw an example above using `if outcome.is_success / is_error` to handle a `Result` union. ghūl also provides a `case` construct (similar to a switch) for matching constant values:

```ghul
case status_code
when 200:
    IO.Std.write_line("OK");
when 404:
    IO.Std.write_line("Not Found");
when 500, 501, 502:
    IO.Std.write_line("Server error");
default:
    IO.Std.write_line("Unknown status");
esac
```

Each `when` label can list one or multiple literal values (comma-separated) to compare against the `case` expression. The `default` clause handles any value not matched by earlier cases. You terminate the construct with `esac` (“case” reversed). The `case` statement is useful for matching primitive values like numbers or enum constants. However, it **cannot deconstruct union types** – you cannot directly pattern-match a `Result.SUCCESS(...)` vs `Result.ERROR(...)` in a `case`. Instead, you would either use the `if/elif` style shown earlier or switch on an auxiliary tag (for example, you might switch on an enum inside your union). In summary, until pattern matching is added to the language, handling variant types involves manual tag checks. This is one area where ghūl’s syntax is still evolving.

## Control Flow Constructs

ghūl supports standard control flow constructs, often using keyword pairs to delimit blocks. All the familiar loops and conditionals are available, with a few syntactic twists:

* **Conditional (`if`) Statements:** The `if`...`then`...`fi` statement works much like in other languages, but uses keywords instead of braces. You can optionally include `elif` (else-if) clauses and a final `else`. For example:

  ```ghul
  if x > 0 then
      IO.Std.write_line("x is positive");
  elif x < 0 then
      IO.Std.write_line("x is negative");
  else
      IO.Std.write_line("x is zero");
  fi
  ```

  Each `if/elif/else` block is a new scope for local variables. You can also use an `if` *as an expression* that yields a value – for instance: `let sign = if x >= 0 then "non-negative" else "negative" fi;` will set `sign` based on the condition. (When used as an expression, all branches must produce a value of a compatible type.)

* **Loops:** ghūl provides a few looping constructs:

  * **`while` loop:** Syntax: `while condition do ... od`. This loops as long as the boolean condition remains true (checked before each iteration).
  * **`for` loop:** ghūl’s `for` is used to iterate over collections or ranges. Syntax: `for item in collection do ... od`. If the expression after `in` is a range or an iterable, the loop will iterate over it. For example:

    ```ghul
    for i in 1::5 do    // i takes values 1,2,3,4,5
        IO.Std.write_line("Number {i}");
    od
    ```

    The range operator `::` produces an inclusive range (here 1 through 5). ghūl also has a `..` range operator which is inclusive of the start and *exclusive* of the end. So `0..3` would generate 0,1,2. You can iterate over any object that implements the enumerable pattern; for example, a list (IReadOnlyList) or array can be used in `for`. If iterating a key-value map, you’d get key/value tuples, etc., similar to C#’s foreach.
  * **`do` loop:** Syntax: `do ... od`. This is a loop with no explicit condition – essentially an infinite loop, intended to be controlled via `break`/`continue` inside. You use `do`/`od` when you want a manual loop that you break out of under certain conditions (similar to `while(true)` in other languages). For example:

    ```ghul
    do
        update_state();
        if state.is_finished then break fi;
    od
    ```

    Each of these loops (`while`, `for`, `do`) forms its own block scope, so variables defined inside the loop are local to the loop.

  All loops support the **`break`** statement to exit the loop immediately, and **`continue`** to skip to the next iteration. ghūl’s `break`/`continue` work analogously to those in C# or Java.

* **`try`/`catch` Exception Handling:** ghūl handles exceptions in a familiar way, with some syntactic differences. A try-block begins with `try` and ends with `yrt` (“try” reversed). Between them, you can have one or more `catch` clauses and optionally a `finally`. For example:

  ```ghul
  try
      // code that might throw
      risky_operation();
  catch ex: SomeExceptionType
      IO.Std.write_line("Failed: " + ex.message);
  finally
      cleanup();
  yrt
  ```

  Each `catch` clause names an exception variable (`ex` above) and a type to catch. Catches are checked in order, and a catch will handle any exception of the specified type or its subtypes (just like in .NET). The `finally` block (if present) always executes after the try and any catches, typically for resource cleanup. You can omit `finally` if not needed, or have multiple `catch` blocks for different exceptions. The main difference from C# is just the delimiter keywords: end the whole construct with `yrt` instead of a closing brace.

* **`assert` statements:** ghūl includes a built-in `assert` for sanity checks. An assert statement looks like `assert condition else expression;`. If the condition is true, nothing happens; if it's false, the program throws an exception. If the `else` expression is a string, it will be wrapped in an `AssertionFailedException` automatically. If it’s already an exception object, that is thrown as-is. Example:

  ```ghul
  assert index < array.count else "Index out of range";
  ```

  This will throw an `AssertionFailedException` with the given message if the condition fails. Assertions are mainly for internal invariants (they are always checked at runtime, since ghūl doesn’t have a static analyzer for them).

* **`return` statements:** As shown earlier, use `return value;` to return a value from a function with a block body, or just `return;` to return from a void function. If a function has a non-void return type and you fall off the end without a return, ghūl implicitly returns the default value (e.g. null, zero). It’s good practice to return explicitly for clarity. Also note, ghūl does not have a separate yield statement – generators are typically implemented via lazy sequences (more on that in Data Structures).

## Data Structures and Collections

ghūl leverages .NET’s collection types and also has built-in literals for common data structures:

* **Lists and Arrays:** In ghūl, square brackets `[...]` represent an **array/list literal**. For example, `[1, 2, 3]` produces a collection of those three integers. The element type is inferred to the most specific type that accommodates all elements. If you mix types, the common base type (often `object`) is used. The literal `[1, 2, 3, 4, 5]` would be of type `List[int]` (read “list of int”). Internally this is a .NET array `Int32[]`, but ghūl treats it as an immutable list by default. In fact, the type of a list literal is the **read-only list interface** `Collections.List[T]` (which corresponds to `IReadOnlyList<T>` in .NET). This means you cannot add or remove elements from the literal list – you can only read or transform it. For example:

  ```ghul
  let numbers = [1, 2, 3, 4, 5];
  let first = numbers[0];               // indexing (0-based) works
  // numbers.add(6);  // ERROR: no add method on IReadOnlyList
  ```

  If you need a mutable list, you can explicitly use the `.NET List` type which is exposed as `Collections.LIST[T]` in ghūl. For instance, `let nums = LIST[int](); nums.add(42);` would create a growable list of int. But most of the time, you'll work with immutable sequences and use functional transformations.

  ghūl’s **pipeline operator** `|` provides a fluent way to work with list/sequence data. By writing an expression followed by `| .method`, you can call sequence extension methods in a chain (similar to LINQ in C# or pipelines in F#). ghūl supports typical sequence operations like **map**, **filter**, **reduce**, etc. For example, using the list defined above:

  ```ghul
  let evens = numbers | .filter(x => x % 2 == 0);
  let doubled = numbers | .map(x => x * 2);
  let sum = numbers | .reduce(0, (acc, x) => acc + x);

  IO.Std.write_line("evens: {evens}");   // evens: [2, 4]
  IO.Std.write_line("doubled: {doubled}"); // doubled: [2, 4, 6, 8, 10]
  IO.Std.write_line("sum: {sum}");         // sum: 15
  ```

  In the above, `.filter` takes a predicate function and produces a new filtered list, `.map` applies a function to each element, and `.reduce` folds the list into a single value with a starting accumulator. These operations do **not** mutate the original list – they return new sequences (the original `numbers` remains `[1,2,3,4,5]`). This approach encourages an immutable, functional style. Under the hood, these are extension methods on the `Collections.Iterable`/`List` interfaces.

  You can also iterate through a list with a `for` loop (as shown in Control Flow) or access elements by index with the `[index]` syntax. Lists have properties like `.count` for length.

* **Tuples:** ghūl supports tuple literals using parentheses. For example, `(10, "hello")` is a tuple of int and string, type `(int, string)`. Tuples can also have **named elements** for clarity: `(x: 10, y: 20)` has type `(x: int, y: int)` and you can access `tup.x` and `tup.y` if you bind it to a variable. Tuples are immutable structured data useful for returning multiple values from a function or grouping values ad-hoc. They implement structural equality and can be nested. Tuple element types are inferred if not explicitly annotated.

* **Dictionaries (Maps):** The language doesn’t have a literal syntax for dictionaries, but you can use .NET dictionaries via `Collections.MAP[K,V]` (the mutable `Dictionary<K,V>`) or the read-only interface `Collections.Map[K,V]` (which corresponds to `IReadOnlyDictionary`). For example:

  ```ghul
  let dict = MAP[string, int]();
  dict.add("one", 1);
  dict.add("two", 2);
  let readOnly: Collections.Map[string,int] = dict; 
  ```

  Here `dict` is a mutable dictionary, and `readOnly` is typed as the interface. You can iterate a map with `for (key, value) in dict do ... od`, and there are methods like `.contains_key` or indexer access `dict["one"]`. Like lists, the naming convention is that uppercase `MAP` is the concrete type and capitalized `Map` is the interface. Similarly, `SET`/`Set` for hash sets, etc., following .NET’s generic collections.

* **Option Type:**

> **Note on Union Types:**
> Union types in ghūl are a newly implemented feature and are reference types (not value types). The implementation is still evolving and may contain bugs or limitations. If you encounter existing code using unions, be aware that it may include workarounds for known or unknown issues in the union type system. When writing new code, use unions cautiously: if they are clearly the best fit for your use case, consider them, but be prepared to encounter and possibly work around implementation problems. Also, while an `Option[T]` union type is available for representing optional values, there is currently no real library support for unions—most of the underlying library is just .NET 8, which does not natively support these constructs.

As discussed in the Types section, an `Option[T]` union can represent optional values. Rather than using `null` references, you can use `Option.NONE` or `Option.SOME(x)` to indicate missing or present values. For example:

  ```ghul
  function find_user(id: int) -> Option[User] is
      let user = lookup_db(id);
      if user? then               // check if not null
          return Option.SOME[User](user);
      else
          return Option.NONE;
      fi
  si

  let result = find_user(42);
  if result.is_some then
      IO.Std.write_line("Found: {result.some.name}");
  else
      IO.Std.write_line("No user with that ID");
  fi
  ```

  In this snippet, `user?` is a quick null-check (true if `user` is non-null). We wrap the found user in `Option.SOME`, otherwise return `NONE`. Later, by checking `result.is_some`, we safely access `result.some`. This pattern avoids null reference errors. (ghūl does allow `null` for reference types since it’s on .NET, but using `Option` is safer and more idiomatic for optional data.)

**Note on Null Checking:** The `obj?` syntax used above is a convenient way to test if an object reference is not null. It returns a boolean – essentially sugar for `obj != null`. You’ll often see it before calling methods on possibly-null objects.

## Advanced Features: Generics and Type Inference

ghūl has a modern type system with **generics** (parametric polymorphism) and **type inference** to reduce verbosity:

* **Generics:** You can parameterize classes, structs, traits, functions, and even union variants with type parameters. Generic type parameters are written in brackets after the name. For example, a generic function and struct:

  ```ghul
  print_something[T](value: T) => IO.Std.write_line("something is {value}");

  struct Box[T] is
      item: T;
      init(item: T) is self.item = item; si
  si
  ```

  Here `[T]` declares a type parameter `T` that can be any type. `print_something[T]` simply prints whatever value it’s given. We can call `print_something[int](1234)` or `print_something[string]("hello")` to specify `T` explicitly. However, ghūl often **infers generic type arguments** from context. If we call `print_something(1234)`, the compiler sees an int and infers `T` as int. So you usually don’t need to write the type argument for generic functions – just call `print_something("hi")` and it deduces `T` = string. Similarly, methods and static methods can be generic and perform type argument inference on calls.

  Generic classes/structs require type arguments when you construct them, *unless* the constructor itself provides enough clues for inference. For example, with `Box[T]` above, you typically create an instance with `Box[int](5)` or `Box[string]("text")`. But if the `init` arguments unambiguously determine `T`, ghūl can infer it. Suppose `init` for `Box[T]` took a `T` – then writing `Box(5)` would let the compiler infer that `T` is int. In general, ghūl can infer generic types for function calls and even constructor calls if all generic parameters appear in the parameter types and there's no ambiguity.

  All the core type constructs can be generic. For instance, you could have `class Pair[T,U]`, `trait Comparable[T]`, `union Either[L,R]`, etc. One constraint: currently ghūl does not support specifying explicit interface/trait constraints on generics (there’s no `where T: SomeTrait` syntax yet), so generic code is somewhat limited to using methods available on `object` unless you cast or otherwise know the type (this is noted as a limitation). Still, generics are powerful for building reusable data structures and algorithms.

* **Type Inference:** ghūl is statically typed but tries to infer types to reduce noise. The compiler can infer:

  * **Local variable types:** If you initialize a `let` variable without specifying a type, the type is inferred from the initializer. e.g. `let count = 123;` infers `count: int`. If no initializer is given, you *must* specify a type (`let count: int;`).
  * **List literal element types:** As mentioned, the element type of list/array literals is inferred from the elements. If no common subtype exists, it defaults to `object`.
  * **Conditional expressions:** The type of an `if ... else` expression is inferred by finding a common type for the results of each branch. For example, in `if cond then "yes" else StringBuilder() fi`, the result type would be inferred as `object` (since one branch is string and the other is a `StringBuilder` object, their closest common type is `object`).
  * **Generic type arguments:** As discussed, you can often omit explicit `[T]` parameters on function and method calls – the compiler deduces them from the argument types. It can also deduce type arguments for constructors in some cases.
  * **Anonymous function return types & parameters:** If you write a lambda literal and don’t specify its return type, the compiler infers it from the expression or return statements inside. If you pass a lambda to a function where the expected delegate type is known, ghūl infers the parameter types of that lambda. For example, in `numbers | .filter(i => i > 3)`, the compiler knows `filter` expects a function of type `int -> bool` (because `numbers` is a `Pipe[int]` or `Iterable[int]`), so it infers `i` is an `int`. You don’t need to annotate lambda parameter types in such cases.

  In summary, ghūl’s type inference is *local* (it won’t infer a function’s return type without a hint, except for `=>` single-expression functions where it obviously comes from the expression). It’s powerful enough to avoid a lot of verbosity (especially with generics and collections) while still making types explicit where it matters (function signatures, public APIs).

## Quick Reference Summary

Below is a concise summary of ghūl syntax, keywords, and type system features for easy reference:

* **File Structure:** Code is organized into `namespace` blocks. Syntax: `namespace Name.Of.Namespace is ... si`. If any namespace is declared in a file, all code must reside in some namespace (no free-floating definitions). If no namespace is given, the file has an implicit private namespace.
* **Imports:** Use `use NamespaceName;` to import all symbols from a namespace, or `use Namespace.Symbol;` to import one symbol. This allows using names without qualification within the current file’s namespace scope.
* **Entry Point:** The program entry point is a parameterless function named `entry`. For example,

  ```ghul
  entry() is 
      IO.Std.write_line("Hello world");
  si
  ```

  is analogous to a `Main` method. The `entry` function should return void (you can omit the return type).
* **Variables:** Declared with `let`. Example: `let x = 42;`. You can optionally specify the type (`let x: int = 42;`). Without an initializer, a type is required (`let flag: bool;`). ghūl uses type inference for `let` initializers. All variables are block-scoped (there are no global mutable variables outside of a function). Reassignment of a `let` variable is allowed (they are not immutable by default), but cannot change type.
* **Naming Conventions:** Use `snake_case` for variables, functions, and methods; `PascalCase` for traits and namespaces; `MACRO_CASE` for class, struct, enum, and union names. A leading underscore `_name` on any identifier indicates intended privacy/protected status (non-public), enforced in some cases by the compiler (e.g., you cannot access another class’s `_private_field`).
* **Primitive Types:** ghūl uses .NET primitive types with familiar names (all lowercase). e.g. `int` (System.Int32), `long` (Int64), `double` (Double), `bool` (Boolean), `string` (String), etc. Value literals look like in C#: `1234`, `3.14D` for double (or no suffix for single-precision float), `'c'` for char, `true/false` for bool, `null` for null reference. Numeric literals can use `_` as a digit separator and can have type suffixes (e.g. `1_000L` for a long, `0xFFUL` for unsigned long).
* **Operators:** Arithmetic `+ - * / %` and comparison `< <= > >= == !=` work as in C-family languages. Boolean logic uses a slightly different notation: logical AND is written as `/\` and OR as `\/` (these correspond to `&&` and `||`). Logical NOT is `!` as usual. Bitwise operators use `& | ^ ~` similar to C#. The string concatenation operator is `+` (since strings are objects). ghūl supports string interpolation: any string literal can contain `{expr}` placeholders which will be replaced by the formatted value of `expr` at runtime (no special prefix like `$` is needed). Example: `"Hello, {name}"`. The interpolation calls the `.ToString()` or equivalent on the expression.
* **Assignment:** The `=` operator is used for assignment to variables and fields. You must have declared a variable with `let` before assigning to it. In contrast to some functional languages, ghūl variables are not implicitly immutable – you can do:

  ```ghul
  let count = 0;
  count = count + 1;
  ```

  to increment a variable. However, if `count` were a property with no public setter, `count = ...` would fail. Use of `assert` (as shown above) is encouraged to enforce invariants on assignments where appropriate.
* **Functions:** Declare with optional return type, name, params, and body. Syntax recap:

  * Single expression: `name(param1: Type1, param2: Type2) -> ReturnType => expression;`
  * Block body: `name(params...) -> ReturnType is ... si`

  If ReturnType is omitted, it defaults to `void`. In a block body, use `return expr;` to return a value. A function with no explicit return in a non-void function returns default value. Functions are declared at namespace scope (no nested function definitions inside other functions). They can be overloaded by parameter signature. No support for default parameter values (overload or optional `Option` parameters can be used instead).
* **Methods:** Similar to functions but defined inside a class/struct/trait. They have an implicit `self` for instance methods. Declared just like a function in the class body. If a method name in a class starts with `_`, it is considered protected (only accessible to that class or subclasses). Otherwise methods are public by default. There are no explicit visibility keywords like `public`/`private`; naming convention controls it.
* **Properties:** Declared as `name: Type` with optional getter/setter bodies as described earlier. By default, `name: Type;` in a class creates a public get, protected set property. Prefix with `_` to make it protected get as well. You can also declare *global properties* at namespace scope (essentially global variables, though these should be used sparingly).
* **Control Flow Keywords:**

  * `if ... then ... [elif ... then ...] [else ...] fi` – conditional blocks. Can be used as statement or expression.
  * `while condition do ... od` – pre-condition loop (while-loop).
  * `for x in iterable do ... od` – foreach loop over a range or collection. Use `..` or `::` to create numeric ranges. You can destructure tuples in the loop variable, e.g. `for (key, value) in my_map do ... od`.
  * `do ... od` – indefinite loop (execute repeatedly until broken out).
  * `break` – exit the nearest loop immediately.
  * `continue` – skip to next iteration of nearest loop.
  * `case expr ... when A: ... [when B: ...] ... [default: ...] esac` – multi-way branch on constant values. Use for matching integers, enums, or other comparable constants. No fall-through (each `when` is like its own block).
  * `try ... catch e: ExceptionType ... [finally ...] yrt` – exception handling block. You can catch multiple exception types with multiple `catch` blocks. The `finally` part is optional.
  * `assert condition else expr;` – runtime assertion. Throws an exception (AssertionFailedException or the given exception) if condition is false.
  * `return [expr];` – return from function. Omitting `expr` means return void. In a `finally` block, you can use `yrt` as a closing keyword (you generally wouldn’t `return` from a finally though).
* **Type Definitions:**

  * `class NAME [ : Superclass, Trait, ... ] is ... si` – define class. Supports single inheritance and multiple traits. Use `init` methods for constructors. A class without a specified superclass implicitly inherits from `object` (System.Object).
  * `struct NAME [ : Trait, ... ] is ... si` – define struct (value type). Cannot have a superclass. Copying struct copies data, `==` is memberwise compare.
  * `trait Name [ : ParentTrait, ... ] is ... si` – define trait (interface). Members have no bodies (except possibly default implementations in future). Classes/structs implement traits by listing them after a colon.
  * `union Name is VARIANT1(...); VARIANT2(...); ... si` – define union (discriminated union). Automatically gets `is_variant` tags and `.variant` accessors for payload. Use qualified name to construct, e.g. `Name.VARIANT1(data)`.
  * `enum NAME is MEMBER1[,=value1], MEMBER2[,=value2], ... si` – define enum. Members are constants of that enum type. Backed by int (32-bit) by default.
* **Generics Syntax:**

  * For generic declarations, use `[T, U, ...]` after the name. Examples: `class Box[T] is ...`, `trait Comparable[T] is ...`, `union Option[T] is ...`, `pickFirst[T,U](a: T, b: U) -> T => ...`.
  * For usage, specify type args in brackets if needed: `let b = Box[int](5);` or `pickFirst[int,string](42, "hi")`. Often you can omit the brackets and let the compiler infer them.
  * Inside a generic, the type parameter can be used in property and method definitions. There’s no direct way to restrict a type parameter (no `where` clauses yet), but you can require it implements a trait by using that trait in a function signature or as a superclass (not as a generic constraint, but e.g. `doSomething[T: SomeTrait](x: T)` is not yet supported in current ghūl).
* **Type Inference:**

  * Compiler infers `let` variable types from initializers.
  * It infers the element type of array/list literals and the result type of `if ... else` expressions by finding a common type.
  * It infers generic type parameters for function calls and constructors when possible (contextual type or argument types guide it). You can always specify types explicitly if inference fails.
  * It infers anonymous function return types from their body, and infers anonymous function parameter types from the expected function type if known.
  * It **does not infer** types for function parameters or the top-level function return type – those you must write out (aside from the single-expression `=>` shorthand where the return type can be omitted and is effectively inferred).
* **Null and Option:** ghūl follows .NET’s model where reference types can be `null` by default (there’s no non-nullable reference type feature yet). Use the `obj?` syntax to check for null easily. For a safer alternative, wrap optional values in `Option[T]` and check `is_some`/`is_none` as described.
* **Interoperability:** Because ghūl compiles to .NET IL, you can call into any .NET library. ghūl will map .NET names to its naming conventions: e.g. `System.Collections.Generic.List<T>` is `Collections.LIST[T]`, `IEnumerable<T>` is `Collections.Iterable[T]`, `System.String` is `string`, etc. When in doubt, refer to ghūl documentation for naming, or use your IDE (the ghūl VSCode extension) to find the correct name. You can also escape identifiers that are reserved keywords by enclosing in backticks (e.g. ``let `class` = "test";`` if you needed such a name).

ghūl is still evolving, but this reference should give you a solid grasp of its syntax and semantics. With its mix of familiar .NET paradigms and new twists (like the keyword-based blocks and union types), ghūl enables a variety of programming styles. As you experiment, keep the official ghūl documentation handy – since “whatever the compiler accepts is the definitive reference” in this work-in-progress language. Enjoy exploring ghūl, and happy coding!

**Sources:** The ghūl language reference and examples are drawn from the official ghūl website and the ghūl compiler repository documentation, which provide further details and up-to-date information.

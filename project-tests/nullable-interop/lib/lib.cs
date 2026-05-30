namespace NullableInterop {
    // A reflected (cross-assembly) surface that uses System.Nullable<T>
    // in every position a ghūl user could pass or receive a value-type
    // `T?`: constructor parameter, method parameter, return type, field,
    // property, and as a type argument to another generic. ghūl's value
    // `T?` must interoperate with all of these bidirectionally.
    public class Sink {
        // Constructor parameter `int?` — the FluentAssertions
        // `BooleanAssertions(bool?)` shape. A ghūl bare `int` argument
        // must widen here.
        public Sink(int? seed) { Seed = seed; }

        public int? Seed;

        public int? Prop { get; set; }

        // Method parameter `int?` — must accept a ghūl bare `int`
        // (widening) and a ghūl `int?`.
        public string Describe(int? value) =>
            value.HasValue ? $"present:{value.Value}" : "absent";

        // Return type `int?` — must be usable as a ghūl `int?`.
        public int? Maybe(bool present) => present ? 42 : (int?)null;
    }

    public class Box<T> {
        public T Value;
        public Box(T value) { Value = value; }
    }

    public static class Interop {
        // Boxing round-trip: a ghūl `int?` boxed to `object` must follow
        // the CLR's Nullable boxing — null for an empty optional, a boxed
        // int for a present one (never a boxed Nullable struct).
        public static string Inspect(object o) =>
            o is null ? "null-object" : o is int i ? $"boxed-int:{i}" : $"other:{o.GetType().Name}";

        // Generic over `int?` — exercises `T?` in a type-argument position
        // across the assembly boundary.
        public static Box<int?> MakeBox(int? v) => new Box<int?>(v);

        // typeof check — a ghūl `typeof int?` must equal typeof(Nullable<int>).
        public static bool IsNullableInt(System.Type t) => t == typeof(int?);
    }
}

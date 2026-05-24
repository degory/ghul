namespace ReflectedDefaults {
    public enum Color { Red = 0, Green = 1, Blue = 2 }

    // C# helper assembly carrying methods with optional parameters of
    // each constant kind ghūl's reflected-default emission supports.
    // The ghūl test calls these by name, omits the optional, and
    // asserts the runtime value the .NET-declared default supplied.
    public static class Defaults {
        public static string Int32(int x, int y = 5) => $"Int32({x},{y})";
        public static string Int64(int x, long y = 999999999999L) => $"Int64({x},{y})";
        public static string Boolean(int x, bool b = true) => $"Boolean({x},{b})";
        public static string String(int x, string s = "hello") => $"String({x},{s})";
        public static string Double(int x, double d = 1.5) => $"Double({x},{d.ToString(System.Globalization.CultureInfo.InvariantCulture)})";
        public static string Single(int x, float f = 2.5f) => $"Single({x},{f.ToString(System.Globalization.CultureInfo.InvariantCulture)})";
        public static string Character(int x, char c = 'A') => $"Character({x},{c})";
        public static string Enum(int x, Color c = Color.Green) => $"Enum({x},{c})";
        public static string NullString(int x, string? s = null) => $"NullString({x},{(s ?? "<null>")})";

        // Defaultless parameter — omitting `y` from a named call to this method
        // must remain an error.
        public static string Required(int x, int y) => $"Required({x},{y})";
    }
}

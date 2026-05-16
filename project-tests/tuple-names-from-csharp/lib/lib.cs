namespace TupleNamesFromCSharp {
    public class Points {
        // Return type is a named tuple — the names ride on a
        // TupleElementNamesAttribute on the method's return parameter.
        public static (int x, int y) MakePoint(int a, int b) {
            return (a, b);
        }

        // Parameter is a named tuple.
        public static string Describe((int width, int height) size) {
            return $"{size.width}x{size.height}";
        }
    }
}

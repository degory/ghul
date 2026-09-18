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

        // Named tuples nested in a generic, in another tuple and in an
        // array: C# writes one flattened name array for the whole type.
        public static System.Collections.Generic.List<(int x, int y)> Line() {
            return new System.Collections.Generic.List<(int x, int y)> { (1, 2), (3, 4) };
        }

        public static (string label, (int left, int right) span) Labelled() {
            return ("span", (5, 6));
        }

        public static (int row, int column)[] Cells() {
            return new (int row, int column)[] { (7, 8) };
        }

        // An unnamed tuple ahead of a named one takes null slots in the
        // flattened array.
        public static (int, (int x, int y)) AfterUnnamed() {
            return (9, (10, 11));
        }
    }
}

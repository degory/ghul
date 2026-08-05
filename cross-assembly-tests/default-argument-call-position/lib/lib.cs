namespace DefaultArgLib
{
    // A real .NET optional parameter with a non-degenerate literal
    // default, unlike a bare `default(T)` - exercises that a
    // positionally-written `default` argument in ghūl picks up the
    // callee's declared default value rather than the type's zero
    // value.
    public static class Widget
    {
        public static string Describe(int count, string label = "widgets")
        {
            return count + " " + (label ?? "<null>");
        }

        public static string DescribeWithSuffix(int count, string label = "widgets", string suffix = "!")
        {
            return count + " " + (label ?? "<null>") + (suffix ?? "<null>");
        }
    }
}

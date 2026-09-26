namespace SetSink;

public static class Sets
{
    public static int CountOf(IReadOnlySet<int> set) => set.Count;

    public static bool AddTo(ISet<string> set, string value) => set.Add(value);

    public static IReadOnlySet<int> Primes() => new HashSet<int> { 2, 3, 5, 7 };

    public static ISet<string> Colours() => new HashSet<string> { "red" };
}

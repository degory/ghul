namespace MultiBoundViolation {
    public interface INamed {
        string Name { get; }
    }

    public interface ISized {
        int Size { get; }
    }

    // Implements only the first of the two bounds `Repo` demands.
    public class Partial : INamed {
        public string Name { get { return "partial"; } }
    }

    public class Repo<T> where T : INamed, ISized {
        public T Item { get; }
        public Repo(T item) { Item = item; }
    }
}

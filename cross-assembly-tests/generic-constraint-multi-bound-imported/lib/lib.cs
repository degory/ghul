namespace MultiBoundImported {
    public interface INamed {
        string Name { get; }
    }

    public interface ISized {
        int Size { get; }
    }

    public class Widget : INamed, ISized {
        public string Name { get { return "widget"; } }
        public int Size { get { return 7; } }
    }

    // Declares two type bounds on one parameter. Earlier ghūl kept only
    // the first and drew an unchecked-constraints warning on every use;
    // both are read and enforced now.
    public class Repo<T> where T : INamed, ISized {
        public T Item { get; }
        public Repo(T item) { Item = item; }
    }
}

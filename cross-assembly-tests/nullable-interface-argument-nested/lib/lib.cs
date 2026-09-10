namespace NestedInterfaceArgument {
    public class Outer {
        // A nested interface. Its own metadata `TypeReference`, seen
        // from a ghūl assembly implementing it, carries an empty
        // `Namespace` and points to the enclosing `Outer` through its
        // `ResolutionScope` rather than a namespace string — different
        // fields than a top-level interface reference uses for the
        // same information.
        public interface IInner<T> {
            T Value { get; set; }
        }
    }
}

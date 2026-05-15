namespace GenericConstraintImported {
    // A generic type imported from another assembly, declaring a `class`
    // constraint on its type parameter. ghūl reads the constraint from
    // the assembly metadata (GenericParameterAttributes) and enforces it.
    public class RefCell<T> where T : class {
        public T Value { get; }
        public RefCell(T value) { Value = value; }
    }
}

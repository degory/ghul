namespace GenericConstraintNewImported {
    // A generic type imported from another assembly, declaring a
    // parameterless-constructor (`new()`) constraint on its type
    // parameter. ghūl reads the constraint from the assembly metadata
    // (GenericParameterAttributes.DefaultConstructorConstraint) and
    // enforces it where the generic is instantiated.
    public class Factory<T> where T : new() {
        public T Create() => new T();
    }
}

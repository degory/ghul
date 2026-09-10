namespace DistinctInstantiations {
    // Implemented below at two different closed instantiations of the
    // same open generic interface - one nullable in its type argument,
    // one not. The CLR (and C#) allow this: only instantiations that
    // could unify under some substitution of the implementing type's
    // own type parameters are rejected, and a non-generic class has no
    // parameters to unify under, so `IBox<string?>` and `IBox<object>`
    // are simply two different interfaces here.
    public interface IBox<T> {
        T Value { get; }
    }

    public class Impl : IBox<string?>, IBox<object> {
        string? IBox<string?>.Value => "held";
        object IBox<object>.Value => 42;
    }
}

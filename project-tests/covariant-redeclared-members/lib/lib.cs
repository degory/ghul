namespace CovariantRedeclaredMembers;

// Interface hierarchy that redeclares an inherited member covariantly at
// each level, and a level that redeclares an inherited member abstractly
// even though the base supplies a default implementation — the shapes EF
// Core's metadata interfaces use. A single implementation satisfies every
// redeclared slot through .NET's implicit interface implementation.

public interface IReadOnlyShape
{
    IReadOnlyShape? Parent { get; }
    IEnumerable<IReadOnlyShape> Children();
    string Describe() => "read-only";
}

public interface IShape : IReadOnlyShape
{
    new IShape? Parent { get; }
    new IEnumerable<IShape> Children();
    new string Describe();
}

public sealed class Shape : IShape
{
    private readonly string _name;
    public Shape(string name) => _name = name;

    public IShape? Parent => null;
    IReadOnlyShape? IReadOnlyShape.Parent => Parent;

    public IEnumerable<IShape> Children() => Array.Empty<IShape>();
    IEnumerable<IReadOnlyShape> IReadOnlyShape.Children() => Children();

    public string Describe() => $"shape:{_name}";
}

public static class Shapes
{
    public static IShape Make(string name) => new Shape(name);
}

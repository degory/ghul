namespace NullGenericOverloadInference;

public interface IThing { string Describe(); }

public sealed class Thing : IThing
{
    private readonly string _label;
    public Thing(string label) => _label = label;
    public string Describe() => _label;
}

// Mirrors the shape of Microsoft.AspNetCore.Http.Results.Ok: a no-arg
// overload plus a generic one whose single parameter is an optional
// generic type with a default value.
public static class Results2
{
    public static IThing Ok() => new Thing("ok-empty");
    public static IThing Ok<TValue>(TValue? value = default) =>
        new Thing($"ok:{typeof(TValue).Name}");
}

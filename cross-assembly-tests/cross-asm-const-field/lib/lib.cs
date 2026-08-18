namespace ConstLib;

public enum Level
{
    Low = 1,
    High = 7,
}

// The constant shapes the base class library does not offer: a string, a
// bool, one typed by an enum, and the only constant of a reference type
// metadata can describe, which is null.
public static class Constants
{
    public const string Greeting = "hello";
    public const string Absent = null;
    public const bool Yes = true;
    public const bool No = false;
    public const Level Threshold = Level.High;
    public const char Separator = ';';
    public const long Big = 9_000_000_000L;

    // Not a metadata constant: the C# compiler emits a decimal `const` as
    // a static readonly field, so this stays an ordinary field read.
    public const decimal Rate = 1.5m;

    public static readonly string Readonly = "readonly";
}

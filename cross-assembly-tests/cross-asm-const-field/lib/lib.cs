namespace ConstLib;

public enum Level
{
    Low = 1,
    High = 7,
}

public enum Wide : long
{
    Small = 3,
    Huge = 0x1_0000_0000,
}

// The constant shapes the base class library does not offer: a string, a
// bool, one typed by an enum, and the only constant of a reference type
// metadata can describe, which is null.
public static class Constants
{
    public const string Greeting = "hello";
    public const string Absent = null;

    // The word the argument-default channel uses for "no value", which a
    // library author is free to choose as an actual value.
    public const string Mode = "default";
    public const bool Yes = true;
    public const bool No = false;
    public const Level Threshold = Level.High;
    public const Wide Reach = Wide.Huge;
    public const char Separator = ';';
    public const long Big = 9_000_000_000L;

    // The argument-default channel: a `_` argument reads the declared
    // .NET default, whose enum value has to survive at the width the
    // enum was declared over.
    public static long Take(Wide w = Wide.Huge) => (long)w;

    // Not a metadata constant: the C# compiler emits a decimal `const` as
    // a static readonly field, so this stays an ordinary field read.
    public const decimal Rate = 1.5m;

    public static readonly string Readonly = "readonly";
}

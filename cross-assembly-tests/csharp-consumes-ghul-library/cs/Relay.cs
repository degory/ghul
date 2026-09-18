namespace Relay;

// C# naming a type from a ghūl library: Roslyn rejects this unless the
// library's references to the framework carry the framework's own
// version and public key token.
public class Greeting
{
    public static string Of(string name) => Lib.GREETER.greet(name);
}

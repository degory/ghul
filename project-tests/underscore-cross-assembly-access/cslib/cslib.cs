namespace UnderscoreCrossAssemblyAccessCs;

public class MIXED
{
    public int Both { get; set; }

    public int GetOnly { get; internal set; }

    public int SetOnly { internal get; set; }
}

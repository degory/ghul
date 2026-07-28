namespace ProtectedCrossAssemblyAccess;

public class BASE
{
    protected int Helper() => 7;

    protected internal int SharedHelper() => 11;

    protected class NESTED
    {
        public int Value => 5;
    }

    protected NESTED MakeNested() => new NESTED();
}

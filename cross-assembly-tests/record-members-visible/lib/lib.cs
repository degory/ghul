namespace RecordMembersVisible {
    // A positional record's ToString/Equals/GetHashCode/Deconstruct/
    // equality operators are all compiler-generated (carry
    // [CompilerGenerated]) but are ordinary, user-callable public API -
    // not shadow members. Regression coverage for symbol_factory reading
    // that attribute back on import: it must not make these internal.
    public record POINT(int X, int Y);
}

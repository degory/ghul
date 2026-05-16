namespace NullableImported {
    // A C# library exposing a value-type nullable (`int?`,
    // i.e. System.Nullable<int>) on its public surface. ghūl reflects
    // it as a nullable and drives `?` / `!` / `if let` on the result.
    public static class Probe {
        public static int? Halve(int n) => n % 2 == 0 ? n / 2 : (int?)null;
    }
}

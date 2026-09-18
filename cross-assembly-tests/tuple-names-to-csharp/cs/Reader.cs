namespace TupleNamesReader;

// C# reading tuple element names a ghūl library wrote: each access below
// compiles only if the names arrived where C# expects them.
public class Reader
{
    public static string Read()
    {
        var source = new TupleNamesToCSharp.SOURCE();

        var line = source.line();
        var labelled = source.labelled();
        var cells = source.cells();
        var after = source.after_unnamed();

        return $"{line[1].x},{line[1].y} {labelled.label} {labelled.span.left}..{labelled.span.right} {cells[0].row},{cells[0].column} {after.Item2.named},{after.Item2.too}";
    }
}

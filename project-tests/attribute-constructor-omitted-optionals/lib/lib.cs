using System;

namespace OmittedOptionals {
    // Shaped after MSTest 4's TestMethodAttribute, whose constructor
    // carries CallerFilePath/CallerLineNumber defaults so a bare
    // [TestMethod] still compiles. Exercises the positional-argument
    // constructor form omitting trailing defaults, as opposed to the
    // field/property named-argument form the pragma already supported.
    [AttributeUsage(AttributeTargets.Method)]
    public class MarkAttribute : Attribute {
        public string Label { get; }
        public int Line { get; }

        public MarkAttribute(string label = "unmarked", int line = -1) {
            Label = label;
            Line = line;
        }
    }
}

namespace MethodHidingAndOverriding {
    public class Base {
        public virtual object? Method() {
            System.Console.WriteLine("---- Base.Method()");
            return "from Base.Method()";
        }
    }

    public class OverrideSameReturnType: Base {
        public override object? Method()
        {            
            System.Console.WriteLine(">>>> OverrideSameReturnType.Method()");
            var result = base.Method() + " via OverrideSameReturnType.Method()";
            System.Console.WriteLine("<<<< OverrideSameReturnType.Method()");

            return result;
        }
    }

    public class NewSameReturnType: Base {
        public new object? Method() {
            System.Console.WriteLine("---- NewSameReturnType.Method()");

            return "from NewSameReturnType.Method()";
        }
    }

    public class NewVirtualSameReturnType: Base {
        public virtual new object? Method() {
            System.Console.WriteLine("---- NewVirtualSameReturnType.Method()");

            return "from NewVirtualSameReturnType.Method()";
        }
    }

    public class OverrideCovariantReturnType: Base {
        public override string? Method()
        {
            System.Console.WriteLine(">>>> OverrideCovariantReturnType.Method()");
            var result = base.Method() + " via OverrideCovariantReturnType.Method()";
            System.Console.WriteLine("<<<< OverrideCovariantReturnType.Method()");

            return result;
        }
    }

    public class NewCovariantReturnType: Base {
        public new string? Method() {
            System.Console.WriteLine("---- NewCovariantReturnType.Method()");

            return "from NewCovariantReturnType.Method()";
        }
    }

    public class NewVirtualCovariantReturnType: Base {
        public virtual new string? Method() {
            System.Console.WriteLine("---- NewVirtualCovariantReturnType.Method()");

            return "from NewVirtualCovariantReturnType.Method()";
        }
    }
}




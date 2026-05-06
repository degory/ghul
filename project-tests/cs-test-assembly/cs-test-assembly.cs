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

namespace InheritedGenericMembers {
    // Generic base with parameters used in method signatures and field types,
    // including a self-referencing constraint (CRTP / F-bounded). Patterns
    // like this — used by FluentAssertions and similar libraries — surface
    // inherited members on the constructed base via reflection with their
    // type-parameter references substituted to concrete types. ghūl must
    // recover the open-generic form when emitting methodref/fieldref tokens.
    public class GenericBase<TSubject, TAssertions>
        where TAssertions : GenericBase<TSubject, TAssertions>
    {
        public TSubject SubjectField = default!;
        public TAssertions SelfField = default!;
        public AndConstraint<TAssertions> WrappedSelfField = default!;

        public string DescribeSubject(TSubject subject) {
            return $"DescribeSubject({subject})";
        }

        public TAssertions ReturnSelf() {
            return (TAssertions)(object)this;
        }

        public string TakeSelf(TAssertions other) {
            return $"TakeSelf({other})";
        }

        public AndConstraint<TAssertions> WrapSelf() {
            return new AndConstraint<TAssertions> { And = (TAssertions)(object)this };
        }
    }

    public class AndConstraint<T> {
        public T And = default!;
    }

    public class Concrete: GenericBase<object, Concrete> {
        public Concrete() {
            SubjectField = "subject-init";
            SelfField = this;
            WrappedSelfField = new AndConstraint<Concrete> { And = this };
        }
    }
}




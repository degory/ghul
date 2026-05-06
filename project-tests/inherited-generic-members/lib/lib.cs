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

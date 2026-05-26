
    // SetStateMachine — required by the IAsyncStateMachine interface.
    // For a class-based state machine (what ghūl emits — C# Release
    // uses structs), the implementation is a no-op: the runtime
    // never re-boxes a reference state machine, so there's nothing
    // to do. C# emits the same trivial override for class-based
    // state machines.
    //
    // No placeholders — the .override directive points at the
    // standard System.Runtime interface method.
    .method private final virtual hidebysig newslot specialname instance default void System.Runtime.CompilerServices.IAsyncStateMachine.SetStateMachine (class ['System.Runtime']System.Runtime.CompilerServices.IAsyncStateMachine stateMachine)  cil managed
    {
        .override class ['System.Runtime']System.Runtime.CompilerServices.IAsyncStateMachine::SetStateMachine
        .maxstack 8
        ret
    }

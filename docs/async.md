# ghūl: asynchronous code

Read this when you are writing a coroutine library or a custom task type. It continues sections of [GHUL.md](../GHUL.md), the language reference, under the same headings; GHUL.md is loaded with every session and this file is not.

## asynchronous code

The operand of `await` need not be a task. Anything following .NET's awaiter pattern is accepted: a type with a parameterless `get_awaiter()` whose result has a `bool` property `is_completed`, a parameterless `get_result()`, and implements `System.Runtime.CompilerServices.INotifyCompletion` (or `ICriticalNotifyCompletion`). The `await` expression takes the type `get_result` returns, void included. `Tasks.ValueTask[T]`, `Tasks.TASK.yield()` and `task.configure_await(false)` all qualify, and so does a type written in ghūl - a struct awaitable that hands its continuation to a scheduler is how cooperative multitasking is built without allocating a task per suspension:

```ghul
use System.Runtime.CompilerServices.ICriticalNotifyCompletion;

struct PAUSE: ICriticalNotifyCompletion is
    _ready: Collections.Queue[() -> void];

    init(ready: Collections.Queue[() -> void]) is _ready = ready; si

    get_awaiter() -> PAUSE => self;
    is_completed: bool => false;
    get_result() is si
    on_completed(continuation: () -> void) is _ready.enqueue(continuation); si
    unsafe_on_completed(continuation: () -> void) is _ready.enqueue(continuation); si
si
```

An `await` over a value that does not follow the pattern is reported, naming the first missing member.

What an asynchronous function *produces* is not fixed to `Tasks.TASK` / `Tasks.TASK[T]` either. Any type carrying .NET's `AsyncMethodBuilderAttribute` is a *task-like* return type: the attribute names a builder type, and the compiler drives that builder instead of the Task one. `Tasks.ValueTask[T]` and `Tasks.ValueTask` work this way, and so does a type declared in ghūl source, which is how a library gives its coroutines a return type of their own rather than a Task:

```ghul
@System.Runtime.CompilerServices.AsyncMethodBuilder(typeof(COROUTINE_BUILDER))
class COROUTINE[T] is
    value: T public;

    init() is si
si
```

A builder written in ghūl declares its members under their ghūl names: a static `create()`, a `start` taking the state machine by reference and calling its `move_next`, a readable `task` property returning the task-like, a `set_result` taking the result (or nothing, for a task-like with no result), a `set_exception` taking `Ghul.Exception`, and `await_on_completed` / `await_unsafe_on_completed` each taking the awaiter by reference. That is the same shape .NET's own builders use.

An `async` function declared `-> COROUTINE[int]` awaits, suspends and returns a bare `int` exactly as a `Tasks.TASK[int]` one does. A generic task-like has exactly one type argument and it is the result type, matching `Task` and `ValueTask`; a non-generic one carries no result. A builder missing one of the required members, or declaring one without the by-reference parameter the lowering passes, is reported at the function that returns its task-like, and a return type that is not a task-like is reported too.

A function literal is asynchronous on the same terms. One that declares a task-like return type is driven through that type's builder, as a named function is. One that declares none takes its task-like from the slot it goes into - a typed local variable, a parameter, a return - and where the slot leaves the result type open, as `spawn[T](body: () -> COROUTINE[T])` does, the result is inferred from the body's returns. Where several overloads share the arity, the body settles which is meant: one that produces a value goes to a formal whose task-like carries a result, and one that produces none to a formal whose task-like does not. A literal with nothing to say otherwise returns `Tasks.TASK` or `Tasks.TASK[T]`.

```ghul
let tick = (name: string) -> COROUTINE is
    write_line("{name} before");
    await scheduler.pause();
    write_line("{name} after");
si;

let handle = scheduler.spawn(s is
    await s.pause();
    return 42;
si);                                   // COROUTINE[int], through spawn[T]
```

An asynchronous function whose return type carries no result - `Tasks.TASK`, or a task-like with no type argument - completes when its body falls off the end, so it needs no `return` and draws no `definite-return` warning for lacking one. One whose return type carries a result still warns, as any value-returning function does. The completion holds whether or not the body awaits - the declaration alone makes the function asynchronous - and a bare `return;` is sugar for the same completed handle. A `Tasks.TASK` function completes through `Tasks.TASK.completed_task`; a task-like declared in source completes through its builder, whose members are driven directly.

`await` may appear inside the body of a `for` or `while` loop, and `return` from inside such a body propagates back through the loop. A `try`/`catch`/`finally` around awaiting code works as expected, including a `return` from inside the `try`; what is not yet supported is an `await` inside a `catch` or `finally` *handler*. Reading `.result` on a returned task surfaces a faulted task as a `System.AggregateException`.

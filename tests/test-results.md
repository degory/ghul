# Success: 128/128 tests passed. Run time 5.312 seconds

## PASS enum-relational-operators

## PASS function-no-arg-type

### stderr:

```
test.ghul: 6,18..6,22: error: explicit argument type required
test.ghul: 6,23..6,27: error: explicit argument type required

```
## PASS function-type-checks

### stderr:

```
test.ghul: 20,18..20,21: error: expected argument of type Ghul.char but Ghul.int supplied
test.ghul: 21,18..21,25: error: expected argument of type Ghul.char but System.String supplied
test.ghul: 23,19..23,26: error: expected argument of type Ghul.int but System.String supplied
test.ghul: 24,24..24,31: error: expected argument of type Ghul.int but System.String supplied
test.ghul: 26,18..26,44: error: expected 1 arguments but 3 supplied
test.ghul: 27,18..27,19: error: expected 1 arguments but 0 supplied
test.ghul: 35,13..35,25: error: Ghul.char -> Ghul.char is not assignable to (Ghul.int,Ghul.int) -> Ghul.int
test.ghul: 36,13..36,25: error: Ghul.FUNCTION_1[Ghul.char,Ghul.char] is not assignable to Ghul.FUNCTION_2[Ghul.int,Ghul.int,Ghul.int]
test.ghul: 38,13..38,20: error: cannot call value of non-function type System.String

```
## PASS function-type

## PASS generic-arguments

## PASS generic-function-type

## PASS generic-inheritance-2

## PASS generic-inheritance

## PASS generic-overrides

## PASS generic-self-2

## PASS generic-self

## PASS generic-traits

## PASS generic-type-compatibility-2

## PASS generic-type-compatibility-3

## PASS generic-type-compatibility

## PASS generic-type-constraints

### stderr:

```
test.ghul: 19,24..19,40: error: member nonTraitFunction not found in Test.GenericTypeConstraints.NeedsSomeTrait.T

```
## PASS il-def-class-implement-traits

## PASS il-def-class-implement-trait

## PASS il-def-class-minimal

## PASS il-def-class-superclass-and-traits

## PASS il-def-class-superclass

## PASS il-def-function-fall-through-returns

## PASS il-def-function-instance-args-innate-types

## PASS il-def-function-instance-il-name-override

## PASS il-def-function-instance-minimal

## PASS il-def-function-static

## PASS il-def-generic-class

## PASS il-def-namespace-class-method

## PASS il-def-namespace-minimal

## PASS il-def-namespace-nested

## PASS il-def-namespace-qualified-name

## PASS il-def-trait-method

## PASS il-operations-arithmetic-integer

## PASS il-output-pragma

## PASS indexer-type-checks

### stderr:

```
test.ghul: 9,13..9,23: error: indexer [System.String] = Ghul.int not found in Ghul.int[]
test.ghul: 10,13..10,18: error: indexer [Ghul.int] = System.String not found in Ghul.int[]
test.ghul: 12,13..12,17: error: indexer not found in Ghul.int
test.ghul: 14,21..14,31: error: indexer [System.String] not found in Ghul.int[]

```
## PASS indirect-overrides

## PASS integration-hello-world

### stdout:

```
hello, world

```
## PASS integration-ilasm-failure

### stderr:

```
ilasm failed
out.il : Error : No entry point found.

***** FAILURE *****



```
## PASS integration-minimal

## PASS integration-to-string

### stdout:

```
A thing
A thing

```
## PASS parse-definition-pragma-1

## PASS parse-generic-function-1

## PASS parse-incomplete-class-10

### stderr:

```
test.ghul: 6,1..6,2: error: in type expression: expected ( or identifier but found si

```
## PASS parse-incomplete-class-11

### stderr:

```
test.ghul: 6,1..6,2: error: in type expression: expected ] but found si

```
## PASS parse-incomplete-class-12

### stderr:

```
test.ghul: 6,1..6,2: error: syntax error: expected is but found si

```
## PASS parse-incomplete-class-13

### stderr:

```
test.ghul: 6,1..6,3: error: syntax error: expected si but found end of input

```
## PASS parse-incomplete-class-1

### stderr:

```
test.ghul: 6,1..6,2: error: syntax error: expected is but found si

```
## PASS parse-incomplete-class-2

### stderr:

```
test.ghul: 6,1..6,2: error: in type expression: expected ( or identifier but found si

```
## PASS parse-incomplete-class-3

### stderr:

```
test.ghul: 6,1..6,2: error: syntax error: expected ] but found si

```
## PASS parse-incomplete-class-4

### stderr:

```
test.ghul: 6,1..6,2: error: in type expression: expected ( or identifier but found si

```
## PASS parse-incomplete-class-5

### stderr:

```
test.ghul: 6,1..6,2: error: syntax error: expected ] but found si

```
## PASS parse-incomplete-class-6

### stderr:

```
test.ghul: 6,1..6,2: error: syntax error: expected is but found si

```
## PASS parse-incomplete-class-7

### stderr:

```
test.ghul: 6,1..6,2: error: in type expression: expected ( or identifier but found si

```
## PASS parse-incomplete-class-8

### stderr:

```
test.ghul: 6,1..6,2: error: in type expression: expected ( or identifier but found si
test.ghul: 5,22..6,2: error: expected 2 type arguments

```
## PASS parse-incomplete-class-9

### stderr:

```
test.ghul: 6,1..6,2: error: in type expression: expected ] but found si
test.ghul: 5,22..6,2: error: expected 2 type arguments

```
## PASS parse-incomplete-enum-10

### stderr:

```
test.ghul: 8,5..8,10: error: in identifier: expected identifier but found class

```
## PASS parse-incomplete-enum-1

### stderr:

```
test.ghul: 6,1..6,2: error: in identifier: expected identifier but found si

```
## PASS parse-incomplete-enum-2

### stderr:

```
test.ghul: 6,1..6,2: error: syntax error: expected is but found si

```
## PASS parse-incomplete-enum-3

### stderr:

```
test.ghul: 7,1..7,3: error: syntax error: expected si but found end of input

```
## PASS parse-incomplete-enum-4

### stderr:

```
test.ghul: 7,1..7,2: error: in identifier: expected identifier but found si

```
## PASS parse-incomplete-enum-5

### stderr:

```
test.ghul: 8,1..8,3: error: syntax error: expected si but found end of input

```
## PASS parse-incomplete-enum-6

### stderr:

```
test.ghul: 8,1..8,2: error: in primary expression: expected (, [, cast, char literal, identifier, int literal, isa, native, new, none, null, self, string literal or super but found si

```
## PASS parse-incomplete-enum-7

### stderr:

```
test.ghul: 7,5..7,10: error: in identifier: expected identifier but found class

```
## PASS parse-incomplete-enum-8

### stderr:

```
test.ghul: 7,5..7,11: error: syntax error: expected is but found struct

```
## PASS parse-incomplete-enum-9

### stderr:

```
test.ghul: 7,5..7,9: error: in identifier: expected identifier but found enum

```
## PASS parse-incomplete-function-1

### stderr:

```
test.ghul: 6,5..6,7: error: syntax error: expected identifier but found si

```
## PASS parse-incomplete-function-2

### stderr:

```
test.ghul: 5,18..5,26: error: explicit argument type required
test.ghul: 6,5..6,7: error: syntax error: expected ) but found si

```
## PASS parse-incomplete-function-3

### stderr:

```
test.ghul: 6,5..6,7: error: in type expression: expected ( or identifier but found si
test.ghul: 6,5..6,7: error: syntax error: expected ) but found si

```
## PASS parse-incomplete-function-4

### stderr:

```
test.ghul: 6,5..6,7: error: syntax error: expected ) but found si

```
## PASS parse-incomplete-function-5

### stderr:

```
test.ghul: 6,5..6,7: error: syntax error: expected ; but found si

```
## PASS parse-incomplete-function-6

### stderr:

```
test.ghul: 7,1..7,3: error: syntax error: expected si but found end of input

```
## PASS parse-incomplete-function-7

### stderr:

```
test.ghul: 5,28..5,30: error: in type expression: expected ( or identifier but found in
test.ghul: 6,5..6,7: error: syntax error: expected ) but found si

```
## PASS parse-incomplete-if-1

### stderr:

```
test.ghul: 9,9..9,11: error: in primary expression: expected (, [, cast, char literal, identifier, int literal, isa, native, new, none, null, self, string literal or super but found si
test.ghul: 9,9..9,11: error: syntax error: expected then but found si

```
## PASS parse-incomplete-if-2

### stderr:

```
test.ghul: 9,9..9,11: error: syntax error: expected then but found si

```
## PASS parse-incomplete-if-3

### stderr:

```
test.ghul: 9,9..9,11: error: syntax error: expected else but found si

```
## PASS parse-incomplete-member

### stderr:

```
test.ghul: 6,5..6,7: error: in member: expected :, ;, => or = but found si

```
## PASS parse-incomplete-namespace-1

### stderr:

```
test.ghul: 1,1..2,1: error: in qualified identifier: expected identifier but found end of input
System.NullPointerException: null pointer dereference
ghul(_ZN6System20NullPointerException8throwNPEEv+0x34) [0x7835d4]
ghul() [0x7eef95]
ghul(_ZN6Syntax6Parser11LAZY_PARSERIN6Syntax4Tree10Definition9NAMESPACEEE5parseEN6Syntax6Parser7CONTEXTE+0x23) [0x870683]
ghul(__thunk_bound__ZN6Syntax6Parser10Definition4NODE8__anon_1EN6Syntax6Parser7CONTEXTE+0x1a) [0x87806a]
ghul(_ZN6Syntax6Parser4BASEIN6Syntax4Tree10Definition4NODEEE5parseEN6Syntax6Parser7CONTEXTE+0x45) [0x80a075]
ghul(_ZN6Driver8COMPILER5parseEN6System6StringEN2IO6ReaderEN6Driver11BUILD_FLAGSE+0x10e) [0x77cd3e]
ghul(_ZN6Driver8COMPILER15parse_and_queueEN6System6StringEN2IO6ReaderEN6Driver11BUILD_FLAGSE+0x12) [0x77cb82]
ghul(_ZN6Driver4Main11parse_flagsEv+0x119) [0x7adc49]
ghul(_ZN6Driver4Main4initEv+0x170) [0x7ad970]
ghul(_ZN6System7Startup4run1EN6System6ObjectE+0xd) [0x83d7bd]
ghul(main+0x43) [0x74b8d3]


```
## PASS parse-incomplete-namespace-2

### stderr:

```
test.ghul: 1,11..1,15: error: syntax error: expected is but found end of input

```
## PASS parse-incomplete-namespace-3

### stderr:

```
test.ghul: 1,15..1,16: error: in qualified identifier: expected identifier but found end of input

```
## PASS parse-incomplete-namespace-4

### stderr:

```
test.ghul: 1,16..1,20: error: syntax error: expected is but found end of input

```
## PASS parse-incomplete-namespace-5

### stderr:

```
test.ghul: 1,21..1,23: error: syntax error: expected si but found end of input

```
## PASS parse-incomplete-namespace-6

### stderr:

```
test.ghul: 1,17..1,18: error: in qualified identifier: expected identifier but found is

```
## PASS parse-incomplete-namespace-7

### stderr:

```
test.ghul: 1,17..1,19: error: in qualified identifier: expected identifier but found is

```
## PASS parse-incomplete-property-10

### stderr:

```
test.ghul: 6,5..6,7: error: syntax error: expected ; but found si

```
## PASS parse-incomplete-property-11

### stderr:

```
test.ghul: 6,5..6,7: error: unexpected input in property

```
## PASS parse-incomplete-property-12

### stderr:

```
test.ghul: 5,33..5,34: error: syntax error: expected si but found ,
test.ghul: 6,5..6,7: error: unexpected input in property

```
## PASS parse-incomplete-property-13

### stderr:

```
test.ghul: 6,5..6,7: error: unexpected input in property

```
## PASS parse-incomplete-property-14

### stderr:

```
test.ghul: 6,5..6,7: error: in primary expression: expected (, [, cast, char literal, identifier, int literal, isa, native, new, none, null, self, string literal or super but found si
test.ghul: 6,5..6,7: error: syntax error: expected ; but found si

```
## PASS parse-incomplete-property-15

### stderr:

```
test.ghul: 6,5..6,7: error: in primary expression: expected (, [, cast, char literal, identifier, int literal, isa, native, new, none, null, self, string literal or super but found si
test.ghul: 6,5..6,7: error: syntax error: expected ; but found si

```
## PASS parse-incomplete-property-16

### stderr:

```
test.ghul: 6,5..6,7: error: syntax error: expected ; but found si

```
## PASS parse-incomplete-property-17

### stderr:

```
test.ghul: 5,19..5,20: error: in type expression: expected ( or identifier but found =

```
## PASS parse-incomplete-property-1

### stderr:

```
test.ghul: 6,5..6,7: error: in type expression: expected ( or identifier but found si

```
## PASS parse-incomplete-property-2

### stderr:

```
test.ghul: 6,5..6,7: error: unexpected input in property

```
## PASS parse-incomplete-property-3

### stderr:

```
test.ghul: 6,5..6,7: error: in primary expression: expected (, [, cast, char literal, identifier, int literal, isa, native, new, none, null, self, string literal or super but found si
test.ghul: 6,5..6,7: error: syntax error: expected ; but found si

```
## PASS parse-incomplete-property-4

### stderr:

```
test.ghul: 6,5..6,7: error: in primary expression: expected (, [, cast, char literal, identifier, int literal, isa, native, new, none, null, self, string literal or super but found si
test.ghul: 6,5..6,7: error: syntax error: expected ; but found si

```
## PASS parse-incomplete-property-5

### stderr:

```
test.ghul: 6,5..6,7: error: unexpected input in property

```
## PASS parse-incomplete-property-6

### stderr:

```
test.ghul: 6,5..6,7: error: in identifier: expected identifier but found si
test.ghul: 6,5..6,7: error: syntax error: expected ; but found si

```
## PASS parse-incomplete-property-7

### stderr:

```
test.ghul: 6,5..6,7: error: syntax error: expected ; but found si

```
## PASS parse-incomplete-property-8

### stderr:

```
test.ghul: 7,1..8,1: error: syntax error: expected si but found end of input

```
## PASS parse-incomplete-property-9

### stderr:

```
test.ghul: 6,5..6,7: error: in identifier: expected identifier but found si
test.ghul: 6,5..6,7: error: syntax error: expected ; but found si

```
## PASS parse-incomplete-trait-1

### stderr:

```
test.ghul: 6,1..6,2: error: in type expression: expected ( or identifier but found si

```
## PASS parse-incomplete-type-1

### stderr:

```
test.ghul: 4,5..4,7: error: in qualified identifier: expected identifier but found si

```
## PASS parse-incomplete-use-1

### stderr:

```
test.ghul: 3,1..3,3: error: in qualified identifier: expected identifier but found si

```
## PASS parse-incomplete-use-2

### stderr:

```
test.ghul: 3,1..3,3: error: syntax error: expected ; but found si

```
## PASS parse-incomplete-use-3

### stderr:

```
test.ghul: 3,1..3,3: error: in qualified identifier: expected identifier but found si
test.ghul: 3,1..3,3: error: syntax error: expected ; but found si

```
## PASS parse-incomplete-use-4

### stderr:

```
test.ghul: 3,1..3,3: error: syntax error: expected ; but found si

```
## PASS parse-incomplete-use-5

### stderr:

```
test.ghul: 7,5..7,10: error: in qualified identifier: expected identifier but found class
test.ghul: 13,15..13,27: error: member doesNotExist not found in Test.Test

```
## PASS parse-incomplete-use-6

### stderr:

```
test.ghul: 5,5..5,8: error: in qualified identifier: expected identifier but found use

```
## PASS parse-incomplete-use-7

### stderr:

```
test.ghul: 4,5..4,8: error: syntax error: expected ; but found use
test.ghul: 6,5..6,10: error: syntax error: expected ; but found class

```
## PASS parse-incomplete-variable-10

### stderr:

```
test.ghul: 6,25..6,27: error: in type expression: expected ( or identifier but found in
test.ghul: 7,9..7,11: error: syntax error: expected ; but found si

```
## PASS parse-incomplete-variable-1

### stderr:

```
test.ghul: 7,9..7,11: error: syntax error: expected identifier but found si
test.ghul: 7,9..7,11: error: syntax error: expected ; but found si

```
## PASS parse-incomplete-variable-2

### stderr:

```
test.ghul: 7,9..7,11: error: syntax error: expected ; but found si
test.ghul: 6,17..6,18: error: variable must have explict type or initializer

```
## PASS parse-incomplete-variable-3

### stderr:

```
test.ghul: 7,9..7,11: error: syntax error: expected ; but found si

```
## PASS parse-incomplete-variable-4

### stderr:

```
test.ghul: 7,9..7,11: error: in type expression: expected ( or identifier but found si
test.ghul: 7,9..7,11: error: syntax error: expected ; but found si

```
## PASS parse-incomplete-variable-5

### stderr:

```
test.ghul: 7,9..7,11: error: in primary expression: expected (, [, cast, char literal, identifier, int literal, isa, native, new, none, null, self, string literal or super but found si
test.ghul: 7,9..7,11: error: syntax error: expected ; but found si

```
## PASS parse-incomplete-variable-6

### stderr:

```
test.ghul: 7,9..7,11: error: in primary expression: expected (, [, cast, char literal, identifier, int literal, isa, native, new, none, null, self, string literal or super but found si
test.ghul: 7,9..7,11: error: syntax error: expected ; but found si

```
## PASS parse-incomplete-variable-7

### stderr:

```
test.ghul: 7,9..7,11: error: syntax error: expected ; but found si

```
## PASS parse-incomplete-variable-8

### stderr:

```
test.ghul: 7,9..7,11: error: in type expression: expected ( or identifier but found si
test.ghul: 7,9..7,11: error: syntax error: expected ; but found si

```
## PASS parse-incomplete-variable-9

### stderr:

```
test.ghul: 6,20..6,22: error: in type expression: expected ( or identifier but found in
test.ghul: 7,9..7,11: error: syntax error: expected ; but found si

```
## PASS parse-statement-pragma-1

### stderr:

```
IO.IOException: open "../lib/ghul.ghul": No such file or directory (2)
ghul(_ZN2IO11IOException4initEiN6System6StringE+0x2d) [0x7cda2d]
ghul(_ZN2IO10FileStream16throwIOExceptionEN6System6StringEiN6System6StringE+0x105) [0x7cb025]
ghul(_ZN2IO4File10openStreamEN6System6StringEiib+0x62) [0x834722]
ghul(_ZN6Driver4Main11parse_flagsEv+0xf3) [0x7adc23]
ghul(_ZN6Driver4Main4initEv+0x170) [0x7ad970]
ghul(_ZN6System7Startup4run1EN6System6ObjectE+0xd) [0x83d7bd]
ghul(main+0x43) [0x74b8d3]


```
## PASS parse-struct-1

## PASS parse-struct-2

### stderr:

```
ghul(__segv_handler+0x83)[0x74b2b3]
swallowing System.MemoryProtectionException: invalid pointer dereference
ghul(_ZN6System15MemoryException7throwMEEv+0x50) [0x7b6d20]
/lib/x86_64-linux-gnu/libc.so.6(+0x46210) [0x7faaa8091210]
ghul(_ZN8Semantic4Type7GENERIC10specializeEN7Generic4DictIN6System6StringEN8Semantic4Type4BASEEEE+0x5d) [0x75b9bd]
ghul(_ZN8Semantic6Symbol8Property10specializeEN7Generic4DictIN6System6StringEN8Semantic4Type4BASEEEE+0x60) [0x7a4980]
ghul(_ZN8Semantic6Symbol7GENERIC11_specializeEN8Semantic6Symbol4BASEE+0xb5) [0x8618e5]
ghul(_ZN8Semantic6Symbol7GENERIC11find_memberEN6System6StringE+0x22) [0x860b22]
ghul(_ZN8Semantic6Symbol21ScopedWithInheritance16find_member_onlyEN6System6StringE+0x193) [0x7ec493]
ghul(_ZN8Semantic6Symbol21ScopedWithInheritance11find_memberEN6System6StringE+0x37) [0x7eb537]
ghul(_ZN6Syntax7Process11INFER_TYPES5visitEN6Syntax4Tree10Expression6MEMBERE+0x177) [0x7ded27]
ghul(_ZN6Syntax4Tree10Expression6MEMBER4walkEN6Syntax7VisitorE+0x54) [0x7d7744]
ghul(_ZN6Syntax4Tree4Body10EXPRESSION4walkEN6Syntax7VisitorE+0x30) [0x7b1630]
ghul(_ZN6Syntax4Tree10Definition8PROPERTY4walkEN6Syntax7VisitorE+0x74) [0x7f37d4]
ghul(_ZN6Syntax4Tree10Definition4LIST4walkEN6Syntax7VisitorE+0x60) [0x80a620]
ghul(_ZN6Syntax4Tree10Definition6STRUCT4walkEN6Syntax7VisitorE+0x13a) [0x7ac88a]
ghul(_ZN6Syntax4Tree10Definition4LIST4walkEN6Syntax7VisitorE+0x60) [0x80a620]
ghul(_ZN6Syntax4Tree10Definition9NAMESPACE4walkEN6Syntax7VisitorE+0x41) [0x766511]


```
## PASS parse-unary

## PASS scope-namespace-qualified

## PASS simple-generic

## PASS simple-overrides

## PASS simple-type-compatibility

## PASS single-element-tuple

### stderr:

```
possible tuple match: (Ghul.int) vs ((Ghul.int))
tuple match score: (Ghul.int) vs (Ghul.int) = 0
possible tuple match: (Ghul.int) vs ((Ghul.int))
tuple match score: (Ghul.int) vs (Ghul.int) = 0
possible tuple match: (Ghul.int) vs ((Ghul.int))
tuple match score: (Ghul.int) vs (Ghul.int) = 0

```


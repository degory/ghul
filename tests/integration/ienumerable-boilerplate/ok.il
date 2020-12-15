.assembly extern System.Runtime
{
  .ver 5:0:0:0
  .publickeytoken = (B7 7A 5C 56 19 34 E0 89 ) // .z\V.4..
}
.assembly extern mscorlib
{
  .ver 4:0:0:0
  .publickeytoken = (B7 7A 5C 56 19 34 E0 89 ) // .z\V.4..
}
.assembly extern System.Core
{
  .ver 4:0:0:0
  .publickeytoken = (B7 7A 5C 56 19 34 E0 89 ) // .z\V.4..
}
.assembly extern System.Collections
{
  .ver 4:0:0:0
  .publickeytoken = (B7 7A 5C 56 19 34 E0 89 ) // .z\V.4..
}
.assembly extern System.Console
{
  .ver 4:0:0:0
  .publickeytoken = (B7 7A 5C 56 19 34 E0 89 ) // .z\V.4..
}
.assembly extern System
{
  .ver 4:0:0:0
  .publickeytoken = (B7 7A 5C 56 19 34 E0 89 ) // .z\V.4..
}
.assembly 'test'
{
}
.module 'test.exe'

.namespace 'Ghul' { // fixed
  // define trait Ghul.Range
  .class public interface auto ansi beforefieldinit Range`1<T>
  {
    // // define Ghul.Range.__read_from() -> Ghul.Range.T // abstract method
    .method public virtual hidebysig abstract instance default  !0 '__read_from'() cil managed
    {
    }
    // // define Ghul.Range.__read_to() -> Ghul.Range.T // abstract method
    .method public virtual hidebysig abstract instance default  !0 '__read_to'() cil managed
    {
    }
  }
}
.namespace 'Ghul' { // fixed
  // define struct Ghul.INT_RANGE
  .class public sealed auto ansi beforefieldinit 'INT_RANGE' extends [mscorlib]System.ValueType implements class 'Ghul'.Range`1<int32>, class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>, class [mscorlib]System.Collections.Generic.IEnumerator`1<int32>
  {
    // // define Ghul.INT_RANGE.init(from: Ghul.int, to: Ghul.int) -> Ghul.void // method
    .method public hidebysig instance default  void '.ctor'(int32 'from',int32 'to') cil managed
    {
      .maxstack 64
      ldarg.0        // self Ghul.INT_RANGE
      ldarg 'from'        // Semantic.Symbols.LOCAL_ARGUMENT from @ ../../../lib/dotnet/ghul/range.ghul 19,14..19,17 type: Ghul.int
      ldc.i4 1
      sub
      call instance void valuetype 'Ghul'.'INT_RANGE'::'__assign_current'(int32)
      ldarg.0        // self Ghul.INT_RANGE
      ldarg 'to'        // Semantic.Symbols.LOCAL_ARGUMENT to @ ../../../lib/dotnet/ghul/range.ghul 19,25..19,26 type: Ghul.int
      call instance void valuetype 'Ghul'.'INT_RANGE'::'__assign_to'(int32)
      ret
    }
    // // define Ghul.INT_RANGE.move_next() -> Ghul.bool // method
    .method public final virtual hidebysig instance default  bool MoveNext() cil managed
    {
      .maxstack 64
      ldarg.0        // self Ghul.INT_RANGE
      ldarg.0        // self Ghul.INT_RANGE
      call instance int32 valuetype 'Ghul'.'INT_RANGE'::get_Current()
      ldc.i4 1
      add
      call instance void valuetype 'Ghul'.'INT_RANGE'::'__assign_current'(int32)
      ldarg.0        // self Ghul.INT_RANGE
      call instance int32 valuetype 'Ghul'.'INT_RANGE'::get_Current()
      ldarg.0        // self Ghul.INT_RANGE
      call instance int32 valuetype 'Ghul'.'INT_RANGE'::'__read_to'()
      clt        // <
      ret
      .locals init (bool '.default')
      ldloc '.default'
      ret
    }
    // // define Ghul.INT_RANGE.__read_iterator() -> Collections.Iterator[Ghul.int] // method
    .method public final virtual hidebysig instance default  class [mscorlib]System.Collections.Generic.IEnumerator`1<int32> GetEnumerator() cil managed
    {
      .maxstack 64
      ldarg.0        // self Ghul.INT_RANGE
      ldobj valuetype 'Ghul'.'INT_RANGE'
      box valuetype 'Ghul'.'INT_RANGE'
      ret
      .locals init (class [mscorlib]System.Collections.Generic.IEnumerator`1<int32> '.default')
      ldloc '.default'
      ret
    }
    .field public int32 '__backing_current'
    // // define Ghul.INT_RANGE.__read_current() -> Ghul.int // method
    .method public final virtual hidebysig instance default  int32 get_Current() cil managed
    {
      .maxstack 64
      ldarg.0        // self Ghul.INT_RANGE
      ldfld int32 valuetype 'Ghul'.'INT_RANGE'::'__backing_current'        // Semantic.Symbols.INSTANCE_FIELD __backing_current @ internal 1,1..1,1 type: Ghul.int
      ret
      .locals init (int32 '.default')
      ldloc '.default'
      ret
    }
    // // define Ghul.INT_RANGE.__assign_current(__value: Ghul.int) -> Ghul.void // method
    .method public final virtual hidebysig instance default  void '__assign_current'(int32 '__value') cil managed
    {
      .maxstack 64
      ldarg.0        // self Ghul.INT_RANGE
      ldarg '__value'        // Semantic.Symbols.LOCAL_ARGUMENT __value @ ../../../lib/dotnet/ghul/range.ghul 14,9..14,21 type: Ghul.int
      stfld int32 valuetype 'Ghul'.'INT_RANGE'::'__backing_current'        // Semantic.Symbols.INSTANCE_FIELD __backing_current @ internal 1,1..1,1 type: Ghul.int
      ret
    }
    // // define Ghul.INT_RANGE.__read_from() -> Ghul.int // method
    .method public final virtual hidebysig instance default  int32 '__read_from'() cil managed
    {
      .maxstack 64
      ldarg.0        // self Ghul.INT_RANGE
      call instance int32 valuetype 'Ghul'.'INT_RANGE'::get_Current()
      ldc.i4 1
      add
      ret
      .locals init (int32 '.default')
      ldloc '.default'
      ret
    }
    .field public int32 '__backing_to'
    // // define Ghul.INT_RANGE.__read_to() -> Ghul.int // method
    .method public final virtual hidebysig instance default  int32 '__read_to'() cil managed
    {
      .maxstack 64
      ldarg.0        // self Ghul.INT_RANGE
      ldfld int32 valuetype 'Ghul'.'INT_RANGE'::'__backing_to'        // Semantic.Symbols.INSTANCE_FIELD __backing_to @ internal 1,1..1,1 type: Ghul.int
      ret
      .locals init (int32 '.default')
      ldloc '.default'
      ret
    }
    // // define Ghul.INT_RANGE.__assign_to(__value: Ghul.int) -> Ghul.void // method
    .method public final virtual hidebysig instance default  void '__assign_to'(int32 '__value') cil managed
    {
      .maxstack 64
      ldarg.0        // self Ghul.INT_RANGE
      ldarg '__value'        // Semantic.Symbols.LOCAL_ARGUMENT __value @ ../../../lib/dotnet/ghul/range.ghul 17,9..17,16 type: Ghul.int
      stfld int32 valuetype 'Ghul'.'INT_RANGE'::'__backing_to'        // Semantic.Symbols.INSTANCE_FIELD __backing_to @ internal 1,1..1,1 type: Ghul.int
      ret
    }
    
    // start IEnumerable boilerplate
    .method private final virtual hidebysig newslot 
           instance default class [mscorlib]System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator ()  cil managed 
    {
	.override class [mscorlib]System.Collections.IEnumerable::GetEnumerator
	.maxstack 8
	ldnull 
	ret 
    }
    // end IEnumerable boilerplate

    
    // start IEnumerator boilerplate
    .method private final virtual hidebysig newslot specialname instance default class [mscorlib]System.Object System.Collections.IEnumerator.get_Current ()  cil managed 
    {
    	.override class [mscorlib]System.Collections.IEnumerator::get_Current
	    .maxstack 8
	    ldnull 
	    ret 
    }

    .method public final virtual hidebysig newslot instance default void Reset ()  cil managed 
    {
        .maxstack 8
        ret 
    }

    .method public final virtual hidebysig newslot instance default void Dispose ()  cil managed 
    {
	    .maxstack 8
	    ret 
    }
    // end IEnumerator boilerplate

  }
}
.namespace 'Ghul' { // fixed
  // define struct Ghul.INT_RANGE_INCLUSIVE
  .class public sealed auto ansi beforefieldinit 'INT_RANGE_INCLUSIVE' extends [mscorlib]System.ValueType implements class 'Ghul'.Range`1<int32>, class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>, class [mscorlib]System.Collections.Generic.IEnumerator`1<int32>
  {
    // // define Ghul.INT_RANGE_INCLUSIVE.init(from: Ghul.int, to: Ghul.int) -> Ghul.void // method
    .method public hidebysig instance default  void '.ctor'(int32 'from',int32 'to') cil managed
    {
      .maxstack 64
      ldarg.0        // self Ghul.INT_RANGE_INCLUSIVE
      ldarg 'from'        // Semantic.Symbols.LOCAL_ARGUMENT from @ ../../../lib/dotnet/ghul/range.ghul 41,14..41,17 type: Ghul.int
      ldc.i4 1
      sub
      call instance void valuetype 'Ghul'.'INT_RANGE_INCLUSIVE'::'__assign_current'(int32)
      ldarg.0        // self Ghul.INT_RANGE_INCLUSIVE
      ldarg 'to'        // Semantic.Symbols.LOCAL_ARGUMENT to @ ../../../lib/dotnet/ghul/range.ghul 41,25..41,26 type: Ghul.int
      call instance void valuetype 'Ghul'.'INT_RANGE_INCLUSIVE'::'__assign_to'(int32)
      ret
    }
    // // define Ghul.INT_RANGE_INCLUSIVE.move_next() -> Ghul.bool // method
    .method public final virtual hidebysig instance default  bool MoveNext() cil managed
    {
      .maxstack 64
      ldarg.0        // self Ghul.INT_RANGE_INCLUSIVE
      ldarg.0        // self Ghul.INT_RANGE_INCLUSIVE
      call instance int32 valuetype 'Ghul'.'INT_RANGE_INCLUSIVE'::get_Current()
      ldc.i4 1
      add
      call instance void valuetype 'Ghul'.'INT_RANGE_INCLUSIVE'::'__assign_current'(int32)
      ldarg.0        // self Ghul.INT_RANGE_INCLUSIVE
      call instance int32 valuetype 'Ghul'.'INT_RANGE_INCLUSIVE'::get_Current()
      ldarg.0        // self Ghul.INT_RANGE_INCLUSIVE
      call instance int32 valuetype 'Ghul'.'INT_RANGE_INCLUSIVE'::'__read_to'()
      cgt        // <=
      ldc.i4 0
      ceq
      ret
      .locals init (bool '.default')
      ldloc '.default'
      ret
    }
    // // define Ghul.INT_RANGE_INCLUSIVE.__read_iterator() -> Collections.Iterator[Ghul.int] // method
    .method public final virtual hidebysig instance default  class [mscorlib]System.Collections.Generic.IEnumerator`1<int32> GetEnumerator() cil managed
    {
      .maxstack 64
      ldarg.0        // self Ghul.INT_RANGE_INCLUSIVE
      ldobj valuetype 'Ghul'.'INT_RANGE_INCLUSIVE'
      box valuetype 'Ghul'.'INT_RANGE_INCLUSIVE'
      ret
      .locals init (class [mscorlib]System.Collections.Generic.IEnumerator`1<int32> '.default')
      ldloc '.default'
      ret
    }
    // // define Ghul.INT_RANGE_INCLUSIVE.__read_from() -> Ghul.int // method
    .method public final virtual hidebysig instance default  int32 '__read_from'() cil managed
    {
      .maxstack 64
      ldarg.0        // self Ghul.INT_RANGE_INCLUSIVE
      call instance int32 valuetype 'Ghul'.'INT_RANGE_INCLUSIVE'::get_Current()
      ldc.i4 1
      add
      ret
      .locals init (int32 '.default')
      ldloc '.default'
      ret
    }
    .field public int32 '__backing_to'
    // // define Ghul.INT_RANGE_INCLUSIVE.__read_to() -> Ghul.int // method
    .method public final virtual hidebysig instance default  int32 '__read_to'() cil managed
    {
      .maxstack 64
      ldarg.0        // self Ghul.INT_RANGE_INCLUSIVE
      ldfld int32 valuetype 'Ghul'.'INT_RANGE_INCLUSIVE'::'__backing_to'        // Semantic.Symbols.INSTANCE_FIELD __backing_to @ internal 1,1..1,1 type: Ghul.int
      ret
      .locals init (int32 '.default')
      ldloc '.default'
      ret
    }
    // // define Ghul.INT_RANGE_INCLUSIVE.__assign_to(__value: Ghul.int) -> Ghul.void // method
    .method public final virtual hidebysig instance default  void '__assign_to'(int32 '__value') cil managed
    {
      .maxstack 64
      ldarg.0        // self Ghul.INT_RANGE_INCLUSIVE
      ldarg '__value'        // Semantic.Symbols.LOCAL_ARGUMENT __value @ ../../../lib/dotnet/ghul/range.ghul 36,9..36,16 type: Ghul.int
      stfld int32 valuetype 'Ghul'.'INT_RANGE_INCLUSIVE'::'__backing_to'        // Semantic.Symbols.INSTANCE_FIELD __backing_to @ internal 1,1..1,1 type: Ghul.int
      ret
    }
    .field public int32 '__backing_current'
    // // define Ghul.INT_RANGE_INCLUSIVE.__read_current() -> Ghul.int // method
    .method public final virtual hidebysig instance default  int32 get_Current() cil managed
    {
      .maxstack 64
      ldarg.0        // self Ghul.INT_RANGE_INCLUSIVE
      ldfld int32 valuetype 'Ghul'.'INT_RANGE_INCLUSIVE'::'__backing_current'        // Semantic.Symbols.INSTANCE_FIELD __backing_current @ internal 1,1..1,1 type: Ghul.int
      ret
      .locals init (int32 '.default')
      ldloc '.default'
      ret
    }
    // // define Ghul.INT_RANGE_INCLUSIVE.__assign_current(__value: Ghul.int) -> Ghul.void // method
    .method public final virtual hidebysig instance default  void '__assign_current'(int32 '__value') cil managed
    {
      .maxstack 64
      ldarg.0        // self Ghul.INT_RANGE_INCLUSIVE
      ldarg '__value'        // Semantic.Symbols.LOCAL_ARGUMENT __value @ ../../../lib/dotnet/ghul/range.ghul 39,9..39,21 type: Ghul.int
      stfld int32 valuetype 'Ghul'.'INT_RANGE_INCLUSIVE'::'__backing_current'        // Semantic.Symbols.INSTANCE_FIELD __backing_current @ internal 1,1..1,1 type: Ghul.int
      ret
    }
    
    // start IEnumerable boilerplate
    .method private final virtual hidebysig newslot 
           instance default class [mscorlib]System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator ()  cil managed 
    {
	.override class [mscorlib]System.Collections.IEnumerable::GetEnumerator
	.maxstack 8
	ldnull 
	ret 
    }
    // end IEnumerable boilerplate

    
    // start IEnumerator boilerplate
    .method private final virtual hidebysig newslot specialname instance default class [mscorlib]System.Object System.Collections.IEnumerator.get_Current ()  cil managed 
    {
    	.override class [mscorlib]System.Collections.IEnumerator::get_Current
	    .maxstack 8
	    ldnull 
	    ret 
    }

    .method public final virtual hidebysig newslot instance default void Reset ()  cil managed 
    {
        .maxstack 8
        ret 
    }

    .method public final virtual hidebysig newslot instance default void Dispose ()  cil managed 
    {
	    .maxstack 8
	    ret 
    }
    // end IEnumerator boilerplate

  }
}
.namespace 'Test' {
  // define class Test.Main
  .class public auto ansi beforefieldinit 'Main' extends [System.Runtime]'System'.'Object'
  {
    // // define Test.Main.entry() -> Ghul.void // class method
    .method public hidebysig static default  void 'entry'() cil managed
    {
      .maxstack 64
      .entrypoint
      .locals init (class 'Test'.GENERIC_CLASS`1<int32> 'gci.0')
      ldc.i4 5
      newarr int32
      dup
      ldc.i4 0
      ldc.i4 1
      stelem int32
      dup
      ldc.i4 1
      ldc.i4 2
      stelem int32
      dup
      ldc.i4 2
      ldc.i4 3
      stelem int32
      dup
      ldc.i4 3
      ldc.i4 4
      stelem int32
      dup
      ldc.i4 4
      ldc.i4 5
      stelem int32
      newobj instance void class 'Test'.GENERIC_CLASS`1<int32>::'.ctor'(class [mscorlib]System.Collections.Generic.IEnumerable`1<!0>)        // Test.GENERIC_CLASS[Ghul.int]
      stloc 'gci.0'        // Semantic.Symbols.LOCAL_VARIABLE gci @ test.ghul 20,17..20,19 type: Test.GENERIC_CLASS[Ghul.int]
      .locals init (valuetype 'Test'.GENERIC_STRUCT`1<int32> 'gsi.1')
      ldc.i4 5
      newarr int32
      dup
      ldc.i4 0
      ldc.i4 5
      stelem int32
      dup
      ldc.i4 1
      ldc.i4 4
      stelem int32
      dup
      ldc.i4 2
      ldc.i4 3
      stelem int32
      dup
      ldc.i4 3
      ldc.i4 2
      stelem int32
      dup
      ldc.i4 4
      ldc.i4 1
      stelem int32
      newobj instance void valuetype 'Test'.GENERIC_STRUCT`1<int32>::'.ctor'(class [mscorlib]System.Collections.Generic.IEnumerable`1<!0>)        // Test.GENERIC_STRUCT[Ghul.int]
      stloc 'gsi.1'        // Semantic.Symbols.LOCAL_VARIABLE gsi @ test.ghul 21,17..21,19 type: Test.GENERIC_STRUCT[Ghul.int]
      .locals init (class 'Test'.'INT_CLASS' 'ic.2')
      ldc.i4 5
      newarr int32
      dup
      ldc.i4 0
      ldc.i4 1
      stelem int32
      dup
      ldc.i4 1
      ldc.i4 2
      stelem int32
      dup
      ldc.i4 2
      ldc.i4 3
      stelem int32
      dup
      ldc.i4 3
      ldc.i4 4
      stelem int32
      dup
      ldc.i4 4
      ldc.i4 5
      stelem int32
      newobj instance void class 'Test'.'INT_CLASS'::'.ctor'(class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>)        // Test.INT_CLASS
      stloc 'ic.2'        // Semantic.Symbols.LOCAL_VARIABLE ic @ test.ghul 22,17..22,18 type: Test.INT_CLASS
      .locals init (valuetype 'Test'.'INT_STRUCT' 'is_.3')
      ldc.i4 5
      newarr int32
      dup
      ldc.i4 0
      ldc.i4 1
      stelem int32
      dup
      ldc.i4 1
      ldc.i4 2
      stelem int32
      dup
      ldc.i4 2
      ldc.i4 3
      stelem int32
      dup
      ldc.i4 3
      ldc.i4 4
      stelem int32
      dup
      ldc.i4 4
      ldc.i4 5
      stelem int32
      newobj instance void valuetype 'Test'.'INT_STRUCT'::'.ctor'(class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>)        // Test.INT_STRUCT
      stloc 'is_.3'        // Semantic.Symbols.LOCAL_VARIABLE is_ @ test.ghul 23,17..23,19 type: Test.INT_STRUCT
      .locals init (class 'Test'.GENERIC_CLASS`1<class [System.Runtime]'System'.'String'> 'gcs.4')
      ldc.i4 5
      newarr class [System.Runtime]'System'.'String'
      dup
      ldc.i4 0
      ldstr bytearray (6F 00 6E 00 65 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 1
      ldstr bytearray (74 00 77 00 6F 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 2
      ldstr bytearray (74 00 68 00 72 00 65 00 65 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 3
      ldstr bytearray (66 00 6F 00 75 00 72 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 4
      ldstr bytearray (66 00 69 00 76 00 65 00 )
      stelem class [System.Runtime]'System'.'String'
      newobj instance void class 'Test'.GENERIC_CLASS`1<class [System.Runtime]'System'.'String'>::'.ctor'(class [mscorlib]System.Collections.Generic.IEnumerable`1<!0>)        // Test.GENERIC_CLASS[System.String]
      stloc 'gcs.4'        // Semantic.Symbols.LOCAL_VARIABLE gcs @ test.ghul 25,17..25,19 type: Test.GENERIC_CLASS[System.String]
      .locals init (valuetype 'Test'.GENERIC_STRUCT`1<class [System.Runtime]'System'.'String'> 'gss.5')
      ldc.i4 5
      newarr class [System.Runtime]'System'.'String'
      dup
      ldc.i4 0
      ldstr bytearray (6F 00 6E 00 65 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 1
      ldstr bytearray (74 00 77 00 6F 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 2
      ldstr bytearray (74 00 68 00 72 00 65 00 65 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 3
      ldstr bytearray (66 00 6F 00 75 00 72 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 4
      ldstr bytearray (66 00 69 00 76 00 65 00 )
      stelem class [System.Runtime]'System'.'String'
      newobj instance void valuetype 'Test'.GENERIC_STRUCT`1<class [System.Runtime]'System'.'String'>::'.ctor'(class [mscorlib]System.Collections.Generic.IEnumerable`1<!0>)        // Test.GENERIC_STRUCT[System.String]
      stloc 'gss.5'        // Semantic.Symbols.LOCAL_VARIABLE gss @ test.ghul 26,17..26,19 type: Test.GENERIC_STRUCT[System.String]
      .locals init (class 'Test'.'STRING_CLASS' 'sc.6')
      ldc.i4 5
      newarr class [System.Runtime]'System'.'String'
      dup
      ldc.i4 0
      ldstr bytearray (6F 00 6E 00 65 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 1
      ldstr bytearray (74 00 77 00 6F 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 2
      ldstr bytearray (74 00 68 00 72 00 65 00 65 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 3
      ldstr bytearray (66 00 6F 00 75 00 72 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 4
      ldstr bytearray (66 00 69 00 76 00 65 00 )
      stelem class [System.Runtime]'System'.'String'
      newobj instance void class 'Test'.'STRING_CLASS'::'.ctor'(class [mscorlib]System.Collections.Generic.IEnumerable`1<class [System.Runtime]'System'.'String'>)        // Test.STRING_CLASS
      stloc 'sc.6'        // Semantic.Symbols.LOCAL_VARIABLE sc @ test.ghul 27,17..27,18 type: Test.STRING_CLASS
      .locals init (valuetype 'Test'.'STRING_STRUCT' 'ss.7')
      ldc.i4 5
      newarr class [System.Runtime]'System'.'String'
      dup
      ldc.i4 0
      ldstr bytearray (6F 00 6E 00 65 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 1
      ldstr bytearray (74 00 77 00 6F 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 2
      ldstr bytearray (74 00 68 00 72 00 65 00 65 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 3
      ldstr bytearray (66 00 6F 00 75 00 72 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 4
      ldstr bytearray (66 00 69 00 76 00 65 00 )
      stelem class [System.Runtime]'System'.'String'
      newobj instance void valuetype 'Test'.'STRING_STRUCT'::'.ctor'(class [mscorlib]System.Collections.Generic.IEnumerable`1<class [System.Runtime]'System'.'String'>)        // Test.STRING_STRUCT
      stloc 'ss.7'        // Semantic.Symbols.LOCAL_VARIABLE ss @ test.ghul 28,17..28,18 type: Test.STRING_STRUCT
      ldstr bytearray (67 00 65 00 6E 00 65 00 72 00 69 00 63 00 20 00 69 00 6E 00 74 00 65 00 67 00 65 00 72 00 20 00 63 00 6C 00 61 00 73 00 73 00 )
      ldloc 'gci.0'        // Semantic.Symbols.LOCAL_VARIABLE gci @ test.ghul 20,17..20,19 type: Test.GENERIC_CLASS[Ghul.int]
      ldc.i4 5
      newarr int32
      dup
      ldc.i4 0
      ldc.i4 1
      stelem int32
      dup
      ldc.i4 1
      ldc.i4 2
      stelem int32
      dup
      ldc.i4 2
      ldc.i4 3
      stelem int32
      dup
      ldc.i4 3
      ldc.i4 4
      stelem int32
      dup
      ldc.i4 4
      ldc.i4 5
      stelem int32
      call void class 'Test'.'Main'::'check'(class [System.Runtime]'System'.'String',class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>,class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>)
      ldstr bytearray (67 00 65 00 6E 00 65 00 72 00 69 00 63 00 20 00 69 00 6E 00 74 00 65 00 67 00 65 00 72 00 20 00 73 00 74 00 72 00 75 00 63 00 74 00 )
      ldloc 'gsi.1'        // Semantic.Symbols.LOCAL_VARIABLE gsi @ test.ghul 21,17..21,19 type: Test.GENERIC_STRUCT[Ghul.int]
      box valuetype 'Test'.GENERIC_STRUCT`1<int32>
      ldc.i4 5
      newarr int32
      dup
      ldc.i4 0
      ldc.i4 5
      stelem int32
      dup
      ldc.i4 1
      ldc.i4 4
      stelem int32
      dup
      ldc.i4 2
      ldc.i4 3
      stelem int32
      dup
      ldc.i4 3
      ldc.i4 2
      stelem int32
      dup
      ldc.i4 4
      ldc.i4 1
      stelem int32
      call void class 'Test'.'Main'::'check'(class [System.Runtime]'System'.'String',class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>,class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>)
      ldstr bytearray (69 00 6E 00 74 00 65 00 67 00 65 00 72 00 20 00 63 00 6C 00 61 00 73 00 73 00 )
      ldloc 'ic.2'        // Semantic.Symbols.LOCAL_VARIABLE ic @ test.ghul 22,17..22,18 type: Test.INT_CLASS
      ldc.i4 5
      newarr int32
      dup
      ldc.i4 0
      ldc.i4 1
      stelem int32
      dup
      ldc.i4 1
      ldc.i4 2
      stelem int32
      dup
      ldc.i4 2
      ldc.i4 3
      stelem int32
      dup
      ldc.i4 3
      ldc.i4 4
      stelem int32
      dup
      ldc.i4 4
      ldc.i4 5
      stelem int32
      call void class 'Test'.'Main'::'check'(class [System.Runtime]'System'.'String',class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>,class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>)
      ldstr bytearray (69 00 6E 00 74 00 65 00 67 00 65 00 72 00 20 00 73 00 74 00 72 00 75 00 63 00 74 00 )
      ldloc 'is_.3'        // Semantic.Symbols.LOCAL_VARIABLE is_ @ test.ghul 23,17..23,19 type: Test.INT_STRUCT
      box valuetype 'Test'.'INT_STRUCT'
      ldc.i4 5
      newarr int32
      dup
      ldc.i4 0
      ldc.i4 1
      stelem int32
      dup
      ldc.i4 1
      ldc.i4 2
      stelem int32
      dup
      ldc.i4 2
      ldc.i4 3
      stelem int32
      dup
      ldc.i4 3
      ldc.i4 4
      stelem int32
      dup
      ldc.i4 4
      ldc.i4 5
      stelem int32
      call void class 'Test'.'Main'::'check'(class [System.Runtime]'System'.'String',class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>,class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>)
      ldstr bytearray (67 00 65 00 6E 00 65 00 72 00 69 00 63 00 20 00 73 00 74 00 72 00 69 00 6E 00 67 00 20 00 63 00 6C 00 61 00 73 00 73 00 )
      ldloc 'gcs.4'        // Semantic.Symbols.LOCAL_VARIABLE gcs @ test.ghul 25,17..25,19 type: Test.GENERIC_CLASS[System.String]
      ldc.i4 5
      newarr class [System.Runtime]'System'.'String'
      dup
      ldc.i4 0
      ldstr bytearray (6F 00 6E 00 65 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 1
      ldstr bytearray (74 00 77 00 6F 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 2
      ldstr bytearray (74 00 68 00 72 00 65 00 65 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 3
      ldstr bytearray (66 00 6F 00 75 00 72 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 4
      ldstr bytearray (66 00 69 00 76 00 65 00 )
      stelem class [System.Runtime]'System'.'String'
      call void class 'Test'.'Main'::'check'(class [System.Runtime]'System'.'String',class [mscorlib]System.Collections.Generic.IEnumerable`1<class [System.Runtime]'System'.'String'>,class [mscorlib]System.Collections.Generic.IEnumerable`1<class [System.Runtime]'System'.'String'>)
      ldstr bytearray (67 00 65 00 6E 00 65 00 72 00 69 00 63 00 20 00 73 00 74 00 72 00 69 00 6E 00 67 00 20 00 73 00 74 00 72 00 75 00 63 00 74 00 )
      ldloc 'gss.5'        // Semantic.Symbols.LOCAL_VARIABLE gss @ test.ghul 26,17..26,19 type: Test.GENERIC_STRUCT[System.String]
      box valuetype 'Test'.GENERIC_STRUCT`1<class [System.Runtime]'System'.'String'>
      ldc.i4 5
      newarr class [System.Runtime]'System'.'String'
      dup
      ldc.i4 0
      ldstr bytearray (6F 00 6E 00 65 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 1
      ldstr bytearray (74 00 77 00 6F 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 2
      ldstr bytearray (74 00 68 00 72 00 65 00 65 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 3
      ldstr bytearray (66 00 6F 00 75 00 72 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 4
      ldstr bytearray (66 00 69 00 76 00 65 00 )
      stelem class [System.Runtime]'System'.'String'
      call void class 'Test'.'Main'::'check'(class [System.Runtime]'System'.'String',class [mscorlib]System.Collections.Generic.IEnumerable`1<class [System.Runtime]'System'.'String'>,class [mscorlib]System.Collections.Generic.IEnumerable`1<class [System.Runtime]'System'.'String'>)
      ldstr bytearray (73 00 74 00 72 00 69 00 6E 00 67 00 20 00 63 00 6C 00 61 00 73 00 73 00 )
      ldloc 'sc.6'        // Semantic.Symbols.LOCAL_VARIABLE sc @ test.ghul 27,17..27,18 type: Test.STRING_CLASS
      ldc.i4 5
      newarr class [System.Runtime]'System'.'String'
      dup
      ldc.i4 0
      ldstr bytearray (6F 00 6E 00 65 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 1
      ldstr bytearray (74 00 77 00 6F 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 2
      ldstr bytearray (74 00 68 00 72 00 65 00 65 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 3
      ldstr bytearray (66 00 6F 00 75 00 72 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 4
      ldstr bytearray (66 00 69 00 76 00 65 00 )
      stelem class [System.Runtime]'System'.'String'
      call void class 'Test'.'Main'::'check'(class [System.Runtime]'System'.'String',class [mscorlib]System.Collections.Generic.IEnumerable`1<class [System.Runtime]'System'.'String'>,class [mscorlib]System.Collections.Generic.IEnumerable`1<class [System.Runtime]'System'.'String'>)
      ldstr bytearray (73 00 74 00 72 00 69 00 6E 00 67 00 20 00 73 00 74 00 72 00 75 00 63 00 74 00 )
      ldloc 'ss.7'        // Semantic.Symbols.LOCAL_VARIABLE ss @ test.ghul 28,17..28,18 type: Test.STRING_STRUCT
      box valuetype 'Test'.'STRING_STRUCT'
      ldc.i4 5
      newarr class [System.Runtime]'System'.'String'
      dup
      ldc.i4 0
      ldstr bytearray (6F 00 6E 00 65 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 1
      ldstr bytearray (74 00 77 00 6F 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 2
      ldstr bytearray (74 00 68 00 72 00 65 00 65 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 3
      ldstr bytearray (66 00 6F 00 75 00 72 00 )
      stelem class [System.Runtime]'System'.'String'
      dup
      ldc.i4 4
      ldstr bytearray (66 00 69 00 76 00 65 00 )
      stelem class [System.Runtime]'System'.'String'
      call void class 'Test'.'Main'::'check'(class [System.Runtime]'System'.'String',class [mscorlib]System.Collections.Generic.IEnumerable`1<class [System.Runtime]'System'.'String'>,class [mscorlib]System.Collections.Generic.IEnumerable`1<class [System.Runtime]'System'.'String'>)
      ret
    }
    // // define Test.Main.check(scenario: System.String, values: Collections.Iterable[Ghul.int], expected: Collections.Iterable[Ghul.int]) -> Ghul.void // class method
    .method public hidebysig static default  void 'check'(class [System.Runtime]'System'.'String' 'scenario',class [mscorlib]System.Collections.Generic.IEnumerable`1<int32> 'values',class [mscorlib]System.Collections.Generic.IEnumerable`1<int32> 'expected') cil managed
    {
      .maxstack 64
      call class [mscorlib]System.IO.TextWriter class [System.Console]System.Console::get_Out()
      ldarg 'scenario'        // Semantic.Symbols.LOCAL_ARGUMENT scenario @ test.ghul 41,15..41,22 type: System.String
      callvirt instance void class [mscorlib]System.IO.TextWriter::WriteLine(class [System.Runtime]'System'.'String')        // System.IO2.TextWriter.write_line(value: String) -> Ghul.void
      .locals init (class [mscorlib]System.Collections.Generic.IEnumerator`1<int32> 'i.0')
      ldarg 'expected'        // Semantic.Symbols.LOCAL_ARGUMENT expected @ test.ghul 41,56..41,63 type: Collections.Iterable[Ghul.int]
      callvirt instance class [mscorlib]System.Collections.Generic.IEnumerator`1<!0> class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>::GetEnumerator()        // Collections.Iterable[Ghul.int].iterator: Collections.Iterator[Ghul.int]
      stloc 'i.0'        // Semantic.Symbols.LOCAL_VARIABLE i @ test.ghul 43,17..43,17 type: Collections.Iterator[Ghul.int]
      .locals init (int32 'v.1')
      .locals init (class [mscorlib]System.Collections.Generic.IEnumerator`1<int32> '.temp.0')
      ldarg 'values'        // Semantic.Symbols.LOCAL_ARGUMENT values @ test.ghul 41,33..41,38 type: Collections.Iterable[Ghul.int]
      callvirt instance class [mscorlib]System.Collections.Generic.IEnumerator`1<!0> class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>::GetEnumerator()        // Collections.Iterable[Ghul.int].iterator: Collections.Iterator[Ghul.int]
      stloc '.temp.0'
      L_0:
      ldloc '.temp.0'        // temp Collections.Iterator[Ghul.int]
      callvirt instance bool class [mscorlib]System.Collections.IEnumerator::MoveNext()        // Collections.MoveNext.move_next() -> Ghul.bool
      brfalse L_1
      ldloc '.temp.0'        // temp Collections.Iterator[Ghul.int]
      callvirt instance !0 class [mscorlib]System.Collections.Generic.IEnumerator`1<int32>::get_Current()        // Collections.Iterator[Ghul.int].current: Ghul.int
      stloc 'v.1'        // Semantic.Symbols.LOCAL_VARIABLE v @ test.ghul 45,17..45,17 type: Ghul.int
      ldloc 'i.0'        // Semantic.Symbols.LOCAL_VARIABLE i @ test.ghul 43,17..43,17 type: Collections.Iterator[Ghul.int]
      callvirt instance bool class [mscorlib]System.Collections.IEnumerator::MoveNext()        // Collections.MoveNext.move_next() -> Ghul.bool
      pop
      call class [mscorlib]System.IO.TextWriter class [System.Console]System.Console::get_Out()
      ldstr bytearray (68 00 61 00 76 00 65 00 20 00 69 00 6E 00 74 00 3A 00 20 00 )
      ldloc 'v.1'        // Semantic.Symbols.LOCAL_VARIABLE v @ test.ghul 45,17..45,17 type: Ghul.int
      box int32
      call string string::Concat(object,object)
      ldstr bytearray (20 00 65 00 78 00 70 00 65 00 63 00 74 00 65 00 64 00 3A 00 20 00 )
      call string string::Concat(object,object)
      ldloc 'i.0'        // Semantic.Symbols.LOCAL_VARIABLE i @ test.ghul 43,17..43,17 type: Collections.Iterator[Ghul.int]
      callvirt instance !0 class [mscorlib]System.Collections.Generic.IEnumerator`1<int32>::get_Current()        // Collections.Iterator[Ghul.int].current: Ghul.int
      box int32
      call string string::Concat(object,object)
      callvirt instance void class [mscorlib]System.IO.TextWriter::WriteLine(class [System.Runtime]'System'.'String')        // System.IO2.TextWriter.write_line(value: String) -> Ghul.void
      br L_0
      L_1:
      call class [mscorlib]System.IO.TextWriter class [System.Console]System.Console::get_Out()
      callvirt instance void class [mscorlib]System.IO.TextWriter::WriteLine()        // System.IO2.TextWriter.write_line() -> Ghul.void
      ret
    }
    // // define Test.Main.check(scenario: System.String, values: Collections.Iterable[System.String], expected: Collections.Iterable[System.String]) -> Ghul.void // class method
    .method public hidebysig static default  void 'check'(class [System.Runtime]'System'.'String' 'scenario',class [mscorlib]System.Collections.Generic.IEnumerable`1<class [System.Runtime]'System'.'String'> 'values',class [mscorlib]System.Collections.Generic.IEnumerable`1<class [System.Runtime]'System'.'String'> 'expected') cil managed
    {
      .maxstack 64
      call class [mscorlib]System.IO.TextWriter class [System.Console]System.Console::get_Out()
      ldarg 'scenario'        // Semantic.Symbols.LOCAL_ARGUMENT scenario @ test.ghul 53,15..53,22 type: System.String
      callvirt instance void class [mscorlib]System.IO.TextWriter::WriteLine(class [System.Runtime]'System'.'String')        // System.IO2.TextWriter.write_line(value: String) -> Ghul.void
      .locals init (class [mscorlib]System.Collections.Generic.IEnumerator`1<class [System.Runtime]'System'.'String'> 'i.0')
      ldarg 'expected'        // Semantic.Symbols.LOCAL_ARGUMENT expected @ test.ghul 53,59..53,66 type: Collections.Iterable[System.String]
      callvirt instance class [mscorlib]System.Collections.Generic.IEnumerator`1<!0> class [mscorlib]System.Collections.Generic.IEnumerable`1<class [System.Runtime]'System'.'String'>::GetEnumerator()        // Collections.Iterable[System.String].iterator: Collections.Iterator[System.String]
      stloc 'i.0'        // Semantic.Symbols.LOCAL_VARIABLE i @ test.ghul 55,17..55,17 type: Collections.Iterator[System.String]
      .locals init (class [System.Runtime]'System'.'String' 'v.1')
      .locals init (class [mscorlib]System.Collections.Generic.IEnumerator`1<class [System.Runtime]'System'.'String'> '.temp.1')
      ldarg 'values'        // Semantic.Symbols.LOCAL_ARGUMENT values @ test.ghul 53,33..53,38 type: Collections.Iterable[System.String]
      callvirt instance class [mscorlib]System.Collections.Generic.IEnumerator`1<!0> class [mscorlib]System.Collections.Generic.IEnumerable`1<class [System.Runtime]'System'.'String'>::GetEnumerator()        // Collections.Iterable[System.String].iterator: Collections.Iterator[System.String]
      stloc '.temp.1'
      L_2:
      ldloc '.temp.1'        // temp Collections.Iterator[System.String]
      callvirt instance bool class [mscorlib]System.Collections.IEnumerator::MoveNext()        // Collections.MoveNext.move_next() -> Ghul.bool
      brfalse L_3
      ldloc '.temp.1'        // temp Collections.Iterator[System.String]
      callvirt instance !0 class [mscorlib]System.Collections.Generic.IEnumerator`1<class [System.Runtime]'System'.'String'>::get_Current()        // Collections.Iterator[System.String].current: System.String
      stloc 'v.1'        // Semantic.Symbols.LOCAL_VARIABLE v @ test.ghul 57,17..57,17 type: System.String
      ldloc 'i.0'        // Semantic.Symbols.LOCAL_VARIABLE i @ test.ghul 55,17..55,17 type: Collections.Iterator[System.String]
      callvirt instance bool class [mscorlib]System.Collections.IEnumerator::MoveNext()        // Collections.MoveNext.move_next() -> Ghul.bool
      pop
      call class [mscorlib]System.IO.TextWriter class [System.Console]System.Console::get_Out()
      ldstr bytearray (68 00 61 00 76 00 65 00 20 00 73 00 74 00 72 00 69 00 6E 00 67 00 3A 00 20 00 )
      ldloc 'v.1'        // Semantic.Symbols.LOCAL_VARIABLE v @ test.ghul 57,17..57,17 type: System.String
      call string string::Concat(object,object)
      ldstr bytearray (20 00 65 00 78 00 70 00 65 00 63 00 74 00 65 00 64 00 3A 00 20 00 )
      call string string::Concat(object,object)
      ldloc 'i.0'        // Semantic.Symbols.LOCAL_VARIABLE i @ test.ghul 55,17..55,17 type: Collections.Iterator[System.String]
      callvirt instance !0 class [mscorlib]System.Collections.Generic.IEnumerator`1<class [System.Runtime]'System'.'String'>::get_Current()        // Collections.Iterator[System.String].current: System.String
      call string string::Concat(object,object)
      callvirt instance void class [mscorlib]System.IO.TextWriter::WriteLine(class [System.Runtime]'System'.'String')        // System.IO2.TextWriter.write_line(value: String) -> Ghul.void
      br L_2
      L_3:
      call class [mscorlib]System.IO.TextWriter class [System.Console]System.Console::get_Out()
      callvirt instance void class [mscorlib]System.IO.TextWriter::WriteLine()        // System.IO2.TextWriter.write_line() -> Ghul.void
      ret
    }
  }
}
.namespace 'Test' {
  // define class Test.GENERIC_CLASS
  .class public auto ansi beforefieldinit GENERIC_CLASS`1<T> extends [System.Runtime]'System'.'Object' implements class [mscorlib]System.Collections.Generic.IEnumerable`1<!0>
  {
    .field public class [mscorlib]System.Collections.Generic.IEnumerable`1<!0> '_values'
    // // define Test.GENERIC_CLASS.init(values: Collections.Iterable[Test.GENERIC_CLASS.T]) -> Ghul.void // method
    .method public hidebysig instance default  void '.ctor'(class [mscorlib]System.Collections.Generic.IEnumerable`1<!0> 'values') cil managed
    {
      .maxstack 64
      ldarg.0        // self Test.GENERIC_CLASS
      ldarg 'values'        // Semantic.Symbols.LOCAL_ARGUMENT values @ test.ghul 68,14..68,19 type: Collections.Iterable[Test.GENERIC_CLASS.T]
      stfld class [mscorlib]System.Collections.Generic.IEnumerable`1<!0> class 'Test'.'GENERIC_CLASS`1'<!0>::'_values'        // Semantic.Symbols.INSTANCE_FIELD _values @ test.ghul 67,9..67,15 type: Collections.Iterable[Test.GENERIC_CLASS.T]
      ret
    }
    // // define Test.GENERIC_CLASS.__read_iterator() -> Collections.Iterator[Test.GENERIC_CLASS.T] // method
    .method public virtual hidebysig instance default  class [mscorlib]System.Collections.Generic.IEnumerator`1<!0> GetEnumerator() cil managed
    {
      .maxstack 64
      ldarg.0        // self Test.GENERIC_CLASS
      ldfld class [mscorlib]System.Collections.Generic.IEnumerable`1<!0> class 'Test'.'GENERIC_CLASS`1'<!0>::'_values'        // Semantic.Symbols.INSTANCE_FIELD _values @ test.ghul 67,9..67,15 type: Collections.Iterable[Test.GENERIC_CLASS.T]
      newobj instance void class [mscorlib]System.Collections.Generic.List`1<!0>::.ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<!0>)        // Collections.LIST[Test.GENERIC_CLASS.T]
      callvirt instance valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<!0> class [mscorlib]System.Collections.Generic.List`1<!0>::GetEnumerator()        // Collections.LIST[Test.GENERIC_CLASS.T].iterator: Collections.LIST_ITERATOR[Test.GENERIC_CLASS.T]
      box valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<!0>
      ret
      .locals init (class [mscorlib]System.Collections.Generic.IEnumerator`1<!0> '.default')
      ldloc '.default'
      ret
    }
    
    // start IEnumerable boilerplate
    .method private final virtual hidebysig newslot 
           instance default class [mscorlib]System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator ()  cil managed 
    {
	.override class [mscorlib]System.Collections.IEnumerable::GetEnumerator
	.maxstack 8
	ldnull 
	ret 
    }
    // end IEnumerable boilerplate

  }
}
.namespace 'Test' { // fixed
  // define struct Test.GENERIC_STRUCT
  .class public sealed auto ansi beforefieldinit GENERIC_STRUCT`1<T> extends [mscorlib]System.ValueType implements class [mscorlib]System.Collections.Generic.IEnumerable`1<!0>
  {
    .field public class [mscorlib]System.Collections.Generic.IEnumerable`1<!0> '_values'
    // // define Test.GENERIC_STRUCT.init(values: Collections.Iterable[Test.GENERIC_STRUCT.T]) -> Ghul.void // method
    .method public hidebysig instance default  void '.ctor'(class [mscorlib]System.Collections.Generic.IEnumerable`1<!0> 'values') cil managed
    {
      .maxstack 64
      ldarg.0        // self Test.GENERIC_STRUCT
      ldarg 'values'        // Semantic.Symbols.LOCAL_ARGUMENT values @ test.ghul 78,14..78,19 type: Collections.Iterable[Test.GENERIC_STRUCT.T]
      stfld class [mscorlib]System.Collections.Generic.IEnumerable`1<!0> valuetype 'Test'.'GENERIC_STRUCT`1'<!0>::'_values'        // Semantic.Symbols.INSTANCE_FIELD _values @ test.ghul 77,9..77,15 type: Collections.Iterable[Test.GENERIC_STRUCT.T]
      ret
    }
    // // define Test.GENERIC_STRUCT.__read_iterator() -> Collections.Iterator[Test.GENERIC_STRUCT.T] // method
    .method public final virtual hidebysig instance default  class [mscorlib]System.Collections.Generic.IEnumerator`1<!0> GetEnumerator() cil managed
    {
      .maxstack 64
      ldarg.0        // self Test.GENERIC_STRUCT
      ldfld class [mscorlib]System.Collections.Generic.IEnumerable`1<!0> valuetype 'Test'.'GENERIC_STRUCT`1'<!0>::'_values'        // Semantic.Symbols.INSTANCE_FIELD _values @ test.ghul 77,9..77,15 type: Collections.Iterable[Test.GENERIC_STRUCT.T]
      newobj instance void class [mscorlib]System.Collections.Generic.List`1<!0>::.ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<!0>)        // Collections.LIST[Test.GENERIC_STRUCT.T]
      callvirt instance valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<!0> class [mscorlib]System.Collections.Generic.List`1<!0>::GetEnumerator()        // Collections.LIST[Test.GENERIC_STRUCT.T].iterator: Collections.LIST_ITERATOR[Test.GENERIC_STRUCT.T]
      box valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<!0>
      ret
      .locals init (class [mscorlib]System.Collections.Generic.IEnumerator`1<!0> '.default')
      ldloc '.default'
      ret
    }
    
    // start IEnumerable boilerplate
    .method private final virtual hidebysig newslot 
           instance default class [mscorlib]System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator ()  cil managed 
    {
	.override class [mscorlib]System.Collections.IEnumerable::GetEnumerator
	.maxstack 8
	ldnull 
	ret 
    }
    // end IEnumerable boilerplate

  }
}
.namespace 'Test' {
  // define class Test.INT_CLASS
  .class public auto ansi beforefieldinit 'INT_CLASS' extends [System.Runtime]'System'.'Object' implements class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>
  {
    .field public class [mscorlib]System.Collections.Generic.IEnumerable`1<int32> '_values'
    // // define Test.INT_CLASS.init(values: Collections.Iterable[Ghul.int]) -> Ghul.void // method
    .method public hidebysig instance default  void '.ctor'(class [mscorlib]System.Collections.Generic.IEnumerable`1<int32> 'values') cil managed
    {
      .maxstack 64
      ldarg.0        // self Test.INT_CLASS
      ldarg 'values'        // Semantic.Symbols.LOCAL_ARGUMENT values @ test.ghul 88,14..88,19 type: Collections.Iterable[Ghul.int]
      stfld class [mscorlib]System.Collections.Generic.IEnumerable`1<int32> class 'Test'.'INT_CLASS'::'_values'        // Semantic.Symbols.INSTANCE_FIELD _values @ test.ghul 87,9..87,15 type: Collections.Iterable[Ghul.int]
      ret
    }
    // // define Test.INT_CLASS.__read_iterator() -> Collections.Iterator[Ghul.int] // method
    .method public virtual hidebysig instance default  class [mscorlib]System.Collections.Generic.IEnumerator`1<int32> GetEnumerator() cil managed
    {
      .maxstack 64
      ldarg.0        // self Test.INT_CLASS
      ldfld class [mscorlib]System.Collections.Generic.IEnumerable`1<int32> class 'Test'.'INT_CLASS'::'_values'        // Semantic.Symbols.INSTANCE_FIELD _values @ test.ghul 87,9..87,15 type: Collections.Iterable[Ghul.int]
      newobj instance void class [mscorlib]System.Collections.Generic.List`1<int32>::.ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<!0>)        // Collections.LIST[Ghul.int]
      callvirt instance valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<!0> class [mscorlib]System.Collections.Generic.List`1<int32>::GetEnumerator()        // Collections.LIST[Ghul.int].iterator: Collections.LIST_ITERATOR[Ghul.int]
      box valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<int32>
      ret
      .locals init (class [mscorlib]System.Collections.Generic.IEnumerator`1<int32> '.default')
      ldloc '.default'
      ret
    }
    
    // start IEnumerable boilerplate
    .method private final virtual hidebysig newslot 
           instance default class [mscorlib]System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator ()  cil managed 
    {
	.override class [mscorlib]System.Collections.IEnumerable::GetEnumerator
	.maxstack 8
	ldnull 
	ret 
    }
    // end IEnumerable boilerplate

  }
}
.namespace 'Test' {
  // define class Test.STRING_CLASS
  .class public auto ansi beforefieldinit 'STRING_CLASS' extends [System.Runtime]'System'.'Object' implements class [mscorlib]System.Collections.Generic.IEnumerable`1<class [System.Runtime]'System'.'String'>
  {
    .field public class [mscorlib]System.Collections.Generic.IEnumerable`1<class [System.Runtime]'System'.'String'> '_values'
    // // define Test.STRING_CLASS.init(values: Collections.Iterable[System.String]) -> Ghul.void // method
    .method public hidebysig instance default  void '.ctor'(class [mscorlib]System.Collections.Generic.IEnumerable`1<class [System.Runtime]'System'.'String'> 'values') cil managed
    {
      .maxstack 64
      ldarg.0        // self Test.STRING_CLASS
      ldarg 'values'        // Semantic.Symbols.LOCAL_ARGUMENT values @ test.ghul 98,14..98,19 type: Collections.Iterable[System.String]
      stfld class [mscorlib]System.Collections.Generic.IEnumerable`1<class [System.Runtime]'System'.'String'> class 'Test'.'STRING_CLASS'::'_values'        // Semantic.Symbols.INSTANCE_FIELD _values @ test.ghul 97,9..97,15 type: Collections.Iterable[System.String]
      ret
    }
    // // define Test.STRING_CLASS.__read_iterator() -> Collections.Iterator[System.String] // method
    .method public virtual hidebysig instance default  class [mscorlib]System.Collections.Generic.IEnumerator`1<class [System.Runtime]'System'.'String'> GetEnumerator() cil managed
    {
      .maxstack 64
      ldarg.0        // self Test.STRING_CLASS
      ldfld class [mscorlib]System.Collections.Generic.IEnumerable`1<class [System.Runtime]'System'.'String'> class 'Test'.'STRING_CLASS'::'_values'        // Semantic.Symbols.INSTANCE_FIELD _values @ test.ghul 97,9..97,15 type: Collections.Iterable[System.String]
      newobj instance void class [mscorlib]System.Collections.Generic.List`1<class [System.Runtime]'System'.'String'>::.ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<!0>)        // Collections.LIST[System.String]
      callvirt instance valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<!0> class [mscorlib]System.Collections.Generic.List`1<class [System.Runtime]'System'.'String'>::GetEnumerator()        // Collections.LIST[System.String].iterator: Collections.LIST_ITERATOR[System.String]
      box valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<class [System.Runtime]'System'.'String'>
      ret
      .locals init (class [mscorlib]System.Collections.Generic.IEnumerator`1<class [System.Runtime]'System'.'String'> '.default')
      ldloc '.default'
      ret
    }
    
    // start IEnumerable boilerplate
    .method private final virtual hidebysig newslot 
           instance default class [mscorlib]System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator ()  cil managed 
    {
	.override class [mscorlib]System.Collections.IEnumerable::GetEnumerator
	.maxstack 8
	ldnull 
	ret 
    }
    // end IEnumerable boilerplate

  }
}
.namespace 'Test' { // fixed
  // define struct Test.INT_STRUCT
  .class public sealed auto ansi beforefieldinit 'INT_STRUCT' extends [mscorlib]System.ValueType implements class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>
  {
    .field public class [mscorlib]System.Collections.Generic.IEnumerable`1<int32> '_values'
    // // define Test.INT_STRUCT.init(values: Collections.Iterable[Ghul.int]) -> Ghul.void // method
    .method public hidebysig instance default  void '.ctor'(class [mscorlib]System.Collections.Generic.IEnumerable`1<int32> 'values') cil managed
    {
      .maxstack 64
      ldarg.0        // self Test.INT_STRUCT
      ldarg 'values'        // Semantic.Symbols.LOCAL_ARGUMENT values @ test.ghul 108,14..108,19 type: Collections.Iterable[Ghul.int]
      stfld class [mscorlib]System.Collections.Generic.IEnumerable`1<int32> valuetype 'Test'.'INT_STRUCT'::'_values'        // Semantic.Symbols.INSTANCE_FIELD _values @ test.ghul 107,9..107,15 type: Collections.Iterable[Ghul.int]
      ret
    }
    // // define Test.INT_STRUCT.__read_iterator() -> Collections.Iterator[Ghul.int] // method
    .method public final virtual hidebysig instance default  class [mscorlib]System.Collections.Generic.IEnumerator`1<int32> GetEnumerator() cil managed
    {
      .maxstack 64
      ldarg.0        // self Test.INT_STRUCT
      ldfld class [mscorlib]System.Collections.Generic.IEnumerable`1<int32> valuetype 'Test'.'INT_STRUCT'::'_values'        // Semantic.Symbols.INSTANCE_FIELD _values @ test.ghul 107,9..107,15 type: Collections.Iterable[Ghul.int]
      newobj instance void class [mscorlib]System.Collections.Generic.List`1<int32>::.ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<!0>)        // Collections.LIST[Ghul.int]
      callvirt instance valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<!0> class [mscorlib]System.Collections.Generic.List`1<int32>::GetEnumerator()        // Collections.LIST[Ghul.int].iterator: Collections.LIST_ITERATOR[Ghul.int]
      box valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<int32>
      ret
      .locals init (class [mscorlib]System.Collections.Generic.IEnumerator`1<int32> '.default')
      ldloc '.default'
      ret
    }
    
    // start IEnumerable boilerplate
    .method private final virtual hidebysig newslot 
           instance default class [mscorlib]System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator ()  cil managed 
    {
	.override class [mscorlib]System.Collections.IEnumerable::GetEnumerator
	.maxstack 8
	ldnull 
	ret 
    }
    // end IEnumerable boilerplate

  }
}
.namespace 'Test' { // fixed
  // define struct Test.STRING_STRUCT
  .class public sealed auto ansi beforefieldinit 'STRING_STRUCT' extends [mscorlib]System.ValueType implements class [mscorlib]System.Collections.Generic.IEnumerable`1<class [System.Runtime]'System'.'String'>
  {
    .field public class [mscorlib]System.Collections.Generic.IEnumerable`1<class [System.Runtime]'System'.'String'> '_values'
    // // define Test.STRING_STRUCT.init(values: Collections.Iterable[System.String]) -> Ghul.void // method
    .method public hidebysig instance default  void '.ctor'(class [mscorlib]System.Collections.Generic.IEnumerable`1<class [System.Runtime]'System'.'String'> 'values') cil managed
    {
      .maxstack 64
      ldarg.0        // self Test.STRING_STRUCT
      ldarg 'values'        // Semantic.Symbols.LOCAL_ARGUMENT values @ test.ghul 118,14..118,19 type: Collections.Iterable[System.String]
      stfld class [mscorlib]System.Collections.Generic.IEnumerable`1<class [System.Runtime]'System'.'String'> valuetype 'Test'.'STRING_STRUCT'::'_values'        // Semantic.Symbols.INSTANCE_FIELD _values @ test.ghul 117,9..117,15 type: Collections.Iterable[System.String]
      ret
    }
    // // define Test.STRING_STRUCT.__read_iterator() -> Collections.Iterator[System.String] // method
    .method public final virtual hidebysig instance default  class [mscorlib]System.Collections.Generic.IEnumerator`1<class [System.Runtime]'System'.'String'> GetEnumerator() cil managed
    {
      .maxstack 64
      ldarg.0        // self Test.STRING_STRUCT
      ldfld class [mscorlib]System.Collections.Generic.IEnumerable`1<class [System.Runtime]'System'.'String'> valuetype 'Test'.'STRING_STRUCT'::'_values'        // Semantic.Symbols.INSTANCE_FIELD _values @ test.ghul 117,9..117,15 type: Collections.Iterable[System.String]
      newobj instance void class [mscorlib]System.Collections.Generic.List`1<class [System.Runtime]'System'.'String'>::.ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<!0>)        // Collections.LIST[System.String]
      callvirt instance valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<!0> class [mscorlib]System.Collections.Generic.List`1<class [System.Runtime]'System'.'String'>::GetEnumerator()        // Collections.LIST[System.String].iterator: Collections.LIST_ITERATOR[System.String]
      box valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<class [System.Runtime]'System'.'String'>
      ret
      .locals init (class [mscorlib]System.Collections.Generic.IEnumerator`1<class [System.Runtime]'System'.'String'> '.default')
      ldloc '.default'
      ret
    }
    
    // start IEnumerable boilerplate
    .method private final virtual hidebysig newslot 
           instance default class [mscorlib]System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator ()  cil managed 
    {
	.override class [mscorlib]System.Collections.IEnumerable::GetEnumerator
	.maxstack 8
	ldnull 
	ret 
    }
    // end IEnumerable boilerplate

  }
}

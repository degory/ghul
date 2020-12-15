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
.assembly 'binary'
{
}
.module 'binary.exe'

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
  .class public sealed auto ansi beforefieldinit 'INT_RANGE' extends [System.Runtime]'System'.'ValueType' implements class 'Ghul'.Range`1<int32>, class [mscorlib]'System'.'Collections'.'Generic'.'IEnumerable`1'<int32>, class [mscorlib]'System'.'Collections'.'Generic'.'IEnumerator`1'<int32>
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
    .method public final virtual hidebysig instance default  class [mscorlib]'System'.'Collections'.'Generic'.'IEnumerator`1'<int32> GetEnumerator() cil managed
    {
      .maxstack 64
      ldarg.0        // self Ghul.INT_RANGE
      ldobj valuetype 'Ghul'.'INT_RANGE'
      box valuetype 'Ghul'.'INT_RANGE'
      ret
      .locals init (class [mscorlib]'System'.'Collections'.'Generic'.'IEnumerator`1'<int32> '.default')
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
  .class public sealed auto ansi beforefieldinit 'INT_RANGE_INCLUSIVE' extends [System.Runtime]'System'.'ValueType' implements class 'Ghul'.Range`1<int32>, class [mscorlib]'System'.'Collections'.'Generic'.'IEnumerable`1'<int32>, class [mscorlib]'System'.'Collections'.'Generic'.'IEnumerator`1'<int32>
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
    .method public final virtual hidebysig instance default  class [mscorlib]'System'.'Collections'.'Generic'.'IEnumerator`1'<int32> GetEnumerator() cil managed
    {
      .maxstack 64
      ldarg.0        // self Ghul.INT_RANGE_INCLUSIVE
      ldobj valuetype 'Ghul'.'INT_RANGE_INCLUSIVE'
      box valuetype 'Ghul'.'INT_RANGE_INCLUSIVE'
      ret
      .locals init (class [mscorlib]'System'.'Collections'.'Generic'.'IEnumerator`1'<int32> '.default')
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
      .locals init (valuetype [System.Runtime]'System'.'ValueTuple`3'<int32,int32,int32> 'x.0')
      ldc.i4 1
      ldc.i4 2
      ldc.i4 3
      newobj instance void valuetype [System.Runtime]'System'.'ValueTuple`3'<int32,int32,int32> ::'.ctor'(!0,!1,!2)        // tuple Ghul.TUPLE_3[Ghul.int,Ghul.int,Ghul.int]
      stloc 'x.0'        // Semantic.Symbols.LOCAL_VARIABLE x @ test.ghul 16,17..16,17 type: Ghul.TUPLE_3[Ghul.int,Ghul.int,Ghul.int]
      .locals init (valuetype [System.Runtime]'System'.'ValueTuple`2'<class [System.Runtime]'System'.'String',class [System.Runtime]'System'.'String'> 'y.1')
      ldstr bytearray (68 00 65 00 6C 00 6C 00 6F 00 )
      ldstr bytearray (77 00 6F 00 72 00 6C 00 64 00 )
      newobj instance void valuetype [System.Runtime]'System'.'ValueTuple`2'<class [System.Runtime]'System'.'String',class [System.Runtime]'System'.'String'> ::'.ctor'(!0,!1)        // tuple Ghul.TUPLE_2[Ghul.string,Ghul.string]
      stloc 'y.1'        // Semantic.Symbols.LOCAL_VARIABLE y @ test.ghul 18,17..18,17 type: Ghul.TUPLE_2[Ghul.string,Ghul.string]
      call class [System.Runtime]'System'.'IO'.'TextWriter' class [System.Console]'System'.'Console'::get_Out()
      ldstr bytearray (69 00 6E 00 74 00 20 00 74 00 75 00 70 00 6C 00 65 00 20 00 69 00 73 00 3A 00 20 00 )
      ldloc 'x.0'        // Semantic.Symbols.LOCAL_VARIABLE x @ test.ghul 16,17..16,17 type: Ghul.TUPLE_3[Ghul.int,Ghul.int,Ghul.int]
      box valuetype [System.Runtime]'System'.'ValueTuple`3'<int32,int32,int32>
      call string string::Concat(object,object)
      callvirt instance void class [System.Runtime]'System'.'IO'.'TextWriter'::WriteLine(class [System.Runtime]'System'.'String')        // IO.TextWriter.write_line(value: string) -> Ghul.void
      call class [System.Runtime]'System'.'IO'.'TextWriter' class [System.Console]'System'.'Console'::get_Out()
      ldstr bytearray (73 00 74 00 72 00 69 00 6E 00 67 00 20 00 74 00 75 00 70 00 6C 00 65 00 20 00 69 00 73 00 3A 00 20 00 )
      ldloc 'y.1'        // Semantic.Symbols.LOCAL_VARIABLE y @ test.ghul 18,17..18,17 type: Ghul.TUPLE_2[Ghul.string,Ghul.string]
      box valuetype [System.Runtime]'System'.'ValueTuple`2'<class [System.Runtime]'System'.'String',class [System.Runtime]'System'.'String'>
      call string string::Concat(object,object)
      callvirt instance void class [System.Runtime]'System'.'IO'.'TextWriter'::WriteLine(class [System.Runtime]'System'.'String')        // IO.TextWriter.write_line(value: string) -> Ghul.void
      call class [System.Runtime]'System'.'IO'.'TextWriter' class [System.Console]'System'.'Console'::get_Out()
      ldstr bytearray (74 00 65 00 73 00 74 00 20 00 69 00 6E 00 74 00 20 00 74 00 6F 00 20 00 73 00 74 00 72 00 69 00 6E 00 67 00 3A 00 20 00 )
      ldc.i4 123
      ldc.i4 456
      ldc.i4 789
      newobj instance void valuetype [System.Runtime]'System'.'ValueTuple`3'<int32,int32,int32> ::'.ctor'(!0,!1,!2)        // tuple Ghul.TUPLE_3[Ghul.int,Ghul.int,Ghul.int]
      call valuetype [System.Runtime]'System'.'ValueTuple`2'<class [System.Runtime]'System'.'String',class [System.Runtime]'System'.'String'> class 'Test'.'Main'::'test_int_to_string'(valuetype [System.Runtime]'System'.'ValueTuple`3'<int32,int32,int32>)
      box valuetype [System.Runtime]'System'.'ValueTuple`2'<class [System.Runtime]'System'.'String',class [System.Runtime]'System'.'String'>
      call string string::Concat(object,object)
      callvirt instance void class [System.Runtime]'System'.'IO'.'TextWriter'::WriteLine(class [System.Runtime]'System'.'String')        // IO.TextWriter.write_line(value: string) -> Ghul.void
      ret
    }
    // // define Test.Main.test_int_to_string(int_tuple: Ghul.TUPLE_3[Ghul.int,Ghul.int,Ghul.int]) -> Ghul.TUPLE_2[Ghul.string,Ghul.string] // class method
    .method public hidebysig static default  valuetype [System.Runtime]'System'.'ValueTuple`2'<class [System.Runtime]'System'.'String',class [System.Runtime]'System'.'String'> 'test_int_to_string'(valuetype [System.Runtime]'System'.'ValueTuple`3'<int32,int32,int32> 'int_tuple') cil managed
    {
      .maxstack 64
      ldsflda !0 valuetype [System.Runtime]'System'.'ValueTuple`3'<int32,int32,int32>::Item1        // Semantic.Symbols.STATIC_FIELD _0 @ internal 1,1..1,1 type: Ghul.int
      call instance class [System.Runtime]'System'.'String' int32::ToString()
      ldsflda !2 valuetype [System.Runtime]'System'.'ValueTuple`3'<int32,int32,int32>::Item3        // Semantic.Symbols.STATIC_FIELD _2 @ internal 1,1..1,1 type: Ghul.int
      call instance class [System.Runtime]'System'.'String' int32::ToString()
      newobj instance void valuetype [System.Runtime]'System'.'ValueTuple`2'<class [System.Runtime]'System'.'String',class [System.Runtime]'System'.'String'> ::'.ctor'(!0,!1)        // tuple Ghul.TUPLE_2[Ghul.string,Ghul.string]
      ret
      .locals init (valuetype [System.Runtime]'System'.'ValueTuple`2'<class [System.Runtime]'System'.'String',class [System.Runtime]'System'.'String'> '.default')
      ldloc '.default'
      ret
    }
  }
}

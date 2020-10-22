.assembly 'ghul-app'
{
}
.module 'ghul-app.exe'

.namespace 'Ghul' { // fixed
  .class public interface auto ansi beforefieldinit Range`1<T>
  {
    .method public virtual hidebysig abstract instance default  !0 '__read_from'() cil managed
    {
    }
    .method public virtual hidebysig abstract instance default  !0 '__read_to'() cil managed
    {
    }
  }
}
.namespace 'Ghul' { // fixed
  .class public auto ansi beforefieldinit 'INT_RANGE' extends class [mscorlib]System.ValueType implements class 'Ghul'.Range`1<int32>, class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>, class [mscorlib]System.Collections.Generic.IEnumerator`1<int32>
  {
    .method public final virtual hidebysig newslot instance default  void 'init'(int32 'from',int32 'to') cil managed
    {
      ldarg.0        // self Ghul.INT_RANGE
      ldarg 'from'        // Semantic.Symbol.LOCAL_ARGUMENT from @ ../../../lib/dotnet/ghul/range.ghul 19,14..19,17 type: Ghul.int
      ldc.i4 1
      sub
      call instance void valuetype 'Ghul'.'INT_RANGE'::'__assign_current'(int32)
      ldarg.0        // self Ghul.INT_RANGE
      ldarg 'to'        // Semantic.Symbol.LOCAL_ARGUMENT to @ ../../../lib/dotnet/ghul/range.ghul 19,25..19,26 type: Ghul.int
      call instance void valuetype 'Ghul'.'INT_RANGE'::'__assign_to'(int32)
      ret
    }
    .method public final virtual hidebysig newslot instance default  bool MoveNext() cil managed
    {
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
    .method public final virtual hidebysig newslot instance default  class [mscorlib]System.Collections.Generic.IEnumerator`1<int32> GetEnumerator() cil managed
    {
      ldarg.0        // self Ghul.INT_RANGE
      box valuetype 'Ghul'.'INT_RANGE'
      ret
      .locals init (class [mscorlib]System.Collections.Generic.IEnumerator`1<int32> '.default')
      ldloc '.default'
      ret
    }
    .field public int32 '__backing_current'
    .method public final virtual hidebysig newslot instance default  int32 get_Current() cil managed
    {
      ldarg.0        // self Ghul.INT_RANGE
      ldfld int32 valuetype 'Ghul'.'INT_RANGE'::'__backing_current'        // Semantic.Symbol.INSTANCE_FIELD __backing_current @ internal 1,1..1,1 type: Ghul.int
      ret
      .locals init (int32 '.default')
      ldloc '.default'
      ret
    }
    .method public final virtual hidebysig newslot instance default  void '__assign_current'(int32 '__value') cil managed
    {
      ldarg.0        // self Ghul.INT_RANGE
      ldarg '__value'        // Semantic.Symbol.LOCAL_ARGUMENT __value @ ../../../lib/dotnet/ghul/range.ghul 14,9..14,21 type: Ghul.int
      stfld int32 valuetype 'Ghul'.'INT_RANGE'::'__backing_current'        // Semantic.Symbol.INSTANCE_FIELD __backing_current @ internal 1,1..1,1 type: Ghul.int
      ret
    }
    .method public final virtual hidebysig newslot instance default  int32 '__read_from'() cil managed
    {
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
    .method public final virtual hidebysig newslot instance default  int32 '__read_to'() cil managed
    {
      ldarg.0        // self Ghul.INT_RANGE
      ldfld int32 valuetype 'Ghul'.'INT_RANGE'::'__backing_to'        // Semantic.Symbol.INSTANCE_FIELD __backing_to @ internal 1,1..1,1 type: Ghul.int
      ret
      .locals init (int32 '.default')
      ldloc '.default'
      ret
    }
    .method public final virtual hidebysig newslot instance default  void '__assign_to'(int32 '__value') cil managed
    {
      ldarg.0        // self Ghul.INT_RANGE
      ldarg '__value'        // Semantic.Symbol.LOCAL_ARGUMENT __value @ ../../../lib/dotnet/ghul/range.ghul 17,9..17,16 type: Ghul.int
      stfld int32 valuetype 'Ghul'.'INT_RANGE'::'__backing_to'        // Semantic.Symbol.INSTANCE_FIELD __backing_to @ internal 1,1..1,1 type: Ghul.int
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
  .class public auto ansi beforefieldinit 'INT_RANGE_INCLUSIVE' extends class [mscorlib]System.ValueType implements class 'Ghul'.Range`1<int32>, class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>, class [mscorlib]System.Collections.Generic.IEnumerator`1<int32>
  {
    .method public final virtual hidebysig newslot instance default  void 'init'(int32 'from',int32 'to') cil managed
    {
      ldarg.0        // self Ghul.INT_RANGE_INCLUSIVE
      ldarg 'from'        // Semantic.Symbol.LOCAL_ARGUMENT from @ ../../../lib/dotnet/ghul/range.ghul 41,14..41,17 type: Ghul.int
      ldc.i4 1
      sub
      call instance void valuetype 'Ghul'.'INT_RANGE_INCLUSIVE'::'__assign_current'(int32)
      ldarg.0        // self Ghul.INT_RANGE_INCLUSIVE
      ldarg 'to'        // Semantic.Symbol.LOCAL_ARGUMENT to @ ../../../lib/dotnet/ghul/range.ghul 41,25..41,26 type: Ghul.int
      call instance void valuetype 'Ghul'.'INT_RANGE_INCLUSIVE'::'__assign_to'(int32)
      ret
    }
    .method public final virtual hidebysig newslot instance default  bool MoveNext() cil managed
    {
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
    .method public final virtual hidebysig newslot instance default  class [mscorlib]System.Collections.Generic.IEnumerator`1<int32> GetEnumerator() cil managed
    {
      ldarg.0        // self Ghul.INT_RANGE_INCLUSIVE
      box valuetype 'Ghul'.'INT_RANGE_INCLUSIVE'
      ret
      .locals init (class [mscorlib]System.Collections.Generic.IEnumerator`1<int32> '.default')
      ldloc '.default'
      ret
    }
    .method public final virtual hidebysig newslot instance default  int32 '__read_from'() cil managed
    {
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
    .method public final virtual hidebysig newslot instance default  int32 '__read_to'() cil managed
    {
      ldarg.0        // self Ghul.INT_RANGE_INCLUSIVE
      ldfld int32 valuetype 'Ghul'.'INT_RANGE_INCLUSIVE'::'__backing_to'        // Semantic.Symbol.INSTANCE_FIELD __backing_to @ internal 1,1..1,1 type: Ghul.int
      ret
      .locals init (int32 '.default')
      ldloc '.default'
      ret
    }
    .method public final virtual hidebysig newslot instance default  void '__assign_to'(int32 '__value') cil managed
    {
      ldarg.0        // self Ghul.INT_RANGE_INCLUSIVE
      ldarg '__value'        // Semantic.Symbol.LOCAL_ARGUMENT __value @ ../../../lib/dotnet/ghul/range.ghul 36,9..36,16 type: Ghul.int
      stfld int32 valuetype 'Ghul'.'INT_RANGE_INCLUSIVE'::'__backing_to'        // Semantic.Symbol.INSTANCE_FIELD __backing_to @ internal 1,1..1,1 type: Ghul.int
      ret
    }
    .field public int32 '__backing_current'
    .method public final virtual hidebysig newslot instance default  int32 get_Current() cil managed
    {
      ldarg.0        // self Ghul.INT_RANGE_INCLUSIVE
      ldfld int32 valuetype 'Ghul'.'INT_RANGE_INCLUSIVE'::'__backing_current'        // Semantic.Symbol.INSTANCE_FIELD __backing_current @ internal 1,1..1,1 type: Ghul.int
      ret
      .locals init (int32 '.default')
      ldloc '.default'
      ret
    }
    .method public final virtual hidebysig newslot instance default  void '__assign_current'(int32 '__value') cil managed
    {
      ldarg.0        // self Ghul.INT_RANGE_INCLUSIVE
      ldarg '__value'        // Semantic.Symbol.LOCAL_ARGUMENT __value @ ../../../lib/dotnet/ghul/range.ghul 39,9..39,21 type: Ghul.int
      stfld int32 valuetype 'Ghul'.'INT_RANGE_INCLUSIVE'::'__backing_current'        // Semantic.Symbol.INSTANCE_FIELD __backing_current @ internal 1,1..1,1 type: Ghul.int
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
  .class public auto ansi beforefieldinit 'Main' extends object
  {
    .method public hidebysig static default  void 'entry'() cil managed
    {
      .entrypoint
      .locals init (valuetype 'Test'.'THING_DOER_STRUCT' 'tds.0')
      newobj instance void valuetype 'Test'.'THING_DOER_STRUCT'::.ctor()        // Test.THING_DOER_STRUCT
      stloc 'tds.0'        // Semantic.Symbol.LOCAL_VARIABLE tds @ test.ghul 6,17..6,19 type: Test.THING_DOER_STRUCT
      ldloca 'tds.0'        // Semantic.Symbol.LOCAL_VARIABLE tds @ test.ghul 6,17..6,19 type: Test.THING_DOER_STRUCT
      ldc.i4 12345
      call instance void valuetype 'Test'.'THING_DOER_STRUCT'::'do_something'(int32)
      .locals init (class 'Test'.'THING_DOER_CLASS' 'tdc.1')
      newobj instance void class 'Test'.'THING_DOER_CLASS'::.ctor()        // Test.THING_DOER_CLASS
      stloc 'tdc.1'        // Semantic.Symbol.LOCAL_VARIABLE tdc @ test.ghul 9,17..9,19 type: Test.THING_DOER_CLASS
      ldloc 'tdc.1'        // Semantic.Symbol.LOCAL_VARIABLE tdc @ test.ghul 9,17..9,19 type: Test.THING_DOER_CLASS
      ldc.i4 33333
      callvirt void class 'Test'.'THING_DOER_CLASS'::'do_something'(int32)        // Test.THING_DOER_CLASS.do_something(value: int) -> Ghul.void
      .locals init (class 'Test'.'DoSomething' 'ds.2')
      ldloca 'tds.0'        // Semantic.Symbol.LOCAL_VARIABLE tds @ test.ghul 6,17..6,19 type: Test.THING_DOER_STRUCT
      call instance class 'Test'.'DoSomething' valuetype 'Test'.'THING_DOER_STRUCT'::'get_self'()
      stloc 'ds.2'        // Semantic.Symbol.LOCAL_VARIABLE ds @ test.ghul 12,17..12,18 type: Test.DoSomething
      ldloc 'ds.2'        // Semantic.Symbol.LOCAL_VARIABLE ds @ test.ghul 12,17..12,18 type: Test.DoSomething
      ldc.i4 54321
      callvirt void class 'Test'.'DoSomething'::'do_something'(int32)        // Test.DoSomething.do_something(value: int) -> Ghul.void
      ldloc 'tdc.1'        // Semantic.Symbol.LOCAL_VARIABLE tdc @ test.ghul 9,17..9,19 type: Test.THING_DOER_CLASS
      callvirt class 'Test'.'DoSomething' class 'Test'.'THING_DOER_CLASS'::'get_self'()        // Test.THING_DOER_CLASS.get_self() -> Test.DoSomething
      stloc 'ds.2'        // Semantic.Symbol.LOCAL_VARIABLE ds @ test.ghul 12,17..12,18 type: Test.DoSomething
      ldloc 'ds.2'        // Semantic.Symbol.LOCAL_VARIABLE ds @ test.ghul 12,17..12,18 type: Test.DoSomething
      ldc.i4 66666
      callvirt void class 'Test'.'DoSomething'::'do_something'(int32)        // Test.DoSomething.do_something(value: int) -> Ghul.void
      ret
    }
  }
}
.namespace 'Test' { // fixed
  .class public interface auto ansi beforefieldinit 'DoSomething'
  {
    .method public virtual hidebysig abstract instance default  void 'do_something'(int32 'value') cil managed
    {
    }
  }
}
.namespace 'Test' { // fixed
  .class public auto ansi beforefieldinit 'THING_DOER_STRUCT' extends class [mscorlib]System.ValueType implements class 'Test'.'DoSomething'
  {
    .method public final virtual hidebysig newslot instance default  void .ctor() cil managed
    {
      ret
    }
    .method public final virtual hidebysig newslot instance default  void 'do_something'(int32 'value') cil managed
    {
      ldstr bytearray (73 00 74 00 72 00 75 00 63 00 74 00 20 00 64 00 6F 00 20 00 73 00 6F 00 6D 00 65 00 74 00 68 00 69 00 6E 00 67 00 3A 00 20 00 )
      ldarg 'value'        // Semantic.Symbol.LOCAL_ARGUMENT value @ test.ghul 29,22..29,26 type: Ghul.int
      box int32
      call string string::Concat(object,object)
      call void class [mscorlib]System.Console::WriteLine(class [mscorlib]System.String)
      ret
    }
    .method public final virtual hidebysig newslot instance default  class 'Test'.'DoSomething' 'get_self'() cil managed
    {
      ldarg.0        // self Test.THING_DOER_STRUCT
      box valuetype 'Test'.'THING_DOER_STRUCT'
      ret
      .locals init (class 'Test'.'DoSomething' '.default')
      ldloc '.default'
      ret
    }
  }
}
.namespace 'Test' {
  .class public auto ansi beforefieldinit 'THING_DOER_CLASS' extends object implements class 'Test'.'DoSomething'
  {
    .method public hidebysig instance default  void .ctor() cil managed
    {
      ret
    }
    .method public virtual hidebysig instance default  void 'do_something'(int32 'value') cil managed
    {
      ldstr bytearray (63 00 6C 00 61 00 73 00 73 00 20 00 64 00 6F 00 20 00 73 00 6F 00 6D 00 65 00 74 00 68 00 69 00 6E 00 67 00 3A 00 20 00 )
      ldarg 'value'        // Semantic.Symbol.LOCAL_ARGUMENT value @ test.ghul 39,22..39,26 type: Ghul.int
      box int32
      call string string::Concat(object,object)
      call void class [mscorlib]System.Console::WriteLine(class [mscorlib]System.String)
      ret
    }
    .method public virtual hidebysig instance default  class 'Test'.'DoSomething' 'get_self'() cil managed
    {
      ldarg.0        // self Test.THING_DOER_CLASS
      ret
      .locals init (class 'Test'.'DoSomething' '.default')
      ldloc '.default'
      ret
    }
  }
}

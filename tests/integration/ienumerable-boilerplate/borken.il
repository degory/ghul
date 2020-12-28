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
.assembly extern 'ghul-runtime'
{
  .ver 0:0:0:0
}
.assembly 'binary'
{
}
.module 'binary.exe'

// define class Test.Main
.class public auto ansi beforefieldinit 'Test'.'Main' extends ['System.Runtime']'System'.'Object' 
{
  // define Test.Main.entry() -> Ghul.void // class method
  .method public hidebysig static  default void 'entry'() cil managed
  {
    .maxstack 64
    .entrypoint
    .locals init (class 'Test'.'GENERIC_CLASS' <int32 > 'gci.0')
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
    newobj instance void class 'Test'.'GENERIC_CLASS' <int32 > ::'.ctor'(class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <!0 > )
    stloc 'gci.0'        // Semantic.Symbols.LOCAL_VARIABLE gci @ test.ghul 20,17..20,19 type: Test.GENERIC_CLASS[Ghul.int]
    .locals init (valuetype 'Test'.'GENERIC_STRUCT' <int32 > 'gsi.1')
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
    newobj instance void valuetype 'Test'.'GENERIC_STRUCT' <int32 > ::'.ctor'(class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <!0 > )
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
    newobj instance void class 'Test'.'INT_CLASS' ::'.ctor'(class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <int32 > )
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
    newobj instance void valuetype 'Test'.'INT_STRUCT' ::'.ctor'(class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <int32 > )
    stloc 'is_.3'        // Semantic.Symbols.LOCAL_VARIABLE is_ @ test.ghul 23,17..23,19 type: Test.INT_STRUCT
    .locals init (class 'Test'.'GENERIC_CLASS' <class ['System.Runtime']'System'.'String' > 'gcs.4')
    ldc.i4 5
    newarr class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 0
    ldstr bytearray (6F 00 6E 00 65 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 1
    ldstr bytearray (74 00 77 00 6F 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 2
    ldstr bytearray (74 00 68 00 72 00 65 00 65 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 3
    ldstr bytearray (66 00 6F 00 75 00 72 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 4
    ldstr bytearray (66 00 69 00 76 00 65 00 )
    stelem class ['System.Runtime']'System'.'String' 
    newobj instance void class 'Test'.'GENERIC_CLASS' <class ['System.Runtime']'System'.'String' > ::'.ctor'(class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <!0 > )
    stloc 'gcs.4'        // Semantic.Symbols.LOCAL_VARIABLE gcs @ test.ghul 25,17..25,19 type: Test.GENERIC_CLASS[Ghul.string]
    .locals init (valuetype 'Test'.'GENERIC_STRUCT' <class ['System.Runtime']'System'.'String' > 'gss.5')
    ldc.i4 5
    newarr class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 0
    ldstr bytearray (6F 00 6E 00 65 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 1
    ldstr bytearray (74 00 77 00 6F 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 2
    ldstr bytearray (74 00 68 00 72 00 65 00 65 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 3
    ldstr bytearray (66 00 6F 00 75 00 72 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 4
    ldstr bytearray (66 00 69 00 76 00 65 00 )
    stelem class ['System.Runtime']'System'.'String' 
    newobj instance void valuetype 'Test'.'GENERIC_STRUCT' <class ['System.Runtime']'System'.'String' > ::'.ctor'(class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <!0 > )
    stloc 'gss.5'        // Semantic.Symbols.LOCAL_VARIABLE gss @ test.ghul 26,17..26,19 type: Test.GENERIC_STRUCT[Ghul.string]
    .locals init (class 'Test'.'STRING_CLASS' 'sc.6')
    ldc.i4 5
    newarr class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 0
    ldstr bytearray (6F 00 6E 00 65 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 1
    ldstr bytearray (74 00 77 00 6F 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 2
    ldstr bytearray (74 00 68 00 72 00 65 00 65 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 3
    ldstr bytearray (66 00 6F 00 75 00 72 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 4
    ldstr bytearray (66 00 69 00 76 00 65 00 )
    stelem class ['System.Runtime']'System'.'String' 
    newobj instance void class 'Test'.'STRING_CLASS' ::'.ctor'(class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <class ['System.Runtime']'System'.'String' > )
    stloc 'sc.6'        // Semantic.Symbols.LOCAL_VARIABLE sc @ test.ghul 27,17..27,18 type: Test.STRING_CLASS
    .locals init (valuetype 'Test'.'STRING_STRUCT' 'ss.7')
    ldc.i4 5
    newarr class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 0
    ldstr bytearray (6F 00 6E 00 65 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 1
    ldstr bytearray (74 00 77 00 6F 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 2
    ldstr bytearray (74 00 68 00 72 00 65 00 65 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 3
    ldstr bytearray (66 00 6F 00 75 00 72 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 4
    ldstr bytearray (66 00 69 00 76 00 65 00 )
    stelem class ['System.Runtime']'System'.'String' 
    newobj instance void valuetype 'Test'.'STRING_STRUCT' ::'.ctor'(class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <class ['System.Runtime']'System'.'String' > )
    stloc 'ss.7'        // Semantic.Symbols.LOCAL_VARIABLE ss @ test.ghul 28,17..28,18 type: Test.STRING_STRUCT
    ldstr bytearray (67 00 65 00 6E 00 65 00 72 00 69 00 63 00 20 00 69 00 6E 00 74 00 65 00 67 00 65 00 72 00 20 00 63 00 6C 00 61 00 73 00 73 00 )
    ldloc 'gci.0'
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
    call void class 'Test'.'Main' ::'check'(class ['System.Runtime']'System'.'String' ,class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <int32 > ,class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <int32 > )
    ldstr bytearray (67 00 65 00 6E 00 65 00 72 00 69 00 63 00 20 00 69 00 6E 00 74 00 65 00 67 00 65 00 72 00 20 00 73 00 74 00 72 00 75 00 63 00 74 00 )
    ldloc 'gsi.1'
    box valuetype 'Test'.'GENERIC_STRUCT' <int32 > 
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
    call void class 'Test'.'Main' ::'check'(class ['System.Runtime']'System'.'String' ,class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <int32 > ,class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <int32 > )
    ldstr bytearray (69 00 6E 00 74 00 65 00 67 00 65 00 72 00 20 00 63 00 6C 00 61 00 73 00 73 00 )
    ldloc 'ic.2'
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
    call void class 'Test'.'Main' ::'check'(class ['System.Runtime']'System'.'String' ,class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <int32 > ,class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <int32 > )
    ldstr bytearray (69 00 6E 00 74 00 65 00 67 00 65 00 72 00 20 00 73 00 74 00 72 00 75 00 63 00 74 00 )
    ldloc 'is_.3'
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
    call void class 'Test'.'Main' ::'check'(class ['System.Runtime']'System'.'String' ,class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <int32 > ,class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <int32 > )
    ldstr bytearray (67 00 65 00 6E 00 65 00 72 00 69 00 63 00 20 00 73 00 74 00 72 00 69 00 6E 00 67 00 20 00 63 00 6C 00 61 00 73 00 73 00 )
    ldloc 'gcs.4'
    ldc.i4 5
    newarr class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 0
    ldstr bytearray (6F 00 6E 00 65 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 1
    ldstr bytearray (74 00 77 00 6F 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 2
    ldstr bytearray (74 00 68 00 72 00 65 00 65 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 3
    ldstr bytearray (66 00 6F 00 75 00 72 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 4
    ldstr bytearray (66 00 69 00 76 00 65 00 )
    stelem class ['System.Runtime']'System'.'String' 
    call void class 'Test'.'Main' ::'check'(class ['System.Runtime']'System'.'String' ,class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <class ['System.Runtime']'System'.'String' > ,class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <class ['System.Runtime']'System'.'String' > )
    ldstr bytearray (67 00 65 00 6E 00 65 00 72 00 69 00 63 00 20 00 73 00 74 00 72 00 69 00 6E 00 67 00 20 00 73 00 74 00 72 00 75 00 63 00 74 00 )
    ldloc 'gss.5'
    box valuetype 'Test'.'GENERIC_STRUCT' <class ['System.Runtime']'System'.'String' > 
    ldc.i4 5
    newarr class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 0
    ldstr bytearray (6F 00 6E 00 65 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 1
    ldstr bytearray (74 00 77 00 6F 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 2
    ldstr bytearray (74 00 68 00 72 00 65 00 65 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 3
    ldstr bytearray (66 00 6F 00 75 00 72 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 4
    ldstr bytearray (66 00 69 00 76 00 65 00 )
    stelem class ['System.Runtime']'System'.'String' 
    call void class 'Test'.'Main' ::'check'(class ['System.Runtime']'System'.'String' ,class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <class ['System.Runtime']'System'.'String' > ,class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <class ['System.Runtime']'System'.'String' > )
    ldstr bytearray (73 00 74 00 72 00 69 00 6E 00 67 00 20 00 63 00 6C 00 61 00 73 00 73 00 )
    ldloc 'sc.6'
    ldc.i4 5
    newarr class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 0
    ldstr bytearray (6F 00 6E 00 65 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 1
    ldstr bytearray (74 00 77 00 6F 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 2
    ldstr bytearray (74 00 68 00 72 00 65 00 65 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 3
    ldstr bytearray (66 00 6F 00 75 00 72 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 4
    ldstr bytearray (66 00 69 00 76 00 65 00 )
    stelem class ['System.Runtime']'System'.'String' 
    call void class 'Test'.'Main' ::'check'(class ['System.Runtime']'System'.'String' ,class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <class ['System.Runtime']'System'.'String' > ,class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <class ['System.Runtime']'System'.'String' > )
    ldstr bytearray (73 00 74 00 72 00 69 00 6E 00 67 00 20 00 73 00 74 00 72 00 75 00 63 00 74 00 )
    ldloc 'ss.7'
    box valuetype 'Test'.'STRING_STRUCT' 
    ldc.i4 5
    newarr class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 0
    ldstr bytearray (6F 00 6E 00 65 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 1
    ldstr bytearray (74 00 77 00 6F 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 2
    ldstr bytearray (74 00 68 00 72 00 65 00 65 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 3
    ldstr bytearray (66 00 6F 00 75 00 72 00 )
    stelem class ['System.Runtime']'System'.'String' 
    dup
    ldc.i4 4
    ldstr bytearray (66 00 69 00 76 00 65 00 )
    stelem class ['System.Runtime']'System'.'String' 
    call void class 'Test'.'Main' ::'check'(class ['System.Runtime']'System'.'String' ,class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <class ['System.Runtime']'System'.'String' > ,class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <class ['System.Runtime']'System'.'String' > )
    ret
  }
  // define Test.Main.check(scenario: Ghul.string, values: Collections.Iterable[Ghul.int], expected: Collections.Iterable[Ghul.int]) -> Ghul.void // class method
  .method public hidebysig static  default void 'check'(class ['System.Runtime']'System'.'String' 'scenario',class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <int32 > 'values',class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <int32 > 'expected') cil managed
  {
    .maxstack 64
    call class ['System.Runtime']'System'.'IO'.'TextWriter' class ['System.Console']'System'.'Console' ::'get_Out'()
    ldarg 'scenario'
    callvirt instance void class ['System.Runtime']'System'.'IO'.'TextWriter' ::'WriteLine'(class ['System.Runtime']'System'.'String' )
    .locals init (class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <int32 > 'i.0')
    ldarg 'expected'
    callvirt instance class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <!0 > class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <int32 > ::'GetEnumerator'()
    stloc 'i.0'        // Semantic.Symbols.LOCAL_VARIABLE i @ test.ghul 43,17..43,17 type: Collections.Iterator[Ghul.int]
    .locals init (int32 'v.1')
    .locals init (class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <int32 >  '.temp.0')
    ldarg 'values'
    callvirt instance class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <!0 > class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <int32 > ::'GetEnumerator'()
    stloc '.temp.0'
    L_0:
    ldloc '.temp.0'
    callvirt instance bool class ['System.Runtime']'System'.'Collections'.'IEnumerator' ::'MoveNext'()
    brfalse L_1
    ldloc '.temp.0'
    callvirt instance !0 class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <int32 > ::'get_Current'()
    stloc 'v.1'        // Semantic.Symbols.LOCAL_VARIABLE v @ test.ghul 45,17..45,17 type: Ghul.int
    ldloc 'i.0'
    callvirt instance bool class ['System.Runtime']'System'.'Collections'.'IEnumerator' ::'MoveNext'()
    pop
    call class ['System.Runtime']'System'.'IO'.'TextWriter' class ['System.Console']'System'.'Console' ::'get_Out'()
    ldstr bytearray (68 00 61 00 76 00 65 00 20 00 69 00 6E 00 74 00 3A 00 20 00 )
    ldloc 'v.1'
    box int32 
    call string string::Concat(object,object)
    ldstr bytearray (20 00 65 00 78 00 70 00 65 00 63 00 74 00 65 00 64 00 3A 00 20 00 )
    call string string::Concat(object,object)
    ldloc 'i.0'
    callvirt instance !0 class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <int32 > ::'get_Current'()
    box int32 
    call string string::Concat(object,object)
    callvirt instance void class ['System.Runtime']'System'.'IO'.'TextWriter' ::'WriteLine'(class ['System.Runtime']'System'.'String' )
    br L_0
    L_1:
    call class ['System.Runtime']'System'.'IO'.'TextWriter' class ['System.Console']'System'.'Console' ::'get_Out'()
    callvirt instance void class ['System.Runtime']'System'.'IO'.'TextWriter' ::'WriteLine'()
    ret
  }
  // define Test.Main.check(scenario: Ghul.string, values: Collections.Iterable[Ghul.string], expected: Collections.Iterable[Ghul.string]) -> Ghul.void // class method
  .method public hidebysig static  default void 'check'(class ['System.Runtime']'System'.'String' 'scenario',class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <class ['System.Runtime']'System'.'String' > 'values',class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <class ['System.Runtime']'System'.'String' > 'expected') cil managed
  {
    .maxstack 64
    call class ['System.Runtime']'System'.'IO'.'TextWriter' class ['System.Console']'System'.'Console' ::'get_Out'()
    ldarg 'scenario'
    callvirt instance void class ['System.Runtime']'System'.'IO'.'TextWriter' ::'WriteLine'(class ['System.Runtime']'System'.'String' )
    .locals init (class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <class ['System.Runtime']'System'.'String' > 'i.0')
    ldarg 'expected'
    callvirt instance class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <!0 > class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <class ['System.Runtime']'System'.'String' > ::'GetEnumerator'()
    stloc 'i.0'        // Semantic.Symbols.LOCAL_VARIABLE i @ test.ghul 55,17..55,17 type: Collections.Iterator[Ghul.string]
    .locals init (class ['System.Runtime']'System'.'String' 'v.1')
    .locals init (class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <class ['System.Runtime']'System'.'String' >  '.temp.1')
    ldarg 'values'
    callvirt instance class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <!0 > class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <class ['System.Runtime']'System'.'String' > ::'GetEnumerator'()
    stloc '.temp.1'
    L_2:
    ldloc '.temp.1'
    callvirt instance bool class ['System.Runtime']'System'.'Collections'.'IEnumerator' ::'MoveNext'()
    brfalse L_3
    ldloc '.temp.1'
    callvirt instance !0 class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <class ['System.Runtime']'System'.'String' > ::'get_Current'()
    stloc 'v.1'        // Semantic.Symbols.LOCAL_VARIABLE v @ test.ghul 57,17..57,17 type: Ghul.string
    ldloc 'i.0'
    callvirt instance bool class ['System.Runtime']'System'.'Collections'.'IEnumerator' ::'MoveNext'()
    pop
    call class ['System.Runtime']'System'.'IO'.'TextWriter' class ['System.Console']'System'.'Console' ::'get_Out'()
    ldstr bytearray (68 00 61 00 76 00 65 00 20 00 73 00 74 00 72 00 69 00 6E 00 67 00 3A 00 20 00 )
    ldloc 'v.1'
    call string string::Concat(object,object)
    ldstr bytearray (20 00 65 00 78 00 70 00 65 00 63 00 74 00 65 00 64 00 3A 00 20 00 )
    call string string::Concat(object,object)
    ldloc 'i.0'
    callvirt instance !0 class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <class ['System.Runtime']'System'.'String' > ::'get_Current'()
    call string string::Concat(object,object)
    callvirt instance void class ['System.Runtime']'System'.'IO'.'TextWriter' ::'WriteLine'(class ['System.Runtime']'System'.'String' )
    br L_2
    L_3:
    call class ['System.Runtime']'System'.'IO'.'TextWriter' class ['System.Console']'System'.'Console' ::'get_Out'()
    callvirt instance void class ['System.Runtime']'System'.'IO'.'TextWriter' ::'WriteLine'()
    ret
  }
}
// define class Test.GENERIC_CLASS
.class public auto ansi beforefieldinit 'Test'.'GENERIC_CLASS'<'T'>  extends ['System.Runtime']'System'.'Object' implements class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <!0 > 
{
  .field public class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <!0 > '_values'
  // define Test.GENERIC_CLASS.init(values: Collections.Iterable[Test.GENERIC_CLASS.T]) -> Ghul.void // method
  .method public hidebysig specialname instance  default void '.ctor'(class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <!0 > 'values') cil managed
  {
    .maxstack 64
    ldarg.0        // self Test.GENERIC_CLASS
    ldarg 'values'
    stfld class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <!0 > class 'Test'.'GENERIC_CLASS' <!0> ::'_values'        // Semantic.Symbols.INSTANCE_FIELD _values @ test.ghul 67,9..67,15 type: Collections.Iterable[Test.GENERIC_CLASS.T]
    ret
  }
  .property instance callconv(8) class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <!0 > 'iterator'() { .get instance class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <!0 > 'Test'.'GENERIC_CLASS'::'GetEnumerator'() }
  // define Test.GENERIC_CLASS.$get_iterator() -> Collections.Iterator[Test.GENERIC_CLASS.T] // method
  .method public virtual hidebysig specialname instance  default class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <!0 > 'GetEnumerator'() cil managed
  {
    .maxstack 64
    ldarg.0        // self Test.GENERIC_CLASS
    ldfld class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <!0 > class 'Test'.'GENERIC_CLASS' <!0> ::'_values'
    newobj instance void class ['System.Collections']'System'.'Collections'.'Generic'.'List`1' <!0 > ::'.ctor'(class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <!0 > )
    callvirt instance valuetype ['System.Runtime']'System'.'Collections'.'Generic'.'List`1'/'Enumerator' <!0 > class ['System.Collections']'System'.'Collections'.'Generic'.'List`1' <!0 > ::'GetEnumerator'()
    box valuetype ['System.Runtime']'System'.'Collections'.'Generic'.'List`1'/'Enumerator' <!0 > 
    ret
    .locals init (class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <!0 >  '.default')
    ldloc '.default'
    ret
  }
  
    // start IEnumerable boilerplate
    .method private final virtual hidebysig newslot 
           instance default class ['System.Runtime']System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator ()  cil managed 
    {
	.override class ['System.Runtime']System.Collections.IEnumerable::GetEnumerator
	.maxstack 8
	ldnull 
	ret 
    }
    // end IEnumerable boilerplate

}
// define struct Test.GENERIC_STRUCT
.class public sealed auto ansi beforefieldinit 'Test'.'GENERIC_STRUCT'<'T'>  extends ['System.Runtime']'System'.'ValueType' implements class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <!0 > 
{
  .field public class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <!0 > '_values'
  // define Test.GENERIC_STRUCT.init(values: Collections.Iterable[Test.GENERIC_STRUCT.T]) -> Ghul.void // method
  .method public hidebysig specialname instance  default void '.ctor'(class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <!0 > 'values') cil managed
  {
    .maxstack 64
    ldarg.0        // self Test.GENERIC_STRUCT
    ldarg 'values'
    stfld class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <!0 > valuetype 'Test'.'GENERIC_STRUCT' <!0> ::'_values'        // Semantic.Symbols.INSTANCE_FIELD _values @ test.ghul 76,9..76,15 type: Collections.Iterable[Test.GENERIC_STRUCT.T]
    ret
  }
  .property instance callconv(8) class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <!0 > 'iterator'() { .get instance class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <!0 > 'Test'.'GENERIC_STRUCT'::'GetEnumerator'() }
  // define Test.GENERIC_STRUCT.$get_iterator() -> Collections.Iterator[Test.GENERIC_STRUCT.T] // method
  .method public final virtual hidebysig instance  default class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <!0 > 'GetEnumerator'() cil managed
  {
    .maxstack 64
    ldarg.0        // self Test.GENERIC_STRUCT
    ldfld class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <!0 > valuetype 'Test'.'GENERIC_STRUCT' <!0> ::'_values'
    newobj instance void class ['System.Collections']'System'.'Collections'.'Generic'.'List`1' <!0 > ::'.ctor'(class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <!0 > )
    callvirt instance valuetype ['System.Runtime']'System'.'Collections'.'Generic'.'List`1'/'Enumerator' <!0 > class ['System.Collections']'System'.'Collections'.'Generic'.'List`1' <!0 > ::'GetEnumerator'()
    box valuetype ['System.Runtime']'System'.'Collections'.'Generic'.'List`1'/'Enumerator' <!0 > 
    ret
    .locals init (class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <!0 >  '.default')
    ldloc '.default'
    ret
  }
  
    // start IEnumerable boilerplate
    .method private final virtual hidebysig newslot 
           instance default class ['System.Runtime']System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator ()  cil managed 
    {
	.override class ['System.Runtime']System.Collections.IEnumerable::GetEnumerator
	.maxstack 8
	ldnull 
	ret 
    }
    // end IEnumerable boilerplate

}
// define class Test.INT_CLASS
.class public auto ansi beforefieldinit 'Test'.'INT_CLASS' extends ['System.Runtime']'System'.'Object' implements class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <int32 > 
{
  .field public class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <int32 > '_values'
  // define Test.INT_CLASS.init(values: Collections.Iterable[Ghul.int]) -> Ghul.void // method
  .method public hidebysig specialname instance  default void '.ctor'(class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <int32 > 'values') cil managed
  {
    .maxstack 64
    ldarg.0        // self Test.INT_CLASS
    ldarg 'values'
    stfld class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <int32 > class 'Test'.'INT_CLASS' ::'_values'        // Semantic.Symbols.INSTANCE_FIELD _values @ test.ghul 85,9..85,15 type: Collections.Iterable[Ghul.int]
    ret
  }
  .property instance callconv(8) class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <int32 > 'iterator'() { .get instance class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <int32 > 'Test'.'INT_CLASS'::'GetEnumerator'() }
  // define Test.INT_CLASS.$get_iterator() -> Collections.Iterator[Ghul.int] // method
  .method public virtual hidebysig specialname instance  default class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <int32 > 'GetEnumerator'() cil managed
  {
    .maxstack 64
    ldarg.0        // self Test.INT_CLASS
    ldfld class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <int32 > class 'Test'.'INT_CLASS' ::'_values'
    newobj instance void class ['System.Collections']'System'.'Collections'.'Generic'.'List`1' <int32 > ::'.ctor'(class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <!0 > )
    callvirt instance valuetype ['System.Runtime']'System'.'Collections'.'Generic'.'List`1'/'Enumerator' <!0 > class ['System.Collections']'System'.'Collections'.'Generic'.'List`1' <int32 > ::'GetEnumerator'()
    box valuetype ['System.Runtime']'System'.'Collections'.'Generic'.'List`1'/'Enumerator' <int32 > 
    ret
    .locals init (class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <int32 >  '.default')
    ldloc '.default'
    ret
  }
  
    // start IEnumerable boilerplate
    .method private final virtual hidebysig newslot 
           instance default class ['System.Runtime']System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator ()  cil managed 
    {
	.override class ['System.Runtime']System.Collections.IEnumerable::GetEnumerator
	.maxstack 8
	ldnull 
	ret 
    }
    // end IEnumerable boilerplate

}
// define class Test.STRING_CLASS
.class public auto ansi beforefieldinit 'Test'.'STRING_CLASS' extends ['System.Runtime']'System'.'Object' implements class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <class ['System.Runtime']'System'.'String' > 
{
  .field public class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <class ['System.Runtime']'System'.'String' > '_values'
  // define Test.STRING_CLASS.init(values: Collections.Iterable[Ghul.string]) -> Ghul.void // method
  .method public hidebysig specialname instance  default void '.ctor'(class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <class ['System.Runtime']'System'.'String' > 'values') cil managed
  {
    .maxstack 64
    ldarg.0        // self Test.STRING_CLASS
    ldarg 'values'
    stfld class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <class ['System.Runtime']'System'.'String' > class 'Test'.'STRING_CLASS' ::'_values'        // Semantic.Symbols.INSTANCE_FIELD _values @ test.ghul 94,9..94,15 type: Collections.Iterable[Ghul.string]
    ret
  }
  .property instance callconv(8) class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <class ['System.Runtime']'System'.'String' > 'iterator'() { .get instance class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <class ['System.Runtime']'System'.'String' > 'Test'.'STRING_CLASS'::'GetEnumerator'() }
  // define Test.STRING_CLASS.$get_iterator() -> Collections.Iterator[Ghul.string] // method
  .method public virtual hidebysig specialname instance  default class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <class ['System.Runtime']'System'.'String' > 'GetEnumerator'() cil managed
  {
    .maxstack 64
    ldarg.0        // self Test.STRING_CLASS
    ldfld class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <class ['System.Runtime']'System'.'String' > class 'Test'.'STRING_CLASS' ::'_values'
    newobj instance void class ['System.Collections']'System'.'Collections'.'Generic'.'List`1' <class ['System.Runtime']'System'.'String' > ::'.ctor'(class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <!0 > )
    callvirt instance valuetype ['System.Runtime']'System'.'Collections'.'Generic'.'List`1'/'Enumerator' <!0 > class ['System.Collections']'System'.'Collections'.'Generic'.'List`1' <class ['System.Runtime']'System'.'String' > ::'GetEnumerator'()
    box valuetype ['System.Runtime']'System'.'Collections'.'Generic'.'List`1'/'Enumerator' <class ['System.Runtime']'System'.'String' > 
    ret
    .locals init (class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <class ['System.Runtime']'System'.'String' >  '.default')
    ldloc '.default'
    ret
  }
  
    // start IEnumerable boilerplate
    .method private final virtual hidebysig newslot 
           instance default class ['System.Runtime']System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator ()  cil managed 
    {
	.override class ['System.Runtime']System.Collections.IEnumerable::GetEnumerator
	.maxstack 8
	ldnull 
	ret 
    }
    // end IEnumerable boilerplate

}
// define struct Test.INT_STRUCT
.class public sealed auto ansi beforefieldinit 'Test'.'INT_STRUCT' extends ['System.Runtime']'System'.'ValueType' implements class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <int32 > 
{
  .field public class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <int32 > '_values'
  // define Test.INT_STRUCT.init(values: Collections.Iterable[Ghul.int]) -> Ghul.void // method
  .method public hidebysig specialname instance  default void '.ctor'(class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <int32 > 'values') cil managed
  {
    .maxstack 64
    ldarg.0        // self Test.INT_STRUCT
    ldarg 'values'
    stfld class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <int32 > valuetype 'Test'.'INT_STRUCT' ::'_values'        // Semantic.Symbols.INSTANCE_FIELD _values @ test.ghul 103,9..103,15 type: Collections.Iterable[Ghul.int]
    ret
  }
  .property instance callconv(8) class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <int32 > 'iterator'() { .get instance class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <int32 > 'Test'.'INT_STRUCT'::'GetEnumerator'() }
  // define Test.INT_STRUCT.$get_iterator() -> Collections.Iterator[Ghul.int] // method
  .method public final virtual hidebysig instance  default class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <int32 > 'GetEnumerator'() cil managed
  {
    .maxstack 64
    ldarg.0        // self Test.INT_STRUCT
    ldfld class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <int32 > valuetype 'Test'.'INT_STRUCT' ::'_values'
    newobj instance void class ['System.Collections']'System'.'Collections'.'Generic'.'List`1' <int32 > ::'.ctor'(class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <!0 > )
    callvirt instance valuetype ['System.Runtime']'System'.'Collections'.'Generic'.'List`1'/'Enumerator' <!0 > class ['System.Collections']'System'.'Collections'.'Generic'.'List`1' <int32 > ::'GetEnumerator'()
    box valuetype ['System.Runtime']'System'.'Collections'.'Generic'.'List`1'/'Enumerator' <int32 > 
    ret
    .locals init (class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <int32 >  '.default')
    ldloc '.default'
    ret
  }
  
    // start IEnumerable boilerplate
    .method private final virtual hidebysig newslot 
           instance default class ['System.Runtime']System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator ()  cil managed 
    {
	.override class ['System.Runtime']System.Collections.IEnumerable::GetEnumerator
	.maxstack 8
	ldnull 
	ret 
    }
    // end IEnumerable boilerplate

}
// define struct Test.STRING_STRUCT
.class public sealed auto ansi beforefieldinit 'Test'.'STRING_STRUCT' extends ['System.Runtime']'System'.'ValueType' implements class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <class ['System.Runtime']'System'.'String' > 
{
  .field public class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <class ['System.Runtime']'System'.'String' > '_values'
  // define Test.STRING_STRUCT.init(values: Collections.Iterable[Ghul.string]) -> Ghul.void // method
  .method public hidebysig specialname instance  default void '.ctor'(class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <class ['System.Runtime']'System'.'String' > 'values') cil managed
  {
    .maxstack 64
    ldarg.0        // self Test.STRING_STRUCT
    ldarg 'values'
    stfld class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <class ['System.Runtime']'System'.'String' > valuetype 'Test'.'STRING_STRUCT' ::'_values'        // Semantic.Symbols.INSTANCE_FIELD _values @ test.ghul 112,9..112,15 type: Collections.Iterable[Ghul.string]
    ret
  }
  .property instance callconv(8) class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <class ['System.Runtime']'System'.'String' > 'iterator'() { .get instance class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <class ['System.Runtime']'System'.'String' > 'Test'.'STRING_STRUCT'::'GetEnumerator'() }
  // define Test.STRING_STRUCT.$get_iterator() -> Collections.Iterator[Ghul.string] // method
  .method public final virtual hidebysig instance  default class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <class ['System.Runtime']'System'.'String' > 'GetEnumerator'() cil managed
  {
    .maxstack 64
    ldarg.0        // self Test.STRING_STRUCT
    ldfld class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <class ['System.Runtime']'System'.'String' > valuetype 'Test'.'STRING_STRUCT' ::'_values'
    newobj instance void class ['System.Collections']'System'.'Collections'.'Generic'.'List`1' <class ['System.Runtime']'System'.'String' > ::'.ctor'(class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerable`1' <!0 > )
    callvirt instance valuetype ['System.Runtime']'System'.'Collections'.'Generic'.'List`1'/'Enumerator' <!0 > class ['System.Collections']'System'.'Collections'.'Generic'.'List`1' <class ['System.Runtime']'System'.'String' > ::'GetEnumerator'()
    box valuetype ['System.Runtime']'System'.'Collections'.'Generic'.'List`1'/'Enumerator' <class ['System.Runtime']'System'.'String' > 
    ret
    .locals init (class ['System.Runtime']'System'.'Collections'.'Generic'.'IEnumerator`1' <class ['System.Runtime']'System'.'String' >  '.default')
    ldloc '.default'
    ret
  }
  
    // start IEnumerable boilerplate
    .method private final virtual hidebysig newslot 
           instance default class ['System.Runtime']System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator ()  cil managed 
    {
	.override class ['System.Runtime']System.Collections.IEnumerable::GetEnumerator
	.maxstack 8
	ldnull 
	ret 
    }
    // end IEnumerable boilerplate

}

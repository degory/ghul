
//  Microsoft (R) .NET IL Disassembler.  Version 5.0.0



// Metadata version: v4.0.30319
.assembly extern System.Runtime
{
  .publickeytoken = (B7 7A 5C 56 19 34 E0 89 )                         // .z\V.4..
  .ver 5:0:0:0
}
.assembly extern mscorlib
{
  .publickeytoken = (B7 7A 5C 56 19 34 E0 89 )                         // .z\V.4..
  .ver 4:0:0:0
}
.assembly extern System.Core
{
  .publickeytoken = (B7 7A 5C 56 19 34 E0 89 )                         // .z\V.4..
  .ver 4:0:0:0
}
.assembly extern System.Collections
{
  .publickeytoken = (B7 7A 5C 56 19 34 E0 89 )                         // .z\V.4..
  .ver 4:0:0:0
}
.assembly extern System.Console
{
  .publickeytoken = (B7 7A 5C 56 19 34 E0 89 )                         // .z\V.4..
  .ver 4:0:0:0
}
.assembly extern System
{
  .publickeytoken = (B7 7A 5C 56 19 34 E0 89 )                         // .z\V.4..
  .ver 4:0:0:0
}
.assembly extern 'ghul-runtime'
{
  .ver 0:0:0:0
}
.assembly binary
{
  .ver 0:0:0:0
}
.module binary.exe
// MVID: {a64242cb-86d1-4d92-a2d9-2076a234e221}
.imagebase 0x00400000
.file alignment 0x00000200
.stackreserve 0x00100000
.subsystem 0x0003       // WINDOWS_CUI
.corflags 0x00000001    //  ILONLY
// Image base: 0x00007FB5105E9000


// =============== CLASS MEMBERS DECLARATION ===================

.class public auto ansi beforefieldinit Test.Main
       extends [System.Runtime]System.Object
{
  .method public hidebysig static void  entry() cil managed
  {
    .entrypoint
    // Code size       1645 (0x66d)
    .maxstack  64
    .locals init (class Test.GENERIC_CLASS<int32> V_0,
             valuetype Test.GENERIC_STRUCT<int32> V_1,
             class Test.INT_CLASS V_2,
             valuetype Test.INT_STRUCT V_3,
             class Test.GENERIC_CLASS<string> V_4,
             valuetype Test.GENERIC_STRUCT<string> V_5,
             class Test.STRING_CLASS V_6,
             valuetype Test.STRING_STRUCT V_7)
    IL_0000:  ldc.i4     0x5
    IL_0005:  newarr     int32
    IL_000a:  dup
    IL_000b:  ldc.i4     0x0
    IL_0010:  ldc.i4     0x1
    IL_0015:  stelem     int32
    IL_001a:  dup
    IL_001b:  ldc.i4     0x1
    IL_0020:  ldc.i4     0x2
    IL_0025:  stelem     int32
    IL_002a:  dup
    IL_002b:  ldc.i4     0x2
    IL_0030:  ldc.i4     0x3
    IL_0035:  stelem     int32
    IL_003a:  dup
    IL_003b:  ldc.i4     0x3
    IL_0040:  ldc.i4     0x4
    IL_0045:  stelem     int32
    IL_004a:  dup
    IL_004b:  ldc.i4     0x4
    IL_0050:  ldc.i4     0x5
    IL_0055:  stelem     int32
    IL_005a:  newobj     instance void class Test.GENERIC_CLASS<int32>::.ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<!0>)
    IL_005f:  stloc      V_0
    IL_0063:  ldc.i4     0x5
    IL_0068:  newarr     int32
    IL_006d:  dup
    IL_006e:  ldc.i4     0x0
    IL_0073:  ldc.i4     0x5
    IL_0078:  stelem     int32
    IL_007d:  dup
    IL_007e:  ldc.i4     0x1
    IL_0083:  ldc.i4     0x4
    IL_0088:  stelem     int32
    IL_008d:  dup
    IL_008e:  ldc.i4     0x2
    IL_0093:  ldc.i4     0x3
    IL_0098:  stelem     int32
    IL_009d:  dup
    IL_009e:  ldc.i4     0x3
    IL_00a3:  ldc.i4     0x2
    IL_00a8:  stelem     int32
    IL_00ad:  dup
    IL_00ae:  ldc.i4     0x4
    IL_00b3:  ldc.i4     0x1
    IL_00b8:  stelem     int32
    IL_00bd:  newobj     instance void valuetype Test.GENERIC_STRUCT<int32>::.ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<!0>)
    IL_00c2:  stloc      V_1
    IL_00c6:  ldc.i4     0x5
    IL_00cb:  newarr     int32
    IL_00d0:  dup
    IL_00d1:  ldc.i4     0x0
    IL_00d6:  ldc.i4     0x1
    IL_00db:  stelem     int32
    IL_00e0:  dup
    IL_00e1:  ldc.i4     0x1
    IL_00e6:  ldc.i4     0x2
    IL_00eb:  stelem     int32
    IL_00f0:  dup
    IL_00f1:  ldc.i4     0x2
    IL_00f6:  ldc.i4     0x3
    IL_00fb:  stelem     int32
    IL_0100:  dup
    IL_0101:  ldc.i4     0x3
    IL_0106:  ldc.i4     0x4
    IL_010b:  stelem     int32
    IL_0110:  dup
    IL_0111:  ldc.i4     0x4
    IL_0116:  ldc.i4     0x5
    IL_011b:  stelem     int32
    IL_0120:  newobj     instance void class Test.INT_CLASS::.ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>)
    IL_0125:  stloc      V_2
    IL_0129:  ldc.i4     0x5
    IL_012e:  newarr     int32
    IL_0133:  dup
    IL_0134:  ldc.i4     0x0
    IL_0139:  ldc.i4     0x1
    IL_013e:  stelem     int32
    IL_0143:  dup
    IL_0144:  ldc.i4     0x1
    IL_0149:  ldc.i4     0x2
    IL_014e:  stelem     int32
    IL_0153:  dup
    IL_0154:  ldc.i4     0x2
    IL_0159:  ldc.i4     0x3
    IL_015e:  stelem     int32
    IL_0163:  dup
    IL_0164:  ldc.i4     0x3
    IL_0169:  ldc.i4     0x4
    IL_016e:  stelem     int32
    IL_0173:  dup
    IL_0174:  ldc.i4     0x4
    IL_0179:  ldc.i4     0x5
    IL_017e:  stelem     int32
    IL_0183:  newobj     instance void valuetype Test.INT_STRUCT::.ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>)
    IL_0188:  stloc      V_3
    IL_018c:  ldc.i4     0x5
    IL_0191:  newarr     string
    IL_0196:  dup
    IL_0197:  ldc.i4     0x0
    IL_019c:  ldstr      "one"
    IL_01a1:  stelem     string
    IL_01a6:  dup
    IL_01a7:  ldc.i4     0x1
    IL_01ac:  ldstr      "two"
    IL_01b1:  stelem     string
    IL_01b6:  dup
    IL_01b7:  ldc.i4     0x2
    IL_01bc:  ldstr      "three"
    IL_01c1:  stelem     string
    IL_01c6:  dup
    IL_01c7:  ldc.i4     0x3
    IL_01cc:  ldstr      "four"
    IL_01d1:  stelem     string
    IL_01d6:  dup
    IL_01d7:  ldc.i4     0x4
    IL_01dc:  ldstr      "five"
    IL_01e1:  stelem     string
    IL_01e6:  newobj     instance void class Test.GENERIC_CLASS<string>::.ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<!0>)
    IL_01eb:  stloc      V_4
    IL_01ef:  ldc.i4     0x5
    IL_01f4:  newarr     string
    IL_01f9:  dup
    IL_01fa:  ldc.i4     0x0
    IL_01ff:  ldstr      "one"
    IL_0204:  stelem     string
    IL_0209:  dup
    IL_020a:  ldc.i4     0x1
    IL_020f:  ldstr      "two"
    IL_0214:  stelem     string
    IL_0219:  dup
    IL_021a:  ldc.i4     0x2
    IL_021f:  ldstr      "three"
    IL_0224:  stelem     string
    IL_0229:  dup
    IL_022a:  ldc.i4     0x3
    IL_022f:  ldstr      "four"
    IL_0234:  stelem     string
    IL_0239:  dup
    IL_023a:  ldc.i4     0x4
    IL_023f:  ldstr      "five"
    IL_0244:  stelem     string
    IL_0249:  newobj     instance void valuetype Test.GENERIC_STRUCT<string>::.ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<!0>)
    IL_024e:  stloc      V_5
    IL_0252:  ldc.i4     0x5
    IL_0257:  newarr     string
    IL_025c:  dup
    IL_025d:  ldc.i4     0x0
    IL_0262:  ldstr      "one"
    IL_0267:  stelem     string
    IL_026c:  dup
    IL_026d:  ldc.i4     0x1
    IL_0272:  ldstr      "two"
    IL_0277:  stelem     string
    IL_027c:  dup
    IL_027d:  ldc.i4     0x2
    IL_0282:  ldstr      "three"
    IL_0287:  stelem     string
    IL_028c:  dup
    IL_028d:  ldc.i4     0x3
    IL_0292:  ldstr      "four"
    IL_0297:  stelem     string
    IL_029c:  dup
    IL_029d:  ldc.i4     0x4
    IL_02a2:  ldstr      "five"
    IL_02a7:  stelem     string
    IL_02ac:  newobj     instance void class Test.STRING_CLASS::.ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<string>)
    IL_02b1:  stloc      V_6
    IL_02b5:  ldc.i4     0x5
    IL_02ba:  newarr     string
    IL_02bf:  dup
    IL_02c0:  ldc.i4     0x0
    IL_02c5:  ldstr      "one"
    IL_02ca:  stelem     string
    IL_02cf:  dup
    IL_02d0:  ldc.i4     0x1
    IL_02d5:  ldstr      "two"
    IL_02da:  stelem     string
    IL_02df:  dup
    IL_02e0:  ldc.i4     0x2
    IL_02e5:  ldstr      "three"
    IL_02ea:  stelem     string
    IL_02ef:  dup
    IL_02f0:  ldc.i4     0x3
    IL_02f5:  ldstr      "four"
    IL_02fa:  stelem     string
    IL_02ff:  dup
    IL_0300:  ldc.i4     0x4
    IL_0305:  ldstr      "five"
    IL_030a:  stelem     string
    IL_030f:  newobj     instance void valuetype Test.STRING_STRUCT::.ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<string>)
    IL_0314:  stloc      V_7
    IL_0318:  ldstr      "generic integer class"
    IL_031d:  ldloc      V_0
    IL_0321:  ldc.i4     0x5
    IL_0326:  newarr     int32
    IL_032b:  dup
    IL_032c:  ldc.i4     0x0
    IL_0331:  ldc.i4     0x1
    IL_0336:  stelem     int32
    IL_033b:  dup
    IL_033c:  ldc.i4     0x1
    IL_0341:  ldc.i4     0x2
    IL_0346:  stelem     int32
    IL_034b:  dup
    IL_034c:  ldc.i4     0x2
    IL_0351:  ldc.i4     0x3
    IL_0356:  stelem     int32
    IL_035b:  dup
    IL_035c:  ldc.i4     0x3
    IL_0361:  ldc.i4     0x4
    IL_0366:  stelem     int32
    IL_036b:  dup
    IL_036c:  ldc.i4     0x4
    IL_0371:  ldc.i4     0x5
    IL_0376:  stelem     int32
    IL_037b:  call       void class Test.Main::check(string,
                                                     class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>,
                                                     class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>)
    IL_0380:  ldstr      "generic integer struct"
    IL_0385:  ldloc      V_1
    IL_0389:  box        valuetype Test.GENERIC_STRUCT<int32>
    IL_038e:  ldc.i4     0x5
    IL_0393:  newarr     int32
    IL_0398:  dup
    IL_0399:  ldc.i4     0x0
    IL_039e:  ldc.i4     0x5
    IL_03a3:  stelem     int32
    IL_03a8:  dup
    IL_03a9:  ldc.i4     0x1
    IL_03ae:  ldc.i4     0x4
    IL_03b3:  stelem     int32
    IL_03b8:  dup
    IL_03b9:  ldc.i4     0x2
    IL_03be:  ldc.i4     0x3
    IL_03c3:  stelem     int32
    IL_03c8:  dup
    IL_03c9:  ldc.i4     0x3
    IL_03ce:  ldc.i4     0x2
    IL_03d3:  stelem     int32
    IL_03d8:  dup
    IL_03d9:  ldc.i4     0x4
    IL_03de:  ldc.i4     0x1
    IL_03e3:  stelem     int32
    IL_03e8:  call       void class Test.Main::check(string,
                                                     class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>,
                                                     class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>)
    IL_03ed:  ldstr      "integer class"
    IL_03f2:  ldloc      V_2
    IL_03f6:  ldc.i4     0x5
    IL_03fb:  newarr     int32
    IL_0400:  dup
    IL_0401:  ldc.i4     0x0
    IL_0406:  ldc.i4     0x1
    IL_040b:  stelem     int32
    IL_0410:  dup
    IL_0411:  ldc.i4     0x1
    IL_0416:  ldc.i4     0x2
    IL_041b:  stelem     int32
    IL_0420:  dup
    IL_0421:  ldc.i4     0x2
    IL_0426:  ldc.i4     0x3
    IL_042b:  stelem     int32
    IL_0430:  dup
    IL_0431:  ldc.i4     0x3
    IL_0436:  ldc.i4     0x4
    IL_043b:  stelem     int32
    IL_0440:  dup
    IL_0441:  ldc.i4     0x4
    IL_0446:  ldc.i4     0x5
    IL_044b:  stelem     int32
    IL_0450:  call       void class Test.Main::check(string,
                                                     class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>,
                                                     class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>)
    IL_0455:  ldstr      "integer struct"
    IL_045a:  ldloc      V_3
    IL_045e:  box        valuetype Test.INT_STRUCT
    IL_0463:  ldc.i4     0x5
    IL_0468:  newarr     int32
    IL_046d:  dup
    IL_046e:  ldc.i4     0x0
    IL_0473:  ldc.i4     0x1
    IL_0478:  stelem     int32
    IL_047d:  dup
    IL_047e:  ldc.i4     0x1
    IL_0483:  ldc.i4     0x2
    IL_0488:  stelem     int32
    IL_048d:  dup
    IL_048e:  ldc.i4     0x2
    IL_0493:  ldc.i4     0x3
    IL_0498:  stelem     int32
    IL_049d:  dup
    IL_049e:  ldc.i4     0x3
    IL_04a3:  ldc.i4     0x4
    IL_04a8:  stelem     int32
    IL_04ad:  dup
    IL_04ae:  ldc.i4     0x4
    IL_04b3:  ldc.i4     0x5
    IL_04b8:  stelem     int32
    IL_04bd:  call       void class Test.Main::check(string,
                                                     class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>,
                                                     class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>)
    IL_04c2:  ldstr      "generic string class"
    IL_04c7:  ldloc      V_4
    IL_04cb:  ldc.i4     0x5
    IL_04d0:  newarr     string
    IL_04d5:  dup
    IL_04d6:  ldc.i4     0x0
    IL_04db:  ldstr      "one"
    IL_04e0:  stelem     string
    IL_04e5:  dup
    IL_04e6:  ldc.i4     0x1
    IL_04eb:  ldstr      "two"
    IL_04f0:  stelem     string
    IL_04f5:  dup
    IL_04f6:  ldc.i4     0x2
    IL_04fb:  ldstr      "three"
    IL_0500:  stelem     string
    IL_0505:  dup
    IL_0506:  ldc.i4     0x3
    IL_050b:  ldstr      "four"
    IL_0510:  stelem     string
    IL_0515:  dup
    IL_0516:  ldc.i4     0x4
    IL_051b:  ldstr      "five"
    IL_0520:  stelem     string
    IL_0525:  call       void class Test.Main::check(string,
                                                     class [mscorlib]System.Collections.Generic.IEnumerable`1<string>,
                                                     class [mscorlib]System.Collections.Generic.IEnumerable`1<string>)
    IL_052a:  ldstr      "generic string struct"
    IL_052f:  ldloc      V_5
    IL_0533:  box        valuetype Test.GENERIC_STRUCT<string>
    IL_0538:  ldc.i4     0x5
    IL_053d:  newarr     string
    IL_0542:  dup
    IL_0543:  ldc.i4     0x0
    IL_0548:  ldstr      "one"
    IL_054d:  stelem     string
    IL_0552:  dup
    IL_0553:  ldc.i4     0x1
    IL_0558:  ldstr      "two"
    IL_055d:  stelem     string
    IL_0562:  dup
    IL_0563:  ldc.i4     0x2
    IL_0568:  ldstr      "three"
    IL_056d:  stelem     string
    IL_0572:  dup
    IL_0573:  ldc.i4     0x3
    IL_0578:  ldstr      "four"
    IL_057d:  stelem     string
    IL_0582:  dup
    IL_0583:  ldc.i4     0x4
    IL_0588:  ldstr      "five"
    IL_058d:  stelem     string
    IL_0592:  call       void class Test.Main::check(string,
                                                     class [mscorlib]System.Collections.Generic.IEnumerable`1<string>,
                                                     class [mscorlib]System.Collections.Generic.IEnumerable`1<string>)
    IL_0597:  ldstr      "string class"
    IL_059c:  ldloc      V_6
    IL_05a0:  ldc.i4     0x5
    IL_05a5:  newarr     string
    IL_05aa:  dup
    IL_05ab:  ldc.i4     0x0
    IL_05b0:  ldstr      "one"
    IL_05b5:  stelem     string
    IL_05ba:  dup
    IL_05bb:  ldc.i4     0x1
    IL_05c0:  ldstr      "two"
    IL_05c5:  stelem     string
    IL_05ca:  dup
    IL_05cb:  ldc.i4     0x2
    IL_05d0:  ldstr      "three"
    IL_05d5:  stelem     string
    IL_05da:  dup
    IL_05db:  ldc.i4     0x3
    IL_05e0:  ldstr      "four"
    IL_05e5:  stelem     string
    IL_05ea:  dup
    IL_05eb:  ldc.i4     0x4
    IL_05f0:  ldstr      "five"
    IL_05f5:  stelem     string
    IL_05fa:  call       void class Test.Main::check(string,
                                                     class [mscorlib]System.Collections.Generic.IEnumerable`1<string>,
                                                     class [mscorlib]System.Collections.Generic.IEnumerable`1<string>)
    IL_05ff:  ldstr      "string struct"
    IL_0604:  ldloc      V_7
    IL_0608:  box        valuetype Test.STRING_STRUCT
    IL_060d:  ldc.i4     0x5
    IL_0612:  newarr     string
    IL_0617:  dup
    IL_0618:  ldc.i4     0x0
    IL_061d:  ldstr      "one"
    IL_0622:  stelem     string
    IL_0627:  dup
    IL_0628:  ldc.i4     0x1
    IL_062d:  ldstr      "two"
    IL_0632:  stelem     string
    IL_0637:  dup
    IL_0638:  ldc.i4     0x2
    IL_063d:  ldstr      "three"
    IL_0642:  stelem     string
    IL_0647:  dup
    IL_0648:  ldc.i4     0x3
    IL_064d:  ldstr      "four"
    IL_0652:  stelem     string
    IL_0657:  dup
    IL_0658:  ldc.i4     0x4
    IL_065d:  ldstr      "five"
    IL_0662:  stelem     string
    IL_0667:  call       void class Test.Main::check(string,
                                                     class [mscorlib]System.Collections.Generic.IEnumerable`1<string>,
                                                     class [mscorlib]System.Collections.Generic.IEnumerable`1<string>)
    IL_066c:  ret
  } // end of method Main::entry

  .method public hidebysig static void  check(string scenario,
                                              class [mscorlib]System.Collections.Generic.IEnumerable`1<int32> values,
                                              class [mscorlib]System.Collections.Generic.IEnumerable`1<int32> expected) cil managed
  {
    // Code size       151 (0x97)
    .maxstack  64
    .locals init (class [mscorlib]System.Collections.Generic.IEnumerator`1<int32> V_0,
             int32 V_1,
             class [mscorlib]System.Collections.Generic.IEnumerator`1<int32> V_2)
    IL_0000:  call       class [System.Runtime]System.IO.TextWriter class [System.Console]System.Console::get_Out()
    IL_0005:  ldarg      scenario
    IL_0009:  callvirt   instance void class [System.Runtime]System.IO.TextWriter::WriteLine(string)
    IL_000e:  ldarg      expected
    IL_0012:  callvirt   instance class [mscorlib]System.Collections.Generic.IEnumerator`1<!0> class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>::GetEnumerator()
    IL_0017:  stloc      V_0
    IL_001b:  ldarg      values
    IL_001f:  callvirt   instance class [mscorlib]System.Collections.Generic.IEnumerator`1<!0> class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>::GetEnumerator()
    IL_0024:  stloc      V_2
    IL_0028:  ldloc      V_2
    IL_002c:  callvirt   instance bool class [mscorlib]System.Collections.IEnumerator::MoveNext()
    IL_0031:  brfalse    IL_008c

    IL_0036:  ldloc      V_2
    IL_003a:  callvirt   instance !0 class [mscorlib]System.Collections.Generic.IEnumerator`1<int32>::get_Current()
    IL_003f:  stloc      V_1
    IL_0043:  ldloc      V_0
    IL_0047:  callvirt   instance bool class [mscorlib]System.Collections.IEnumerator::MoveNext()
    IL_004c:  pop
    IL_004d:  call       class [System.Runtime]System.IO.TextWriter class [System.Console]System.Console::get_Out()
    IL_0052:  ldstr      "have int: "
    IL_0057:  ldloc      V_1
    IL_005b:  box        int32
    IL_0060:  call       string string::Concat(object,
                                               object)
    IL_0065:  ldstr      " expected: "
    IL_006a:  call       string string::Concat(object,
                                               object)
    IL_006f:  ldloc      V_0
    IL_0073:  callvirt   instance !0 class [mscorlib]System.Collections.Generic.IEnumerator`1<int32>::get_Current()
    IL_0078:  box        int32
    IL_007d:  call       string string::Concat(object,
                                               object)
    IL_0082:  callvirt   instance void class [System.Runtime]System.IO.TextWriter::WriteLine(string)
    IL_0087:  br         IL_0028

    IL_008c:  call       class [System.Runtime]System.IO.TextWriter class [System.Console]System.Console::get_Out()
    IL_0091:  callvirt   instance void class [System.Runtime]System.IO.TextWriter::WriteLine()
    IL_0096:  ret
  } // end of method Main::check

  .method public hidebysig static void  check(string scenario,
                                              class [mscorlib]System.Collections.Generic.IEnumerable`1<string> values,
                                              class [mscorlib]System.Collections.Generic.IEnumerable`1<string> expected) cil managed
  {
    // Code size       141 (0x8d)
    .maxstack  64
    .locals init (class [mscorlib]System.Collections.Generic.IEnumerator`1<string> V_0,
             string V_1,
             class [mscorlib]System.Collections.Generic.IEnumerator`1<string> V_2)
    IL_0000:  call       class [System.Runtime]System.IO.TextWriter class [System.Console]System.Console::get_Out()
    IL_0005:  ldarg      scenario
    IL_0009:  callvirt   instance void class [System.Runtime]System.IO.TextWriter::WriteLine(string)
    IL_000e:  ldarg      expected
    IL_0012:  callvirt   instance class [mscorlib]System.Collections.Generic.IEnumerator`1<!0> class [mscorlib]System.Collections.Generic.IEnumerable`1<string>::GetEnumerator()
    IL_0017:  stloc      V_0
    IL_001b:  ldarg      values
    IL_001f:  callvirt   instance class [mscorlib]System.Collections.Generic.IEnumerator`1<!0> class [mscorlib]System.Collections.Generic.IEnumerable`1<string>::GetEnumerator()
    IL_0024:  stloc      V_2
    IL_0028:  ldloc      V_2
    IL_002c:  callvirt   instance bool class [mscorlib]System.Collections.IEnumerator::MoveNext()
    IL_0031:  brfalse    IL_0082

    IL_0036:  ldloc      V_2
    IL_003a:  callvirt   instance !0 class [mscorlib]System.Collections.Generic.IEnumerator`1<string>::get_Current()
    IL_003f:  stloc      V_1
    IL_0043:  ldloc      V_0
    IL_0047:  callvirt   instance bool class [mscorlib]System.Collections.IEnumerator::MoveNext()
    IL_004c:  pop
    IL_004d:  call       class [System.Runtime]System.IO.TextWriter class [System.Console]System.Console::get_Out()
    IL_0052:  ldstr      "have string: "
    IL_0057:  ldloc      V_1
    IL_005b:  call       string string::Concat(object,
                                               object)
    IL_0060:  ldstr      " expected: "
    IL_0065:  call       string string::Concat(object,
                                               object)
    IL_006a:  ldloc      V_0
    IL_006e:  callvirt   instance !0 class [mscorlib]System.Collections.Generic.IEnumerator`1<string>::get_Current()
    IL_0073:  call       string string::Concat(object,
                                               object)
    IL_0078:  callvirt   instance void class [System.Runtime]System.IO.TextWriter::WriteLine(string)
    IL_007d:  br         IL_0028

    IL_0082:  call       class [System.Runtime]System.IO.TextWriter class [System.Console]System.Console::get_Out()
    IL_0087:  callvirt   instance void class [System.Runtime]System.IO.TextWriter::WriteLine()
    IL_008c:  ret
  } // end of method Main::check

} // end of class Test.Main

.class public auto ansi beforefieldinit Test.GENERIC_CLASS<T>
       extends [System.Runtime]System.Object
       implements class [mscorlib]System.Collections.Generic.IEnumerable`1<!T>
{
  .field public class [mscorlib]System.Collections.Generic.IEnumerable`1<!T> _values
  .method public hidebysig specialname rtspecialname 
          instance void  .ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<!T> values) cil managed
  {
    // Code size       11 (0xb)
    .maxstack  64
    IL_0000:  ldarg.0
    IL_0001:  ldarg      values
    IL_0005:  stfld      class [mscorlib]System.Collections.Generic.IEnumerable`1<!0> class Test.GENERIC_CLASS<!T>::_values
    IL_000a:  ret
  } // end of method GENERIC_CLASS::.ctor

  .method public hidebysig specialname virtual 
          instance class [mscorlib]System.Collections.Generic.IEnumerator`1<!T> 
          GetEnumerator() cil managed
  {
    // Code size       27 (0x1b)
    .maxstack  64
    .locals init (class [mscorlib]System.Collections.Generic.IEnumerator`1<!T> V_0)
    IL_0000:  ldarg.0
    IL_0001:  ldfld      class [mscorlib]System.Collections.Generic.IEnumerable`1<!0> class Test.GENERIC_CLASS<!T>::_values
    IL_0006:  newobj     instance void class [mscorlib]System.Collections.Generic.List`1<!T>::.ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<!0>)
    IL_000b:  callvirt   instance valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<!0> class [mscorlib]System.Collections.Generic.List`1<!T>::GetEnumerator()
    IL_0010:  box        valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<!T>
    IL_0015:  ret

    IL_0016:  ldloc      V_0
    IL_001a:  ret
  } // end of method GENERIC_CLASS::GetEnumerator

  .method private hidebysig newslot virtual final 
          instance class [mscorlib]System.Collections.IEnumerator 
          System.Collections.IEnumerable.GetEnumerator() cil managed
  {
    .override  method instance class [mscorlib]System.Collections.IEnumerator class [mscorlib]System.Collections.IEnumerable::GetEnumerator()
    // Code size       2 (0x2)
    .maxstack  8
    IL_0000:  ldnull
    IL_0001:  ret
  } // end of method GENERIC_CLASS::System.Collections.IEnumerable.GetEnumerator

} // end of class Test.GENERIC_CLASS

.class public auto ansi sealed beforefieldinit Test.GENERIC_STRUCT<T>
       extends [System.Runtime]System.ValueType
       implements class [mscorlib]System.Collections.Generic.IEnumerable`1<!T>
{
  .field public class [mscorlib]System.Collections.Generic.IEnumerable`1<!T> _values
  .method public hidebysig specialname rtspecialname 
          instance void  .ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<!T> values) cil managed
  {
    // Code size       11 (0xb)
    .maxstack  64
    IL_0000:  ldarg.0
    IL_0001:  ldarg      values
    IL_0005:  stfld      class [mscorlib]System.Collections.Generic.IEnumerable`1<!0> valuetype Test.GENERIC_STRUCT<!T>::_values
    IL_000a:  ret
  } // end of method GENERIC_STRUCT::.ctor

  .method public hidebysig specialname virtual final 
          instance class [mscorlib]System.Collections.Generic.IEnumerator`1<!T> 
          GetEnumerator() cil managed
  {
    // Code size       27 (0x1b)
    .maxstack  64
    .locals init (class [mscorlib]System.Collections.Generic.IEnumerator`1<!T> V_0)
    IL_0000:  ldarg.0
    IL_0001:  ldfld      class [mscorlib]System.Collections.Generic.IEnumerable`1<!0> valuetype Test.GENERIC_STRUCT<!T>::_values
    IL_0006:  newobj     instance void class [mscorlib]System.Collections.Generic.List`1<!T>::.ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<!0>)
    IL_000b:  callvirt   instance valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<!0> class [mscorlib]System.Collections.Generic.List`1<!T>::GetEnumerator()
    IL_0010:  box        valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<!T>
    IL_0015:  ret

    IL_0016:  ldloc      V_0
    IL_001a:  ret
  } // end of method GENERIC_STRUCT::GetEnumerator

  .method private hidebysig newslot virtual final 
          instance class [mscorlib]System.Collections.IEnumerator 
          System.Collections.IEnumerable.GetEnumerator() cil managed
  {
    .override  method instance class [mscorlib]System.Collections.IEnumerator class [mscorlib]System.Collections.IEnumerable::GetEnumerator()
    // Code size       2 (0x2)
    .maxstack  8
    IL_0000:  ldnull
    IL_0001:  ret
  } // end of method GENERIC_STRUCT::System.Collections.IEnumerable.GetEnumerator

} // end of class Test.GENERIC_STRUCT

.class public auto ansi beforefieldinit Test.INT_CLASS
       extends [System.Runtime]System.Object
       implements class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>
{
  .field public class [mscorlib]System.Collections.Generic.IEnumerable`1<int32> _values
  .method public hidebysig specialname rtspecialname 
          instance void  .ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<int32> values) cil managed
  {
    // Code size       11 (0xb)
    .maxstack  64
    IL_0000:  ldarg.0
    IL_0001:  ldarg      values
    IL_0005:  stfld      class [mscorlib]System.Collections.Generic.IEnumerable`1<int32> class Test.INT_CLASS::_values
    IL_000a:  ret
  } // end of method INT_CLASS::.ctor

  .method public hidebysig specialname virtual 
          instance class [mscorlib]System.Collections.Generic.IEnumerator`1<int32> 
          GetEnumerator() cil managed
  {
    // Code size       27 (0x1b)
    .maxstack  64
    .locals init (class [mscorlib]System.Collections.Generic.IEnumerator`1<int32> V_0)
    IL_0000:  ldarg.0
    IL_0001:  ldfld      class [mscorlib]System.Collections.Generic.IEnumerable`1<int32> class Test.INT_CLASS::_values
    IL_0006:  newobj     instance void class [mscorlib]System.Collections.Generic.List`1<int32>::.ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<!0>)
    IL_000b:  callvirt   instance valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<!0> class [mscorlib]System.Collections.Generic.List`1<int32>::GetEnumerator()
    IL_0010:  box        valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<int32>
    IL_0015:  ret

    IL_0016:  ldloc      V_0
    IL_001a:  ret
  } // end of method INT_CLASS::GetEnumerator

  .method private hidebysig newslot virtual final 
          instance class [mscorlib]System.Collections.IEnumerator 
          System.Collections.IEnumerable.GetEnumerator() cil managed
  {
    .override  method instance class [mscorlib]System.Collections.IEnumerator class [mscorlib]System.Collections.IEnumerable::GetEnumerator()
    // Code size       2 (0x2)
    .maxstack  8
    IL_0000:  ldnull
    IL_0001:  ret
  } // end of method INT_CLASS::System.Collections.IEnumerable.GetEnumerator

} // end of class Test.INT_CLASS

.class public auto ansi sealed beforefieldinit Test.INT_STRUCT
       extends [System.Runtime]System.ValueType
       implements class [mscorlib]System.Collections.Generic.IEnumerable`1<int32>
{
  .field public class [mscorlib]System.Collections.Generic.IEnumerable`1<int32> _values
  .method public hidebysig specialname rtspecialname 
          instance void  .ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<int32> values) cil managed
  {
    // Code size       11 (0xb)
    .maxstack  64
    IL_0000:  ldarg.0
    IL_0001:  ldarg      values
    IL_0005:  stfld      class [mscorlib]System.Collections.Generic.IEnumerable`1<int32> valuetype Test.INT_STRUCT::_values
    IL_000a:  ret
  } // end of method INT_STRUCT::.ctor

  .method public hidebysig specialname virtual final 
          instance class [mscorlib]System.Collections.Generic.IEnumerator`1<int32> 
          GetEnumerator() cil managed
  {
    // Code size       27 (0x1b)
    .maxstack  64
    .locals init (class [mscorlib]System.Collections.Generic.IEnumerator`1<int32> V_0)
    IL_0000:  ldarg.0
    IL_0001:  ldfld      class [mscorlib]System.Collections.Generic.IEnumerable`1<int32> valuetype Test.INT_STRUCT::_values
    IL_0006:  newobj     instance void class [mscorlib]System.Collections.Generic.List`1<int32>::.ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<!0>)
    IL_000b:  callvirt   instance valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<!0> class [mscorlib]System.Collections.Generic.List`1<int32>::GetEnumerator()
    IL_0010:  box        valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<int32>
    IL_0015:  ret

    IL_0016:  ldloc      V_0
    IL_001a:  ret
  } // end of method INT_STRUCT::GetEnumerator

  .method private hidebysig newslot virtual final 
          instance class [mscorlib]System.Collections.IEnumerator 
          System.Collections.IEnumerable.GetEnumerator() cil managed
  {
    .override  method instance class [mscorlib]System.Collections.IEnumerator class [mscorlib]System.Collections.IEnumerable::GetEnumerator()
    // Code size       2 (0x2)
    .maxstack  8
    IL_0000:  ldnull
    IL_0001:  ret
  } // end of method INT_STRUCT::System.Collections.IEnumerable.GetEnumerator

} // end of class Test.INT_STRUCT

.class public auto ansi beforefieldinit Test.STRING_CLASS
       extends [System.Runtime]System.Object
       implements class [mscorlib]System.Collections.Generic.IEnumerable`1<string>
{
  .field public class [mscorlib]System.Collections.Generic.IEnumerable`1<string> _values
  .method public hidebysig specialname rtspecialname 
          instance void  .ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<string> values) cil managed
  {
    // Code size       11 (0xb)
    .maxstack  64
    IL_0000:  ldarg.0
    IL_0001:  ldarg      values
    IL_0005:  stfld      class [mscorlib]System.Collections.Generic.IEnumerable`1<string> class Test.STRING_CLASS::_values
    IL_000a:  ret
  } // end of method STRING_CLASS::.ctor

  .method public hidebysig specialname virtual 
          instance class [mscorlib]System.Collections.Generic.IEnumerator`1<string> 
          GetEnumerator() cil managed
  {
    // Code size       27 (0x1b)
    .maxstack  64
    .locals init (class [mscorlib]System.Collections.Generic.IEnumerator`1<string> V_0)
    IL_0000:  ldarg.0
    IL_0001:  ldfld      class [mscorlib]System.Collections.Generic.IEnumerable`1<string> class Test.STRING_CLASS::_values
    IL_0006:  newobj     instance void class [mscorlib]System.Collections.Generic.List`1<string>::.ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<!0>)
    IL_000b:  callvirt   instance valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<!0> class [mscorlib]System.Collections.Generic.List`1<string>::GetEnumerator()
    IL_0010:  box        valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<string>
    IL_0015:  ret

    IL_0016:  ldloc      V_0
    IL_001a:  ret
  } // end of method STRING_CLASS::GetEnumerator

  .method private hidebysig newslot virtual final 
          instance class [mscorlib]System.Collections.IEnumerator 
          System.Collections.IEnumerable.GetEnumerator() cil managed
  {
    .override  method instance class [mscorlib]System.Collections.IEnumerator class [mscorlib]System.Collections.IEnumerable::GetEnumerator()
    // Code size       2 (0x2)
    .maxstack  8
    IL_0000:  ldnull
    IL_0001:  ret
  } // end of method STRING_CLASS::System.Collections.IEnumerable.GetEnumerator

} // end of class Test.STRING_CLASS

.class public auto ansi sealed beforefieldinit Test.STRING_STRUCT
       extends [System.Runtime]System.ValueType
       implements class [mscorlib]System.Collections.Generic.IEnumerable`1<string>
{
  .field public class [mscorlib]System.Collections.Generic.IEnumerable`1<string> _values
  .method public hidebysig specialname rtspecialname 
          instance void  .ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<string> values) cil managed
  {
    // Code size       11 (0xb)
    .maxstack  64
    IL_0000:  ldarg.0
    IL_0001:  ldarg      values
    IL_0005:  stfld      class [mscorlib]System.Collections.Generic.IEnumerable`1<string> valuetype Test.STRING_STRUCT::_values
    IL_000a:  ret
  } // end of method STRING_STRUCT::.ctor

  .method public hidebysig specialname virtual final 
          instance class [mscorlib]System.Collections.Generic.IEnumerator`1<string> 
          GetEnumerator() cil managed
  {
    // Code size       27 (0x1b)
    .maxstack  64
    .locals init (class [mscorlib]System.Collections.Generic.IEnumerator`1<string> V_0)
    IL_0000:  ldarg.0
    IL_0001:  ldfld      class [mscorlib]System.Collections.Generic.IEnumerable`1<string> valuetype Test.STRING_STRUCT::_values
    IL_0006:  newobj     instance void class [mscorlib]System.Collections.Generic.List`1<string>::.ctor(class [mscorlib]System.Collections.Generic.IEnumerable`1<!0>)
    IL_000b:  callvirt   instance valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<!0> class [mscorlib]System.Collections.Generic.List`1<string>::GetEnumerator()
    IL_0010:  box        valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<string>
    IL_0015:  ret

    IL_0016:  ldloc      V_0
    IL_001a:  ret
  } // end of method STRING_STRUCT::GetEnumerator

  .method private hidebysig newslot virtual final 
          instance class [mscorlib]System.Collections.IEnumerator 
          System.Collections.IEnumerable.GetEnumerator() cil managed
  {
    .override  method instance class [mscorlib]System.Collections.IEnumerator class [mscorlib]System.Collections.IEnumerable::GetEnumerator()
    // Code size       2 (0x2)
    .maxstack  8
    IL_0000:  ldnull
    IL_0001:  ret
  } // end of method STRING_STRUCT::System.Collections.IEnumerable.GetEnumerator

} // end of class Test.STRING_STRUCT


// =============================================================

// *********** DISASSEMBLY COMPLETE ***********************

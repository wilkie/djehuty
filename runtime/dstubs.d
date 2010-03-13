/*
 * dstubs.d
 *
 * This module stubs out the dynamic parts of the D language.
 *
 */

module runtime.dstubs;

import runtime.dstatic;
import runtime.exception;
import runtime.common;

extern(C):

/**************************************************
 Stub function
**************************************************/
private template Stub(char[] signature) {
	const char[] Stub = signature ~ " { assert(false, \"Undefined runtime stub executed: " ~ signature ~ "\"); }";
}

/**************************************************
 Random stubs (they'll go somewhere eventually)
**************************************************/

mixin(Stub!("void abort()"));
mixin(Stub!("bool rt_isHalting()"));
mixin(Stub!("bool runModuleUnitTests()"));
mixin(Stub!("void _d_monitordelete(Object h, bool det = true)"));

/**************************************************
 Lifetime stubs
**************************************************/

mixin(Stub!("Object _d_allocclass(ClassInfo ci)"));
mixin(Stub!("Object _d_newclass(ClassInfo ci)"));
mixin(Stub!("void _d_delinterface(void** p)"));
mixin(Stub!("void _d_delclass(Object* p)"));
mixin(Stub!("Array _d_newarrayT(TypeInfo ti, size_t length)"));
mixin(Stub!("Array _d_newarrayiT(TypeInfo ti, size_t length)"));
mixin(Stub!("Array _d_newarrayvT(TypeInfo ti, size_t length)"));
mixin(Stub!("void[] _d_newarraymTp(TypeInfo ti, int ndims, size_t* pdim)"));
mixin(Stub!("void[] _d_newarraymiTp(TypeInfo ti, int ndims, size_t* pdim)"));
mixin(Stub!("void _d_delarray(Array *p)"));
mixin(Stub!("void _d_delmemory(void* *p)"));
mixin(Stub!("void _d_callfinalizer(void* p)"));
mixin(Stub!("void rt_finalize(void* p, bool det = true)"));
mixin(Stub!("byte[] _d_arraysetlengthT(TypeInfo ti, size_t newlength, Array *p)"));
mixin(Stub!("byte[] _d_arraysetlengthiT(TypeInfo ti, size_t newlength, Array *p)"));
mixin(Stub!("Array _d_arrayappendT(TypeInfo ti, Array *px, byte[] y)"));
mixin(Stub!("byte[] _d_arrayappendcTp(TypeInfo ti, inout byte[] x, void *argp)"));
mixin(Stub!("byte[] _d_arraycatT(TypeInfo ti, byte[] x, byte[] y)"));
mixin(Stub!("byte[] _d_arraycatnT(TypeInfo ti, uint n, ...)"));
mixin(Stub!("Array _adDupT(TypeInfo ti, Array a)"));

/**************************************************
 GC stubs
**************************************************/

mixin(Stub!("void gc_init()"));
mixin(Stub!("void gc_term()"));
mixin(Stub!("void gc_enable()"));
mixin(Stub!("void gc_disable()"));
mixin(Stub!("void gc_collect()"));
mixin(Stub!("uint gc_getAttr( void* p )"));
mixin(Stub!("uint gc_setAttr( void* p, uint a )"));
mixin(Stub!("uint gc_clrAttr( void* p, uint a )"));
mixin(Stub!("void* gc_malloc( size_t sz, uint ba = 0 )"));
mixin(Stub!("void* gc_calloc( size_t sz, uint ba = 0 )"));
mixin(Stub!("void* gc_realloc( void* p, size_t sz, uint ba = 0 )"));
mixin(Stub!("size_t gc_extend( void* p, size_t mx, size_t sz )"));
mixin(Stub!("void gc_free( void* p )"));
mixin(Stub!("size_t gc_sizeOf( void* p )"));
mixin(Stub!("void gc_addRoot( void* p )"));
mixin(Stub!("void gc_addRange( void* p, size_t sz )"));
mixin(Stub!("void gc_removeRoot( void *p )"));
mixin(Stub!("void gc_removeRange( void *p )"));
mixin(Stub!("bool onCollectResource( Object obj )"));

/**************************************************
 Exception stubs
**************************************************/

/*mixin(Stub!("void onFinalizeError( ClassInfo info, Exception ex )"));
mixin(Stub!("void onOutOfMemoryError()"));
mixin(Stub!("void onUnicodeError( char[] msg, size_t idx )"));
mixin(Stub!("void _d_throw_exception(Object e)"));*/

/**************************************************
 DEH and Unwind stubs
**************************************************/

mixin(Stub!("void _gdc_cleanupException()"));
mixin(Stub!("void _d_throw(Object obj)"));
mixin(Stub!("int __gdc_personality_v0()"));
mixin(Stub!("void _Unwind_RaiseException ()"));
mixin(Stub!("void _Unwind_ForcedUnwind ()"));
mixin(Stub!("void _Unwind_DeleteException ()"));
mixin(Stub!("void _Unwind_Resume()"));
mixin(Stub!("void _Unwind_Resume_or_Rethrow ()"));
mixin(Stub!("void _Unwind_Backtrace ()"));
mixin(Stub!("void _Unwind_GetGR ()"));
mixin(Stub!("void _Unwind_SetGR ()"));
mixin(Stub!("void _Unwind_GetIP ()"));
mixin(Stub!("void _Unwind_SetIP ()"));
mixin(Stub!("void _Unwind_GetCFA ()"));
mixin(Stub!("void *_Unwind_GetLanguageSpecificData ()"));
mixin(Stub!("void _Unwind_GetRegionStart ()"));
mixin(Stub!("void _Unwind_SjLj_RaiseException()"));
mixin(Stub!("void _Unwind_SjLj_ForcedUnwind()"));
mixin(Stub!("void _Unwind_SjLj_Resume ()"));
mixin(Stub!("void _Unwind_GetDataRelBase ()"));
mixin(Stub!("void _Unwind_GetTextRelBase ()"));
mixin(Stub!("uint size_of_encoded_value (ubyte encoding)"));
mixin(Stub!("void base_of_encoded_value ()"));
mixin(Stub!("void read_uleb128()"));
mixin(Stub!("void read_sleb128()"));
mixin(Stub!("void read_encoded_value_with_base()"));
mixin(Stub!("void read_encoded_value()"));

/**************************************************
 AA stubs
**************************************************/

mixin(Stub!("size_t _aaLen(AA aa)"));
mixin(Stub!("void *_aaGetp(AA* aa, TypeInfo keyti, size_t valuesize, void *pkey)"));
mixin(Stub!("void *_aaGetRvaluep(AA aa, TypeInfo keyti, size_t valuesize, void *pkey)"));
mixin(Stub!("void* _aaInp(AA aa, TypeInfo keyti, void *pkey)"));
mixin(Stub!("void _aaDelp(AA aa, TypeInfo keyti, void *pkey)"));
mixin(Stub!("Array _aaValues(AA aa, size_t keysize, size_t valuesize)"));
mixin(Stub!("AA _aaRehash(AA* paa, TypeInfo keyti)"));
mixin(Stub!("Array _aaKeys(AA aa, size_t keysize)"));
mixin(Stub!("int _aaApply(AA aa, size_t keysize, aa_dg_t dg)"));
mixin(Stub!("int _aaApply2(AA aa, size_t keysize, aa_dg2_t dg)"));
mixin(Stub!("BB* _d_assocarrayliteralTp(TypeInfo_AssociativeArray ti, size_t length, void *keys, void *values)"));

/**************************************************
 Array stubs
**************************************************/

mixin(Stub!("int _aApplycw1(char[] aa, array_dg_t dg)"));
mixin(Stub!("int _aApplycd1(char[] aa, array_dg_t dg)"));
mixin(Stub!("int _aApplywc1(wchar[] aa, array_dg_t dg)"));
mixin(Stub!("int _aApplywd1(wchar[] aa, array_dg_t dg)"));
mixin(Stub!("int _aApplydc1(dchar[] aa, array_dg_t dg)"));
mixin(Stub!("int _aApplydw1(dchar[] aa, array_dg_t dg)"));
mixin(Stub!("int _aApplycw2(char[] aa, array_dg2_t dg)"));
mixin(Stub!("int _aApplycd2(char[] aa, array_dg2_t dg)"));
mixin(Stub!("int _aApplywc2(wchar[] aa, array_dg2_t dg)"));
mixin(Stub!("int _aApplywd2(wchar[] aa, array_dg2_t dg)"));
mixin(Stub!("int _aApplydc2(dchar[] aa, array_dg2_t dg)"));
mixin(Stub!("int _aApplydw2(dchar[] aa, array_dg2_t dg)"));
mixin(Stub!("int _aApplyRcw1(char[] aa, array_dg_t dg)"));
mixin(Stub!("int _aApplyRcd1(char[] aa, array_dg_t dg)"));
mixin(Stub!("int _aApplyRwc1(wchar[] aa, array_dg_t dg)"));
mixin(Stub!("int _aApplyRwd1(wchar[] aa, array_dg_t dg)"));
mixin(Stub!("int _aApplyRdc1(dchar[] aa, array_dg_t dg)"));
mixin(Stub!("int _aApplyRdw1(dchar[] aa, array_dg_t dg)"));
mixin(Stub!("int _aApplyRcw2(char[] aa, array_dg2_t dg)"));
mixin(Stub!("int _aApplyRcd2(char[] aa, array_dg2_t dg)"));
mixin(Stub!("int _aApplyRwc2(wchar[] aa, array_dg2_t dg)"));
mixin(Stub!("int _aApplyRwd2(wchar[] aa, array_dg2_t dg)"));
mixin(Stub!("int _aApplyRdc2(dchar[] aa, array_dg2_t dg)"));
mixin(Stub!("int _aApplyRdw2(dchar[] aa, array_dg2_t dg)"));
mixin(Stub!("char[] _adSortChar(char[] a)"));
mixin(Stub!("wchar[] _adSortWchar(wchar[] a)"));

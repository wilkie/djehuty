/*
 * lifetime.d
 *
 * This module implements the D runtime for allocation of data.
 *
 */

module mindrt.lifetime;

import mindrt.common;
import mindrt.exception;
import mindrt.gc;

extern(C):

Object _d_allocclass(ClassInfo ci) {
	return null;
}

Object _d_newclass(ClassInfo ci) {
	return null;
}

void _d_delinterface(void** p) {
}

void _d_delclass(Object* p) {
}

// Description: Will allocate a new array of type ti with the length
//  given, and will initialize it to the default value.
Array _d_newarrayT(TypeInfo ti, size_t length) {
	Array r;
	return r;
}

// Description: Will allocate a new array of type ti with the length
//  given, and will initialize it to a given value.
Array _d_newarrayiT(TypeInfo ti, size_t length) {
	Array r;
	return r;
}

// Description: Will allocate a uninitialized array of type ti with
//  the length given.
Array _d_newarrayvT(TypeInfo ti, size_t length) {
	Array r;
	return r;
}

void[] _d_newarraymTp(TypeInfo ti, int ndims, size_t* pdim) {
	return null;
}

void[] _d_newarraymiTp(TypeInfo ti, int ndims, size_t* pdim) {
	return null;
}

// Description: Will delete an array.
void _d_delarray(Array* p) {
}

// Description: Will simply remove the memory pointed to a p.
void _d_delmemory(void** p) {
	if (p !is null) {
		gc_free(p);
	}
}

void _d_callfinalizer(void* p) {
}

void rt_finalize(void* p, bool det = true) {
}

byte[] _d_arraysetlengthT(TypeInfo ti, size_t newlength, Array* p) {
	return null;
}

byte[] _d_arraysetlengthiT(TypeInfo ti, size_t newlength, Array* p) {
	return null;
}

Array _d_arrayappendT(TypeInfo ti, Array* px, byte[] y) {
	Array r;
	return r;
}

byte[] _d_arrayappendcTp(TypeInfo ti, ref byte[] x, void* argp) {
	return null;
}

byte[] _d_arraycatT(TypeInfo ti, byte[] x, byte[] y) {
	return null;
}

byte[] _d_arraycatnT(TypeInfo ti, uint n, ...) {
	return null;
}

Array _adDupT(TypeInfo ti, Array a) {
	Array r;
	return r;
}

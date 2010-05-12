/*
 * lifetime.d
 *
 * This module implements the D runtime for allocation of data.
 *
 */

module runtime.lifetime;

import runtime.exception;
import runtime.common;
import runtime.gc;

extern(C):

Object _d_allocclass(ClassInfo ci) {
	return cast(Object)gc_malloc(ci.init.length, BlkAttr.FINALIZE | (ci.flags & 2 ? BlkAttr.NO_SCAN : 0));
}

void* _d_allocmemoryT(TypeInfo ti) {
	return gc_malloc(ti.tsize(), 0);
}

Object _d_newclass(ClassInfo ci) {
	return null;
}

void _d_delinterface(Interface*** p) {
	if (p is null) {
		return;
	}
	Interface* pi = **p;
	Object o = cast(Object)(p - pi.offset);
	_d_delclass(o);
}

void _d_delclass(Object p) {
	if (p is null) {
		return;
	}

	ClassInfo** pc = cast(ClassInfo**)p;
	if (*pc !is null) {
		ClassInfo c = **pc;
		rt_finalize(cast(void*)p);

		if (c.deallocator !is null) {
			//c.deallocator();
			return;
		}
	}
	else {
		rt_finalize(cast(void*)p);
	}
	gc_free(cast(ubyte*)p);
}

private template _newarray(bool initialize, bool withZero) {
	void[] _newarray(TypeInfo ti, size_t length) {
		if (cast(TypeInfo_Typedef)ti !is null) {
//			ti = ti.next;
		}
		size_t elementSize = ti.next.tsize();
		size_t returnLength = length;

		// Check to see if the size of the array can fit
		// within a size_t. If there is no overflow, then
		// it will divide back out evenly.
		if (length > 0) {
			size_t check = elementSize * length;
			if ((check / length) != elementSize) {
				onOutOfMemoryError();
			}
			length = check;
		}

		// Allocate the array
		ubyte[] ret = (cast(ubyte*)gc_malloc(length+1, 0))[0..length];

		// Initialize the array with one of two methods.
		static if (initialize) {
			static if (withZero) {
				// Zero the contents
				ret[0..length] = 0;
			}
			else {
				// Initialize with the values set in the TypeInfo
				ubyte[] init = cast(ubyte[])ti.next.init();

				// If there is no init vector, then just init to zero
				if (init is null) {
					ret[0..length] = 0;
				}
				else {
					// Initialize all values we can
					size_t initIndex = 0;

//					foreach(size_t idx, ref element; ret) {
					for(size_t idx = 0; idx < length; idx++) {
//						element = init[initIndex];
						ret[idx] = init[initIndex];
						initIndex++;
						if (initIndex == init.length) {
							initIndex = 0;
						}
					}	
				}
			}
		}

		// For arrays that are of the form ubyte[] array = void;
		// we do not initialize them. Falling through will
		// work for those.

		return ret[0..returnLength];
	}
}

// Description: Will allocate a new array of type ti with the length
//  given, and will initialize it to the default value.
// ti: The TypeInfo object that represents the array to be allocated.
// length: The number of elements in the array to be allocated.
void* _d_newarrayT(TypeInfo ti, size_t length) {
	// Use the template, initialize the array with 0
	return _newarray!(true, true)(ti, length).ptr;
}

// Description: Will allocate a new array of type ti with the length
//   given, and will initialize it to a given value.
// ti: The TypeInfo object that represents the array to be allocated.
//   The init() function within the TypeInfo will be used to initialize
//   the array.
// length: The number of elements in the array to be allocated.
void* _d_newarrayiT(TypeInfo ti, size_t length) {
	return _newarray!(true, false)(ti, length).ptr;
}

// Description: Will allocate a uninitialized array of type ti with
//   the length given.
// ti: The TypeInfo object that represents the array to be allocated.
// length: The number of elements in the array to be allocated.
void*_d_newarrayvT(TypeInfo ti, size_t length) {
	// Use the template, but do not initialize
	return _newarray!(false, false)(ti, length).ptr;
}

template _newarraym(bool initialize, bool withZero) {
	void[] _newarraym(TypeInfo ti, size_t[] dimensions) {
		if (dimensions.length == 0) {
			return null;
		}

		// We need to allocate either the final array or the arrays of arrays
		// The intermediate arrays are void[]

		// This function is recursive, the base case is when we are allocating a
		// simple array.
		if (dimensions.length == 1) {
			return _newarray!(initialize, withZero)(ti, dimensions[$-1]);
		}

		// The intermediate dimensions... we call upon this function recursively

		// For each intermediate layer, we need to allocate a void[]
		void[][] intermediate = (cast(void[]*)gc_malloc(dimensions[0] * (void[]).sizeof + 1))[0 .. dimensions[0]];
		for(size_t i = 0; i < dimensions[0]; i++) {
			intermediate[i] = _newarraym!(initialize, withZero)(ti, dimensions[1..$]);
		}
		return intermediate;
	}
}

void* _d_newarraymT(TypeInfo ti, size_t[] dimensions) {
	return _newarraym!(true, true)(ti, dimensions).ptr;
}

void* _d_newarraymiT(TypeInfo ti, size_t[] dimensions) {
	return _newarraym!(true, false)(ti, dimensions).ptr;
}

void* _d_newarraymvT(TypeInfo ti, size_t[] dimensions) {
	return _newarraym!(false, false)(ti, dimensions).ptr;
}

// Description: Will delete an array.
// array: The array to delete.
void _d_delarray(void[] array) {
	if (array !is null) {
		gc_free(cast(ubyte*)array.ptr);
	}
}

// Description: Will simply remove the memory pointed to a ptr.
// ptr: The pointer to the address to free.
void _d_delmemory(void* ptr) {
	if (ptr !is null) {
		gc_free(cast(ubyte*)ptr);
	}
}

void _d_callfinalizer(void* p) {
	rt_finalize(p);
}

void rt_finalize(void* p, bool det = true) {
}

byte* _d_arraysetlengthT(TypeInfo ti, size_t newlength, size_t plength, byte* pdata) {
	return null;
}

byte* _d_arraysetlengthiT(TypeInfo ti, size_t newlength, size_t plength, byte* pdata) {
	return null;
}

void[] _d_arrayappendT(TypeInfo ti, void[]* px, byte[] y) {
	return null;
}

// Description: This runtime function will append a single element to an
//   array.
// ti: The TypeInfo of the base type of this array.
// array: The array to append the element.
// element: The element to append.
byte[] _d_arrayappendcT(TypeInfo ti, ref byte[] array, void* element) {
	return null;
}

byte[] _d_arraycatT(TypeInfo ti, byte[] x, byte[] y) {
	return null;
}
byte[] _d_arraycatnT(TypeInfo ti, uint n, ...) {
	return null;
}

void[] _adDupT(TypeInfo ti, void[] a) {
	ubyte[] ret = (cast(ubyte*)_d_newarrayvT(ti, a.length))[0..a.length*ti.next.tsize()];
	ubyte[] array = (cast(ubyte*)a)[0..a.length*ti.next.tsize()];

	foreach(size_t idx, ref element; ret) {
		element = array[idx];
	}

	return ret;
}

/*
 * lifetime.d
 *
 * This module implements the D runtime for allocation of data.
 *
 */

module runtime.lifetime;

import runtime.common;
import runtime.exception;
import runtime.gc;

extern(C):

Object _d_allocclass(ClassInfo ci) {
	return cast(Object)gc_malloc(ci.init.length, BlkAttr.FINALIZE | (ci.flags & 2 ? BlkAttr.NO_SCAN : 0));
}

Object _d_newclass(ClassInfo ci) {
	return null;
}

void _d_delinterface(void* p) {
	if (p is null) {
		return;
	}
	Interface* pi = **cast(Interface***)p;
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
	gc_free(cast(void*)p);
}

private template _newarray(bool initialize, bool withZero) {
	void[] _newarray(TypeInfo ti, size_t length) {
		size_t elementSize = ti.next.tsize();

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
				size_t initIndex = 0;

				foreach(size_t idx, ref element; ret) {
					element = init[initIndex];
					initIndex++;
					if (initIndex == init.length) {
						initIndex = 0;
					}	
				}
			}
		}

		// For arrays that are of the form ubyte[] array = void;
		// we do not initialize them. Falling through will
		// work for those.

		return ret;
	}
}

// Description: Will allocate a new array of type ti with the length
//  given, and will initialize it to the default value.
void[] _d_newarrayT(TypeInfo ti, size_t length) {
	// Use the template, initialize the array with 0
	return _newarray!(true, true)(ti, length);
}

// Description: Will allocate a new array of type ti with the length
//   given, and will initialize it to a given value.
void[] _d_newarrayiT(TypeInfo ti, size_t length) {
	return _newarray!(true, false)(ti, length);
}

// Description: Will allocate a uninitialized array of type ti with
//   the length given.
void[]_d_newarrayvT(TypeInfo ti, size_t length) {
	// Use the template, but do not initialize
	return _newarray!(false, false)(ti, length);
}

void[] _d_newarraymTp(TypeInfo ti, size_t[] dimensions) {
	return null;
}

void[] _d_newarraymiTp(TypeInfo ti, size_t[] dimensions) {
	return null;
}

// Description: Will delete an array.
// array: The array to delete.
void _d_delarray(void[] array) {
	if (array !is null) {
		gc_free(array.ptr);
	}
}

// Description: Will simply remove the memory pointed to a ptr.
// ptr: The pointer to the address to free.
void _d_delmemory(void* ptr) {
	if (ptr !is null) {
		gc_free(ptr);
	}
}

void _d_callfinalizer(void* p) {
	rt_finalize(p);
}

void rt_finalize(void* p, bool det = true) {
}

byte[] _d_arraysetlengthT(TypeInfo ti, size_t newlength, void[]* p) {
	return null;
}

byte[] _d_arraysetlengthiT(TypeInfo ti, size_t newlength, void[]* p) {
	return null;
}

void[] _d_arrayappendT(TypeInfo ti, void[]* px, byte[] y) {
	return null;
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

void[] _adDupT(TypeInfo ti, void[] a) {
	ubyte[] ret = (cast(ubyte*)_d_newarrayvT(ti, a.length))[0..a.length*ti.next.tsize()];
	ubyte[] array = (cast(ubyte*)a)[0..a.length*ti.next.tsize()];

	foreach(size_t idx, ref element; ret) {
		element = array[idx];
	}

	return ret;
}

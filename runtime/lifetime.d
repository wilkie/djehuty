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

import binding.c;

extern(C):

int printf(char*, ...);

Object _d_allocclass(ClassInfo ci) {
	byte[] mem = cast(byte[])GarbageCollector.malloc(ci.init.length);

    // Initialize it
    mem[0..$] = ci.init[];

    return cast(Object)mem.ptr;
}

void* _d_allocmemoryT(TypeInfo ti) {
	return gc_malloc(ti.tsize(), 0);
}

void _d_delinterface(Interface*** p) {
	if (p is null) {
		return;
	}

	// I do not know...
	Interface* pi = **p;
	Object o = cast(Object)(p - pi.offset);
	_d_delclass(o);
}

void _d_delclass(Object p) {
	if (p is null) {
		return;
	}

	// Object is a pointer to the object space
	// So, the classinfo pointer is the first entry in the Object
	// So, think of p as an Object*, and thus as a ClassInfo**
	ClassInfo** pc = cast(ClassInfo**)p;

	// Does the class have a classinfo pointer?
	if (*pc !is null) {
		ClassInfo c = **pc;
		rt_finalize(cast(void*)p);

		// Call the deallocator
		if (c.deallocator !is null) {
			void function(Object) deallocator;
			deallocator = cast(void function(Object))c.deallocator;
			deallocator(p);
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

					foreach(ref element; ret) {
						element = init[initIndex];
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
void[] _d_newarrayT(TypeInfo ti, size_t length) {
	// Use the template, initialize the array with 0
	return _newarray!(true, true)(ti, length);
}

// Description: Will allocate a new array of type ti with the length
//   given, and will initialize it to a given value.
// ti: The TypeInfo object that represents the array to be allocated.
//   The init() function within the TypeInfo will be used to initialize
//   the array.
// length: The number of elements in the array to be allocated.
void[] _d_newarrayiT(TypeInfo ti, size_t length) {
	return _newarray!(true, false)(ti, length);
}

// Description: Will allocate a uninitialized array of type ti with
//   the length given.
// ti: The TypeInfo object that represents the array to be allocated.
// length: The number of elements in the array to be allocated.
void[] _d_newarrayvT(TypeInfo ti, size_t length) {
	// Use the template, but do not initialize
	return _newarray!(false, false)(ti, length);
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

void[] _d_newarraymT(TypeInfo ti, size_t[] dimensions) {
	return _newarraym!(true, true)(ti, dimensions);
}

void[] _d_newarraymiT(TypeInfo ti, size_t[] dimensions) {
	return _newarraym!(true, false)(ti, dimensions);
}

void[] _d_newarraymvT(TypeInfo ti, size_t[] dimensions) {
	return _newarraym!(false, false)(ti, dimensions);
}

// Description: Will delete an array.
// array: The array to delete.
void _d_delarray(ubyte[] array) {
	if (array !is null) {
		GarbageCollector.free(array);
	}
}

// Description: Will simply remove the memory pointed to a ptr.
// ptr: The pointer to the address to free.
void _d_delmemory(ubyte* ptr) {
	if (ptr !is null) {
		gc_free(ptr);
	}
}

void _d_callfinalizer(void* p) {
	rt_finalize(p);
}

void rt_finalize(void* p, bool det = true) {
}

private template _arraysetlength(bool initWithZero) {
	ubyte* _arraysetlength(TypeInfo ti, size_t length, size_t oldLength, ubyte* oldData) {
		size_t elementSize = ti.next.tsize();

		size_t newSize = length * elementSize;
		size_t oldSize = oldLength * elementSize;
		size_t memorySize;
	   
		if (oldData is null) {
			memorySize = oldSize;
		}
		else {
			memorySize = GarbageCollector.query(oldData[0..oldSize]);
		}

		ubyte[] newArray;

		if (newSize == oldSize) {
			return oldData;
		}

		if (newSize == 0) {
			return null;
		}

		if (memorySize <= newSize) {
			if (newSize < oldSize * 2) {
				newSize = oldSize * 2;
			}

			newArray = GarbageCollector.malloc(newSize);

			if (oldSize != 0) {
				newArray[0..oldSize] = oldData[0..oldSize];
			}
		}
		else {
			// just resize
			newArray = oldData[0..newSize];
		}

		// No need to initialize for truncation.
		if (newSize < oldSize) {
			return newArray.ptr;
		}

		// Initialize the new space
		static if (initWithZero) {
			// Initialize the remaining space with zero
			newArray[oldSize..newSize] = 0;
		}
		else {
			// Initialize the remaining space with the init value from ti
			ubyte[] init = cast(ubyte[])ti.next.init();

			// If there is no init vector, then just init to zero
			if (init is null) {
				newArray[oldSize..newSize] = 0;
			}
			else {
				// Initialize all values we can
				size_t initIndex = 0;

				foreach(ref element; newArray[oldSize..newSize]) {
					element = init[initIndex];
					initIndex++;
					if (initIndex == init.length) {
						initIndex = 0;
					}
				}
			}
		}

		return newArray.ptr;
	}
}

// Description: This runtime function will be called when the length of an
//   array is updated. It will allocate extra space if necessary and will
//   initialize new entries to 0.
// ti: The TypeInfo the represents the base type of the array.
// length: The updated length for the array.
// oldLength: The current length of the array.
// oldData: The pointer to the current array data.
// Returns: The updated pointer of the array data.
ubyte* _d_arraysetlengthT(TypeInfo ti, size_t length, size_t oldLength, ubyte* oldData) {
	return _arraysetlength!(true)(ti, length, oldLength, oldData);
}

// Description: This runtime function will be called when the length of an
//   array is updated. It will allocate extra space if necessary and will
//   initialize new entries to those indicated in the TypeInfo's init array.
// ti: The TypeInfo the represents the base type of the array.
// length: The updated length for the array.
// oldLength: The current length of the array.
// oldData: The pointer to the current array data.
// Returns: The updated pointer of the array data.
ubyte* _d_arraysetlengthiT(TypeInfo ti, size_t length, size_t oldLength, ubyte* oldData) {
	return _arraysetlength!(false)(ti, length, oldLength, oldData);
}

// Description: This runtime function will append two arrays.
// destArray: This is the array that will receive the concatonation.
// srcArray: This is the array that will be concatonated.
// Returns: The updated array.
ubyte[] _d_arrayappendT(TypeInfo ti, ref ubyte[] destArray, ubyte[] srcArray) {
	size_t memorySize;
	size_t elementSize = ti.next.tsize();

	size_t oldLength = destArray.length;
	size_t newSize = (destArray.length + srcArray.length) * elementSize;
	size_t oldSize = oldLength * elementSize;

	if (destArray is null) {
		memorySize = oldSize;
	}
	else {
		memorySize = GarbageCollector.query(destArray);
	}

	ubyte[] newArray;
	if (memorySize <= newSize) {
		if (newSize < oldSize * 2) {
			newSize = oldSize * 2;
		}
		newArray = GarbageCollector.malloc(newSize);
		if (oldSize > 0) {
			newArray[0..oldSize] = destArray.ptr[0..oldSize];
		}
	}
	else {
		// just resize
		newArray = destArray.ptr[0..newSize];
	}

	// Add element
	for(uint destIdx = oldLength * elementSize; destIdx < newSize; ) {
		for(uint srcIdx = 0; srcIdx < srcArray.length * elementSize; srcIdx++) {
			newArray[destIdx] = srcArray[srcIdx];
			destIdx++;
		}
	}

	destArray = (newArray.ptr)[0..oldLength+srcArray.length];

	return destArray;
}

// Description: This runtime function will append a single element to an
//   array.
// ti: The TypeInfo of the base type of this array.
// array: The array to append the element.
// element: The element to append.
ubyte[] _d_arrayappendcT(TypeInfo ti, ref ubyte[] array, ubyte* element) {
	if (element is null) {
		return array;
	}

	size_t memorySize;
	size_t elementSize = ti.next.tsize();

	size_t oldLength = array.length;
	size_t newSize = (array.length + 1) * elementSize;
	size_t oldSize = oldLength * elementSize;

	if (oldSize == 0) {
		memorySize = oldSize;
	}
	else {
		memorySize = GarbageCollector.query(array);
	}

	ubyte[] newArray;

	if (memorySize <= newSize) {
		if (newSize < oldSize * 2) {
			newSize = oldSize * 2;
		}
		newArray = GarbageCollector.malloc(newSize);
		if (oldSize > 0) {
			newArray[0..oldSize] = array.ptr[0..oldSize];
		}
	}
	else {
		// just resize
		newArray = array.ptr[0..newSize];
	}

	// Add element
	for(uint i = 0; i < elementSize; i++) {
		newArray[oldSize+i] = element[i];
	}

	// Update length
	// Oddly, you have to also point the parameter array to the new array
	newArray = newArray[0..oldLength+1];
	array = newArray;
	return newArray;
}

byte[] _d_arraycatT(TypeInfo ti, byte[] x, byte[] y) {
	return null;
}

byte[] _d_arraycatnT(TypeInfo ti, uint n, ...) {
	return null;
}

ubyte[] _adDupT(TypeInfo ti, ubyte[] a) {
	if (a is null) {
		return null;
	}

	ubyte[] ret = (cast(ubyte*)_d_newarrayvT(ti, a.length))[0..a.length*ti.next.tsize()];
	ubyte[] array = a.ptr[0..a.length*ti.next.tsize()];

	ret[0..$] = array[0..$];

	return ret.ptr[0..a.length];
}

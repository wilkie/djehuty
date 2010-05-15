/*
 * array.d
 *
 * This module implements the runtime functions related
 * to arrays.
 *
 */

module runtime.array;

import core.unicode;

import data.iterable;

import runtime.common;
import math.random;

import core.util;
import io.console;

// Arrays in D are represented as such:

// align(size_t.sizeof)
// struct Array {
//   size_t length;
//   void* ptr;
// }

extern(C):

// Description: This runtime function reverses a char array in place and is invoked with
//   the reverse property: array.reverse
// Returns: The reference to the input.
char[] _adReverseChar(char[] a) {
	return a.reverse();
}

// Description: This runtime function reverses a wchar array in place and is invoked with
//   the reverse property: array.reverse
// Returns: The reference to the input.
wchar[] _adReverseWchar(wchar[] a) {
	return a.reverse();
}

// Description: This runtime function reverses an array in place and
//   is invoked with the reverse property: array.reverse
// array: The generic array struct that contains the array items.
// elementSize: The size of an individual element.
// Returns: The reference to the input.
void[] _adReverse(ubyte[] array, size_t elementSize) {
	size_t front, end;

	// Go from front to end, and swap each index

	// Note: Since the array passed has a length measured in a factor
	//   of elementSize, we need to account for that when we treat
	//   it is a byte array.

	if (array.length == 0) {
		return array;
	}

	front = 0;
	end = array.length * elementSize;
	ubyte[] cmp = (array.ptr)[0..end];
	end -= elementSize;

	while(front < end) {
		for(size_t i=0; i < elementSize; i++) {
			// xor swap elements
			cmp[i+front] ^= cmp[i+end];
			cmp[i+end] ^= cmp[i+front];
			cmp[i+front] ^= cmp[i+end];
		}
		front += elementSize;
		end -= elementSize;
	}

	return array;
}

// Description: This runtime function will compare two arrays.
// Returns: 0 when equal, positive when first array is larger, negative otherwise.
int _adCmp(void[] a1, void[] a2, TypeInfo ti) {
	return ti.compare(&a1, &a2);
}

// Description: This runtime function will compare two utf8 arrays.
// Returns: 0 when equal, positive when first array is larger, negative otherwise.
int _adCmpChar(void[] a1, void[] a2) {
	return _adCmp(a1, a2, typeid(char));
}

// Description: This runtime function will compare two arrays for equality.
// Returns: 1 when equal, 0 otherwise
int _adEq(void[] a1, void[] a2, TypeInfo ti) {
	return ti.equals(&a1, &a2);
}

// Description: This runtime function sorts an array and is invoked with
// the sort property: array.sort
ubyte[] _adSort(ubyte[] array, TypeInfo ti) {
	if (array is null) {
		return null;
	}

	ubyte[] cmp = (array.ptr)[0..array.length * ti.tsize()];
	_qsort(cmp, ti.tsize(), ti);
	return array;
}

// Special quicksort implementation
private void _qsort(ubyte[] array, size_t size, TypeInfo ti, Random rnd = null) {
	if (rnd is null) {
		rnd = new Random();
	}

	// Base case
	if ((array.length/size) < 2) {
		return;
	}

	// Selecting a pivot
	size_t length = array.length / size;
	size_t element = cast(size_t)rnd.nextLong(length);
	element *= size;
	//Console.putln("pivot: ", element/size, " array.length: ", array.length/size);

	// Move things
	size_t end = array.length - size;
	for(size_t i = 0; i < array.length; i += size) {
		if (i == element) {
			continue;
		}
		if (i > end) {
			break;
		}
		// compare array[i..i+size] to array[element..element+size]
		// if < and i < element
		//    Just continue (this is normal)
		// if < and i > element
		//    Swap i and element ('i' can only be the next element, that is, element+size)
		// if > and end == element
		//    Swap i and element (This will place element to the left of 'i'), decrement end
		// if > and end > element
		//    Swap i with end, decrement end (this is normal)
		int cmp = ti.compare(&array[i], &array[element]);
		//Console.putln("comparing ", i/size, " against ", element/size, " : ", cmp);
		if (cmp < 0) {
			// array[i] < array[element]
			if (i > element) {
				// swap with element
				for(size_t idx; idx < size; idx++) {
					array[i+idx] ^= array[element+idx];
					array[element+idx] ^= array[i+idx];
					array[i+idx] ^= array[element+idx];
				}
				element = i;
			}
		}
		else if (cmp > 0) {
			if (end > element) {
				if (end != i) {
					for(size_t idx; idx < size; idx++) {
						array[i+idx] ^= array[end+idx];
						array[end+idx] ^= array[i+idx];
						array[i+idx] ^= array[end+idx];
					}
				}
				// we need to compare with the item at end
				i -= size;
			}
			else {
				// swap with element
				for(size_t idx; idx < size; idx++) {
					array[i+idx] ^= array[element+idx];
					array[element+idx] ^= array[i+idx];
					array[i+idx] ^= array[element+idx];
				}
				element = i;
			}
			end -= size;
		}
	}

	_qsort(array[0..element], size, ti, rnd);
	_qsort(array[element+size..$], size, ti, rnd);
}//*/

// Description: This runtime function sorts a char array and is invoked with
// the sort property: array.sort
ubyte[] _adSortChar(ubyte[] array) {
	return _adSort(array, typeid(char[]));
}

// Description: This runtime function sorts a wchar array and is invoked with
// the sort property: array.sort
ubyte[] _adSortWchar(ubyte[] array) {
	return _adSort(array, typeid(wchar[]));
}

private template _array_init(T) {
	void _array_init(T[] array, T value) {
		foreach(ref element; array) {
			element = value;
		}
	}
}

void _d_array_init_i1(bool* array, size_t length, bool value) {
	_array_init(array[0..length], value);
}

void _d_array_init_i8(ubyte* array, size_t length, ubyte value) {
	_array_init(array[0..length], value);
}

void _d_array_init_i16(ushort* array, size_t length, ushort value) {
	_array_init(array[0..length], value);
}

void _d_array_init_i32(uint* array, size_t length, uint value) {
	_array_init(array[0..length], value);
}

void _d_array_init_i64(ulong* array, size_t length, ulong value) {
	_array_init(array[0..length], value);
}

void _d_array_init_float(float* array, size_t length, float value) {
	_array_init(array[0..length], value);
}

void _d_array_init_double(double* array, size_t length, double value) {
	_array_init(array[0..length], value);
}

void _d_array_init_pointer(void** array, size_t length, void* value) {
	_array_init(array[0..length], value);
}

void _d_array_init_cdouble(cdouble* array, size_t length, cdouble value) {
	_array_init(array[0..length], value);
}

void _d_array_init_mem(ubyte* array, size_t length, ubyte* value, size_t valueLength) {
	if (valueLength == 0 || length == 0) {
		return;
	}

	ubyte[] cmp = array[0..length*valueLength];

	size_t valueIndex = 0;
	foreach(ref element; cmp) {
		element = value[valueIndex];
		valueIndex++;
		if (valueIndex == valueLength) {
			valueIndex = 0;
		}
	}
}

size_t _d_array_cast_len(size_t length, size_t elementSize, size_t newElementSize) {
	if (newElementSize == 1) {
		return length * elementSize;
	}
	else if (length % newElementSize != 0) {
		// Probably bad
	}

	return (length * elementSize) / newElementSize;
}

// Description: This runtime function will simply set the length to reflect storing a different type.
ubyte[] _d_arraycast(size_t toElementSize, size_t fromElementSize, ubyte[] array) {
	if (toElementSize == fromElementSize) {
		return array;
	}

	if (toElementSize == 0) {
		// Technically does not divide evenly
		throw new Exception("Array cast misalignment");
	}

	size_t numbytes = array.length * fromElementSize;

	// Can we divide this array up into equal parts of the new elements?
	if (numbytes % toElementSize != 0) {
		// Error
		throw new Exception("Array cast misalignment");
	}
	
	size_t newLength = numbytes / toElementSize;

	// Return the updated array length
	return array.ptr[0..newLength];
}

byte[] _d_arraycopy(size_t size, byte[] from, byte[] to) {
	// The arrays should be of equal size
	if (to.length != from.length) {
		throw new Exception("Length mismatch for array copy");
	}

	// Get the memory bounds for the array
	byte* toEnd = to.ptr + (to.length * size);
	byte* fromEnd = from.ptr + (from.length * size);

	// Check for overlapping copy
	if (toEnd > from.ptr && fromEnd > to.ptr) {
		// Overlapping...
		throw new Exception("Array copy overlaps");
	}

	// Perform the copy
	foreach(size_t idx, ref element; to) {
		element = from[idx];
	}

	return to;
}

void _d_array_slice_copy(ubyte* dst, size_t dstLength, ubyte* src, size_t srcLength) {
	if (dstLength != srcLength) {
		throw new Exception("Length mismatch for array copy");
	}
	
	if (dst + dstLength > src && src + srcLength > dst) {
		// Overlapping copy
		throw new Exception("Array copy overlaps");
	}

	// Perform the copy
	foreach(size_t idx, ref element; dst[0..dstLength]) {
		element = src[idx];
	}
}
//*/

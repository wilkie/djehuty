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
	ubyte[] cmp = (array.ptr)[0..array.length * ti.tsize()];
	qsort(cmp, ti.tsize(), ti);
	return array;
}

// Special quicksort implementation
private void qsort(ubyte[] array, size_t size, TypeInfo ti, Random rnd = null) {
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

	qsort(array[0..element], size, ti, rnd);
	qsort(array[element+size..$], size, ti, rnd);
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

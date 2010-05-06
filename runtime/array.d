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
void[] _adSort(void[] a, TypeInfo ti) {
	return a;
}

// Description: This runtime function sorts a char array and is invoked with
// the sort property: array.sort
char[] _adSortChar(char[] a) {
	return a;
}

// Description: This runtime function sorts a wchar array and is invoked with
// the sort property: array.sort
wchar[] _adSortWchar(wchar[] a) {
	return a;
}

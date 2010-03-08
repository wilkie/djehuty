/*
 * array.d
 *
 * This module implements the runtime functions related
 * to arrays.
 *
 */

module runtime.array;

extern(C):

// Description: This runtime function reverses a char array and is invoked with
// the reverse property: array.reverse
char[] _adReverseChar(char[] a) {
	return null;
}

// Description: This runtime function reverses a wchar array and is invoked with
// the reverse property: array.reverse
wchar[] _adReverseWchar(wchar[] a) {
	return null;
}

// Description: This runtime function reverses an array and
// is invoked with the reverse property: array.reverse
Array _adReverse(Array a, size_t szelem) {
	return a;
}

// Description: This runtime function will compare two arrays.
// Returns: 0 when equal, positive when first array is larger, negative otherwise.
int _adCmp(Array a1, Array a2, TypeInfo ti) {
	return 0;
}

int _adCmpChar(Array a1, Array a2) {
	return 0;
}

// Description: This runtime function will compare two arrays for equality.
// Returns: 1 when equal, 0 otherwise
int _adEq(Array a1, Array a2, TypeInfo ti) {
	return 1;
}

// Description: This runtime function sorts an array and is invoked with
// the sort property: array.sort
Array _adSort(Array a, TypeInfo ti) {
	return a;
}

// Description: This runtime function sorts a char array and is invoked with
// the sort property: array.sort
char[] _adSortChar(char[] a) {
	return null;
}

// Description: This runtime function sorts a wchar array and is invoked with
// the sort property: array.sort
wchar[] _adSortWchar(wchar[] a) {
	return null;
}

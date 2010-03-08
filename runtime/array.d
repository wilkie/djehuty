/*
 * array.d
 *
 * This module implements the runtime functions related
 * to arrays.
 *
 */

module runtime.array;

extern(C):

char[] _adReverseChar(char[] a) {
	return null;
}

wchar[] _adReverseWchar(wchar[] a) {
	return null;
}

int _adCmpChar(Array a1, Array a2) {
	return 0;
}

Array _adReverse(Array a, size_t szelem) {
	return a;
}

int _adEq(Array a1, Array a2, TypeInfo ti) {
	return 1;
}

int _adCmp(Array a1, Array a2, TypeInfo ti) {
	return 0;
}

Array _adSort(Array a, TypeInfo ti) {
	return a;
}


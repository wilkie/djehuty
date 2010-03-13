/*
 * assocarray.d
 *
 * This module implements the D runtime functions that involve
 * associative arrays.
 *
 */

module runtime.assocarray;

import runtime.common;

extern(C):

// Description: This runtime function will determine the number of entries in
//   an associative array.
// Returns: The number of entries in the array.
size_t _aaLen(AA aa) {
	return 0;
}

// Description: This runtime function will return a pointer to the value
//   in an associative array at a particular key and add the entry if
//   it does not exist.
// Returns: A pointer to the value associated with the given key.
void* _aaGetp(AA* aa, TypeInfo keyti, size_t valuesize, void* pkey) {
	return null;
}

void* _aaGetRvaluep(AA aa, TypeInfo keyti, size_t valuesize, void* pkey) {
	return null;
}

// Description: This runtime function will get a pointer to a value in an
//   associative array indexed by a key. Invoked via "aa[key]" and "key in aa".
// Returns: null when the value is not in aa, the pointer to the value
//   otherwise.
void* _aaInp(AA aa, TypeInfo keyti, void* pkey) {
	return null;
}

// Description: This runtime function will delete a value with the given key.
//   It will do nothing if the value does not exist.
void _aaDelp(AA aa, TypeInfo keyti, void* pkey) {
}

// Description: This runtime function will produce an array of values for
//   an associative array.
// Returns: An array of values.
Array _aaValues(AA aa, size_t keysize, size_t valuesize) {
	Array r;
	return r;
}

// Description: This runtime function will rehash an associative array.
AA _aaRehash(AA* paa, TypeInfo keyti) {
	AA r;
	return r;
}

// Description: This runtime function will produce an array of keys of an
//   associative array.
// Returns: An array of keys.
Array _aaKeys(AA aa, size_t keysize) {
	Array r;
	return r;
}

// Description: This runtime function will handle a foreach for an associative
//   array invoked as foreach(foo; aa).
int _aaApply(AA aa, size_t keysize, aa_dg_t dg) {
	return 0;
}

// Description: This runtime function will handle a foreach_reverse for an
// associative array invoked as foreach_reverse(foo; aa).
int _aaApply2(AA aa, size_t keysize, aa_dg2_t dg) {
	return 0;
}

BB* _d_assocarrayliteralTp(TypeInfo_AssociativeArray ti, size_t length, 
		void* keys, void* values) {
	return null;
}

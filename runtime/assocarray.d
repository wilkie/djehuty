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

struct aaA {
	aaA* left;
	aaA* right;
	hash_t hash;
	//  key  //
	// value //
}

struct BB {
	aaA*[] b;
	size_t nodes;
	TypeInfo keyti;
}

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
void* _aaGet(BB* aa, TypeInfo keyti, size_t valuesize, void* pkey) {
	return null;
}

void* _aaGetRvalue(BB aa, TypeInfo keyti, size_t valuesize, void* pkey) {
	return null;
}

// Description: This runtime function will get a pointer to a value in an
//   associative array indexed by a key. Invoked via "aa[key]" and "key in aa".
// Returns: null when the value is not in aa, the pointer to the value
//   otherwise.
void* _aaIn(BB aa, TypeInfo keyti, void* pkey) {
	return null;
}

// Description: This runtime function will delete a value with the given key.
//   It will do nothing if the value does not exist.
void _aaDel(BB aa, TypeInfo keyti, void* pkey) {
}

// Description: This runtime function will produce an array of values for
//   an associative array.
// Returns: An array of values.
void[] _aaValues(BB aa, size_t keysize, size_t valuesize) {
	return null;
}

// Description: This runtime function will rehash an associative array.
BB _aaRehash(BB* paa, TypeInfo keyti) {
	BB ret;
	return ret;
}

// Description: This runtime function will produce an array of keys of an
//   associative array.
// Returns: An array of keys.
void[] _aaKeys(BB aa, size_t keysize) {
	return null;
}

// Description: This runtime function will handle a foreach for an associative
//   array invoked as foreach(foo; aa).
extern (D) typedef int delegate(void *) dg_t;
int _aaApply(BB aa, size_t keysize, dg_t dg) {
	return 0;
}

// Description: This runtime function will handle a foreach_reverse for an
// associative array invoked as foreach_reverse(foo; aa).
extern (D) typedef int delegate(void *, void *) dg2_t;
int _aaApply2(BB aa, size_t keysize, dg2_t dg) {
	return 0;
}

BB* _d_assocarrayliteralT(TypeInfo_AssociativeArray ti, size_t length, 
		void* keys, void* values) {
	return null;
}

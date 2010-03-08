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

size_t _aaLen(AA aa) {
	return 0;
}

void* _aaGetp(AA* aa, TypeInfo keyti, size_t valuesize, void* pkey) {
	return null;
}

void* _aaGetRvaluep(AA aa, TypeInfo keyti, size_t valuesize, void* pkey) {
	return null;
}

void* _aaInp(AA aa, TypeInfo keyti, void* pkey) {
	return null;
}

void _aaDelp(AA aa, TypeInfo keyti, void* pkey) {
}

Array _aaValues(AA aa, size_t keysize, size_t valuesize) {
	Array r;
	return r;
}

AA _aaRehash(AA* paa, TypeInfo keyti) {
	AA r;
	return r;
}

Array _aaKeys(AA aa, size_t keysize) {
	Array r;
	return r;
}

int _aaApply(AA aa, size_t keysize, aa_dg_t dg) {
	return 0;
}

int _aaApply2(AA aa, size_t keysize, aa_dg2_t dg) {
	return 0;
}

BB* _d_assocarrayliteralTp(TypeInfo_AssociativeArray ti, size_t length, 
		void* keys, void* values) {
	return null;
}

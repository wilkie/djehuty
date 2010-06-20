/*
 * bullshit.d
 *
 * Contains all of the DMD bullshit that is not really necessary but exists
 * to test my will and patience.
 *
 */

module compiler.dmd.bullshit;

import runtime.lifetime;
import runtime.assocarray;
import runtime.gc;

import binding.c;

extern(C):

// Wraps the better named _d_allocclass
Object _d_newclass(ClassInfo ci) {
	return _d_allocclass(ci);
}

// Silly function that does not need to exist
void _moduleCtor() {
	// Will be done in main just fine...
}

// Another silly function
void _moduleUnitTests() {
	// Will be done in main just fine...
}

// This is already implemented as some other function
ubyte* _aaGetRvalue(ref AssocArray* aa, TypeInfo keyti, size_t valuesize, ubyte* pkey) {
	return _aaIn(*aa, keyti, pkey);
}

// Silly unnecessary function that uses variadics
void* _d_arrayliteralT(TypeInfo ti, size_t length, ...) {
    auto sizeelem = ti.next.tsize();		// array element size
    ubyte* result;

    if (length == 0 || sizeelem == 0) {
		result = null;
	}
    else {
		result = GarbageCollector.malloc(length * sizeelem).ptr;

		Cva_list q;
		Cva_start!(size_t)(q, length);

		size_t stacksize = (sizeelem + int.sizeof - 1) & ~(int.sizeof - 1);

		if (stacksize == sizeelem) {
			size_t cpylen = length * sizeelem;
			result[0..cpylen] = (cast(ubyte*)q)[0..cpylen];
		}
		else {
		    for (size_t i = 0; i < length; i++) {
		    	ubyte* reference = result + (i * sizeelem);
		    	reference[0..sizeelem] = (cast(ubyte*)q)[0..sizeelem];
				q += stacksize;
		    }
		}

		Cva_end(q);
    }
    return result;
}
/*
 * object.d
 *
 * This module implements the Object class.
 *
 */

module object;

import runtime.util;

// Figure out the size of a pointer
static if ((ubyte*).sizeof == 8) {
	version = Arch64;
}
else static if ((ubyte*).sizeof == 4) {
	version = Arch32;
}

// Pointer sizes
version(Arch32) {
	alias uint size_t;
	alias int ptrdiff_t;
	alias uint hash_t;
}
else {
	alias ulong size_t;
	alias long ptrdiff_t;
	alias ulong hash_t;
}

// String types
alias char[] string;
alias wchar[] wstring;
alias dchar[] dstring;

// Description: The base class inherited by all classes.
class Object {

	void dispose() {
	}

	// Description: Returns a string representing this object.
	char[] toString() {
		return this.classinfo.name;
	}

	// Description: Computes a hash representing this object
	hash_t toHash() {
		// Hash the pointer
		return hash(cast(hash_t)this);
	}

	// Description: Will compare two Object classes
	// Returns: 0 if equal, -1 if o is greater, 1 if o is smaller.
	int opCmp(Object o) {
		return 0;
	}

	// Description: Will compare two Object classes for equality. Defaults
	//   to a comparing references.
	// Returns: 0 if not equal.
	int opEquals(Object o) {
		return cast(int)(this is o);
	}
}

// Description: This is the information stored for an interface.
struct Interface {
	ClassInfo classinfo;		// .classinfo for this interface (not for containing class)
	void *[] vtbl;
	ptrdiff_t offset; 				// offset to Interface 'this' from Object 'this'
}

// Description: The information stored for a class. Retrieved via the .classinfo property.
//  It is stored as the first entry in the class' vtbl[].
class ClassInfo : Object {
	byte[] init;

	string name;
	void*[] vtbl;

	Interface[] interfaces;

	ClassInfo base;
	void* destructor;	
	void* classInvariant;

	uint flags;
	void* deallocator;
	OffsetTypeInfo[] offTi;

	void* defaultConstructor;

	TypeInfo typeinfo;

	static ClassInfo find(string classname) {
		// Loop through every module
		// Then loop through every class
		// Trying to find the class
		return null;
	}

	Object create() {
		// Class factory
		return null;
	}
}

public import runtime.typeinfo;

public import runtime.typeinfos.ti_array;
public import runtime.typeinfos.ti_array_bool;
public import runtime.typeinfos.ti_array_byte;
public import runtime.typeinfos.ti_array_cdouble;
public import runtime.typeinfos.ti_array_cfloat;
public import runtime.typeinfos.ti_array_char;
public import runtime.typeinfos.ti_array_creal;
public import runtime.typeinfos.ti_array_dchar;
public import runtime.typeinfos.ti_array_double;
public import runtime.typeinfos.ti_array_float;
public import runtime.typeinfos.ti_array_idouble;
public import runtime.typeinfos.ti_array_ifloat;
public import runtime.typeinfos.ti_array_int;
public import runtime.typeinfos.ti_array_ireal;
public import runtime.typeinfos.ti_array_long;
public import runtime.typeinfos.ti_array_object;
public import runtime.typeinfos.ti_array_real;
public import runtime.typeinfos.ti_array_short;
public import runtime.typeinfos.ti_array_ubyte;
public import runtime.typeinfos.ti_array_uint;
public import runtime.typeinfos.ti_array_ulong;
public import runtime.typeinfos.ti_array_ushort;
public import runtime.typeinfos.ti_array_void;
public import runtime.typeinfos.ti_array_wchar;
public import runtime.typeinfos.ti_assocarray;
//public import runtime.typeinfos.ti_bool;
public import runtime.typeinfos.ti_byte;
public import runtime.typeinfos.ti_cdouble;
public import runtime.typeinfos.ti_cfloat;
public import runtime.typeinfos.ti_char;
public import runtime.typeinfos.ti_creal;
public import runtime.typeinfos.ti_dchar;
public import runtime.typeinfos.ti_delegate;
public import runtime.typeinfos.ti_double;
public import runtime.typeinfos.ti_enum;
public import runtime.typeinfos.ti_float;
public import runtime.typeinfos.ti_function;
public import runtime.typeinfos.ti_idouble;
public import runtime.typeinfos.ti_ifloat;
public import runtime.typeinfos.ti_int;
public import runtime.typeinfos.ti_interface;
public import runtime.typeinfos.ti_ireal;
public import runtime.typeinfos.ti_long;
public import runtime.typeinfos.ti_object;
public import runtime.typeinfos.ti_ptr;
public import runtime.typeinfos.ti_real;
public import runtime.typeinfos.ti_short;
public import runtime.typeinfos.ti_staticarray;
public import runtime.typeinfos.ti_struct;
public import runtime.typeinfos.ti_tuple;
public import runtime.typeinfos.ti_typedef;
public import runtime.typeinfos.ti_ubyte;
public import runtime.typeinfos.ti_uint;
public import runtime.typeinfos.ti_ulong;
public import runtime.typeinfos.ti_ushort;
public import runtime.typeinfos.ti_void;
public import runtime.typeinfos.ti_wchar;

public import runtime.moduleinfo;

public import core.exception;

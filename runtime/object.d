/*
 * object.d
 *
 * This module implements the Object class.
 *
 */

module object;

// Imports necessary routines used by the runtime
import runtime.util;
import runtime.dstatic;
import runtime.dstubs;
import runtime.exception;
import runtime.error;

public import runtime.types;
public import runtime.classinfo;
public import runtime.typeinfo;

// Description: The base class inherited by all classes.
class Object {

	// Description: Returns a string representing this object.
	char[] toString() {
		return this.classinfo.name;
	}

	// Description: Computes a hash representing this object
	hash_t toHash() {
		string hashStr = (toStr(&this) ~ this.classinfo.name);

		hash_t hash = 0;
		foreach(chr; hashStr) {
			hash *= 9;
			hash += cast(ubyte)chr;
		}
	}

	// Will compare two Object classes
	// Returns: 0 if equal, -1 if o is greater, 1 if o is smaller.
	int opCmp(Object o) {
		// BUG: this prevents a compacting GC from working, needs to be fixed
		//return cast(int)cast(void *)this - cast(int)cast(void *)o;

		throw new Error("need opCmp for class " ~ this.classinfo.name);
	}

	// Will compare two Object classes for equality.
	// Returns: 0 if not equal.
	int opEquals(Object o) {
		return cast(int)(this is o);
	}
}

// Description: This is the information stored for an interface.
struct Interface {
	ClassInfo classinfo;		// .classinfo for this interface (not for containing class)
	void *[] vtbl;
	int offset; 				// offset to Interface 'this' from Object 'this'
}

public import djehuty;

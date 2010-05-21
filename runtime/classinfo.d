module runtime.classinfo;

import core.string;
import core.definitions;

// Description: The information stored for a class. Retrieved via the .classinfo property.
//  It is stored as the first entry in the class' vtbl[].
class ClassInfo {
	byte[] init;

	string name;
	void*[] vtbl;

	Interface[] interfaces;

	ClassInfo base;
	void function() destructor;	
	void function(Object) classInvariant;

	uint flags;
	void function() deallocator;
	OffsetTypeInfo[] offTi;

	Object function() defaultConstructor;

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

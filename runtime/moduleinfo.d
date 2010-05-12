module runtime.moduleinfo;

// Description: This class describes a D module.
class ModuleInfo : Object {
	string name() {
		return _name.dup;
	}

	int opApply(int delegate(ref ModuleInfo) loopBody) {
		int ret = 0;

		foreach(mod; _importedModules) {
			ret = loopBody(mod);
			if(ret) {
				break;
			}
		}

		return ret;
	}

	int opApply(int delegate(ref ClassInfo) loopBody) {
		int ret = 0;

		foreach(lclass; _localClasses) {
			ret = loopBody(lclass);
			if(ret) {
				break;
			}
		}

		return ret;
	}

	static ModuleInfo[] modules() {
		return _modules.dup;
	}

package:
	string _name;
	ModuleInfo[] _importedModules;
	ClassInfo[] _localClasses;

	// For Cycle Dependency
	uint flags;

	// Constructors, Deconstructors
	void function() ctor;
	void function() dtor;
	void function() unitTest;

	// Special functions
	void* xgetMembers;

	// Module Independent Constructor
	void function() ictor;

package:
	static ModuleInfo[] _modules;
	static ModuleInfo[] _dtors;
}

package:

// This linked list is created by a compiler generated function inserted
// into the .ctor list by the compiler.
struct ModuleReference {
    ModuleReference* next;
    ModuleInfo       mod;
}

// Start of the module linked list
extern (C) ModuleReference* _Dmodule_ref;

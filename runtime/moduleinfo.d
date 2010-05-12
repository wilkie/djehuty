module runtime.moduleinfo;

// Description: This class describes a D module.
class ModuleInfo : Object {
	string name;
	ModuleInfo[] importedModules;
	ClassInfo[] localClasses;

	uint flags;

	void function() ctor;
	void function() dtor;
	void function() unitTest;

	void* xgetMembers;
	void function() ictor;

	static int opApply(int delegate(ref ModuleInfo) loopBody) {
		int ret = 0;

		foreach(mod; _modules) {
			ret = loopBody(mod);
			if(ret) {
				break;
			}
		}

		return ret;
	}

	ModuleInfo[] modules() {
		return _modules.dup;
	}

private:
	static ModuleInfo[] _modules;
}

// This linked list is created by a compiler generated function inserted
// into the .ctor list by the compiler.
struct ModuleReference {
    ModuleReference* next;
    ModuleInfo       mod;
}
extern (C) ModuleReference* _Dmodule_ref;   // start of linked list

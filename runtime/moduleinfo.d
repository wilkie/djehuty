module runtime.moduleinfo;

import core.definitions;

class ModuleInfo {
	string name;
	ModuleInfo[] importedModules;

	uint flags;

	void function() ctor;
	void function() dtor;
	void function() unitTest;

	void* xgetMembers;
	void function() ictor;

	static int opApply(int delegate(ref ModuleInfo)) {
	}
}

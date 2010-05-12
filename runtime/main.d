/*
 * main.d
 *
 * This module provides the C entry into the application.
 *
 */

module runtime.main;

import runtime.gc;
import runtime.moduleinfo;

import core.error;

// The user supplied D entry
int main(char[][] args);

// Description: This function is the main entry point of the application.
// argc: The number of arguments
// argv: An array of strings that specify the arguments.
// Returns: The error code for the application.
import binding.c;

// Initializes data structures to aid in calling module constructors
private void moduleInfoInitialize() {
	// Take the linked list of modules and load them into an array
	ModuleReference* mod = _Dmodule_ref;

	size_t moduleCount = 0;
	while(mod !is null) {
		mod = mod.next;
		moduleCount++;
	}

	ModuleInfo._modules = new ModuleInfo[moduleCount];

	mod = _Dmodule_ref;

	size_t idx = 0;
	while(mod !is null) {
		ModuleInfo._modules[idx] = mod.mod;
		idx++;
		mod = mod.next;
	}

	ModuleInfo._dtors = new ModuleInfo[moduleCount];
	
}

// Those module constructors that do not depend on other
// constructors being called.
private void moduleIndependentConstructors() {
	// Call Module Independent Constructors
	foreach(modInfo; ModuleInfo._modules) {
		if (modInfo !is null && modInfo.ictor !is null) {
			modInfo.ictor();
		}
	}
}

// Calls the module constructors and avoids cycles.
private void moduleConstructors(ModuleInfo from, ModuleInfo[] imports, ref int dtors) {
	static const int CtorVisiting = 1;
	static const int CtorVisited = 2;
	foreach(mod; imports) {
		if (mod is null) {
			continue;
		}

		if (mod.flags == CtorVisited) {
			continue;
		}

		if (mod.ctor !is null || mod.dtor !is null) {
			if (mod.flags & CtorVisiting) {
				// Already visiting this node...
				// There is a cycle
				throw new RuntimeError.CyclicDependency(from.name, mod.name);
			}
			mod.flags = CtorVisiting;

			moduleConstructors(mod, mod._importedModules, dtors);

			// Run the constructor
			if (mod.ctor !is null) {
				mod.ctor();
			}

			mod.flags = CtorVisited;

			// Save the destructor for later
			if (mod.dtor !is null) {
				ModuleInfo._dtors[dtors] = mod;
				dtors++;
			}
		}
		else {
			mod.flags = CtorVisited;
			moduleConstructors(mod, mod._importedModules, dtors);
		}
	}
}

// Run each destructor
private void moduleDestructors() {
	foreach(mod; ModuleInfo._dtors) {
		if (mod.dtor !is null) {
			mod.dtor();
		}
	}
}

private extern(C) int main(int argc, char** argv) {
	// Initialize the garbage collector
	gc_init();

	moduleInfoInitialize();
	moduleIndependentConstructors();

	int numDtors = 0;
	moduleConstructors(null, ModuleInfo._modules, numDtors);

	ModuleInfo._dtors = ModuleInfo._dtors[0..numDtors];

	// Gather arguments

	// Run main
	int exitCode = main([]);

	// Run the module destructors
	moduleDestructors();

	// Terminate the garbage collector
	gc_term();

	// End the application
	return exitCode;
}

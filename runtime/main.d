/*
 * main.d
 *
 * This module provides the C entry into the application.
 *
 */

module runtime.main;

import runtime.gc;
import runtime.moduleinfo;

import analyzing.debugger;

import core.error;
import core.arguments;

import synch.thread;

import synch.atomic;

import scaffold.console;

// The user supplied D entry
int main(char[][] args);

// Description: This function is the main entry point of the application.
// argc: The number of arguments
// argv: An array of strings that specify the arguments.
// Returns: The error code for the application.
import binding.c;

// Silly DMD bullshits
version(Windows) {
	extern(C) ModuleInfo[] _moduleinfo_array;
	extern(C) void _minit();
}

// Initializes data structures to aid in calling module constructors
private void moduleInfoInitialize() {

	// Take the linked list of modules and load them into an array
	ModuleReference* mod = _Dmodule_ref;

	// Silly DMD bullshits
	version(Windows) {
		_minit();
		ModuleInfo._modules = _moduleinfo_array.dup;
		ModuleInfo._dtors = new ModuleInfo[_moduleinfo_array.length];
	}
	else {
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

private size_t strlen(char* cstr) {
	size_t ret = 0;
	while(*cstr != '\0') {
		ret++;
		cstr++;
	}
	return ret;
}

version(Windows) {
	extern(System) wchar* GetCommandLineW();
	extern(System) wchar* CommandLineToArgvW(wchar*, int*);

	private extern(System)
	int WinMain(int hInstance, int hPrevInstance, char* lpCmdLine, int nCmdShow) {
			wchar* cmdline = GetCommandLineW();

		// count the number of arguments
		// and convert to utf8 arguments
		char*[] argv;
		int pos = 0;
		int start = 0;
		while(cmdline[pos] != '\0') {
			if (cmdline[pos] == '\n' || cmdline[pos] == ' ' || cmdline[pos] == '\t') {
				char[] str = new char[pos - start];
				str = cast(char[])cmdline[start..pos];
				argv ~= str.ptr;
				start = pos+1;
			}
			pos++;
		}

		return main(argv.length, argv.ptr);
	}
}

extern(C) int printf(char*, ...);

private extern(C) int main(int argc, char** argv) {
	// Initialize the garbage collector
	gc_init();

	int exitCode = -1;

	try {
		moduleInfoInitialize();
		moduleIndependentConstructors();

		int numDtors = 0;
		moduleConstructors(null, ModuleInfo._modules, numDtors);

		ModuleInfo._dtors = ModuleInfo._dtors[0..numDtors];

		// Gather arguments
		Arguments argList = Arguments.instance();

		auto arglist = argv[0..argc];
		foreach(cstr; arglist) {
			string arg = cstr[0..strlen(cstr)];
			argList.add(arg);
		}

		// Initialize the console
		ConsoleInit();

		// Make an instance for the main thread
		Thread mainThread = new Thread();

		// Run main
		exitCode = main(argList.array);

		// Uninitialize the console
		ConsoleUninit();

		// Run the module destructors
		moduleDestructors();
	}
	catch(Object o) {
		/*
		Debugger.raiseException(cast(Exception)o);
		*/
	}

	// Terminate the garbage collector
	gc_term();

	// End the application
	return exitCode;
}

/*
 * library.d
 *
 * This file implements the Library class, which allows access to external
 * dynamic libraries at runtime.
 *
 * Author: Dave Wilkinson
 * Originated: May 29, 2009
 *
 */

module core.library;

import core.string;

import platform.imports;
mixin(PlatformGenericImport!("vars"));
mixin(PlatformGenericImport!("definitions"));
mixin(PlatformScaffoldImport!());

// Description: This class will allow runtime linking to dynamic libraries.
class Library {

	// Description: This constructor will dynamically load the library found at the given framework path.
	// path: The path to the library in question.
	this(String path) {
		Scaffold.SystemLoadLibrary(_pfvars, path);
	}

	// Description: This constructor will dynamically load the library found at the given framework path.
	// path: The path to the library in question.
	this(StringLiteral path) {
		this(new String(path));
	}

	~this() {
		Scaffold.SystemFreeLibrary(_pfvars);
	}

protected:

	// Description: This function can only be called within an instance of the class. It will give the function pointer to the procedure specified by proc and null when the procedure cannot be found.
	// proc: The name of the procedure to call upon.
	// Returns: Will return null if the procedure cannot be found, otherwise it will return the address to this function.
	final void* getProc(StringLiteral proc) {
		return getProc(new String(proc));
	}

	// Description: This function can only be called within an instance of the class. It will give the function pointer to the procedure specified by proc and null when the procedure cannot be found.
	// proc: The name of the procedure to call upon.
	// Returns: Will return null if the procedure cannot be found, otherwise it will return the address to this function.
	final void* getProc(String proc) {
		if (proc.array in _funcs) {
			return _funcs[proc.array];
		}

		// acquire the signature (or null)
		void* signature = Scaffold.SystemLoadLibraryProc(_pfvars, proc);

		// set in hash
		_funcs[proc.array] = signature;
		return signature;
	}

	final void*[StringLiteral] _funcs;
	
	LibraryPlatformVars _pfvars;
}
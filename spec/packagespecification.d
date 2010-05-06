/*
 * packagespecification.d
 *
 * This module implements a class that will provide an outlet to test an entire
 * package.
 *
 * Originated: May 6th, 2010
 *
 */

module spec.packagespecification;

import spec.modulespecification;

import djehuty;

class PackageSpecification {
	this(string name) {
		_name = name.dup;
	}

	string name() {
		return _name;
	}

	void add(string moduleName, ModuleSpecification spec) {
		_modules[moduleName] = spec;
	}

	bool all() {
		bool ret = true;
		foreach(mod; _modules.values) {
			if (!mod.all()) {
				ret = false;
			}
		}
		return ret;
	}

	ModuleSpecification test(string name) {
		return _modules[name];
	}

	int opApply(int delegate(ref ModuleSpecification) loopBody) {
		foreach(mod; _modules.values.sort) {
			if (loopBody(mod)) {
				return 1;
			}
		}
		return 1;
	}

	// Description: Print out the specification of the package, which serves as
	//   documentation for the application.
	string toString() {
		// Package
		//   Module
		//     Item should do this
		//     Item should do that
		string ret = "";

		foreach(mod; _modules.values.sort) {
			ret ~= mod.name ~ "\n";
			foreach(item; mod) {
				foreach(spec; item) {
					ret ~= "  " ~ item.name ~ " " ~ spec ~ "\n";
				}
			}
		}

		return ret;
	}

private:

	string _name;

	ModuleSpecification _modules[string];
}

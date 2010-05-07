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

	void add(ModuleSpecification spec) {
		_modules[spec.name] = spec;
	}

	void add(PackageSpecification spec) {
		_packages[spec.name] = spec;
	}

	PackageSpecification traverse(string name) {
		if (!(name in _packages)) {
			return null;
		}
		return _packages[name];
	}

	ModuleSpecification retrieve(string name) {
		if (!(name in _modules)) {
			return null;
		}
		return _modules[name];
	}

	int opApply(int delegate(ref PackageSpecification) loopBody) {
		foreach(pack; _packages.keys.sort) {
			if (loopBody(_packages[pack])) {
				return 1;
			}
		}
		return 1;
	}

	int opApply(int delegate(ref ModuleSpecification) loopBody) {
		foreach(mod; _modules.keys.sort) {
			if (loopBody(_modules[mod])) {
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
		return _toString("");
	}

private:

	string _toString(string padding) {
		string ret = padding ~ _name ~ "\n";

		foreach(pack; _packages.values.sort) {
			ret ~= pack._toString(padding ~ "  ");
		}

		foreach(mod; _modules.values.sort) {
			ret ~= padding ~ "  " ~ mod.name ~ "\n";
			foreach(item; mod) {
				foreach(spec; item) {
					ret ~= padding ~ "    " ~ item.name ~ " " ~ spec ~ "\n";
				}
			}
		}

		return ret;
	}

	string _name;

	ModuleSpecification _modules[string];
	PackageSpecification _packages[string];
}

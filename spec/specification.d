/*
 * specification.d
 *
 * This module facilitates specifying the application.
 *
 * Originated: May 6th, 2010
 *
 */

module spec.specification;
import spec.packagespecification;

import djehuty;

class Specification {
static:
private:

	PackageSpecification[string] _packages;

public:
	string name() {
		return Djehuty.app.name; 
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

	int opApply(int delegate(ref PackageSpecification) loopBody) {
		foreach(pack; _packages.values.sort) {
			if (loopBody(pack)) {
				return 1;
			}
		}
		return 1;
	}

	// Description: Print out the specification, which is documentation of
	//   the application.
	string toString() {
		// Package
		//   Module
		//     Item should do this
		//     Item should do that
		string ret = "";

		foreach(pack; _packages.values.sort) {
			ret ~= pack.toString();
		}

		return ret;
	}
}

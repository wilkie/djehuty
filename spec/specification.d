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

	string name() {
		return Djehuty.app.name; 
	}

	void add(string packageName, PackageSpecification spec) {
		_packages[packageName] = spec;
	}

	bool all() {
		bool ret = true;
		foreach(pack; _packages) {
			if (!pack.all()) {
				ret = false;
			}
		}
		return false;
	}

	PackageSpecification test(string name) {
		return _packages[name];
	}

	int opApply(int delegate(PackageSpecification) loopBody) {
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
			ret ~= pack.name ~ "\n";
			foreach(mod; pack) {
				ret ~= "  " ~ mod.name ~ "\n";
				foreach(item; mod) {
					foreach(spec; item) {
						ret ~= "    " ~ item.name ~ " " ~ spec ~ "\n";
					}
				}
			}
		}

		return ret;
	}

private:

	PackageSpecification[string] _packages;
}

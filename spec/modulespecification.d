/*
 * moduletester.d
 *
 * This module implements a class that will interface the testing of a module.
 *
 * Originated: May 6th, 2010
 *
 */

module spec.modulespecification;

import spec.itemspecification;

import djehuty;

import io.console;

class ModuleSpecification {
	this(string name) {
		_name = name.dup;
	}

	string name() {
		return _name;
	}

	void add(ItemSpecification item) {
		_tests[item.name] = item;
	}

	// Description: This function will return a class representing the test
	//   given by the name.
	// name: The name of the test.
	// Returns: A class that can be used to run the test.
	ItemSpecification retrieve(string name) {
		if (!(name in _tests)) {
			return null;
		}
		return _tests[name];
	}

	int opApply(int delegate(ref ItemSpecification) loopBody) {
		foreach(test; _tests.keys.sort) {
			if (loopBody(_tests[test])) {
				return 1;
			}
		}
		return 1;
	}

private:
	string _name;
	ItemSpecification[string] _tests;
}

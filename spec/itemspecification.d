/*
 * specification.d
 *
 * This module implements a class that wraps the specification of a particular
 * subsection of a module.
 *
 * Originated: May 6th, 2010
 *
 */

module spec.itemspecification;

import spec.logic;

import djehuty;

import io.console;

class ItemSpecification {

	this(string name) {
		_name = name.dup;
	}

	string name() {
		return _name;
	}

	void add(string specification, it function() testBody) {
		_tests[specification] = testBody;
	}

	// Description: This will test a particular item.
	// Returns: When the test is successful, it returns true. It returns false otherwise.
	bool test(string name) {
		if (!(name in _tests)) {
			throw new Exception("Unknown Test::" ~ name);
		}
		it ret = _tests[name]();
		return ret == it.does;
	}

	size_t length() {
		return _tests.length;
	}

	int opApply(int delegate(ref string) loopBody) {
		foreach(test; _tests.keys) {
//		Console.putln(".",test);
			if (loopBody(test)) {
				return 1;
			}
		}
		return 1;
	}

	// Description: Print out the specification of the package, which serves as
	//   documentation for the application.
	string toString() {
		// Item should do this
		// Item should do that
		string ret = "";

		foreach(spec; _tests.keys) {
			ret ~= _name ~ " " ~ spec ~ "\n";
		}

		return ret;
	}

private:

	string _name;

	it function()[string] _tests;
}


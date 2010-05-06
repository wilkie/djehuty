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

import spec.support : describe, done;
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

	void add(string specification, it delegate() testBody) {
		_tests[specification] = testBody;
	}

	// Description: This will run all tests.
	// Returns: When all tests are successful, it returns true. It returns false otherwise.
	bool all() {
		bool ret = true;
		foreach(test; _tests.values) {
			if (!test()) {
				ret = false;
			}
		}
		return ret;
	}

	// Description: This will test a particular item.
	// Returns: When the test is successful, it returns true. It returns false otherwise.
	bool test(string name) {
		it ret = _tests[name]();
		return false;
	}

	int opApply(int delegate(ref string) loopBody) {
		foreach(test; _tests.keys) {
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

	it delegate()[string] _tests;
}

/*
class Tester {
	this(char[] testClass, char[] moduleName, char[] specFile = "") {
		currentTest = testClass;
		this.specFile = specFile;
	}

	void run() {
	}

	void logSubset(char[] subsetName) {
		currentRegion = subsetName;
	}

	void logResult(it result, char[] msg, char[] lineNumber) {
		if (result == it.does) {
			// success
			Console.forecolor = Color.Green;
			Console.putln("  OK   : (", lineNumber, ") : ", currentTest, " ", msg);
			Console.forecolor = Color.Gray;

			testsOk++;
			classOk++;
		}
		else {
			// fail
			Console.forecolor = Color.Red;
			Console.putln("FAILED : (", specFile, ":", lineNumber, ")");
			Console.putln("       : ", currentTest, " ", msg);
			Console.putln();
			Console.forecolor = Color.Gray;

			testsFailcopter++;
			classFail++;
		}
	}

	void finish() {
		if (classFail == 0) {
			// success
			Console.forecolor = Color.Green;
			Console.putln("  OK   : ", currentTest, " (", classOk, " out of ", classOk + classFail, ")");
			Console.forecolor = Color.Gray;
		}
		else {
			Console.forecolor = Color.Red;
			Console.putln("FAILED : ", currentTest, " (", classOk, " out of ", classOk + classFail, ")");
			Console.putln();
			Console.forecolor = Color.Gray;
		}

		classOk = 0;
		classFail = 0;
	}

	static void done() {
		Console.putln("");
		Console.putln("Testing Completed");
		Console.putln("");
		if (testsFailcopter > 0) {
			Console.forecolor = Color.Red;
			Console.putln(testsFailcopter, " tests FAILED");
			Console.forecolor = Color.Gray;
		}
		else {
			Console.forecolor = Color.Green;
			Console.putln("All ", testsOk, " tests SUCCEEDED");
			Console.forecolor = Color.Gray;
		}
		Console.putln("");

		lastOk = testsOk;
		lastFailcopter = testsFailcopter;

		testsFailcopter = 0;
		testsOk = 0;
	}

	static uint getSuccessCount() {
		return lastOk;
	}

	static uint getFailureCount() {
		return lastFailcopter;
	}

private:

	static uint testsOk;
	static uint testsFailcopter;

	static uint lastOk;
	static uint lastFailcopter;

	uint classFail;
	uint classOk;

	char[] currentTest;
	char[] specFile;
	char[] currentRegion;
}
*/

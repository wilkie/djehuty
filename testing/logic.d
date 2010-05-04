module testing.logic;

public import testing.support : describe, done;

import djehuty;

import io.console;

enum it {
	does,
	doesnt
}

class Test {
	this(char[] testClass, char[] specFile = "") {
		currentTest = testClass;
		this.specFile = specFile;
	}

	void logSubset(char[] subsetName) {
		currentRegion = subsetName;
	}

	void logResult(it result, char[] msg, char[] lineNumber) {
		if (result == it.does) {
			// success
			Console.forecolor = Color.Green;
			//Console.putln("  OK   : (", lineNumber, ") : ", currentTest, " ", msg);
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

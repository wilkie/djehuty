module testing.logic;

public import testing.support : describe, done;

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
			//Console.setColor(fgColor.BrightGreen);
			//Console.putln("  OK   : (", lineNumber, ") : ", currentTest, " ", msg);
			//Console.setColor(fgColor.White);

			testsOk++;
			classOk++;
		}
		else {
			// fail
			Console.setColor(fgColor.BrightRed);
			Console.putln("FAILED : (", specFile, ":", lineNumber, ")");
			Console.putln("       : ", currentTest, " ", msg);
			Console.putln();
			Console.setColor(fgColor.White);

			testsFailcopter++;
			classFail++;
		}
	}

	void finish() {
		if (classFail == 0) {
			// success
			Console.setColor(fgColor.BrightGreen);
			Console.putln("  OK   : ", currentTest, " (", classOk, " out of ", classOk + classFail, ")");
			Console.setColor(fgColor.White);
		}
		else {
			Console.setColor(fgColor.BrightRed);
			Console.putln("FAILED : ", currentTest, " (", classOk, " out of ", classOk + classFail, ")");
			Console.putln();
			Console.setColor(fgColor.White);
		}

		classOk = 0;
		classFail = 0;
	}

	static void done() {
		Console.putln("");
		Console.putln("Testing Completed");
		Console.putln("");
		if (testsFailcopter > 0) {
			Console.setColor(fgColor.BrightRed);
			Console.putln(testsFailcopter, " tests FAILED");
			Console.setColor(fgColor.White);
		}
		else {
			Console.setColor(fgColor.BrightGreen);
			Console.putln("All ", testsOk, " tests SUCCEEDED");
			Console.setColor(fgColor.White);
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

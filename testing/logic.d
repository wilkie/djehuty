module testing.logic;

public import testing.support : describe, done;

import console.main;

enum it
{
	does,
	doesnt
}

class Test
{
	static int testsOk;
	static int testsFailcopter;

	char[] currentTest;
	char[] currentRegion;

	this(char[] testClass)
	{
		currentTest = testClass;
	}

	void logSubset(char[] subsetName)
	{
		currentRegion = subsetName;
	}

	void logResult(it result, char[] msg, char[] lineNumber)
	{
		if (result == it.does)
		{
			// success
			Console.setColor(fgColor.BrightGreen);
			Console.putln("  OK   : (", lineNumber, ") : ", currentTest, " ", msg);
			Console.setColor(fgColor.White);

			testsOk++;
		}
		else
		{
			// fail
			Console.setColor(fgColor.BrightRed);
			Console.putln("FAILED : (", lineNumber, ") : ", currentTest, " ", msg);
			Console.setColor(fgColor.White);

			testsFailcopter++;
		}
	}

	static void done()
	{
		Console.putln("");
		Console.putln("Testing Completed");
		Console.putln("");
		if (testsFailcopter > 0)
		{
			Console.setColor(fgColor.BrightRed);
			Console.putln(testsFailcopter, " tests FAILED");
			Console.setColor(fgColor.White);
		}
		else
		{
			Console.setColor(fgColor.BrightGreen);
			Console.putln("All ", testsOk, " tests SUCCEEDED");
			Console.setColor(fgColor.White);
		}
		Console.putln("");
	}
}
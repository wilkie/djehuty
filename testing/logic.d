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
		}
		else
		{
			// fail
			Console.setColor(fgColor.BrightRed);
			Console.putln("FAILED : (", lineNumber, ") : ", currentTest, " ", msg);
			Console.setColor(fgColor.White);
		}
	}
}
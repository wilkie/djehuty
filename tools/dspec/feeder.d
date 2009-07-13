module feeder;

import core.file;
import core.string;
import core.unicode;

import console.main;

// *** delete all three
//import std.stdio;
//import std.file;
//import std.string;

char[] delims = " \t.{}()[];,-+=/\\*&^%!|?:<>";

class Feeder
{
	this(String filename)
	{
		fp = new File(filename);
		//fp = fopen(std.string.toStringz(filename), "rb");

		// reinit
		lineNumber = 0;
	}

	~this()
	{
		// *** delete
		//fclose(fp);
	}

	String[] feed()
	{
		char[] line;

		if(fp.readLine(line))
		//if(!feof(fp))
		{
			// Minimal Logic:
			// - know not to parse comments
			// - know that first describe dictates control
			// - know how to expand should and shouldNot

			// *** delete
			//char[] line = readln(fp);

			// Increment line counter
			lineNumber++;

			// sanitize line
			// *** delete (I don't add newline)
			//line = chomp(line);

			// return tokens
			return splitAll(line, delims);
		}

		return null;
	}

	uint getLineNumber()
	{
		return lineNumber;
	}

protected:

	File fp;
	//_iobuf* fp;
	uint lineNumber = 0;

	String[] splitAll(char[] s, char[] delim, bool keepDelim = true)
	{
		String[] ret;

		uint lastpos = 0;
		foreach(i, c; s)
		{
			foreach(cmp; delim)
			{
				if (c == cmp)
				{
					if (lastpos != i)
					{
						ret ~= new String(s[lastpos..i]);
					}
					if (keepDelim)
					{
						ret ~= new String(s[i..i+1]);
					}
					lastpos = i+1;
				}
			}
		}
		
		ret ~= new String("\n");

		return ret;
	}
}
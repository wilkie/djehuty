module feeder;

// *** import core.file;

// *** delete all three
import std.stdio;
import std.file;
import std.string;

char[] delims = " \t.{}()[];,-+=/\\*&^%!|?:<>";

class Feeder
{
	this(char[] filename)
	{
		// *** fp = new File(filename);
		fp = fopen(std.string.toStringz(filename), "rb");

		// reinit
		lineNumber = 0;
	}

	~this()
	{
		// *** delete
		fclose(fp);
	}

	char[][] feed()
	{
		// *** char[] line
		// *** if(fp.readLine(line))
		if(!feof(fp))
		{
			// Minimal Logic:
			// - know not to parse comments
			// - know that first describe dictates control
			// - know how to expand should and shouldNot

			// *** delete
			char[] line = readln(fp);

			// Increment line counter
			lineNumber++;

			// sanitize line
			// *** delete (I don't add newline)
			line = chomp(line);

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

	// *** File fp;
	_iobuf* fp;
	uint lineNumber = 0;

	char[][] splitAll(char[] s, char[] delim, bool keepDelim = true)
	{
		char[][] ret;

		uint lastpos = 0;
		foreach(i, c; s)
		{
			foreach(cmp; delim)
			{
				if (c == cmp)
				{
					if (lastpos != i)
					{
						ret ~= s[lastpos..i];
					}
					if (keepDelim)
					{
						ret ~= s[i..i+1];
					}
					lastpos = i+1;
				}
			}
		}
		
		ret ~= "\n";

		return ret;
	}
}
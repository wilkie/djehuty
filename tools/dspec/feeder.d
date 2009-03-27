module feeder;

import std.stdio;
import std.file;
import std.string;

char[] delims = " \t.{}()[];,-+=/\\*&^%!|?:<>";

class Feeder
{
	this(char[] filename)
	{
		fp = fopen(std.string.toStringz(filename), "rb");
				
		// reinit
		lineNumber = 0;
	}
	
	~this()
	{
		fclose(fp);
	}
	
	char[][] feed()
	{
		if(!feof(fp))
		{	
			// Minimal Logic:
			// - know not to parse comments
			// - know that first describe dictates control
			// - know how to expand should and shouldNot
			
			char[] line = readln(fp);
			
			// Increment line counter
			lineNumber++;
			
			// sanitize line
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
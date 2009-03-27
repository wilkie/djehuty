/*
 * dspec.d
 *
 * This tool will use the parser to parse specifications and produce tests
 *
 */
 
import std.stdio;

import filelist;
import parser;
 
char[] usage = `dspec rev0

USAGE: dspec [-I<PATH>]
EXAMPLE: dspec -Ispecs/.
`;
 
int main(string args[])
{	
	// Interpret arguments
	if (args.length != 2 || args[1].length < 3 || args[1][0..2] != "-I")
	{
		writefln(usage);
		return -1;
	}
	
	char[] path = args[1][2..$];
	
	// Get the list of spec files
	FileList files = new FileList();
	if (!(files.fetch(path)))
	{
		return -1;
	}
	
	Parser parser = new Parser();
	if (!(parser.parseFiles(path, files)))
	{
		return -1;
	}
		
	return 0;
}
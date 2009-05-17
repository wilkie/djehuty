/*
 * dspec.d
 *
 * This tool will use the parser to parse specifications and produce tests
 *
 */

import console.main;

import core.main;
import core.string;
import core.unicode;
import core.arguments;

import filelist;
import parser;

char[] usage = `dspec rev1

USAGE: dspec [-I<PATH>]
EXAMPLE: dspec -Ispecs/.
`;

extern(System) void DjehutyMain(Arguments args)
{
	Djehuty.setApplicationName("djehuty-dspec");

	String[] argList = args.getList();

	foreach(str; argList)
	{
		Console.putln(str.array);
	}

	// Interpret arguments
	if (argList.length != 2 || argList[1].length < 3 || argList[1][0..2] != "-I")
	{
		Console.putln(usage);
		return;
	}

	String path = new String(argList[1][2..argList[1].length]);

	Console.putln("starting");

	// Get the list of spec files
	FileList files = new FileList();
	if (!(files.fetch(path)))
	{
		Console.putln("error");
		return;
	}

	Console.putln("filelist created");

	Parser parser = new Parser();
	if (!(parser.parseFiles(path, files)))
	{
		Console.putln("error");
		return;
	}

	Console.putln("done");

	return;
}
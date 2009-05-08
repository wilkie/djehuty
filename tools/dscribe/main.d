/*
 * dscribe.d
 *
 * This tool will use the parser to parse source and produce documentation
 *
 */

import console.main;

import core.main;
import core.string;
import core.unicode;
import core.arguments;

char[] usage = `dscribe rev0

USAGE: dscribe [-I<PATH>] -o<PATH>
EXAMPLE: dscribe -odocs/.
`;

extern(System) void DjehutyMain(Arguments args)
{
	Djehuty.setApplicationName("djehuty-dscribe");
	
	Console.putln(usage);
}
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
import core.application;

import tools.dscribe.lexer;

char[] usage = `
dscribe rev0

USAGE: dscribe [-I<PATH>] -o<PATH>
EXAMPLE: dscribe -odocs/.`;

class DScribe : Application {
	static this() { new DScribe(); }

	this() {
		super("djehuty-dscribe");
	}

	void OnApplicationStart() {
		Console.putln(usage);

		lexer = new LexerD();

		push(lexer);
		lexer.work();
	}

private:
	LexerD lexer;
}
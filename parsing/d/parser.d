/*
 * parser.d
 *
 * This module will provide a parser for the D programming language.
 *
 * Author: Dave Wilkinson
 * Originated: February 1st, 2010
 *
 */

module parsing.d.parser;

import parsing.d.lexer;
import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.moduleunit;

import parsing.token;
import parsing.ast;
import parsing.lexer;
import parsing.parser;
import parsing.parseunit;

import djehuty;

import io.console;

class DParser : Parser {
private:
	DLexer _lexer;

public:
	this(Stream stream) {
		super(stream);
		_lexer = new DLexer(stream);
	}

	override AbstractSyntaxTree parse() {
		ParseUnit parseUnit = new ModuleUnit();
		parseUnit.lexer = _lexer;
		return parseUnit.parse();
	}
}

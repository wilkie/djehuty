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

import parsing.token;
import parsing.ast;
import parsing.lexer;
import parsing.parser;

import core.string;
import core.stream;
import core.variant;
import core.stream;

import io.console;


class DParser : Parser {
	this(Stream stream) {
		super(stream);
		_lexer = new DLexer(stream);
	}

	override AbstractSyntaxTree parse() {
		// Feed some bits to the D Lexer
		foreach(token; _lexer) {
			// Interpret Token
			Console.put(token.type, " ");
		}

		return null;
	}

private:
	DLexer _lexer;
}
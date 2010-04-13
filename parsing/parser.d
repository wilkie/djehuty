module parsing.parser;

import parsing.ast;

import core.stream;

abstract class Parser {
	this(Stream stream) {
	}

	AbstractSyntaxTree parse() {
		return null;
	}
}

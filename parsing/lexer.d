module parsing.lexer;

import parsing.token;

import core.stream;
import core.definitions;

abstract class Lexer {
	this(Stream stream) {
	}

	void push(Token token) {
	}

	Token pop() {
		return Token.init;
	}

	string line() {
		return "";
	}

	string line(uint idx) {
		return "";
	}
}

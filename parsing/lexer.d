module parsing.lexer;

import parsing.token;

import core.stream;

abstract class Lexer {
	this(Stream stream) {
	}

	void push(Token token) {
	}

	Token pop() {
		return Token.init;
	}

//	int opApply(int delegate(ref Token) loopbody) {
//		return 1;
//	}
}

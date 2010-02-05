module parsing.lexer;

import parsing.token;

import core.stream;

abstract class Lexer {
	this(Stream stream) {
	}

	Token nextToken(Stream stream) {
		Token ret;
		return ret;
	}

//	int opApply(int delegate(ref Token) loopbody) {
//		return 1;
//	}
}
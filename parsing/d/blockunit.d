/*
 * blockunit.d
 *
 */

module parsing.d.blockunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.declarationunit;

class BlockUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.LeftCurly:
				if (leftFound) {
					error("Expected closing '}'.");
				}
				else {
					// Good... look for a declaration
					leftFound = true;
				}
				break;
			case DToken.RightCurly:
				// We are fiiiine... as long as we have found the left curly
				if (!leftFound) {
					error("Found closing '}' without respective opening '}'.");
				}
				return false;
			default:
				// We can look for a simple declaration
				lexer.push(current);
				break;
		}
		return true;
	}
private:
	bool leftFound;
}

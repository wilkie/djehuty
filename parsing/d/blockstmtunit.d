/*
 * blockunit.d
 *
 */

module parsing.d.blockstmtunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.statementunit;

class BlockStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.RightCurly:
				// Done.
				return false;
			default:
				// We can look for a simple declaration
				lexer.push(current);
				auto tree = expand!(StatementUnit)();
				break;
		}
		return true;
	}
}

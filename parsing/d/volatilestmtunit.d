/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.volatilestmtunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.statementunit;

import io.console;

import djehuty;

class VolatileStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.Semicolon:
				// Done.
				return false;

			default:
				if (this.state == 1) {
					// Error: Multiple statements!?
					// TODO:
				}

				lexer.push(current);

				// Statement Follows.
				auto tree = expand!(StatementUnit)();
				this.state = 1;

				break;
		}
		return true;
	}

protected:
	string cur_string = "";

	static const string _common_error_msg = "";
	static const string[] _common_error_usages = null;
}

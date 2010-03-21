/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.returnstmtunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.expressionunit;

import io.console;

import djehuty;

class ReturnStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.Semicolon:
				// Done.
				return false;

			default:
				if (this.state == 1) {
					// Error: Multiple expressions
					// TODO:
				}

				lexer.push(current);

				// Expression follows... and then a semicolon
				auto tree = expand!(ExpressionUnit)();
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

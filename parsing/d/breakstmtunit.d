/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.breakstmtunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import io.console;

import djehuty;

class BreakStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.Semicolon:
				// Done.
				putln("Break: ", cur_string);
				return false;
			case DToken.Identifier:
				if (this.state == 1) {
					// Error: More than one identifier?!?!
					// TODO:
				}
				this.state = 1;
				cur_string = current.value.toString();
				break;
			default:
				// Error:
				// TODO:
				break;
		}
		return true;
	}

protected:
	string cur_string = "";

	static const string _common_error_msg = "";
	static const string[] _common_error_usages = null;
}

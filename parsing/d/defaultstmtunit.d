/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.defaultstmtunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import io.console;

import djehuty;

class DefaultStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.Colon:
				Console.putln("Default:");
				// Done.
				return false;
			default:
				// Error: Default does not allow expressions
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

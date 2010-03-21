/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.primaryexprunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import io.console;

import djehuty;

class PrimaryExprUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.StringLiteral:
				Console.putln("Expression: \"", current.value, "\"");
				cur_string = current.value.toString();
				return false;
			default:
				break;
		}
		return true;
	}

protected:
	string cur_string = "";

	static const string _common_error_msg = "";
	static const string[] _common_error_usages = null;
}

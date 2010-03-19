/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.postfixexprunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import io.console;

import djehuty;

class PostFixExprUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.Null:
			case DToken.True:
			case DToken.False:
			case DToken.IntegerLiteral:
				Console.putln("Expression: ", current.value);
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

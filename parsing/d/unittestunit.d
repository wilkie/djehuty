/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.unittestunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.functionbodyunit;

import io.console;

import djehuty;

class UnittestUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			// Look for the beginning of a functionbody
			case DToken.In:
			case DToken.Out:
			case DToken.Body:
			case DToken.LeftCurly:
				Console.putln("Unittest");
				lexer.push(current);
				auto tree = expand!(FunctionBodyUnit)();
				
				// Done.
				return false;

			// Errors otherwise.
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

/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.functionbodyunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.parameterlistunit;
import parsing.d.functionbodyunit;

import io.console;

import djehuty;

class FunctionBodyUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {

			// We are always looking for the end of the block.
			case DToken.RightCurly:
				// Done.
				return false;

			// TODO: in, out, body, blockstatement foo

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

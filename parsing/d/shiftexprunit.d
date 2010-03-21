/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.shiftexprunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.addexprunit;

import io.console;

import djehuty;

class ShiftExprUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.ShiftLeft:
			case DToken.ShiftRight:
			case DToken.ShiftRightSigned:
				if (this.state == 1) {
					Console.putln("SHIFT");
					this.state = 0;
					break;
				}

				// Fall through
				goto default;

			default:
				lexer.push(current);
				if (this.state == 1) {
					// Done.
					return false;
				}
				auto tree = expand!(AddExprUnit)();
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

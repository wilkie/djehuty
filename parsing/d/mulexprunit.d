/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.mulexprunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.unaryexprunit;

import io.console;

import djehuty;

class MulExprUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.Mul:
			case DToken.Div:
			case DToken.Mod:
				if (this.state == 1) {
					Console.putln("MUL");
					this.state = 0;
					break;
				}

				// Fall through

			default:
				lexer.push(current);
				if (this.state == 1) {
					// Done.
					return false;
				}
				auto tree = expand!(UnaryExprUnit)();
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

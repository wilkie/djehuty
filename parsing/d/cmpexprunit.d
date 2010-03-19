/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.cmpexprunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.shiftexprunit;

import io.console;

import djehuty;

class CmpExprUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.Bang: // !
				// look for is
				Token foo = lexer.pop();
				if (foo.type == DToken.Is) {
					// !is
					Console.putln("!is");
					this.state = 2;
				}
				break;

			case DToken.Equals:						 // ==
			case DToken.NotEquals:					 // !=
			case DToken.LessThan:					 // <
			case DToken.NotLessThan:				 // !<
			case DToken.GreaterThan:				 // >
			case DToken.NotGreaterThan:				 // !>
			case DToken.LessThanEqual:				 // <=
			case DToken.NotLessThanEqual:			 // !<=
			case DToken.GreaterThanEqual:			 // >=
			case DToken.NotGreaterThanEqual:		 // !>=
			case DToken.LessThanGreaterThan:		 // <>
			case DToken.NotLessThanGreaterThan:		 // !<>
			case DToken.LessThanGreaterThanEqual:	 // <>=
			case DToken.NotLessThanGreaterThanEqual: // !<>=
			case DToken.Is:							 // is
			case DToken.In:							 // in

				if (this.state == 1) {
					// ==
					this.state = 2;
				}
				break;
			default:
				lexer.push(current);
				if (this.state == 1) {
					// Done.
					return false;
				}

				auto tree = expand!(ShiftExprUnit)();
				if (this.state == 2) {
					// Done.
					return false;
				}
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

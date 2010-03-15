/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.declaratorsuffixunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.expressionunit;

import io.console;

import djehuty;

class DeclaratorSuffixUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (this.state) {
			case 0:
				// Looking for ( or [
				// Types which have () or [] after them
				switch (current.type) {
					case DToken.LeftParen:
						this.state = 1;
						break;
					case DToken.LeftBracket:
						this.state = 2;
						break;
					default:
						break;
				}
				break;

			case 1:
				// We have found a ( so we are searching for
				// a right parenthesis
				switch (current.type) {
					case DToken.RightParen:
						// Done
						Console.putln("()");
						return false;
					default:
						// This is a parameter list
						// XXX:
//						auto tree = expand!(ParameterList)();
						return false;
				}
				break;

			case 2:
				// We have found a [ so we are searching for
				// a right bracket.
				switch (current.type) {
					case DToken.RightBracket:
						Console.putln("[]");
						// Done
						return false;

					case DToken.Dot:
						break;

					case DToken.Identifier:
						break;

					default:
						// We should assume it is an expression
						lexer.push(current);
						auto tree = expand!(ExpressionUnit)();
						break;
				}
				break;
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

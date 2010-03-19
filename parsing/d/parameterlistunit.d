/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.parameterlistunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.parameterunit;
import parsing.d.functionbodyunit;
import parsing.d.declaratorunit;

import io.console;

import djehuty;

class ParameterListUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {

			case DToken.RightParen:
				// Done.
				return false;
				break;

			case DToken.Variadic:
				if (this.state == 2) {
					// Error: Have two variadics?!
					// TODO: One too many variadics.
				}
				// We have a variadic!
				this.state = 2;
				break;

			case DToken.Comma:
				if (this.state == 0) {
					// Error: Expected a parameter!
					// TODO: Probably accidently removed a parameter without removing the comma.
				}

				// Get Parameter
				this.state = 0;
				break;

			default:
				if (this.state == 0) {
					// Look for a parameter
					lexer.push(current);
					auto tree = expand!(ParameterUnit)();
					this.state = 1;
				}
				else if (this.state == 2) {
					// Error: Parameter after variadic?
					// TODO: Forgot comma.
				}
				else {
					// Error: otherwise
					// TODO:
				}

				break;
		}
		return true;
	}

protected:
	string cur_string = "";

	static const string _common_error_msg = "";
	static const string[] _common_error_usages = null;
}

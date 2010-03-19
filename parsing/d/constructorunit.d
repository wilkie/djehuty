/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.constructorunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.parameterlistunit;
import parsing.d.functionbodyunit;

import io.console;

import djehuty;

class ConstructorUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {

			// First, we look for the left paren of the parameter list
			case DToken.LeftParen:
				if (this.state != 0) {
					// It should be the first thing!
					// Error: Too many left parentheses!
				}
				this.state = 1;
				break;

			// After finding a left paren, look for a right one
			case DToken.RightParen:
				if (this.state == 0) {
					// Error: No left paren found before this right one!
					// TODO:
				}
				else if (this.state != 1) {
					// Error: Already parsed a right paren! We have too many right parens!
					// TODO:
				}
				this.state = 2;
				break;

			// Look for the end of a bodyless declaration
			case DToken.Semicolon:
				if (this.state == 0) {
					// Error: Have not found a left paren!
					// TODO:
				}
				if (this.state != 2) {
					// Error: Have not found a right paren!
					// TODO:
				}
				// Done.
				return false;

			// Function body
			case DToken.In:
			case DToken.Out:
			case DToken.Body:
			case DToken.LeftCurly:
				// Have we found a parameter list?
				if (this.state == 0) {
					// Error: No parameter list given at all
					// TODO:
				}
				else if (this.state == 1) {
					// Error: We have a left parenthesis... but no right one
					// TODO:
				}
				else if (this.state != 2) {
					// Error: No parameter list
					// TODO:
				}

				// Function body!
				lexer.push(current);
				Console.putln("Constructor");
				auto tree = expand!(FunctionBodyUnit)();

				// Done.
				return false;

			// Otherwise, we might have found something that is in the parameter list
			default:
				if (this.state == 1) {
					// Found a left paren, but not a right paren...
					// Look for the parameter list.
					lexer.push(current);
					auto tree = expand!(ParameterListUnit)();
				}
				else {
					// Errors!
					if (this.state == 0) {
						// Error this BLEH...Need parameters!
						// TODO:
					}
					else if (this.state == 2) {
						// Error: this(...) BLEH... Need function body or semicolon!
						// TODO:
					}
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

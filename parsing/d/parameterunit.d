/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.parameterunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.parameterlistunit;
import parsing.d.functionbodyunit;
import parsing.d.declaratorunit;
import parsing.d.basictypeunit;

import io.console;

import djehuty;

class ParameterUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {

			// Default Initializers
			case DToken.Assign:
				if (this.state < 1) {
					// Error: We don't have a declarator!
					// TODO:
				}
				// TODO:
				// auto tree = expand!(DefaultInitializerUnit)();

				// Done.
				return false;

			// Figure out the specifier.
			case DToken.In:
			case DToken.Out:
			case DToken.Ref:
			case DToken.Lazy:
				if (this.state >= 1) {
					// Error: Already have an in, out, ref, or lazy specifier.
					// TODO:
				}

				// Specifier.

				// Fall through to hit the declarator call

			default:
				lexer.push(current);
				if (this.state == 2) {
					// Could not find an equals
					// Done.
					lexer.push(current);
					return false;
				}
				if (this.state == 1) {
					// Could be a declarator then.
					auto tree = expand!(DeclaratorUnit)();
					this.state = 2;
				}
				else if (this.state == 0) {
					// Hopefully this is a BasicType 
					auto tree = expand!(BasicTypeUnit)();
					this.state = 1;
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

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

import parsing.d.parameterlistunit;
import parsing.d.functionbodyunit;
import parsing.d.declaratorunit;

import io.console;

import djehuty;

class ParameterListUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {

			// Default Initializers
			case DToken.Assign:
				if (this.state != 1) {
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
				if (this.state == 1) {
					// Failed to find an equals, so we must be done.
					return false;
				}
				else if (this.state == 0) {
					// Hopefully this is a Declarator
					auto tree = expand!(DeclaratorUnit)();
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

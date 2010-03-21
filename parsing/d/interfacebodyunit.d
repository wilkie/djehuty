/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.interfacebodyunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.declarationunit;

import io.console;

import djehuty;

class InterfaceBodyUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			// We are always looking for the end of the body.
			case DToken.RightCurly:
				// Done.
				return false;

			// We cannot have allocators in interfaces!
			case DToken.New:
				// Error: No allocators allowed.
				// TODO:
				break;

			// Ditto for a delete token for deallocator.
			case DToken.Delete:
				// Error: No deallocators allowed.
				// TODO:
				break;

			// Otherwise, it must be some Declarator
			default:
				lexer.push(current);
				auto tree = expand!(DeclarationUnit)();
				break;
		}
		return true;
	}

protected:
	string cur_string = "";

	static const string _common_error_msg = "";
	static const string[] _common_error_usages = null;
}

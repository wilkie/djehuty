/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.interfacedeclunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.declarationunit;
import parsing.d.interfacebodyunit;

import io.console;

import djehuty;

class InterfaceDeclUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			// The start of the body
			case DToken.LeftCurly:
				auto tree = expand!(InterfaceBodyUnit)();

				// Done.
				return false;

			// Look for a template parameter list
			case DToken.LeftParen:
				if (cur_string == "") {
					// Error: No name?
					// TODO:
				}
				if (this.state >= 1) {
					// Error: Already have base class list or template parameters
					// TODO:
				}
				this.state = 1;

				// TODO: expand out parameter list				
				break;

			// Look for inherited classes
			case DToken.Colon:
				if (cur_string == "") {
					// Error: No name?
					// TODO:
				}
				if (this.state >= 2) {
					// Error: Already have base class list
					// TODO:
				}
				this.state = 2;

				// TODO: expand out base class list
				break;

			// Name
			case DToken.Identifier:
				if (cur_string != "") {
					// Error: Two names?
					// TODO:
				}
				cur_string = current.value.toString();
				Console.putln("Interface: ", current.value);
				break;

			default:
				// Error: Unrecognized foo.
				break;
		}
		return true;
	}

protected:
	string cur_string = "";

	static const string _common_error_msg = "";
	static const string[] _common_error_usages = null;
}

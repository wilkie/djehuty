/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.enumdeclunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.typeunit;
import parsing.d.enumbodyunit;

import io.console;

import djehuty;

class EnumDeclUnit : ParseUnit {
	override bool tokenFound(Token current) {
		// Looking for a name, or a colon for a type, or a curly
		// braces for the enum body
		switch (current.type) {
			case DToken.Identifier:
				// The name of the enum
				if (this.state >= 1) {
					// We are already passed the name stage.
					// XXX: error
				}
				this.state = 1;
				cur_string = current.value.toString();
				Console.putln("Enum: ", current.value);
				break;
			case DToken.Colon:
				// The type of the enum
				if (this.state >= 2) {
					// Already passed the type stage.
					// XXX: error
				}
				this.state = 2;
				auto tree = expand!(TypeUnit)();
				break;
			case DToken.Semicolon:
				if (this.state == 0) {
					// Need some kind of information about the enum.
					error(_common_error_msg,
							"Without a name, the linker will not know what it should be linking to.",
							["enum FooBar;", "enum FooBar : uint;"]);
					return false;
				}
				// Done.
				return false;
			case DToken.LeftCurly:
				// We are going into the body of the enum
				auto tree = expand!(EnumBodyUnit)();
				// Done.
				return false;
			default:
				break;
		}
		return true;
	}

protected:
	string cur_string = "";

	static const string _common_error_msg = "Enum declaration is invalid.";
	static const string[] _common_error_usages = null;
}

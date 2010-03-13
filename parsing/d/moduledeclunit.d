/*
 * moduledeclunit.d
 *
 * This module parses out the 'identifier.foo.bar' stuff out of a module
 * or import statement.
 *
 * Author: Dave Wilkinson
 * Originated: February 6th, 2010
 *
 */

module parsing.d.moduledeclunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import djehuty;

class ModuleDeclUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.Dot:
				if (cur_string.length > 0 && cur_string[$-1] == '.') {
					error("Expected identifier after dot in module name, found '..'");
				}
				else {
					cur_string ~= ".";
				}
				break;
			case DToken.Semicolon:
				makeNode(DNode.ModuleName, null, cur_string);
				return false;
			case DToken.Identifier:
				if (cur_string.length > 0 && cur_string[$-1] != '.') {
					error("Expected '.' or ';', found identifier in module name.");
				}
				else {
					cur_string ~= toStr(current.value);
				}
				break;
			default:
				error("Expected identifier within module name.");
				break;
		}
		return true;
	}
protected:
	string cur_string = "";
}

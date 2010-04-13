/*
 * moduleunit.d
 *
 * This module parses a D source file. It is the root parse unit.
 * 
 * Author: Dave Wilkinson
 * Originated: February 6th 2010
 *
 */

module parsing.d.moduleunit;

import parsing.parseunit;
import parsing.lexer;
import parsing.token;

import parsing.d.nodes;
import parsing.d.tokens;

import parsing.d.moduledeclunit;
import parsing.d.declarationunit;

import io.console;

class ModuleUnit : ParseUnit {
protected:

	override bool tokenFound(Token current) {

		// This parsing unit searches for declarations.

		switch (current.type) {

			// Module Declaration
			case DToken.Module:
				
				if (root !is null) {
					// Error: The module declaration is found, 
					// but it is not at the root of the parse tree.
					error("Module declaration should be on one of the first lines of the file.");
				}
				else {
					auto tree = expand!(ModuleDeclUnit)();
				}
				break;

			default:
				lexer.push(current);
				auto tree = expand!(DeclarationUnit)();
				break;
		}
		return true;
	}
}

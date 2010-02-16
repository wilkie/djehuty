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
import parsing.d.modulenameunit;
import parsing.d.declarationunit;

class ModuleUnit : ParseUnit {
	this(Lexer lexer) {
		super(lexer);
	}

protected:

	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.Module:
				if (_root !is null) {
					error("Module declaration should be the first line.");
				}
				else {
					makeNode(DNode.Module, new ModuleNameUnit, "Module");
				}
				break;
			default:
				_lexer.push(current);
				makeNode(new DeclarationUnit);
				break;
		}
		return true;
	}
}
/*
 * declarationunit.d
 *
 */

module parsing.d.declarationunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.staticunit;
import parsing.d.modulenameunit;
import parsing.d.typedeclarationunit;

import djehuty;

import io.console;

class DeclarationUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.Version:
				// version (foo) ...
				break;
			case DToken.Debug:
				// debug (foo) ...
				break;
			case DToken.Static:
				// static ...
				// static if ...
				makeNode(new StaticUnit);
				break;
			case DToken.Synchronized:
				break;
			case DToken.Deprecated:
				break;
			case DToken.Import:
				Console.putln("IMPORT");
				makeNode(DNode.Import, new ModuleNameUnit, "Import");
				break;
			default:
				// type declaration
				_lexer.push(current);
				makeNode(new TypeDeclarationUnit);
				break;
		}
		return true;
	}
}

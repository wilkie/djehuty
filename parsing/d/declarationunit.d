/*
 * declarationunit.d
 *
 */

module parsing.d.declarationunit;

import parsing.parseunit;
import parsing.lexer;
import parsing.token;

import parsing.d.nodes;
import parsing.d.tokens;
import parsing.d.moduledeclunit;
import parsing.d.importdeclunit;
import parsing.d.staticunit;
import parsing.d.declarationunit;
import parsing.d.typedeclarationunit;
import parsing.d.enumdeclunit;
import parsing.d.aggregatedeclunit;
import parsing.d.classdeclunit;
import parsing.d.interfacedeclunit;
import parsing.d.constructorunit;
import parsing.d.destructorunit;

import io.console;

class DeclarationUnit : ParseUnit {
protected:

	override bool tokenFound(Token current) {

		// This parsing unit searches for declarations.

		switch (current.type) {

			// Module Declaration
			case DToken.Module:
				
				// Error: The module declaration is found, 
				// but it is not at the root of the parse tree.
				error("Module declaration should be on one of the first lines of the file.");
				break;

			// Attribute Specifier
			case DToken.Synchronized:
			case DToken.Deprecated:
			case DToken.Final:
			case DToken.Override:
			case DToken.Auto:
			case DToken.Scope:
			case DToken.Private:
			case DToken.Public:
			case DToken.Protected:
			case DToken.Export:
			case DToken.Extern:
			case DToken.Align:
			case DToken.Pragma:
				break;

			// Static
			case DToken.Static:
				auto tree = expand!(StaticUnit)();
				break;

			// Import Declaration
			case DToken.Import:
				auto tree = expand!(ImportDeclUnit)();
				break;

			// Enum Declaration
			case DToken.Enum:
				auto tree = expand!(EnumDeclUnit)();
				break;

			// Template Declaration
			case DToken.Template:
				break;

			// Mixin Declaration
			case DToken.Mixin:
				break;

			// Class Declaration
			case DToken.Class:
				auto tree = expand!(ClassDeclUnit)();
				break;

			// Interface Declaration
			case DToken.Interface:
				auto tree = expand!(InterfaceDeclUnit)();
				break;

			// Aggregate Declaration
			case DToken.Struct:
			case DToken.Union:
				auto tree = expand!(AggregateDeclUnit)();
				break;

			// Constructor Declaration
			case DToken.This:
				auto tree = expand!(ConstructorUnit)();
				break;

			// Destructor Declaration
			case DToken.Cat:
				auto tree = expand!(DestructorUnit)();
				break;

			// Version Block
			case DToken.Version:
				break;

			// Debug Block
			case DToken.Debug:
				break;

			// Unittest Block
			case DToken.Unittest:
				break;

			// Typedef Declaration
			case DToken.Typedef:
				break;

			// Alias Declaration
			case DToken.Alias:
				break;

			// A random semicolon, can't hurt
			case DToken.Semicolon:
				break;

			// If we cannot figure it out, it must be a Type Declaration
			default:
				lexer.push(current);
				auto tree = expand!(TypeDeclarationUnit)();
				break;
		}
		return false;
	}
}

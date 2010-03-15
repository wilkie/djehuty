/*
 * typedeclarationunit.d
 *
 */

module parsing.d.typedeclarationunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.staticunit;
import parsing.d.declaratorunit;

import djehuty;

import io.console;

class TypeDeclarationUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch(this.state) {

			// Looking for a basic type or identifier
			case 0:
				switch (current.type) {
					case DToken.Bool:
					case DToken.Byte:
					case DToken.Ubyte:
					case DToken.Short:
					case DToken.Ushort:
					case DToken.Int:
					case DToken.Uint:
					case DToken.Long:
					case DToken.Ulong:
					case DToken.Char:
					case DToken.Wchar:
					case DToken.Dchar:
					case DToken.Float:
					case DToken.Double:
					case DToken.Real:
					case DToken.Ifloat:
					case DToken.Idouble:
					case DToken.Ireal:
					case DToken.Cfloat:
					case DToken.Cdouble:
					case DToken.Creal:
					case DToken.Void:
						// We have a basic type... look for Declarator
						Console.putln("TypeDecl: basic type");
						auto tree = expand!(DeclaratorUnit)();
						this.state = 1;
						break;

					case DToken.Identifier:
						// Named Type
						break;

					case DToken.Typeof:
						// TypeOfExpression
						// TODO: this
						break;

					// Invalid token for this state
					case DToken.Assign:
						break;

					// Invalid token for this state
					case DToken.Semicolon:
						break;

					default:

						// We will pass this off to a Declarator
						auto tree = expand!(DeclaratorUnit)();
						this.state = 1;
						break;
				}

			// We have found a basic type and are looking for either an initializer
			// or another type declaration. We could also have a function body
			// for function literals.
			case 1:
				switch(current.type) {
					case DToken.Semicolon:
						// Done
						return false;
					case DToken.Comma:
						// XXX: Dunno
						return false;
					case DToken.Assign:
						// Initializer
//						auto tree = expand!(InitializerUnit)();
						this.state = 4;
						break;
					default:
						// It could be a function body
//						auto tree = expand!(FunctionBodyUnit)();
						return false;
				}
				break;

			default:
				break;
		}
		return true;
	}
}

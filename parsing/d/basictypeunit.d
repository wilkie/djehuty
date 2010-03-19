/*
 * typedeclarationunit.d
 *
 */

module parsing.d.basictypeunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.staticunit;
import parsing.d.declaratorunit;

import djehuty;

import io.console;

class BasicTypeUnit : ParseUnit {
	override bool tokenFound(Token current) {

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
				// We have a basic type
				Console.putln("BasicType ");

				// Done.
				return false;

			case DToken.Identifier:
				// Named Type, could be a scoped list
				// TODO:
				break;

			// Scope Operator
			case DToken.Dot:
				// TODO:
				break;

			case DToken.Typeof:
				// TypeOfExpression
				// TODO: this
				break;

			default:

				// We will pass this off to a Declarator
				auto tree = expand!(DeclaratorUnit)();
				this.state = 1;
				break;
		}
		return true;
	}
}

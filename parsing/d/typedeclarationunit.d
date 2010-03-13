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

import djehuty;

import io.console;

class TypeDeclarationUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.Bool:
				break;
			case DToken.Byte:
				break;
			case DToken.Ubyte:
				break;
			case DToken.Short:
				break;
			case DToken.Ushort:
				break;
			case DToken.Int:
				break;
			case DToken.Uint:
				break;
			case DToken.Long:
				break;
			case DToken.Ulong:
				break;
			case DToken.Char:
				break;
			case DToken.Wchar:
				break;
			case DToken.Dchar:
				break;
			case DToken.Float:
				break;
			case DToken.Double:
				break;
			case DToken.Real:
				break;
			case DToken.Ifloat:
				break;
			case DToken.Idouble:
				break;
			case DToken.Ireal:
				break;
			case DToken.Cfloat:
				break;
			case DToken.Cdouble:
				break;
			case DToken.Creal:
				break;
			case DToken.Void:
				break;
			case DToken.Assign:
				break;
			case DToken.Semicolon:
				// end ...
				// XXX: ...
				break;
			case DToken.Typeof:
				// look for typeof expression
				// XXX: ...
				// then look for identifier lists
				// XXX: ...
				break;
			case DToken.Const:
				// look for Parens
				// and then Type
				// XXX: ...
				break;
			case DToken.Invariant:
				// look for Parens
				// and then Type
				// XXX: ...
				break;
			default:
				break;
		}
		return true;
	}
}

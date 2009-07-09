/*
 * lexer.d
 *
 * This module implements the D lexicon.
 *
 */

module tools.dscribe.lexer;

import parsing.lexer;

import core.event;
import core.string;
import core.regex;

import tools.dscribe.tokens;

import console.main;

class LexerD : Lexer {
	this() {
		// D Lexicon

		addRule(Lex.Whitespace, `\s*`);

		// Wysiwyg String Literal

		addRule(Lex.WysiwygString, "`([^`]*)`");
		addRule(Lex.WysiwygString, `r"([^"]*)"`);

		// String Literal

		addRule(Lex.DoubleQuotedString, `"((?:[^\"](?:\\["'?\\abfnrtv])?)*)"`);

		// Comment Line
		addRule(Lex.CommentLine, `//([^\n\r]*)`);

		// Comment Blocks
		addRule(Lex.CommentBlock, `/\*([^\*](?:\*[^/])?)*\*/`);

		// Nested Comment Blocks
		addRule(Lex.CommentNestedStart, `/\+`);

		nestedCommentState = newState(); // For within comment blocks

		// /+ afsdfasdf /+ afsdasdf +/ asdfasdfsda +/

		addRule(Lex.CommentNestedStart, `/\+`);
		addRule(Lex.CommentNestedEnd, `\+/`);
		addRule(Lex.Comment, `([^\+/](?:\+[^/])?)*`);

		setState(normalState);

		// Identifier

		addRule(Lex.Identifier, `[_a-zA-Z][_a-zA-Z0-9]*`);
		addRule(Lex.HexLiteral, `0x[0-9a-fA-F_]+`);
		addRule(Lex.BinaryLiteral, `0b[01_]+`);
		addRule(Lex.OctalLiteral, `0[_0-7]+`);
		addRule(Lex.IntegerLiteral, `([1-9][_0-9]*|0)`);

		// Operators
		addRule(Lex.DivAssign, `/=`);
		addRule(Lex.Div, `/`);

		addRule(Lex.MulAssign, `\*=`);
		addRule(Lex.Mul, `\*`);

		addRule(Lex.AddAdd, `\+\+`);
		addRule(Lex.AddAssign, `+=`);
		addRule(Lex.Add, `\+`);

		addRule(Lex.SubSub, `--`);
		addRule(Lex.SubAssign, `-=`);
		addRule(Lex.Sub, `-`);

		addRule(Lex.AndAnd, `&&`);
		addRule(Lex.AndAssign, `&=`);
		addRule(Lex.And, `&`);

		addRule(Lex.OrOr, `\|\|`);
		addRule(Lex.OrAssign, `\|=`);
		addRule(Lex.Or, `\|`);

		addRule(Lex.DotDotDot, `\.\.\.`);
		addRule(Lex.DotDot, `\.\.`);
		addRule(Lex.Dot, `\.`);

		addRule(Lex.LeftShiftAssign, `<<=`);
		addRule(Lex.LeftShift, `<<`);
		addRule(Lex.LessOrEqual, `<=`);
		addRule(Lex.NotEqualOrEqual, `<>=`);
		addRule(Lex.NotEqual, `<>`);
		addRule(Lex.LessThan, `<`);

		// Special Tokens

		addRule(Lex.SpecialLine, `#line\s+(0x[0-9a-fA-F_]+|0b[01_]+|0[_0-7]+|(?:[1-9][_0-9]*|0))(?:\s+("[^"]*"))?`);
	}

	override bool raiseSignal(uint signal) {
		switch(signal) {
			case Lex.CommentLine:
				token = new Token(Lex.Comment, _1);
				signal = Lex.Comment;
				break;
			case Lex.Whitespace:
				return true;
			case Lex.DoubleQuotedString:
			case Lex.WysiwygString:
				token = new Token(Lex.StringLiteral, _1);
				signal = Lex.StringLiteral;
				break;
			case Lex.CommentBlock:
				// The grouping is the actual comment data
				token = new Token(Lex.Comment, _1);
				signal = Lex.Comment;
				break;
			case Lex.CommentNestedStart:
				if (getState() == nestedCommentState) {
					nestedCommentDepth++;
					comment ~= token.getValue();
					return true;
				}
				else {
					comment = new String("");
					nestedCommentDepth = 0;
					setState(nestedCommentState);
					return true;
				}
			case Lex.CommentNestedEnd:
				if (nestedCommentDepth == 0) {
					setState(normalState);
					return true;
				}
				else {
					comment ~= token.getValue();
					nestedCommentDepth--;
					return true;
				}
			case Lex.Identifier:
				if (token.getValue() == `abstract`) {
					signal = Lex.Abstract;
				}
				else if (token.getValue() == `alias`) {
					signal = Lex.Alias;
				}
				else if (token.getValue() == `align`) {
					signal = Lex.Align;
				}
				else if (token.getValue() == `asm`) {
					signal = Lex.Asm;
				}
				else if (token.getValue() == `assert`) {
					signal = Lex.Assert;
				}
				else if (token.getValue() == `auto`) {
					signal = Lex.Auto;
				}
				else if (token.getValue() == `body`) {
					signal = Lex.Body;
				}
				else if (token.getValue() == `bool`) {
					signal = Lex.Bool;
				}
				else if (token.getValue() == `break`) {
					signal = Lex.Break;
				}
				else if (token.getValue() == `byte`) {
					signal = Lex.Byte;
				}
				else if (token.getValue() == `case`) {
					signal = Lex.Case;
				}
				else if (token.getValue() == `cast`) {
					signal = Lex.Cast;
				}
				else if (token.getValue() == `catch`) {
					signal = Lex.Catch;
				}
				else if (token.getValue() == `cdouble`) {
					signal = Lex.Cdouble;
				}
				else if (token.getValue() == `cent`) {
					signal = Lex.Cent;
				}
				else if (token.getValue() == `cfloat`) {
					signal = Lex.Cfloat;
				}
				else if (token.getValue() == `char`) {
					signal = Lex.Char;
				}
				else if (token.getValue() == `class`) {
					signal = Lex.Class;
				}
				else if (token.getValue() == `const`) {
					signal = Lex.Const;
				}
				else if (token.getValue() == `continue`) {
					signal = Lex.Continue;
				}
				else if (token.getValue() == `creal`) {
					signal = Lex.Creal;
				}
				else if (token.getValue() == `dchar`) {
					signal = Lex.Dchar;
				}
				else if (token.getValue() == `debug`) {
					signal = Lex.Debug;
				}
				else if (token.getValue() == `default`) {
					signal = Lex.Default;
				}
				else if (token.getValue() == `delegate`) {
					signal = Lex.Delegate;
				}
				else if (token.getValue() == `delete`) {
					signal = Lex.Delete;
				}
				else if (token.getValue() == `deprecated`) {
					signal = Lex.Deprecated;
				}
				else if (token.getValue() == `do`) {
					signal = Lex.Do;
				}
				else if (token.getValue() == `double`) {
					signal = Lex.Double;
				}
				else if (token.getValue() == `else`) {
					signal = Lex.Else;
				}
				else if (token.getValue() == `enum`) {
					signal = Lex.Enum;
				}
				else if (token.getValue() == `export`) {
					signal = Lex.Enum;
				}
				else if (token.getValue() == `extern`) {
					signal = Lex.Extern;
				}
				else if (token.getValue() == `false`) {
					signal = Lex.False;
				}
				else if (token.getValue() == `final`) {
					signal = Lex.Final;
				}
				else if (token.getValue() == `finally`) {
					signal = Lex.Finally;
				}
				else if (token.getValue() == `float`) {
					signal = Lex.Float;
				}
				else if (token.getValue() == `for`) {
					signal = Lex.For;
				}
				else if (token.getValue() == `foreach`) {
					signal = Lex.Foreach;
				}
				else if (token.getValue() == `foreach_reverse`) {
					signal = Lex.Foreach_reverse;
				}
				else if (token.getValue() == `function`) {
					signal = Lex.Function;
				}
				else if (token.getValue() == `goto`) {
					signal = Lex.Goto;
				}
				else if (token.getValue() == `idouble`) {
					signal = Lex.Idouble;
				}
				else if (token.getValue() == `if`) {
					signal = Lex.If;
				}
				else if (token.getValue() == `ifloat`) {
					signal = Lex.Ifloat;
				}
				else if (token.getValue() == `import`) {
					signal = Lex.Import;
				}
				else if (token.getValue() == `in`) {
					signal = Lex.In;
				}
				else if (token.getValue() == `inout`) {
					signal = Lex.Inout;
				}
				else if (token.getValue() == `int`) {
					signal = Lex.Int;
				}
				else if (token.getValue() == `interface`) {
					signal = Lex.Interface;
				}
				else if (token.getValue() == `invariant`) {
					signal = Lex.Invariant;
				}
				else if (token.getValue() == `ireal`) {
					signal = Lex.Ireal;
				}
				else if (token.getValue() == `is`) {
					signal = Lex.Is;
				}
				else if (token.getValue() == `lazy`) {
					signal = Lex.Lazy;
				}
				else if (token.getValue() == `long`) {
					signal = Lex.Long;
				}
				else if (token.getValue() == `macro`) {
					signal = Lex.Macro;
				}
				else if (token.getValue() == `mixin`) {
					signal = Lex.Mixin;
				}
				else if (token.getValue() == `module`) {
					signal = Lex.Module;
				}
				else if (token.getValue() == `new`) {
					signal = Lex.New;
				}
				else if (token.getValue() == `null`) {
					signal = Lex.Null;
				}
				else if (token.getValue() == `out`) {
					signal = Lex.Out;
				}
				else if (token.getValue() == `override`) {
					signal = Lex.Override;
				}
				else if (token.getValue() == `package`) {
					signal = Lex.Package;
				}
				else if (token.getValue() == `pragma`) {
					signal = Lex.Pragma;
				}
				else if (token.getValue() == `private`) {
					signal = Lex.Private;
				}
				else if (token.getValue() == `protected`) {
					signal = Lex.Protected;
				}
				else if (token.getValue() == `public`) {
					signal = Lex.Public;
				}
				else if (token.getValue() == `real`) {
					signal = Lex.Real;
				}
				else if (token.getValue() == `ref`) {
					signal = Lex.Ref;
				}
				else if (token.getValue() == `return`) {
					signal = Lex.Return;
				}
				else if (token.getValue() == `scope`) {
					signal = Lex.Scope;
				}
				else if (token.getValue() == `short`) {
					signal = Lex.Short;
				}
				else if (token.getValue() == `static`) {
					signal = Lex.Static;
				}
				else if (token.getValue() == `struct`) {
					signal = Lex.Struct;
				}
				else if (token.getValue() == `super`) {
					signal = Lex.Super;
				}
				else if (token.getValue() == `switch`) {
					signal = Lex.Switch;
				}
				else if (token.getValue() == `synchronized`) {
					signal = Lex.Synchronized;
				}
				else if (token.getValue() == `template`) {
					signal = Lex.Template;
				}
				else if (token.getValue() == `this`) {
					signal = Lex.This;
				}
				else if (token.getValue() == `throw`) {
					signal = Lex.Throw;
				}
				else if (token.getValue() == `true`) {
					signal = Lex.True;
				}
				else if (token.getValue() == `try`) {
					signal = Lex.Try;
				}
				else if (token.getValue() == `typedef`) {
					signal = Lex.Typedef;
				}
				else if (token.getValue() == `typeid`) {
					signal = Lex.Typeid;
				}
				else if (token.getValue() == `typeof`) {
					signal = Lex.Typeof;
				}
				else if (token.getValue() == `ubyte`) {
					signal = Lex.Ubyte;
				}
				else if (token.getValue() == `ucent`) {
					signal = Lex.Ucent;
				}
				else if (token.getValue() == `uint`) {
					signal = Lex.Uint;
				}
				else if (token.getValue() == `ulong`) {
					signal = Lex.Ulong;
				}
				else if (token.getValue() == `union`) {
					signal = Lex.Union;
				}
				else if (token.getValue() == `unittest`) {
					signal = Lex.Unittest;
				}
				else if (token.getValue() == `ushort`) {
					signal = Lex.Ushort;
				}
				else if (token.getValue() == `version`) {
					signal = Lex.Version;
				}
				else if (token.getValue() == `void`) {
					signal = Lex.Void;
				}
				else if (token.getValue() == `volatile`) {
					signal = Lex.Volatile;
				}
				else if (token.getValue() == `wchar`) {
					signal = Lex.Wchar;
				}
				else if (token.getValue() == `while`) {
					signal = Lex.While;
				}
				else if (token.getValue() == `with`) {
					signal = Lex.With;
				}
				else if (token.getValue()[0..2] == `__`) {

					// Reserved Identifiers

					if (token.getValue() == `__FILE__`) {
						signal = Lex.StringLiteral;
						token = new Token(Lex.StringLiteral, new String("file.d"));
					}
					else if (token.getValue() == `__LINE__`) {
						signal = Lex.IntegerLiteral;
						token = new Token(Lex.IntegerLiteral, new String(0));
					}
					else if (token.getValue() == `__DATE__`) {
						signal = Lex.StringLiteral;
						token = new Token(Lex.StringLiteral, new String("mmmm dd yyyy"));
					}
					else if (token.getValue() == `__TIME__`) {
						signal = Lex.StringLiteral;
						token = new Token(Lex.StringLiteral, new String("hh:mm:ss"));
					}
					else if (token.getValue() == `__TIMESTAMP__`) {
						signal = Lex.StringLiteral;
						token = new Token(Lex.StringLiteral, new String("www mmm dd hh:mm:ss yyyy"));
					}
					else if (token.getValue() == `__VENDER__`) {
						signal = Lex.StringLiteral;
						token = new Token(Lex.StringLiteral, new String(""));
					}
					else if (token.getValue() == `__VERSION__`) {
						signal = Lex.IntegerLiteral;
						token = new Token(Lex.StringLiteral, new String(0));
					}
				}
				break;
			default:
				break;
		}

		Console.putln("raiseSignal " , signal, " [", token.getValue(), "]");

		return super.raiseSignal(signal);
	}

protected:
	uint normalState;
	uint commentBlockState;
	uint nestedCommentState;
	uint nestedCommentDepth;
	uint stringLiteralState;
	uint wysiwygLiteralState;
	uint wysiwygRLiteralState;

	String comment;
}
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

		addRule(Lex.Operator, `[/=+*^%\-<>!~&\|\.]+`);

		// Other Lexicon
		addRule(Lex.Delimiter, `[()\][{}?,;:$]`);

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

		// These rules slow down the lexer with their complexity
		addRule(Lex.DecimalFloat, `([0-9][_0-9]*|0)\.(?:[_0-9]+(?:[eE](?:\+|-)?[_0-9]+)?)?([fF]i?|Li?|i)?`);
		addRule(Lex.DecimalFloat, `\.[0-9][_0-9]*(?:[eE](?:\+|-)?[_0-9]+)?([fF]i?|Li?|i)?`);
		addRule(Lex.DecimalFloat, `[0-9][_0-9]*[eE][+-][_0-9]+([fF]i?|Li?|i)?`);

		addRule(Lex.HexFloat, `0[xX](?:[0-9a-fA-F_]+)?\.?[0-9a-fA-F_]+[pP][+-]?[_0-9]+`);

		addRule(Lex.IntegerFloat, `([1-9][_0-9]*|0)([fF]|L)?i`);

		// Identifier

		addRule(Lex.Identifier, `[_a-zA-Z][_a-zA-Z0-9]*`);
		addRule(Lex.HexLiteral, `0[xX][0-9a-fA-F_]+`);
		addRule(Lex.BinaryLiteral, `0[bB][01_]+`);
		addRule(Lex.OctalLiteral, `0[_0-7]+`);
		addRule(Lex.IntegerLiteral, `([1-9][_0-9]*|0)`);

		// Special Tokens

		addRule(Lex.SpecialLine, 
			`#line\s+(0x[0-9a-fA-F_]+|0b[01_]+|0[_0-7]+|(?:[1-9][_0-9]*|0))(?:\s+("[^"]*"))?`);
	}

	override bool raiseSignal(uint signal) {
		switch(signal) {
			case Lex.Delimiter:
						Console.putln(token.getString());
				switch(token.getString()[0]) {
					case '(':
						token = new Token(Lex.LeftParen);
						break;
					case ')':
						token = new Token(Lex.RightParen);
						break;
					case '{':
						token = new Token(Lex.LeftCurly);
						break;
					case '}':
						token = new Token(Lex.RightCurly);
						break;
					case '[':
						token = new Token(Lex.LeftBrace);
						break;
					case ']':
						token = new Token(Lex.RightBrace);
						break;
					case '?':
						token = new Token(Lex.QuestionMark);
						break;
					case ',':
						token = new Token(Lex.Comma);
						break;
					case ';':
						token = new Token(Lex.Semicolon);
						break;
					case ':':
						token = new Token(Lex.Colon);
						break;
					case '$':
						token = new Token(Lex.Dollar);
						break;
					default:
						// unknown block delimiter
						return true;
					}
				break;
			case Lex.Operator:
				switch(token.getString().toString) {
					case `==`:
						token = new Token(Lex.Equal);
						break;
					case `=`:
						token = new Token(Lex.Assign);
						break;
					case `>>`:
						token = new Token(Lex.RightShift);
						break;
					case `>>=`:
						token = new Token(Lex.RightShiftAssign);
						break;
					case `>>>`:
						token = new Token(Lex.RightShiftUnsigned);
						break;
					case `>>>=`:
						token = new Token(Lex.RightShiftUnsignedAssign);
						break;
					case `>`:
						token = new Token(Lex.GreaterThan);
						break;
					case `>=`:
						token = new Token(Lex.GreaterOrEqual);
						break;
					case `<<`:
						token = new Token(Lex.LeftShift);
						break;
					case `<<=`:
						token = new Token(Lex.LeftShiftAssign);
						break;
					case `<`:
						token = new Token(Lex.LessThan);
						break;
					case `<=`:
						token = new Token(Lex.LessOrEqual);
						break;
					case `<>`:
						token = new Token(Lex.NotEqual);
						break;
					case `!=`:
						token = new Token(Lex.UnorderedNotEqual);
						break;
					case `!<>`:
						token = new Token(Lex.UnorderedEqual);
						break;
					case `!>=`:
						token = new Token(Lex.UnorderedLessThan);
						break;
					case `!<=`:
						token = new Token(Lex.UnorderedGreaterThan);
						break;
					case `!<`:
						token = new Token(Lex.UnorderedGreaterOrEqual);
						break;
					case `!>`:
						token = new Token(Lex.UnorderedLessOrEqual);
						break;
					case `<>=`:
						token = new Token(Lex.Tautology);
						break;
					case `!<>=`:
						token = new Token(Lex.UnorderedContradiction);
						break;
					case `.`:
						token = new Token(Lex.Dot);
						break;
					case `..`:
						token = new Token(Lex.DotDot);
						break;
					case `...`:
						token = new Token(Lex.DotDotDot);
						break;
					case `&&`:
						token = new Token(Lex.AndAnd);
						break;
					case `&=`:
						token = new Token(Lex.AndAssign);
						break;
					case `&`:
						token = new Token(Lex.And);
						break;
					case `||`:
						token = new Token(Lex.OrOr);
						break;
					case `|=`:
						token = new Token(Lex.OrAssign);
						break;
					case `|`:
						token = new Token(Lex.Or);
						break;
					case `-=`:
						token = new Token(Lex.SubAssign);
						break;
					case `-`:
						token = new Token(Lex.Sub);
						break;
					case `+=`:
						token = new Token(Lex.AddAssign);
						break;
					case `+`:
						token = new Token(Lex.Add);
						break;
					case `*=`:
						token = new Token(Lex.MulAssign);
						break;
					case `*`:
						token = new Token(Lex.Mul);
						break;
					case `/=`:
						token = new Token(Lex.DivAssign);
						break;
					case `/`:
						token = new Token(Lex.Div);
						break;
					case `~=`:
						token = new Token(Lex.CatAssign);
						break;
					case `~`:
						token = new Token(Lex.Cat);
						break;
					case `!`:
						token = new Token(Lex.Bang);
						break;
					default:
						// unknown operator
						return true;
				}
				break;
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
					comment ~= token.getString();
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
					comment ~= token.getString();
					nestedCommentDepth--;
					return true;
				}
			case Lex.HexLiteral:
				ulong value = 0;

				foreach(chr; token.getString()[2..token.getString().length]) {
					if (chr != '_') {
						value *= 16;
						if (chr >= 'a' && chr <= 'f') {
							value += 10 + (chr - 'a');
						}
						else if (chr >= 'A' && chr <= 'F') {
							value += 10 + (chr - 'A');
						}
						else {
							value += chr - '0';
						}
					}
				}
				
				token = new Token(Lex.IntegerLiteral, value);
				break;
			case Lex.OctalLiteral:
				ulong value = 0;

				foreach(chr; token.getString()[1..token.getString().length]) {
					if (chr != '_') {
						value *= 8;
						value += chr - '0';
					}
				}

				token = new Token(Lex.IntegerLiteral, value);
				break;
			case Lex.BinaryLiteral:
				ulong value = 0;

				foreach(chr; token.getString()[2..token.getString().length]) {
					if (chr != '_') {
						value *= 2;
						value += chr - '0';
					}
				}
				
				token = new Token(Lex.IntegerLiteral, value);
				break;
			case Lex.IntegerLiteral:
				ulong value = 0;

				foreach(chr; token.getString()) {
					if (chr != '_') {
						value *= 10;
						value += chr - '0';
					}
				}
				
				token = new Token(Lex.IntegerLiteral, value);
				break;
			case Lex.Identifier:
				if (token.getString() == `abstract`) {
					token = new Token(Lex.Abstract);
				}
				else if (token.getString() == `alias`) {
					token = new Token(Lex.Alias);
				}
				else if (token.getString() == `align`) {
					token = new Token(Lex.Align);
				}
				else if (token.getString() == `asm`) {
					token = new Token(Lex.Asm);
				}
				else if (token.getString() == `assert`) {
					token = new Token(Lex.Assert);
				}
				else if (token.getString() == `auto`) {
					token = new Token(Lex.Auto);
				}
				else if (token.getString() == `body`) {
					token = new Token(Lex.Body);
				}
				else if (token.getString() == `bool`) {
					token = new Token(Lex.Bool);
				}
				else if (token.getString() == `break`) {
					token = new Token(Lex.Break);
				}
				else if (token.getString() == `byte`) {
					token = new Token(Lex.Byte);
				}
				else if (token.getString() == `case`) {
					token = new Token(Lex.Case);
				}
				else if (token.getString() == `cast`) {
					token = new Token(Lex.Cast);
				}
				else if (token.getString() == `catch`) {
					token = new Token(Lex.Catch);
				}
				else if (token.getString() == `cdouble`) {
					token = new Token(Lex.Cdouble);
				}
				else if (token.getString() == `cent`) {
					token = new Token(Lex.Cent);
				}
				else if (token.getString() == `cfloat`) {
					token = new Token(Lex.Cfloat);
				}
				else if (token.getString() == `char`) {
					token = new Token(Lex.Char);
				}
				else if (token.getString() == `class`) {
					token = new Token(Lex.Class);
				}
				else if (token.getString() == `const`) {
					token = new Token(Lex.Const);
				}
				else if (token.getString() == `continue`) {
					token = new Token(Lex.Continue);
				}
				else if (token.getString() == `creal`) {
					token = new Token(Lex.Creal);
				}
				else if (token.getString() == `dchar`) {
					token = new Token(Lex.Dchar);
				}
				else if (token.getString() == `debug`) {
					token = new Token(Lex.Debug);
				}
				else if (token.getString() == `default`) {
					token = new Token(Lex.Default);
				}
				else if (token.getString() == `delegate`) {
					token = new Token(Lex.Delegate);
				}
				else if (token.getString() == `delete`) {
					token = new Token(Lex.Delete);
				}
				else if (token.getString() == `deprecated`) {
					token = new Token(Lex.Deprecated);
				}
				else if (token.getString() == `do`) {
					token = new Token(Lex.Do);
				}
				else if (token.getString() == `double`) {
					token = new Token(Lex.Double);
				}
				else if (token.getString() == `else`) {
					token = new Token(Lex.Else);
				}
				else if (token.getString() == `enum`) {
					token = new Token(Lex.Enum);
				}
				else if (token.getString() == `export`) {
					token = new Token(Lex.Enum);
				}
				else if (token.getString() == `extern`) {
					token = new Token(Lex.Extern);
				}
				else if (token.getString() == `false`) {
					token = new Token(Lex.False);
				}
				else if (token.getString() == `final`) {
					token = new Token(Lex.Final);
				}
				else if (token.getString() == `finally`) {
					token = new Token(Lex.Finally);
				}
				else if (token.getString() == `float`) {
					token = new Token(Lex.Float);
				}
				else if (token.getString() == `for`) {
					token = new Token(Lex.For);
				}
				else if (token.getString() == `foreach`) {
					token = new Token(Lex.Foreach);
				}
				else if (token.getString() == `foreach_reverse`) {
					token = new Token(Lex.Foreach_reverse);
				}
				else if (token.getString() == `function`) {
					token = new Token(Lex.Function);
				}
				else if (token.getString() == `goto`) {
					token = new Token(Lex.Goto);
				}
				else if (token.getString() == `idouble`) {
					token = new Token(Lex.Idouble);
				}
				else if (token.getString() == `if`) {
					token = new Token(Lex.If);
				}
				else if (token.getString() == `ifloat`) {
					token = new Token(Lex.Ifloat);
				}
				else if (token.getString() == `import`) {
					token = new Token(Lex.Import);
				}
				else if (token.getString() == `in`) {
					token = new Token(Lex.In);
				}
				else if (token.getString() == `inout`) {
					token = new Token(Lex.Inout);
				}
				else if (token.getString() == `int`) {
					token = new Token(Lex.Int);
				}
				else if (token.getString() == `interface`) {
					token = new Token(Lex.Interface);
				}
				else if (token.getString() == `invariant`) {
					token = new Token(Lex.Invariant);
				}
				else if (token.getString() == `ireal`) {
					token = new Token(Lex.Ireal);
				}
				else if (token.getString() == `is`) {
					token = new Token(Lex.Is);
				}
				else if (token.getString() == `lazy`) {
					token = new Token(Lex.Lazy);
				}
				else if (token.getString() == `long`) {
					token = new Token(Lex.Long);
				}
				else if (token.getString() == `macro`) {
					token = new Token(Lex.Macro);
				}
				else if (token.getString() == `mixin`) {
					token = new Token(Lex.Mixin);
				}
				else if (token.getString() == `module`) {
					token = new Token(Lex.Module);
				}
				else if (token.getString() == `new`) {
					token = new Token(Lex.New);
				}
				else if (token.getString() == `null`) {
					token = new Token(Lex.Null);
				}
				else if (token.getString() == `out`) {
					token = new Token(Lex.Out);
				}
				else if (token.getString() == `override`) {
					token = new Token(Lex.Override);
				}
				else if (token.getString() == `package`) {
					token = new Token(Lex.Package);
				}
				else if (token.getString() == `pragma`) {
					token = new Token(Lex.Pragma);
				}
				else if (token.getString() == `private`) {
					token = new Token(Lex.Private);
				}
				else if (token.getString() == `protected`) {
					token = new Token(Lex.Protected);
				}
				else if (token.getString() == `public`) {
					token = new Token(Lex.Public);
				}
				else if (token.getString() == `real`) {
					token = new Token(Lex.Real);
				}
				else if (token.getString() == `ref`) {
					token = new Token(Lex.Ref);
				}
				else if (token.getString() == `return`) {
					token = new Token(Lex.Return);
				}
				else if (token.getString() == `scope`) {
					token = new Token(Lex.Scope);
				}
				else if (token.getString() == `short`) {
					token = new Token(Lex.Short);
				}
				else if (token.getString() == `static`) {
					token = new Token(Lex.Static);
				}
				else if (token.getString() == `struct`) {
					token = new Token(Lex.Struct);
				}
				else if (token.getString() == `super`) {
					token = new Token(Lex.Super);
				}
				else if (token.getString() == `switch`) {
					token = new Token(Lex.Switch);
				}
				else if (token.getString() == `synchronized`) {
					token = new Token(Lex.Synchronized);
				}
				else if (token.getString() == `template`) {
					token = new Token(Lex.Template);
				}
				else if (token.getString() == `this`) {
					token = new Token(Lex.This);
				}
				else if (token.getString() == `throw`) {
					token = new Token(Lex.Throw);
				}
				else if (token.getString() == `true`) {
					token = new Token(Lex.True);
				}
				else if (token.getString() == `try`) {
					token = new Token(Lex.Try);
				}
				else if (token.getString() == `typedef`) {
					token = new Token(Lex.Typedef);
				}
				else if (token.getString() == `typeid`) {
					token = new Token(Lex.Typeid);
				}
				else if (token.getString() == `typeof`) {
					token = new Token(Lex.Typeof);
				}
				else if (token.getString() == `ubyte`) {
					token = new Token(Lex.Ubyte);
				}
				else if (token.getString() == `ucent`) {
					token = new Token(Lex.Ucent);
				}
				else if (token.getString() == `uint`) {
					token = new Token(Lex.Uint);
				}
				else if (token.getString() == `ulong`) {
					token = new Token(Lex.Ulong);
				}
				else if (token.getString() == `union`) {
					token = new Token(Lex.Union);
				}
				else if (token.getString() == `unittest`) {
					token = new Token(Lex.Unittest);
				}
				else if (token.getString() == `ushort`) {
					token = new Token(Lex.Ushort);
				}
				else if (token.getString() == `version`) {
					token = new Token(Lex.Version);
				}
				else if (token.getString() == `void`) {
					token = new Token(Lex.Void);
				}
				else if (token.getString() == `volatile`) {
					token = new Token(Lex.Volatile);
				}
				else if (token.getString() == `wchar`) {
					token = new Token(Lex.Wchar);
				}
				else if (token.getString() == `while`) {
					token = new Token(Lex.While);
				}
				else if (token.getString() == `with`) {
					token = new Token(Lex.With);
				}
				else if (token.getString()[0..2] == `__`) {

					// Reserved Identifiers

					if (token.getString() == `__FILE__`) {
						token = new Token(Lex.StringLiteral, new String("file.d"));
					}
					else if (token.getString() == `__LINE__`) {
						token = new Token(Lex.IntegerLiteral, new String(0));
					}
					else if (token.getString() == `__DATE__`) {
						token = new Token(Lex.StringLiteral, new String("mmmm dd yyyy"));
					}
					else if (token.getString() == `__TIME__`) {
						token = new Token(Lex.StringLiteral, new String("hh:mm:ss"));
					}
					else if (token.getString() == `__TIMESTAMP__`) {
						token = new Token(Lex.StringLiteral, new String("www mmm dd hh:mm:ss yyyy"));
					}
					else if (token.getString() == `__VENDER__`) {
						token = new Token(Lex.StringLiteral, new String(""));
					}
					else if (token.getString() == `__VERSION__`) {
						token = new Token(Lex.StringLiteral, new String(0));
					}
				}
				break;
			default:
				break;
		}

		if (token.getString is null) {
			Console.put(((token.getId())), " [", token.getInteger(), "] ");
		}
		else {
			Console.put(((token.getId())), " [", token.getString(), "] ");
		}

		return super.raiseSignal(token.getId());
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
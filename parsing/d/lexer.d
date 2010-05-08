module parsing.d.lexer;

import parsing.token;
import parsing.lexer;

import parsing.d.tokens;

import djehuty;

import data.stack;

import io.console;

class DLexer : Lexer {

	this(Stream stream) {
		super(stream);
		_bank = new Stack!(Token);
		_stream = stream;
	}

	void push(Token token) {
		_bank.push(token);
	}

	string line() {
		return _line;
	}

	string line(uint number) {
		number--;
		if (number >= _lines.length) {
			return "";
		}
		return _lines[number];
	}

	Token pop() {
		if (!_bank.empty) {
			return _bank.pop();
		}
		Token current;
		current.line = _lineNumber;
		current.column = _pos + 1;

		// will give us a string for the line of utf8 characters.
		for(;;) {
			if (_line is null || _pos >= _line.length) {
				if(!_stream.readLine(_line)) {
					return Token.init;
				}
				_lines ~= _line;
				_lineNumber++;
				_pos = 0;
				current.line++;
				current.column = 1;
			}

			// now break up the line into tokens
			// the return for the line is whitespace, and can be ignored

			for(; _pos <= _line.length; _pos++) {
				char chr;
				if (_pos == _line.length) {
					chr = '\n';
				}
				else {
					chr = _line[_pos];
				}
				switch (state) {
					default:
						// error
						_error("error");
						return Token.init;

					case LexerState.Normal:
						if (tokenMapping[chr] != DToken.Invalid) {
							DToken newType = tokenMapping[chr];
							switch(current.type) {
								case DToken.And: // &
									if (newType == DToken.And) {
										// &&
										current.type = DToken.LogicalAnd;
									}
									else if (newType == DToken.Assign) {
										// &=
										current.type = DToken.AndAssign;
									}
									else {
										goto default;
									}
									break;
								case DToken.Or: // |
									if (newType == DToken.Or) {
										// ||
										current.type = DToken.LogicalOr;
									}
									else if (newType == DToken.Assign) {
										// |=
										current.type = DToken.OrAssign;
									}
									else {
										goto default;
									}
									break;
								case DToken.Add: // +
									if (newType == DToken.Assign) {
										// +=
										current.type = DToken.AddAssign;
									}
									else if (newType == DToken.Add) {
										// ++
										current.type = DToken.Increment;
									}
									else {
										goto default;
									}
									break;
								case DToken.Sub: // -
									if (newType == DToken.Assign) {
										// -=
										current.type = DToken.SubAssign;
									}
									else if (newType == DToken.Sub) {
										// --
										current.type = DToken.Decrement;
									}
									else {
										goto default;
									}
									break;
								case DToken.Div: // /
									if (newType == DToken.Assign) {
										// /=
										current.type = DToken.DivAssign;
									}
									else if (newType == DToken.Add) {
										// /+
									}
									else if (newType == DToken.Div) {
										// //
									}
									else if (newType == DToken.Mul) {
										// /*
									}
									else {
										goto default;
									}
									break;
								case DToken.Mul: // *
									if (newType == DToken.Assign) {
										// *=
										current.type = DToken.MulAssign;
									}
									else {
										goto default;
									}
									break;
								case DToken.Mod: // %
									if (newType == DToken.Assign) {
										// %=
										current.type = DToken.ModAssign;
									}
									else {
										goto default;
									}
									break;
								case DToken.Xor: // ^
									if (newType == DToken.Assign) {
										// ^=
										current.type = DToken.XorAssign;
									}
									else {
										goto default;
									}
									break;
								case DToken.Cat: // ~
									if (newType == DToken.Assign) {
										// ~=
										current.type = DToken.CatAssign;
									}
									else {
										goto default;
									}
									break;
								case DToken.Assign: // =
									if (newType == DToken.Assign) {
										// ==
										current.type = DToken.Equals;
									}
									else {
										goto default;
									}
									break;
								case DToken.LessThan: // <
									if (newType == DToken.LessThan) {
										// <<
										current.type = DToken.ShiftLeft;
									}
									else if (newType == DToken.Assign) {
										// <=
										current.type = DToken.LessThanEqual;
									}
									else if (newType == DToken.GreaterThan) {
										// <>
										current.type = DToken.LessThanGreaterThan;
									}
									else {
										goto default;
									}
									break;
								case DToken.GreaterThan: // >
									if (newType == DToken.GreaterThan) {
										// >>
										current.type = DToken.ShiftRight;
									}
									else if (newType == DToken.Assign) {
										// >=
										current.type = DToken.GreaterThanEqual;
									}
									else {
										goto default;
									}
									break;
								case DToken.ShiftLeft: // <<
									if (newType == DToken.Assign) {
										// <<=
										current.type = DToken.ShiftLeftAssign;
									}
									else {
										goto default;
									}
									break;
								case DToken.ShiftRight: // >>
									if (newType == DToken.Assign) {
										// >>=
										current.type = DToken.ShiftRightAssign;
									}
									else if (newType == DToken.GreaterThan) {
										// >>>
										current.type = DToken.ShiftRightSigned;
									}
									else {
										goto default;
									}
									break;
								case DToken.ShiftRightSigned: // >>>
									if (newType == DToken.Assign) {
										// >>>=
										current.type = DToken.ShiftRightSignedAssign;
									}
									else {
										goto default;
									}
									break;
								case DToken.LessThanGreaterThan: // <>
									if (newType == DToken.Assign) {
										// <>=
										current.type = DToken.LessThanGreaterThanEqual;
									}
									else {
										goto default;
									}
									break;
								case DToken.Bang: // !
									if (newType == DToken.LessThan) {
										// !<
										current.type = DToken.NotLessThan;
									}
									else if (newType == DToken.GreaterThan) {
										// !>
										current.type = DToken.NotGreaterThan;
									}
									else if (newType == DToken.Assign) {
										// !=
										current.type = DToken.NotEquals;
									}
									else {
										goto default;
									}
									break;
								case DToken.NotLessThan: // !<
									if (newType == DToken.GreaterThan) {
										// !<>
										current.type = DToken.NotLessThanGreaterThan;
									}
									else if (newType == DToken.Assign) {
										// !<=
										current.type = DToken.NotLessThanEqual;
									}
									else {
										goto default;
									}
									break;
								case DToken.NotGreaterThan: // !>
									if (newType == DToken.Assign) {
										// !>=
										current.type = DToken.NotGreaterThanEqual;
									}
									else {
										goto default;
									}
									break;
								case DToken.NotLessThanGreaterThan: // !<>
									if (newType == DToken.Assign) {
										// !<>=
										current.type = DToken.NotLessThanGreaterThanEqual;
									}
									else {
										goto default;
									}
									break;
								case DToken.Dot: // .
									if (newType == DToken.Dot) {
										// ..
										current.type = DToken.Slice;
									}
									else {
										goto default;
									}
									break;
								case DToken.Slice: // ..
									if (newType == DToken.Dot) {
										// ...
										current.type = DToken.Variadic;
									}
									else {
										goto default;
									}
									break;
								case DToken.Invalid:
									current.type = tokenMapping[chr];
									break;
								default:
									// Token Error
									if (current.type != DToken.Invalid) {
										current.columnEnd = _pos;
										current.lineEnd = _lineNumber;
										return current;
									}
//									_error("Unknown operator.");
									return Token.init;
							}
							
							continue;
						}

						// A character that will switch states continues

						// Strings
						if (chr == '\'') {
							state = LexerState.String;
							inStringType = StringType.Character;
							cur_string = "";
							if (current.type != DToken.Invalid) {
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;
								_pos++;
								return current;
							}
							continue;
						}
						else if (chr == '"') {
							state = LexerState.String;
							inStringType = StringType.DoubleQuote;
							cur_string = "";
							if (current.type != DToken.Invalid) {
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;
								_pos++;
								return current;
							}
							continue;
						}
						else if (chr == '`') {
							state = LexerState.String;
							inStringType = StringType.WhatYouSeeQuote;
							cur_string = "";
							if (current.type != DToken.Invalid) {
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;
								_pos++;
								return current;
							}
							continue;
						}

						// Whitespace
						else if (chr == ' ' || chr == '\t' || chr == '\n') {
							if (current.type != DToken.Invalid) {
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;
								_pos++;
								return current;
							}
							current.column++;
							continue;
						}

						// Identifiers
						else if ((chr >= 'a' && chr <= 'z') || (chr >= 'A' && chr <= 'Z') || chr == '_') {
							state = LexerState.Identifier;
							cur_string = "";
							if (current.type != DToken.Invalid) {
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;
								return current;
							}
							goto case LexerState.Identifier;
						}

						// Numbers
						else if (chr >= '0' && chr <= '9') {
							// reset to invalid base
							cur_base = 0;
							cur_decimal = 0;
							cur_denominator = 1;
							cur_exponent = 0;

							if (current.type == DToken.Dot) {
								current.type = DToken.Invalid;
								inDecimal = true;
								inExponent = false;
								cur_integer = 0;
								cur_base = 10;
								state = LexerState.FloatingPoint;
								goto case LexerState.FloatingPoint;
							}
							else {
								state = LexerState.Integer;

								if (current.type != DToken.Invalid) {
									current.columnEnd = _pos;
									current.lineEnd = _lineNumber;
									return current;
								}
								goto case LexerState.Integer;
							}
						}
						break;

					case LexerState.String:
						if (inEscape) {
							inEscape = false;
							if (chr == 't') {
								chr = '\t';
							}
							else if (chr == 'b') {
								chr = '\b';
							}
							else if (chr == 'r') {
								chr = '\r';
							}
							else if (chr == 'n') {
								chr = '\n';
							}
							else if (chr == '0') {
								chr = '\0';
							}
							else if (chr == 'x' || chr == 'X') {
								// BLEH!
							}
							cur_string ~= chr;
							continue;
						}

						if (inStringType == StringType.DoubleQuote) {
							if (chr == '"') {
								state = LexerState.Normal;
								current.type = DToken.StringLiteral;
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;
								if (cur_string !is null) {
									current.value = cur_string;
								}
								_pos++;
								return current;
							}
						}
						else if (inStringType == StringType.RawWhatYouSeeQuote) {
							if (chr == '"') {
								state = LexerState.Normal;
								current.type = DToken.StringLiteral;
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;
								if (cur_string !is null) {
									current.value = cur_string;
								}
								_pos++;
								return current;
							}
						}
						else if (inStringType == StringType.WhatYouSeeQuote) {
							if (chr == '`') {
								state = LexerState.Normal;
								current.type = DToken.StringLiteral;
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;
								if (cur_string !is null) {
									current.value = cur_string;
								}
								_pos++;
								return current;
							}
						}
						else { // StringType.Character
							if (chr == '\'') {
								if (cur_string.length > 1) {
									// error
									goto default;
								}
								state = LexerState.Normal;
								current.type = DToken.CharacterLiteral;
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;
								if (cur_string !is null) {
									current.value = cur_string;
								}
								_pos++;
								return current;
							}
						}

						if ((inStringType == StringType.DoubleQuote || inStringType == StringType.Character) && (chr == '\\')) {
							// Escaped Characters
							inEscape = true;
						}
						else {
							cur_string ~= chr;
						}
						continue;
					case LexerState.Comment:
						break;
					case LexerState.Identifier:
						// check for valid succeeding character
						if ((chr < 'a' || chr > 'z') && (chr < 'A' || chr > 'Z') && chr != '_' && (chr < '0' || chr > '9')) {
							// Invalid identifier symbol
							static DToken keywordStart = DToken.Abstract;
							static const string[] keywordList = ["abstract", "alias", "align", "asm", "assert", "auto",
								"body", "bool", "break", "byte", "case", "cast","catch","cdouble","cent","cfloat","char",
								"class","const","continue","creal","dchar","debug","default","delegate","delete","deprecated",
								"do","double","else","enum","export","extern","false","final","finally","float","for","foreach",
								"foreach_reverse","function","goto","idouble","if","ifloat","import","in","inout","int","interface",
								"invariant","ireal","is","lazy","long","macro","mixin","module","new","null","out","override",
								"package","pragma","private","protected","public","real","ref","return","scope","short","static",
								"struct","super","switch","synchronized","template","this","throw","true","try",
								"typedef","typeid","typeof","ubyte","ucent","uint","ulong","union","unittest","ushort","version",
								"void","volatile","wchar","while","with"
							];
							current.type = DToken.Identifier;

							foreach(size_t i, keyword; keywordList) {
								if (cur_string == keyword) {
									current.type = keywordStart + i;
									cur_string = null;
									break;
								}
							}

							if (cur_string !is null) {
								current.value = cur_string;
							}
							state = LexerState.Normal;
							if (current.type != DToken.Invalid) {
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;
								return current;
							}
							goto case LexerState.Normal;
						}
						cur_string ~= chr;
						continue;
					case LexerState.Integer:
						// check for valid succeeding character

						// we may want to switch to floating point state
						if (chr == '.') {
							if (cur_base <= 0) {
								cur_base = 10;
							}
							else if (cur_base == 2) {
								_error("Cannot have binary floating point literals");
								return Token.init;
							}
							else if (cur_base == 8) {
								_error("Cannot have octal floating point literals");
								return Token.init;
							}

							// Reset this just in case, it will get interpreted
							// in the Floating Point state
							inDecimal = false;
							inExponent = false;

							state = LexerState.FloatingPoint;
							goto case LexerState.FloatingPoint;
						}
						else if ((chr == 'p' || chr == 'P') && cur_base == 16) {
							// Reset this just in case, it will get interpreted
							// in the Floating Point state
							inDecimal = false;
							inExponent = false;

							state = LexerState.FloatingPoint;
							goto case LexerState.FloatingPoint;
						}
						else if (chr == '_') {
							// ignore
							if (cur_base == -1) {
								// OCTAL
								cur_base = 8;
							}
						}
						else if (cur_base == 0) {
							// this is the first value
							if (chr == '0') {
								// octal or 0 or 0.0, etc
								// use an invalid value so we can decide
								cur_base = -1;
								cur_integer = 0;
							}
							else if (chr >= '1' && chr <= '9') {
								cur_base = 10;
								cur_integer = (chr - '0');
							}
							// Cannot be any other value
							else {
								_error("Integer literal expected.");
								return Token.init;
							}
						}
						else if (cur_base == -1) {
							// this is the second value of an ambiguous base
							if (chr >= '0' && chr <= '7') {
								// OCTAL
								cur_base = 8;
								cur_integer = (chr - '0');
							}
							else if (chr == 'x' || chr == 'X') {
								// HEX
								cur_base = 16;
							}
							else if (chr == 'b' || chr == 'B') {
								// BINARY
								cur_base = 2;
							}
							else {
								// 0 ?
								current.type = DToken.IntegerLiteral;
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;

								state = LexerState.Normal;
								return current;
							}
						}
						else if (cur_base == 16) {
							if ((chr < '0' || chr > '9') && (chr < 'a' || chr > 'f') && (chr < 'A' || chr > 'F')) {
								current.type = DToken.IntegerLiteral;
								current.value = cur_integer;
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;

								state = LexerState.Normal;
								return current;
							}
							else {
								cur_integer *= cur_base;
								if (chr >= 'a' && chr <= 'f') {
									cur_integer += 10 + (chr - 'a');
								}
								else if (chr >= 'A' && chr <= 'F') {
									cur_integer += 10 + (chr - 'A');
								}
								else {
									cur_integer += (chr - '0');
								}
							}
						}
						else if (cur_base == 10) {
							if (chr < '0' || chr > '9') {
								current.type = DToken.IntegerLiteral;
								current.value = cur_integer;
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;

								state = LexerState.Normal;
								return current;
							}
							else {
								cur_integer *= cur_base;
								cur_integer += (chr - '0');
							}
						}
						else if (cur_base == 8) {
							if (chr >= '8' && chr <= '9') {
								_error("Digits higher than 7 in an octal integer literal are invalid.");
								return Token.init;
							}
							else if (chr < '0' || chr > '7') {
								current.type = DToken.IntegerLiteral;
								current.value = cur_integer;
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;

								state = LexerState.Normal;
								return current;
							}
							else {
								cur_integer *= cur_base;
								cur_integer += (chr - '0');
							}
						}
						else if (cur_base == 2) {
							if (chr < '0' || chr > '1') {
								current.type = DToken.IntegerLiteral;
								current.value = cur_integer;
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;

								state = LexerState.Normal;
								return current;
							}
							else {
								cur_integer *= cur_base;
								cur_integer += (chr - '0');
							}
						}

						continue;
					case LexerState.FloatingPoint:
						if (chr == '_') {
							continue;
						}
						else if (chr == '.' && (cur_base == 10 || cur_base == 16)) {
							// We are now parsing the decimal portion
							if (inDecimal) {
								_error("Only one decimal point is allowed per floating point literal.");
								return Token.init;
							}
							else if (inExponent) {
								_error("Cannot put a decimal point after an exponent in a floating point literal.");
							}
							inDecimal = true;
						}
						else if (cur_base == 16 && (chr == 'p' || chr == 'P')) {
							// We are now parsing the exponential portion
							inDecimal = false;
							inExponent = true;
							cur_exponent = -1;
						}
						else if (cur_base == 10 && (chr == 'e' || chr == 'E')) {
							// We are now parsing the exponential portion
							inDecimal = false;
							inExponent = true;
							cur_exponent = -1;
						}
						else if (cur_base == 10) {
							if (chr == 'p' || chr == 'P') {
								_error("Cannot have a hexidecimal exponent in a non-hexidecimal floating point literal.");
								return Token.init;
							}
							else if (chr < '0' || chr > '9') {
								if (inExponent && cur_exponent == -1) {
									_error("You need to specify a value for the exponent part of the floating point literal.");
									return Token.init;
								}
								current.type = DToken.FloatingPointLiteral;
								double value = cast(double)cur_integer + (cast(double)cur_decimal / cast(double)cur_denominator);
								double exp = 1;
								for(size_t i = 0; i < cur_exponent; i++) {
									exp *= cur_base;
								}
								value *= exp;
								current.value = value;
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;

								state = LexerState.Normal;
								return current;
							}
							else if (inExponent) {
								if (cur_exponent == -1) {
									cur_exponent = 0;
								}
								cur_exponent *= cur_base;
								cur_exponent += (chr - '0');
							}
							else {
								cur_decimal *= cur_base;
								cur_denominator *= cur_base;
								cur_decimal += (chr - '0');
							}
						}
						else { // cur_base == 16
							if ((chr < '0' || chr > '9') && (chr < 'a' || chr > 'f') && (chr < 'A' || chr > 'F')) {
								if (inDecimal && !inExponent) {
									_error("You need to provide an exponent with the decimal portion of a hexidecimal floating point number. Ex: 0xff.3p2");
									return Token.init;
								}
								if (inExponent && cur_exponent == -1) {
									_error("You need to specify a value for the exponent part of the floating point literal.");
									return Token.init;
								}
								current.type = DToken.FloatingPointLiteral;
								double value = cast(double)cur_integer + (cast(double)cur_decimal / cast(double)cur_denominator);
								double exp = 1;
								for(size_t i = 0; i < cur_exponent; i++) {
									exp *= 2;
								}
								value *= exp;
								current.value = value;
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;

								state = LexerState.Normal;
								return current;
							}
							else if (inExponent) {
								if (cur_exponent == -1) {
									cur_exponent = 0;
								}
								cur_exponent *= cur_base;
								if (chr >= 'A' && chr <= 'F') {
									cur_exponent += 10 + (chr - 'A');
								}
								else if (chr >= 'a' && chr <= 'f') {
									cur_exponent += 10 + (chr - 'a');
								}
								else {
									cur_exponent += (chr - '0');
								}
							}
							else {
								cur_decimal *= cur_base;
								cur_denominator *= cur_base;
								if (chr >= 'A' && chr <= 'F') {
									cur_decimal += 10 + (chr - 'A');
								}
								else if (chr >= 'a' && chr <= 'f') {
									cur_decimal += 10 + (chr - 'a');
								}
								else {
									cur_decimal += (chr - '0');
								}
							}
						}
						continue;
				}
			}

			if (current.type != DToken.Invalid) {
				current.columnEnd = _pos;
				current.lineEnd = _lineNumber;
				return current;
			}
			current.line++;
			current.column = 1;

			if (state != LexerState.String) {
				state = LexerState.Normal;
			}
			else {
				if (inStringType == StringType.Character) {
					_error("Unmatched character literal.");
					return Token.init;
				}
				cur_string ~= '\n';
			}
		}

		return Token.init;
	}

	int opApply(int delegate(ref Token) loopbody) {
		int ret;

		Token foo;
		while((foo = this.pop()).type != DToken.Invalid) {
			if ((ret = loopbody(foo)) > 0) {
				return 1;
			}
		}

		return ret;
	}

private:

	void _error(string msg) {
		Console.forecolor = Color.Red;
		Console.putln("Lexical Error: file.d @ ", _lineNumber+1, ":", _pos+1, " - ", msg);
		Console.putln();
	}

	// Describe the number lexer states
	enum LexerState : uint {
		Normal,
		String,
		Comment,
		Identifier,
		Integer,
		FloatingPoint
	}

	LexerState state;
	bool inEscape;

	// Describe the string lexer states
	enum StringType : uint {
		DoubleQuote,		// "..."
		WhatYouSeeQuote,	// `...`
		RawWhatYouSeeQuote,	// r"..."
		Character,			// '.'
	}

	StringType inStringType;

	// Describe the comment lexer states
	enum CommentType : uint {
		BlockComment,
		LineComment,
		NestedComment
	}

	CommentType inCommentType;
	string cur_string;

	Stream _stream;
	string _line;
	size_t _lineNumber;
	size_t _pos;

	static const DToken[] tokenMapping = [
		'!':DToken.Bang,
		':':DToken.Colon,
		';':DToken.Semicolon,
		'.':DToken.Dot,
		',':DToken.Comma,
		'(':DToken.LeftParen,
		')':DToken.RightParen,
		'{':DToken.LeftCurly,
		'}':DToken.RightCurly,
		'[':DToken.LeftBracket,
		']':DToken.RightBracket,
		'<':DToken.LessThan,
		'>':DToken.GreaterThan,
		'=':DToken.Assign,
		'+':DToken.Add,
		'-':DToken.Sub,
		'~':DToken.Cat,
		'*':DToken.Mul,
		'/':DToken.Div,
		'^':DToken.Xor,
		'|':DToken.Or,
		'&':DToken.And,
		'%':DToken.Mod,
		];

	int cur_base;
	ulong cur_integer;
	bool cur_integer_signed;
	ulong cur_decimal;
	ulong cur_exponent;
	ulong cur_denominator;
	bool inDecimal;
	bool inExponent;

	string[] _lines;

	Stack!(Token) _bank;
}

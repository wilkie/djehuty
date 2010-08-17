module system.keyboardtranslator.qwertyus;

import system.keyboardtranslator.keyboardtranslator;

import core.definitions;

class QwertyUSTranslator : KeyboardTranslator {


	override Key translate(Key key) {
		// This array will translate the scan code to the base key
		static int _translateScancode[] = [
			Key.Pause,
			Key.Escape,
			Key.One,
			Key.Two,
			Key.Three,
			Key.Four,
			Key.Five,
			Key.Six,
			Key.Seven,
			Key.Eight,
			Key.Nine,
			Key.Zero,
			Key.Minus,
			Key.Equals,
			Key.Backspace,
			Key.Tab,
			Key.Q,
			Key.W,
			Key.E,
			Key.R,
			Key.T,
			Key.Y,
			Key.U,
			Key.I,
			Key.O,
			Key.P,
			Key.LeftBracket,
			Key.RightBracket,
			Key.Return,
			Key.LeftControl,
			Key.A,
			Key.S,
			Key.D,
			Key.F,
			Key.G,
			Key.H,
			Key.J,
			Key.K,
			Key.L,
			Key.Semicolon,
			Key.Quote,
			Key.SingleQuote,
			Key.LeftShift,
			Key.Backslash,
			Key.Z,
			Key.X,
			Key.C,
			Key.V,
			Key.B,
			Key.N,
			Key.M,
			Key.Comma,
			Key.Period,
			Key.Foreslash,
			Key.RightShift,
			Key.PrintScreen,
			Key.LeftAlt,
			Key.Space,
			Key.CapsLock,
			Key.F1,
			Key.F2,
			Key.F3,
			Key.F4,
			Key.F5,
			Key.F6,
			Key.F7,
			Key.F8,
			Key.F9,
			Key.F10,
			Key.NumLock,
			Key.ScrollLock,
			Key.Home,
			Key.Up,
			Key.PageUp,
			Key.Invalid,
			Key.Left,
			Key.Invalid,
			Key.Right,
			Key.Invalid,
			Key.End,
			Key.Down,
			Key.PageDown,
			Key.Insert,
			Key.Delete,
			Key.SysRq,
			87: Key.F11,
			88: Key.F12
		];

		key.code = _translateScancode[key.scan];
		key.printable = '\0';
		if (key.shift) {
			switch(key.code) {
				case Key.SingleQuote:
					key.code = Key.Tilde;
					key.printable = '~';
					break;
				case Key.One:
					key.code = Key.Bang;
					key.printable = '!';
					break;
				case Key.Two:
					key.code = Key.At;
					key.printable = '@';
					break;
				case Key.Three:
					key.code = Key.Pound;
					key.printable = '#';
					break;
				case Key.Four:
					key.code = Key.Dollar;
					key.printable = '$';
					break;
				case Key.Five:
					key.code = Key.Percent;
					key.printable = '%';
					break;
				case Key.Six:
					key.code = Key.Caret;
					key.printable = '^';
					break;
				case Key.Seven:
					key.code = Key.Ampersand;
					key.printable = '&';
					break;
				case Key.Eight:
					key.code = Key.Asterisk;
					key.printable = '*';
					break;
				case Key.Nine:
					key.code = Key.LeftParenthesis;
					key.printable = '(';
					break;
				case Key.Zero:
					key.code = Key.RightParenthesis;
					key.printable = ')';
					break;
				case Key.Minus:
					key.code = Key.Underscore;
					key.printable = '_';
					break;
				case Key.Equals:
					key.code = Key.Plus;
					key.printable = '+';
					break;
				case Key.LeftBracket:
					key.code = Key.LeftCurly;
					key.printable = '{';
					break;
				case Key.RightBracket:
					key.code = Key.RightCurly;
					key.printable = '}';
					break;
				case Key.Semicolon:
					key.code = Key.Colon;
					key.printable = ':';
					break;
				case Key.Quote:
					key.code = Key.DoubleQuote;
					key.printable = '"';
					break;
				case Key.Comma:
					key.code = Key.LeftAngle;
					key.printable = '<';
					break;
				case Key.Period:
					key.code = Key.RightAngle;
					key.printable = '>';
					break;
				case Key.Backslash:
					key.code = Key.Pipe;
					key.printable = '|';
					break;
				case Key.Foreslash:
					key.code = Key.QuestionMark;
					key.printable = '?';
					break;
				case Key.A, Key.B, Key.C, Key.D, Key.E, Key.F, Key.G, Key.H,
				  Key.I, Key.J, Key.K, Key.L, Key.M, Key.N, Key.O, Key.P, Key.Q,
				  Key.R, Key.S, Key.T, Key.U, Key.V, Key.W, Key.X, Key.Y, Key.Z:
					key.printable = 'A' + (key.code - Key.A);
					break;
				default:
					break;
			}
		}

		if (key.alt || key.ctrl) {
			key.printable = '\0';
		}
		else if (!key.shift) {
			switch(key.code) {
				case Key.SingleQuote:
					key.printable = '`';
					break;
				case Key.One:
					key.printable = '1';
					break;
				case Key.Two:
					key.printable = '2';
					break;
				case Key.Three:
					key.printable = '3';
					break;
				case Key.Four:
					key.printable = '4';
					break;
				case Key.Five:
					key.printable = '5';
					break;
				case Key.Six:
					key.printable = '6';
					break;
				case Key.Seven:
					key.printable = '7';
					break;
				case Key.Eight:
					key.printable = '8';
					break;
				case Key.Nine:
					key.printable = '9';
					break;
				case Key.Zero:
					key.printable = '0';
					break;
				case Key.Minus:
					key.printable = '-';
					break;
				case Key.Equals:
					key.printable = '=';
					break;
				case Key.LeftBracket:
					key.printable = '[';
					break;
				case Key.RightBracket:
					key.printable = ']';
					break;
				case Key.Semicolon:
					key.printable = ';';
					break;
				case Key.Quote:
					key.printable = '\'';
					break;
				case Key.Comma:
					key.printable = ',';
					break;
				case Key.Period:
					key.printable = '.';
					break;
				case Key.Backslash:
					key.printable = '\\';
					break;
				case Key.Foreslash:
					key.printable = '/';
					break;
				case Key.A, Key.B, Key.C, Key.D, Key.E, Key.F, Key.G, Key.H,
				  Key.I, Key.J, Key.K, Key.L, Key.M, Key.N, Key.O, Key.P, Key.Q,
				  Key.R, Key.S, Key.T, Key.U, Key.V, Key.W, Key.X, Key.Y, Key.Z:
					key.printable = 'a' + (key.code - Key.A);
					break;
				default:
					break;
			}
		}

		return key;
	}
}
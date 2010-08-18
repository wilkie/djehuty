/*
 * russian.d
 *
 * This module implements the Russian keyboard layout.
 *
 */

module system.layout.russian;

import system.layout.keytranslator;

import core.definitions;

class RussianKeyboard : KeyTranslator {
	static dchar _translateToChar[] = [
		Key.SingleQuote: '\u0451', // small Io
		Key.One: '1',
		Key.Two: '2',
		Key.Three: '3',
		Key.Four: '4',
		Key.Five: '5',
		Key.Six: '6',
		Key.Seven: '7',
		Key.Eight: '8',
		Key.Nine: '9',
		Key.Zero: '0',
		Key.Minus: '-',
		Key.Equals: '=',
		Key.Q: '\u0439', // cyrillic small short I
		Key.W: '\u0446', // cyrillic small Tse
		Key.E: '\u0443', // cyrillic small U
		Key.R: '\u043a', // cyrillic small Ka
		Key.T: '\u0435', // cyrillic small Ie
		Key.Y: '\u043d', // cyrillic small En
		Key.U: '\u0433', // cyrillic small Ghe
		Key.I: '\u0448', // cyrillic small Sha
		Key.O: '\u0449', // cyrillic small Shcha
		Key.P: '\u0437', // cyrillic small Ze
		Key.A: '\u0444', // cyrillic small Ef
		Key.S: '\u044b', // cyrillic small Yeru
		Key.D: '\u0432', // cyrillic small Ve
		Key.F: '\u0430', // cyrillic small A
		Key.G: '\u043f', // cyrillic small Pe
		Key.H: '\u0440', // cyrillic small Er
		Key.J: '\u043e', // cyrillic small O
		Key.K: '\u043b', // cyrillic small El
		Key.L: '\u0434', // cyrillic small De
		Key.Z: '\u044f', // cyrillic small Ya
		Key.X: '\u0447', // cyrillic small Che
		Key.C: '\u0441', // cyrillic small Es
		Key.V: '\u043c', // cyrillic small Em
		Key.B: '\u0438', // cyrillic small I
		Key.N: '\u0442', // cyrillic small Te
		Key.M: '\u044c', // cyrillic small soft sign
		Key.Semicolon: '\u0436', // cyrillic small Zhe
		Key.Apostrophe: '\u044d', // cyrillic small E
		Key.Comma: '\u0431', // cyrillic small Be
		Key.Period: '\u044e', // cyrillic small Yu
		Key.Foreslash: '\u002e', // full stop
		Key.LeftBracket: '\u0445', // cyrillic small Ha
		Key.RightBracket: '\u044a', // cyrillic small hard sign
		Key.Backslash: '\\',
		Key.Space: ' ',

		Key.KeypadZero: '0',
		Key.KeypadOne: '1',
		Key.KeypadTwo: '2',
		Key.KeypadThree: '3',
		Key.KeypadFour: '4',
		Key.KeypadFive: '5',
		Key.KeypadSix: '6',
		Key.KeypadSeven: '7',
		Key.KeypadEight: '8',
		Key.KeypadNine: '9',
		Key.KeypadMinus: '-',
		Key.KeypadPlus: '+',
		Key.KeypadForeslash: '/',
		Key.KeypadAsterisk: '*',
		Key.KeypadPeriod: '.'
	];

	static dchar _translateShiftToChar[] = [
		Key.SingleQuote: '\u0401', // capital Io
		Key.One: '!',
		Key.Two: '"',
		Key.Three: '\u2116', // Numero Sign
		Key.Four: ';',
		Key.Five: '%',
		Key.Six: ':',
		Key.Seven: '?',
		Key.Eight: '*',
		Key.Nine: '(',
		Key.Zero: ')',
		Key.Minus: '_',
		Key.Equals: '+',
		Key.Q: '\u0419', // cyrillic capital short I
		Key.W: '\u0426', // cyrillic capital Tse
		Key.E: '\u0423', // cyrillic captial U
		Key.R: '\u041a', // cyrillic capital Ka
		Key.T: '\u0415', // cyrillic capital Ie
		Key.Y: '\u041d', // cyrillic capital En
		Key.U: '\u0413', // cyrillic capital Ghe
		Key.I: '\u0428', // cyrillic capital Sha
		Key.O: '\u0429', // cyrillic capital Shcha
		Key.P: '\u0417', // cyrillic capital Ze
		Key.A: '\u0424', // cyrillic capital Ef
		Key.S: '\u042b', // cyrillic capital Yeru
		Key.D: '\u0412', // cyrillic capital Ve
		Key.F: '\u0410', // cyrillic capital A
		Key.G: '\u041f', // cyrillic capital Pe
		Key.H: '\u0420', // cyrillic capital Er
		Key.J: '\u041e', // cyrillic capital O
		Key.K: '\u041b', // cyrillic capital El
		Key.L: '\u0414', // cyrillic capital De
		Key.Z: '\u042f', // cyrillic capital Ya
		Key.X: '\u0427', // cyrillic capital Che
		Key.C: '\u0421', // cyrillic capital Es
		Key.V: '\u041c', // cyrillic capital Em
		Key.B: '\u0418', // cyrillic capital I
		Key.N: '\u0422', // cyrillic capital Te
		Key.M: '\u042c', // cyrillic capital soft sign
		Key.Semicolon: '\u0416', // cyrillic capital Zhe
		Key.Apostrophe: '\u042d', // cyrillic capital E
		Key.Comma: '\u0411', // cyrillic capital Be
		Key.Period: '\u042e', // cyrillic capital Yu
		Key.Foreslash: ',', // full stop
		Key.LeftBracket: '\u0425', // cyrillic capital Ha
		Key.RightBracket: '\u042a', // cyrillic capital hard sign
		Key.Backslash: '/',
		Key.Space: ' '
	];

	override Key translate(Key key) {
		key.printable = '\0';
		if (!key.shift && !key.alt && !key.control) {
			if (key.code < _translateToChar.length) {
				key.printable = _translateToChar[key.code];
			}
		}
		else if (key.shift && !key.alt && !key.control) {
			if (key.code < _translateShiftToChar.length) {
				key.printable = _translateShiftToChar[key.code];
			}
		}
		if (key.printable == 0xffff) {
			key.printable = '\0';
		}
		return key;
	}
}
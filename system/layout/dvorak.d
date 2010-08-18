/*
 * dvorak.d
 *
 * This module implements the dvorak keyboard layout.
 *
 */

module system.layout.dvorak;

import system.layout.keytranslator;

import core.definitions;

class DvorakKeyboard : KeyTranslator {
	static dchar _translateToChar[] = [
		Key.SingleQuote: '`',
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
		Key.Minus: '[',
		Key.Equals: ']',
		Key.Q: '\'',
		Key.W: ',',
		Key.E: '.',
		Key.R: 'p',
		Key.T: 'y',
		Key.Y: 'f',
		Key.U: 'g',
		Key.I: 'c',
		Key.O: 'r',
		Key.P: 'l',
		Key.A: 'a',
		Key.S: 'o',
		Key.D: 'e',
		Key.F: 'u',
		Key.G: 'i',
		Key.H: 'd',
		Key.J: 'h',
		Key.K: 't',
		Key.L: 'n',
		Key.Z: ';',
		Key.X: 'q',
		Key.C: 'j',
		Key.V: 'k',
		Key.B: 'x',
		Key.N: 'b',
		Key.M: 'm',
		Key.Semicolon: 's',
		Key.Apostrophe: '-',
		Key.Comma: 'w',
		Key.Period: 'v',
		Key.Foreslash: 'z',
		Key.LeftBracket: '/',
		Key.RightBracket: '=',
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
		Key.SingleQuote: '~',
		Key.One: '!',
		Key.Two: '@',
		Key.Three: '#',
		Key.Four: '$',
		Key.Five: '%',
		Key.Six: '^',
		Key.Seven: '&',
		Key.Eight: '*',
		Key.Nine: '(',
		Key.Zero: ')',
		Key.Minus: '{',
		Key.Equals: '}',
		Key.Q: '"',
		Key.W: '<',
		Key.E: '>',
		Key.R: 'P',
		Key.T: 'Y',
		Key.Y: 'F',
		Key.U: 'G',
		Key.I: 'C',
		Key.O: 'R',
		Key.P: 'L',
		Key.A: 'A',
		Key.S: 'O',
		Key.D: 'E',
		Key.F: 'U',
		Key.G: 'I',
		Key.H: 'D',
		Key.J: 'H',
		Key.K: 'T',
		Key.L: 'N',
		Key.Z: ':',
		Key.X: 'Q',
		Key.C: 'J',
		Key.V: 'K',
		Key.B: 'X',
		Key.N: 'B',
		Key.M: 'M',
		Key.Semicolon: 'S',
		Key.Apostrophe: '_',
		Key.Comma: 'W',
		Key.Period: 'V',
		Key.Foreslash: 'Z',
		Key.LeftBracket: '?',
		Key.RightBracket: '+',
		Key.Backslash: '|',
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
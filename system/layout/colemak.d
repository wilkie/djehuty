/*
 * colemak.d
 *
 * This module implements the colemak keyboard layout.
 *
 */

module system.layout.colemak;

import system.layout.keytranslator;

import core.definitions;

class ColemakKeyboard : KeyTranslator {

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
		Key.Minus: '-',
		Key.Equals: '=',
		Key.Q: 'q',
		Key.W: 'w',
		Key.E: 'f',
		Key.R: 'p',
		Key.T: 'g',
		Key.Y: 'j',
		Key.U: 'l',
		Key.I: 'u',
		Key.O: 'y',
		Key.P: ';',
		Key.A: 'a',
		Key.S: 'r',
		Key.D: 's',
		Key.F: 't',
		Key.G: 'd',
		Key.H: 'h',
		Key.J: 'n',
		Key.K: 'e',
		Key.L: 'i',
		Key.Z: 'z',
		Key.X: 'x',
		Key.C: 'c',
		Key.V: 'v',
		Key.B: 'b',
		Key.N: 'k',
		Key.M: 'm',
		Key.Semicolon: 'o',
		Key.Apostrophe: '\'',
		Key.Comma: ',',
		Key.Period: '.',
		Key.Foreslash: '/',
		Key.LeftBracket: '[',
		Key.RightBracket: ']',
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
		Key.Minus: '_',
		Key.Equals: '+',
		Key.Q: 'Q',
		Key.W: 'W',
		Key.E: 'F',
		Key.R: 'P',
		Key.T: 'G',
		Key.Y: 'J',
		Key.U: 'L',
		Key.I: 'U',
		Key.O: 'Y',
		Key.P: ':',
		Key.A: 'A',
		Key.S: 'R',
		Key.D: 'S',
		Key.F: 'T',
		Key.G: 'D',
		Key.H: 'H',
		Key.J: 'N',
		Key.K: 'E',
		Key.L: 'I',
		Key.Z: 'Z',
		Key.X: 'X',
		Key.C: 'C',
		Key.V: 'V',
		Key.B: 'B',
		Key.N: 'K',
		Key.M: 'M',
		Key.Semicolon: 'O',
		Key.Apostrophe: '"',
		Key.Comma: '<',
		Key.Period: '>',
		Key.Foreslash: '?',
		Key.LeftBracket: '{',
		Key.RightBracket: '}',
		Key.Backslash: '|',
		Key.Space: ' '
	];

	override Key translate(Key key) {
		key.printable = '\0';
		if (!key.shift && !key.alt && !key.control) {
			if (key.capsLock && ((key.code >= Key.A && key.code <= Key.Z)
			  || key.code == Key.Semicolon)
			  && key.code != Key.P) {
				key.printable = _translateShiftToChar[key.code];
			}
			else if (key.code < _translateToChar.length) {
				key.printable = _translateToChar[key.code];
			}
		}
		else if (key.shift && !key.alt && !key.control) {
			if (key.capsLock && ((key.code >= Key.A && key.code <= Key.Z)
			  || key.code == Key.Semicolon)
			  && key.code != Key.P) {
				key.printable = _translateToChar[key.code];
			}
			else if (key.code < _translateShiftToChar.length) {
				key.printable = _translateShiftToChar[key.code];
			}
		}
		if (key.printable == 0xffff) {
			key.printable = '\0';
		}
		return key;
	}
}
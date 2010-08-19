/*
 * belgian.d
 *
 * This module implements the Belgian azerty keyboard layout.
 *
 */

module system.layout.belgian;

import system.layout.keytranslator;

import core.definitions;
import core.unicode;

class BelgianKeyboard : KeyTranslator {
	static dchar _translateToChar[] = [
		Key.SingleQuote: '\u00b2', // superscript two
		Key.One: '&',
		Key.Two: '\u00e9', // e with acute
		Key.Three: '"',
		Key.Four: '\'',
		Key.Five: '(',
		Key.Six: '\u00a7', // section sign
		Key.Seven: '\u00e8', // e with grave
		Key.Eight: '!',
		Key.Nine: '\u00e7', // c with cedilla
		Key.Zero: '\u00e0', // a with grave
		Key.Minus: ')',
		Key.Equals: '-',
		Key.Q: 'a',
		Key.W: 'z',
		Key.E: 'e',
		Key.R: 'r',
		Key.T: 't',
		Key.Y: 'y',
		Key.U: 'u',
		Key.I: 'i',
		Key.O: 'o',
		Key.P: 'p',
		Key.A: 'q',
		Key.S: 's',
		Key.D: 'd',
		Key.F: 'f',
		Key.G: 'g',
		Key.H: 'h',
		Key.J: 'j',
		Key.K: 'k',
		Key.L: 'l',
		Key.Z: 'w',
		Key.X: 'x',
		Key.C: 'c',
		Key.V: 'v',
		Key.B: 'b',
		Key.N: 'n',
		Key.M: ',',
		Key.Semicolon: 'm',
		Key.Apostrophe: '\u00f9', // u with grave
		Key.Comma: ';',
		Key.Period: ':',
		Key.Foreslash: '=',
		Key.RightBracket: '$',
		Key.Backslash: '\u00b5', // micro sign
		Key.International: '<',
		Key.Space: ' '
	];

	static dchar _translateShiftToChar[] = [
		Key.SingleQuote: '\u00b3', // Superscript three
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
		Key.Minus: '\u00b0',
		Key.Equals: '_',
		Key.Q: 'A',
		Key.W: 'Z',
		Key.E: 'E',
		Key.R: 'R',
		Key.T: 'T',
		Key.Y: 'Y',
		Key.U: 'U',
		Key.I: 'I',
		Key.O: 'O',
		Key.P: 'P',
		Key.A: 'Q',
		Key.S: 'S',
		Key.D: 'D',
		Key.F: 'F',
		Key.G: 'G',
		Key.H: 'H',
		Key.J: 'J',
		Key.K: 'K',
		Key.L: 'L',
		Key.Z: 'W',
		Key.X: 'X',
		Key.C: 'C',
		Key.V: 'V',
		Key.B: 'B',
		Key.N: 'N',
		Key.M: '?',
		Key.Semicolon: 'M',
		Key.Comma: '.',
		Key.Period: '/',
		Key.Apostrophe: '%',
		Key.Foreslash: '+',
		Key.RightBracket: '*',
		Key.Backslash: '\u00a3', // Pound Sign
		Key.International: '>', // Double angle quote right
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

	static dchar _translateAltToChar[] = [
		Key.One: '|',
		Key.Two: '@',
		Key.Three: '#',
		Key.Four: '{',
		Key.Five: '[',
		Key.Six: '^',
		Key.Nine: '{',
		Key.Zero: '}',
		Key.E: '\u20ac', // Euro Sign
		Key.LeftBracket: '[',
		Key.RightBracket: ']',
		Key.International: '\\',
		Key.Space: ' '
	];

	override Key translate(Key key) {
		key.printable = '\0';
		if (!(key.shift ^ key.capsLock) && !key.alt && !key.control) {
			if (key.code == Key.LeftBracket) {
				key.deadChar = '\u0302'; // circumflex
			}
			else if (key.code < _translateToChar.length) {
				key.printable = _translateToChar[key.code];

				if (key.deadChar != '\0') {
					key.printable = Unicode.combine(key.printable, key.deadChar)[0];
				}
			}
		}
		else if ((key.shift || key.capsLock) && !key.alt && !key.control) {
			if (key.code == Key.LeftBracket) {
				key.deadChar = '\u0308'; // diaeresis
			}
			else if (key.code < _translateShiftToChar.length) {
				key.printable = _translateShiftToChar[key.code];

				if (key.deadChar != '\0') {
					key.printable = Unicode.combine(key.printable, key.deadChar)[0];
				}
			}
		}
		else if (!key.shift && key.rightAlt && !key.control) {
			if (key.code == Key.Backslash) {
				key.deadChar = '\u0300'; // grave
			}
			else if (key.code == Key.Apostrophe) {
				key.deadChar = '\u0301'; // acute
			}
			else if (key.code == Key.Foreslash) {
				key.deadChar = '\u0303'; // tilde
			}
			else if (key.code < _translateAltToChar.length) {
				key.printable = _translateAltToChar[key.code];

				if (key.deadChar != '\0') {
					key.printable = Unicode.combine(key.printable, key.deadChar)[0];
				}
			}
		}
		if (key.printable == 0xffff) {
			key.printable = '\0';
		}
		if (key.printable != '\0') {
			key.deadChar = '\0';
		}
		return key;
	}
}
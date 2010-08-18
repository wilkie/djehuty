/*
 * quebec.d
 *
 * This module implements the French Canadian qwerty keyboard layout.
 *
 */

module system.layout.quebec;

import system.layout.keytranslator;

import core.definitions;
import core.unicode;

class QuebecKeyboard : KeyTranslator {
	static dchar _translateToChar[] = [
		Key.SingleQuote: '#',
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
		Key.E: 'e',
		Key.R: 'r',
		Key.T: 't',
		Key.Y: 'y',
		Key.U: 'u',
		Key.I: 'i',
		Key.O: 'o',
		Key.P: 'p',
		Key.A: 'a',
		Key.S: 's',
		Key.D: 'd',
		Key.F: 'f',
		Key.G: 'g',
		Key.H: 'h',
		Key.J: 'j',
		Key.K: 'k',
		Key.L: 'l',
		Key.Z: 'z',
		Key.X: 'x',
		Key.C: 'c',
		Key.V: 'v',
		Key.B: 'b',
		Key.N: 'n',
		Key.M: 'm',
		Key.Semicolon: ';',
		Key.Comma: ',',
		Key.Period: '.',
		Key.Foreslash: '\u00e9', // Minuscule e-acute
		Key.Backslash: '<',
		Key.International: '\u00ab', // Double angle quote left
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
		Key.Two: '"',
		Key.Three: '/',
		Key.Four: '$',
		Key.Five: '%',
		Key.Six: '?',
		Key.Seven: '&',
		Key.Eight: '*',
		Key.Nine: '(',
		Key.Zero: ')',
		Key.Minus: '_',
		Key.Equals: '+',
		Key.Q: 'Q',
		Key.W: 'W',
		Key.E: 'E',
		Key.R: 'R',
		Key.T: 'T',
		Key.Y: 'Y',
		Key.U: 'U',
		Key.I: 'I',
		Key.O: 'O',
		Key.P: 'P',
		Key.A: 'A',
		Key.S: 'S',
		Key.D: 'D',
		Key.F: 'F',
		Key.G: 'G',
		Key.H: 'H',
		Key.J: 'J',
		Key.K: 'K',
		Key.L: 'L',
		Key.Z: 'Z',
		Key.X: 'X',
		Key.C: 'C',
		Key.V: 'V',
		Key.B: 'B',
		Key.N: 'N',
		Key.M: 'M',
		Key.Semicolon: ':',
		Key.Comma: '\'',
		Key.Foreslash: '\u00c9', // Majuscule e-acute
		Key.Backslash: '>',
		Key.International: '\u00bb', // Double angle quote right
		Key.Space: ' '
	];

	static dchar _translateAltToChar[] = [
		Key.SingleQuote: '\\',
		Key.One: '\u00b1',
		Key.Two: '@',
		Key.Three: '\u20a4',
		Key.Four: '\u00a2',
		Key.Five: '\u00a4',
		Key.Six: '\u00ac',
		Key.Seven: '\u00a6',
		Key.Eight: '\u00b2',
		Key.Nine: '\u00b3',
		Key.Zero: '\u00bc',
		Key.Minus: '\u00bd',
		Key.Equals: '\u00be',
		Key.Semicolon: '~',
		Key.Apostrophe: '{',
		Key.O: '\u00a7', // Section Sign
		Key.P: '\u00b6', // Pilcrow Sign
		Key.M: '\u00b5', // Micro Sign
		Key.Comma: '\u00af', // Macron
		Key.Period: '\u00ad', // Soft Hyphen
		Key.LeftBracket: '[',
		Key.RightBracket: ']',
		Key.Backslash: '}',
		Key.International: '\u00b0', // Degree
		Key.Space: ' '
	];

	override Key translate(Key key) {
		key.printable = '\0';
		if (!key.shift && !key.alt && !key.control) {
			if (key.capsLock && (key.code >= Key.A && key.code <= Key.Z
			  || key.code == Key.Foreslash)) {
				key.printable = _translateShiftToChar[key.code];
			}
			else if (key.code == Key.LeftBracket) {
				key.deadChar = '\u0302'; // circumflex
			}
			else if (key.code == Key.RightBracket) {
				key.deadChar = '\u0327'; // cedilla
			}
			else if (key.code == Key.Apostrophe) {
				key.deadChar = '\u0300'; // grave
			}
			else if (key.code < _translateToChar.length) {
				key.printable = _translateToChar[key.code];

				if (key.deadChar != '\0') {
					key.printable = Unicode.combine(key.printable, key.deadChar)[0];
				}
			}
		}
		else if (key.shift && !key.alt && !key.control) {
			if (key.capsLock && (key.code >= Key.A && key.code <= Key.Z
			  || key.code == Key.Foreslash)) {
				key.printable = _translateToChar[key.code];
			}
			else if (key.code == Key.LeftBracket) {
				key.deadChar = '\u0302'; // circumflex
			}
			else if (key.code == Key.RightBracket) {
				key.deadChar = '\u0308'; // diaeresis
			}
			else if (key.code == Key.Apostrophe) {
				key.deadChar = '\u0300'; // grave
			}
			else if (key.code < _translateShiftToChar.length) {
				key.printable = _translateShiftToChar[key.code];

				if (key.deadChar != '\0') {
					key.printable = Unicode.combine(key.printable, key.deadChar)[0];
				}
			}
		}
		else if (!key.shift && key.rightAlt && !key.control) {
			if (key.code == Key.Foreslash) {
				key.deadChar = '\u0301'; // acute
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
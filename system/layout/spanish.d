/*
 * spanish.d
 *
 * This module implements the Spanish (Spain) qwerty keyboard layout.
 *
 */

module system.layout.spanish;

import system.layout.keytranslator;

import core.definitions;
import core.unicode;

class SpanishKeyboard : KeyTranslator {
	static dchar _translateToChar[] = [
		Key.SingleQuote: '\u00ba', // masculing ordinal indicator
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
		Key.Minus: '\'',
		Key.Equals: '\u00a1', // inverted !
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
		Key.Semicolon: '\u00f1', // n with tilde
		Key.Comma: ',',
		Key.Period: '.',
		Key.Foreslash: '-',
		Key.RightBracket: '+',
		Key.Backslash: '\u00e7', // c with cedilla
		Key.International: '<',
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
		Key.SingleQuote: '\u00aa', // feminine ordinal indicator
		Key.One: '!',
		Key.Two: '"',
		Key.Three: '\u00b7', // middle dot
		Key.Four: '$',
		Key.Five: '%',
		Key.Six: '&',
		Key.Seven: '/',
		Key.Eight: '(',
		Key.Nine: ')',
		Key.Zero: '=',
		Key.Minus: '?',
		Key.Equals: '\u00bf', // inverted ?
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
		Key.Semicolon: '\u00d1', // N with tilde
		Key.Comma: ';',
		Key.Period: ':',
		Key.Foreslash: '_',
		Key.Backslash: '\u00c7', // C with cedilla
		Key.RightBracket: '*',
		Key.International: '>',
		Key.Space: ' '
	];

	static dchar _translateAltToChar[] = [
		Key.SingleQuote: '\\',
		Key.One: '|',
		Key.Two: '@',
		Key.Three: '#',
		Key.Five: '\u20ac', // euro sign
		Key.Six: '\u00ac', // not sign
		Key.E: '\u20ac', // euro sign
		Key.LeftBracket: '[',
		Key.RightBracket: ']',
		Key.Backslash: '}',
		Key.Apostrophe: '{',
		Key.Space: ' '
	];

	override Key translate(Key key) {
		key.printable = '\0';
		if (!key.shift && !key.alt && !key.control) {
			if (key.capsLock && (key.code >= Key.A && key.code <= Key.Z
			  || key.code == Key.Backslash || key.code == Key.Semicolon)) {
				key.printable = _translateShiftToChar[key.code];
			}
			else if (key.code == Key.LeftBracket) {
				key.deadChar = '\u0300'; // grave
			}
			else if (key.code == Key.Apostrophe) {
				key.deadChar = '\u0301'; // acute
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
			  || key.code == Key.Backslash || key.code == Key.Semicolon)) {
				key.printable = _translateToChar[key.code];
			}
			else if (key.code == Key.LeftBracket) {
				key.deadChar = '\u0302'; // circumflex
			}
			else if (key.code == Key.Apostrophe) {
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
			if (key.code == Key.Four) {
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
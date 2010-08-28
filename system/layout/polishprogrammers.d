/*
 * polishprogrammers.d
 *
 * This module implements the Polish Programmers qwerty keyboard layout.
 *
 */

module system.layout.polishprogrammers;

import system.layout.keytranslator;

import core.definitions;
import core.unicode;

class PolishProgrammersKeyboard : KeyTranslator {
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
		Key.Foreslash: '/',
		Key.Backslash: '\\',
		Key.LeftBracket: '[',
		Key.RightBracket: ']',
		Key.Apostrophe: '\'',
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
		Key.Comma: '<',
		Key.Foreslash: '?',
		Key.Backslash: '|',
		Key.Period: '>',
		Key.Apostrophe: '"',
		Key.Space: ' '
	];

	static dchar _translateAltToChar[] = [
		Key.E: '\u0119', // e with Ogonek
		Key.U: '\u20ac', // Euro Sign
		Key.O: '\u00f3', // o with acute
		Key.A: '\u0105', // a with ogonek
		Key.S: '\u015b', // s with acute
		Key.L: '\u0142', // l with stroke
		Key.Z: '\u017c', // z with dot above
		Key.X: '\u017a', // z with acute
		Key.C: '\u0107', // c with acute
		Key.N: '\u0144', // n with acute
		Key.Space: ' '
	];

	static dchar _translateShiftAltToChar[] = [
		Key.E: '\u0118', // E with Ogonek
		Key.O: '\u00d3', // O with acute
		Key.A: '\u0104', // A with ogonek
		Key.S: '\u015a', // S with acute
		Key.L: '\u0141', // L with stroke
		Key.Z: '\u017b', // Z with dot above
		Key.X: '\u0179', // Z with acute
		Key.C: '\u0106', // C with acute
		Key.N: '\u0143', // N with acute
		Key.Space: ' '
	];

	override Key translate(Key key) {
		key.printable = '\0';
		if (!key.shift && !key.alt && !key.control) {
			if (key.code >= Key.A && key.code <= Key.Z && key.capsLock) {
				key.printable = _translateShiftToChar[key.code];
			}
			else if (key.code < _translateToChar.length) {
				key.printable = _translateToChar[key.code];

				if (key.deadChar != '\0') {
					key.printable = Unicode.combine(key.printable, key.deadChar)[0];
				}
			}
		}
		else if (key.shift && !key.alt && !key.control) {
			if (key.code >= Key.A && key.code <= Key.Z && key.capsLock) {
				key.printable = _translateToChar[key.code];
			}
			else if (key.code == Key.SingleQuote) {
				key.deadChar = '\u0303'; // tilde
			}
			else if (key.code < _translateShiftToChar.length) {
				key.printable = _translateShiftToChar[key.code];

				if (key.deadChar != '\0') {
					key.printable = Unicode.combine(key.printable, key.deadChar)[0];
				}
			}
		}
		else if (!key.shift && key.rightAlt && !key.control) {
			if (key.code >= Key.A && key.code <= Key.Z && key.capsLock
			  && key.code != Key.U) {
				key.printable = _translateShiftAltToChar[key.code];
			}
			else if (key.code < _translateAltToChar.length) {
				key.printable = _translateAltToChar[key.code];

				if (key.deadChar != '\0') {
					key.printable = Unicode.combine(key.printable, key.deadChar)[0];
				}
			}
		}
		else if (key.shift && key.rightAlt && !key.control) {
			if (key.code >= Key.A && key.code <= Key.Z && key.capsLock
			  && key.code != Key.U) {
				key.printable = _translateAltToChar[key.code];
			}
			else if (key.code < _translateShiftAltToChar.length) {
				key.printable = _translateShiftAltToChar[key.code];

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
/*
 * czechprogrammers.d
 *
 * This module implements the Czech Programmers qwerty keyboard layout.
 *
 */

module system.layout.czechprogrammers;

import system.layout.keytranslator;

import core.definitions;
import core.unicode;

class CzechProgrammersKeyboard : KeyTranslator {
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
		Key.Space: ' '
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
		Key.LeftBracket: '{',
		Key.RightBracket: '}',
		Key.Apostrophe: '"',
		Key.Space: ' '
	];

	static dchar _translateAltToChar[] = [
		Key.SingleQuote: ';',
		Key.One: '+',
		Key.Two: '\u011b', // e with caron
		Key.Three: '\u0161', // s with caron
		Key.Four: '\u010d', // c with caron
		Key.Five: '\u0159', // r with caron
		Key.Six: '\u017e', // z with caron
		Key.Seven: '\u00fd', // y with acute
		Key.Eight: '\u00e1', // a with acute
		Key.Nine: '\u00ed', // i with acute
		Key.Zero: '\u00e9', // e with acute
		Key.Minus: '=',
		Key.E: '\u20ac', // Euro Sign
		Key.LeftBracket: '\u00fa', // u with acute
		Key.RightBracket: ')',
		Key.Semicolon: '\u016f', // u with ring above
		Key.Apostrophe: '\u00a7', // Section Sign
		Key.Comma: '?',
		Key.Period: ':',
		Key.Foreslash: '\u002d', // Hyphen-minus
		Key.Space: ' '
	];

	static dchar _translateShiftAltToChar[] = [
		Key.Minus: '%',
		Key.LeftBracket: '/',
		Key.RightBracket: '(',
		Key.Semicolon: '"',
		Key.Apostrophe: '!',
		Key.Comma: '\u00d7', // multiplication sign
		Key.Period: '\u00f7', // division sign
		Key.Foreslash: '\u005f', // low line
		Key.Space: ' '
	];

	override Key translate(Key key) {
		key.printable = '\0';
		if (!key.shift && !key.alt && !key.control) {
			// Dead characters
			if (key.code < _translateToChar.length) {
				key.printable = _translateToChar[key.code];

				if (key.deadChar != '\0') {
					key.printable = Unicode.combine(key.printable, key.deadChar)[0];
				}
			}
		}
		else if (key.shift && !key.alt && !key.control) {
			if (key.code == Key.SingleQuote) {
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
			if (key.code == Key.Equals) {
				key.deadChar = '\u0301'; // acute
			}
			else if (key.code == Key.Backslash) {
				key.deadChar = '\u0308'; // diaeresis
			}
			else if (key.code < _translateAltToChar.length) {
				key.printable = _translateAltToChar[key.code];

				if (key.deadChar != '\0') {
					key.printable = Unicode.combine(key.printable, key.deadChar)[0];
				}
			}
		}
		else if (key.shift && key.rightAlt && !key.control) {
			if (key.code == Key.Equals) {
				key.deadChar = '\u030c'; // caron
			}
			else if (key.code == Key.Backslash) {
				key.deadChar = '\u0302'; // circumflex
			}
			else if (key.code == Key.SingleQuote) {
				key.deadChar = '\u030a'; // ring above
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
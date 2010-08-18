/*
 * unitedstatesinternational.d
 *
 * This module implements the US International qwerty keyboard layout.
 *
 */

module system.layout.unitedstatesinternational;

import system.layout.keytranslator;

import core.definitions;
import core.unicode;

class UnitedStatesInternationalKeyboard : KeyTranslator {
	static dchar _translateToChar[] = [
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
		Key.LeftBracket: '[',
		Key.RightBracket: ']',
		Key.Backslash: '\\',
		Key.Space: ' '
	];

	static dchar _translateShiftToChar[] = [
		Key.One: '!',
		Key.Two: '@',
		Key.Three: '#',
		Key.Four: '$',
		Key.Five: '%',
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
		Key.Period: '>',
		Key.Foreslash: '?',
		Key.LeftBracket: '{',
		Key.RightBracket: '}',
		Key.Backslash: '|',
		Key.Space: ' '
	];

	static dchar _translateAltToChar[] = [
		Key.One: '\u00a1', // inverted !
		Key.Two: '\u00b2', // superscript 2
		Key.Three: '\u00b3', // superscript 3
		Key.Four: '\u00a4', // currency sign
		Key.Five: '\u20ac', // euro sign
		Key.Six: '\u00bc', // 1/4
		Key.Seven: '\u00bd', // 1/2
		Key.Eight: '\u00be', // 3/4
		Key.Nine: '\u2018', // left single quote
		Key.Zero: '\u2019', // right single quote
		Key.Minus: '\u00a5', // yen
		Key.Equals: '\u00d7', // multiplication sign
		Key.Q: '\u00e4', // a with diaeresis
		Key.W: '\u00e5', // a with ring above
		Key.E: '\u00e9', // e with acute
		Key.R: '\u00ae', // registered sign
		Key.T: '\u00fe', // thorn
		Key.Y: '\u00fc', // u with diaeresis
		Key.U: '\u00fa', // u with acute
		Key.I: '\u00ed', // i with acute
		Key.O: '\u00f3', // o with acute
		Key.P: '\u00f6', // o with diaeresis
		Key.A: '\u00e1', // a with acute
		Key.S: '\u00df', // sharp s
		Key.D: '\u00f0', // small eth
		Key.L: '\u00f8', // o with stroke
		Key.Z: '\u00e6', // ae
		Key.C: '\u00a9', // copyright sign
		Key.N: '\u00f1', // n with tilde
		Key.M: '\u00b5', // micro sign
		Key.Semicolon: '\u00b6', // pilcrow sign
		Key.Comma: '\u00e7', // c with cedilla
		Key.Foreslash: '\u00bf', // inverted ?
		Key.LeftBracket: '\u00ab', // left angle quotes
		Key.RightBracket: '\u00bb', // right angle quotes
		Key.Backslash: '\u00ac', // not sign
		Key.Apostrophe: '\u00b4', // acute accent
		Key.Space: ' '
	];

	static dchar _translateShiftAltToChar[] = [
		Key.One: '\u00b9', // superscript 1
		Key.Four: '\u00a3', // pound sign
		Key.Equals: '\u00f7', // division sign
		Key.Q: '\u00c4', // A with diaeresis
		Key.W: '\u00c5', // A with ring above
		Key.E: '\u00c9', // E with acute
		Key.T: '\u00de', // capital thorn
		Key.Y: '\u00dc', // U with diaeresis
		Key.U: '\u00da', // U with acute
		Key.I: '\u00cd', // I with acute
		Key.O: '\u00d3', // O with acute
		Key.P: '\u00d6', // O with diaeresis
		Key.A: '\u00c1', // a with acute
		Key.S: '\u00a7', // section sign
		Key.D: '\u00d0', // capital eth
		Key.L: '\u00d8', // o with stroke
		Key.Z: '\u00c6', // ae
		Key.C: '\u00a2', // cent sign
		Key.N: '\u00d1', // N with tilde
		Key.Semicolon: '\u00b0', // degree sign
		Key.Comma: '\u00c7', // C with cedilla
		Key.Backslash: '\u00a6', // broken bar
		Key.Apostrophe: '\u00a8', // diaeresis accent
		Key.Space: ' '
	];

	override Key translate(Key key) {
		key.printable = '\0';
		if (!key.shift && !key.alt && !key.control) {
			if (key.code == Key.SingleQuote) {
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
			if (key.code == Key.SingleQuote) {
				key.deadChar = '\u0303'; // tilde
			}
			else if (key.code == Key.Six) {
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
		else if (!key.shift && key.rightAlt && !key.leftAlt && !key.control) {
			if (key.code < _translateAltToChar.length) {
				key.printable = _translateAltToChar[key.code];

				if (key.deadChar != '\0') {
					key.printable = Unicode.combine(key.printable, key.deadChar)[0];
				}
			}
		}
		else if (key.shift && key.rightAlt && !key.leftAlt && !key.control) {
			if (key.code < _translateShiftAltToChar.length) {
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
/*
 * canadianmultilingual.d
 *
 * This module implements the mutlilingual Canadian qwerty keyboard layout.
 *
 */

module system.layout.canadianmultilingual;

import system.layout.keytranslator;

import core.definitions;
import core.unicode;

class CanadianMultilingualKeyboard : KeyTranslator {
	static dchar _translateToChar[] = [
		Key.SingleQuote: '/',
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
		Key.Apostrophe: '\u00e8',
		Key.RightBracket: '\u00e7',
		Key.Backslash: '\u00e0',
		Key.Foreslash: '\u00e9',
		Key.International: '\u00f9', // u grave
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
		Key.SingleQuote: '\\',
		Key.One: '!',
		Key.Two: '@',
		Key.Three: '#',
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
		Key.Period: '"',
		Key.RightBracket: '\u00c7',
		Key.Apostrophe: '\u00c8',
		Key.Backslash: '\u00c0',
		Key.Foreslash: '\u00c9',
		Key.International: '\u00d9', // capital u grave
		Key.Space: ' '
	];

	static dchar _translateAltToChar[] = [
		Key.SingleQuote: '|',
		Key.Seven: '{',
		Key.Eight: '}',
		Key.Nine: '[',
		Key.Zero: ']',
		Key.Equals: '\u00af', // Macron
		Key.Semicolon: '\u00b0', // Degree
		Key.Comma: '<',
		Key.Period: '>',
		Key.Z: '\u00ab', // Double angle quotes left
		Key.X: '\u00bb', // Double angle quotes right
		Key.Space: '\u00a0' // Non-breaking space
	];

	static dchar _translateControlToChar[] = [
		Key.One: '\u00b9', // superscript one
		Key.Two: '\u00b2', // superscript two
		Key.Three: '\u00b3', // superscript three
		Key.Four: '\u00bc', // 1/4
		Key.Five: '\u00bd', // 1/2
		Key.Six: '\u00be', // 3/4
		Key.W: '\u0142', // Small latin L with stroke
		Key.E: '\u0153', // Small latin Ligature Oe
		Key.R: '\u00b6', // Pilcrow Sign
		Key.T: '\u0167', // Small latin T with stroke
		Key.Y: '\u2190', // Leftwards arrow
		Key.U: '\u2193', // Downwards arrow
		Key.I: '\u2192', // Rightwards arrow
		Key.O: '\u00f8', // Small latin letter O with stroke
		Key.P: '\u00fe', // Small latin letter Thorn
		Key.RightBracket: '~',
		Key.A: '\u00e6', // Small latin letter ae
		Key.S: '\u00df', // Small latin letter Sharp S
		Key.D: '\u00f0', // Small latin letter Eth
		Key.G: '\u014b', // Small latin letter Eng
		Key.H: '\u0127', // Small latin letter H with stroke
		Key.J: '\u0133', // Small latin ligature ij
		Key.K: '\u0138', // Small latin letter Kra
		Key.L: '\u0140', // Small latin letter L with middle dot
		Key.C: '\u00a2', // Cent Sign
		Key.V: '\u201c', // Left Double Quote
		Key.B: '\u201d', // Right Double Quote
		Key.N: '\u0149', // Small latin letter N preceded by Apostrophe
		Key.M: '\u00b5', // Micro Sign
		Key.Comma: '\u2015', // Horizontal Bar
	];

	static dchar _translateShiftControlToChar[] = [
		Key.SingleQuote: '\u00ad', // soft hyphen
		Key.One: '\u00a1', // inverted exclamation mark
		Key.Three: '\u00a3', // pound sign
		Key.Four: '\u00a4', // currency sign
		Key.Five: '\u215c', // 3/8
		Key.Six: '\u215d', // 5/8
		Key.Seven: '\u215e', // 7/8
		Key.Eight: '\u2122', // TM
		Key.Nine: '\u00b1', // plus-minus sign
		Key.Minus: '\u00bf', // inverted question mark
		Key.Q: '\u2126', // Ohm Sign
		Key.W: '\u0141', // Capital latin L with stroke
		Key.E: '\u0152', // Capital latin Ligature Oe
		Key.R: '\u00ae', // Registered Sign
		Key.T: '\u0166', // Capital latin T with stroke
		Key.Y: '\u00a5', // Yen
		Key.U: '\u2191', // Upwards arrow
		Key.I: '\u0131', // Small latin letter Dotless i
		Key.O: '\u00d8', // Capital latin letter O with stroke
		Key.P: '\u00de', // Capital latin letter Thorn
		Key.A: '\u00c6', // Capital latin letter ae
		Key.S: '\u00a7', // Section Sign
		Key.D: '\u00d0', // Capital latin letter Eth
		Key.F: '\u00aa', // Feminine Ordinal Indicator
		Key.G: '\u014a', // Capital latin letter Eng
		Key.H: '\u0126', // Capital latin letter H with stroke
		Key.J: '\u0132', // Capital latin ligature ij
		Key.L: '\u013f', // Capital latin letter L with middle dot
		Key.International: '\u00a6', // Broken Bar
		Key.C: '\u00a9', // Copyright Sign
		Key.V: '\u2018', // Left Single Quote
		Key.B: '\u2019', // Right Single Quote
		Key.N: '\u266a', // Eighth Note
		Key.M: '\u00ba', // Masculine Ordinal Indicator
		Key.Comma: '\u00d7', // Multiplication Sign
		Key.Period: '\u00f7', // Division Sign
	];

	override Key translate(Key key) {
		key.printable = '\0';
		if (!key.shift && !key.alt && !key.control) {
			// Dead characters
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
		else if (key.shift && !key.alt && !key.control) {
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
		else if (!key.shift && !key.rightAlt && key.rightControl && !key.leftControl) {
			if (key.code == Key.Equals) {
				// Dead char
			}
			else if (key.code == Key.Period) {
				// Dead char
			}
			else if (key.code == Key.Semicolon) {
				// Dead char
			}
			else if (key.code < _translateControlToChar.length) {
				key.printable = _translateControlToChar[key.code];

				if (key.deadChar != '\0') {
					key.printable = Unicode.combine(key.printable, key.deadChar)[0];
				}
			}
		}
		else if (key.shift && !key.rightAlt && key.rightControl && !key.leftControl) {
			if (key.code == Key.Equals) {
				key.deadChar = '\u0328'; // Ogonek
			}
			else if (key.code == Key.Foreslash) {
				key.deadChar = '\u0307'; // Dot Above
			}
			else if (key.code == Key.LeftBracket) {
				key.deadChar = '\u030a'; // Ring Above
			}
			else if (key.code == Key.RightBracket) {
				key.deadChar = '\u0304'; // Macron
			}
			else if (key.code == Key.Backslash) {
				key.deadChar = '\u0306'; // Breve
			}
			else if (key.code == Key.Semicolon) {
				key.deadChar = '\u030b'; // Double Acute
			}
			else if (key.code == Key.Apostrophe) {
				key.deadChar = '\u030c'; // Caron
			}
			else if (key.code < _translateShiftControlToChar.length) {
				key.printable = _translateShiftControlToChar[key.code];

				if (key.deadChar != '\0') {
					key.printable = Unicode.combine(key.printable, key.deadChar)[0];
				}
			}
		}
		else if (!key.shift && key.rightAlt && !key.leftAlt && !key.control) {
			if (key.code == Key.LeftBracket) {
				key.deadChar = '\u0300'; // grave
			}
			else if (key.code == Key.RightBracket) {
				key.deadChar = '\u0303'; // tilde
			}
			else if (key.code < _translateAltToChar.length) {
				key.printable = _translateAltToChar[key.code];
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
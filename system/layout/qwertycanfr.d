/*
 * qwertycanfr.d
 *
 * This module implements the French Canadian qwerty keyboard layout.
 *
 */

module system.layout.qwertycanfr;

import system.layout.keyboardtranslator;

import core.definitions;

import io.console;

class QwertyCanFrTranslator : KeyboardTranslator {

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
		Key.International: '\u00ab' // Double angle quote left
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
		Key.International: '\u00bb' // Double angle quote right
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
		Key.M: '\u00b5', // Micro Sign
		Key.Comma: '\u00af', // Macron
		Key.Period: '\u00ad', // Soft Hyphen
		Key.LeftBracket: '[',
		Key.RightBracket: ']',
		Key.Backslash: '}',
		Key.International: '\u00b0' // Degree
	];

	static dchar _translateCircumflexToChar[] = [
		Key.A: '\u00e2',
		Key.E: '\u00ea',
		Key.I: '\u00ee',
		Key.O: '\u00f4',
		Key.U: '\u00fb'
	];

	static dchar _translateCedillaToChar[] = [
		Key.C: '\u00e7'
	];

	static dchar _translateGraveToChar[] = [
		Key.A: '\u00e0',
		Key.E: '\u00e8',
		Key.I: '\u00ec',
		Key.O: '\u00f2',
		Key.U: '\u00f9'
	];

	static dchar _translateDiaeresisToChar[] = [
		Key.A: '\u00e4',
		Key.E: '\u00eb',
		Key.I: '\u00ef',
		Key.O: '\u00f6',
		Key.U: '\u00fc',
		Key.Y: '\u00ff'
	];

	static dchar _translateAcuteToChar[] = [
		Key.A: '\u00e1',
		Key.E: '\u00e9',
		Key.I: '\u00ed',
		Key.O: '\u00f3',
		Key.U: '\u00fa',
		Key.Y: '\u00fd'
	];

	static dchar _translateShiftCircumflexToChar[] = [
		Key.A: '\u00c2',
		Key.E: '\u00ca',
		Key.I: '\u00ce',
		Key.O: '\u00d4',
		Key.U: '\u00db'
	];

	static dchar _translateShiftCedillaToChar[] = [
		Key.C: '\u00c7'
	];

	static dchar _translateShiftGraveToChar[] = [
		Key.A: '\u00c0',
		Key.E: '\u00c8',
		Key.I: '\u00cc',
		Key.O: '\u00d2',
		Key.U: '\u00d9'
	];

	static dchar _translateShiftDiaeresisToChar[] = [
		Key.A: '\u00c4',
		Key.E: '\u00cb',
		Key.I: '\u00cf',
		Key.O: '\u00d6',
		Key.U: '\u00dc'
	];

	static dchar _translateShiftAcuteToChar[] = [
		Key.A: '\u00c1',
		Key.E: '\u00c9',
		Key.I: '\u00cd',
		Key.O: '\u00d3',
		Key.U: '\u00da',
		Key.Y: '\u00dd'
	];

	override Key translate(Key key) {
		key.printable = '\0';
		if (!key.shift && !key.alt && !key.ctrl) {
			// Dead characters
			if (key.code == Key.LeftBracket) {
				key.deadChar = '\u0302'; // circumflex
			}
			else if (key.code == Key.RightBracket) {
				key.deadChar = '\u0327'; // cedilla
			}
			else if (key.code == Key.Apostrophe) {
				key.deadChar = '\u0300'; // grave
			}
			else if (key.deadChar == '\u0302') {
				key.printable = _translateCircumflexToChar[key.code];
			}
			else if (key.deadChar == '\u0327') {
				key.printable = _translateCedillaToChar[key.code];
			}
			else if (key.deadChar == '\u0300') {
				key.printable = _translateGraveToChar[key.code];
			}
			else if (key.deadChar == '\u0308') {
				key.printable = _translateDiaeresisToChar[key.code];
			}
			else if (key.deadChar == '\u0301') {
				key.printable = _translateAcuteToChar[key.code];
			}
			else if (key.code < _translateToChar.length) {
				key.printable = _translateToChar[key.code];
			}
		}
		else if (key.shift && !key.alt && !key.ctrl) {
			if (key.code == Key.LeftBracket) {
				key.deadChar = '\u0302'; // circumflex
			}
			else if (key.code == Key.RightBracket) {
				key.deadChar = '\u0308'; // diaeresis
			}
			else if (key.code == Key.Apostrophe) {
				key.deadChar = '\u0300'; // grave
			}
			else if (key.deadChar == '\u0302') {
				key.printable = _translateShiftCircumflexToChar[key.code];
			}
			else if (key.deadChar == '\u0327') {
				key.printable = _translateShiftCedillaToChar[key.code];
			}
			else if (key.deadChar == '\u0300') {
				key.printable = _translateShiftGraveToChar[key.code];
			}
			else if (key.deadChar == '\u0308') {
				key.printable = _translateShiftDiaeresisToChar[key.code];
			}
			else if (key.deadChar == '\u0301') {
				key.printable = _translateShiftAcuteToChar[key.code];
			}
			else if (key.code < _translateShiftToChar.length) {
				key.printable = _translateShiftToChar[key.code];
			}
		}
		else if (!key.shift && key.rightAlt && !key.ctrl) {
			if (key.code == Key.Foreslash) {
				key.deadChar = '\u0301'; // acute
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
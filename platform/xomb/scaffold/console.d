/*
 * console.d
 *
 * This file implements the Console interfaces for the Linux system.
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.console;

import djehuty;

import platform.application;

import synch.thread;
import synch.semaphore;

import Sys = libos.console;
import user.console : SysColor = Color;

import SysK = libos.keyboard;
import user.keycodes : SysKey = Key;

private Semaphore foo = null;

private int _toNearestConsoleColor(Color clr) {
	// 16 colors on console
	// For each channel, it can be 00, 88, or ff
	// That is, something mid range

	int nearRed, nearGreen, nearBlue;
	int ret;

	nearRed = cast(int)((clr.red * 3.0) + 0.5);
	nearGreen = cast(int)((clr.green * 3.0) + 0.5);
	nearBlue = cast(int)((clr.blue * 3.0) + 0.5);

	if ((nearRed == nearGreen) && (nearGreen == nearBlue)) {
		// gray
		if (clr.red < (Color.DarkGray.red / 2.0)) {
			// Closer to black
			ret = 0;
		}
		else if (clr.red < ((Color.Gray.red - Color.DarkGray.red) / 2.0) + Color.DarkGray.red) {
			// Closer to dark gray
			ret = 8;
		}
		else if (clr.red < ((Color.White.red - Color.Gray.red) / 2.0) + Color.Gray.red) {
			// Closer to light gray
			ret = 7;
		}
		else {
			// Closer to white
			ret = 15;
		}
	}
	else {
		// Nearest color match
		static int[3][] translations = [
			[0,0,1],	// 1, Dark Blue
			[0,1,0],	// 2, Dark Green
			[0,1,1],	// 3, Dark Cyan
			[1,0,0],	// 4, Dark Red
			[1,0,1],	// 5, Dark Magenta
			[1,1,0],	// 6, Dark Yellow

			[0,0,2],	// 09, Blue
			[0,2,0],	// 10, Green
			[0,2,2],	// 11, Cyan
			[2,0,0],	// 12, Red
			[2,0,2],	// 13, Magenta
			[2,2,0],	// 14, Yellow
		];

		float mindistance = 4*3;

		foreach(size_t i, coord; translations) {
			// Compare euclidian distance
			float distance = 0.0;
			float intermediate;

			intermediate = coord[0] - nearRed;
			intermediate *= intermediate;

			distance += intermediate;

			intermediate = coord[1] - nearGreen;
			intermediate *= intermediate;

			distance += intermediate;

			intermediate = coord[2] - nearBlue;
			intermediate *= intermediate;

			distance += intermediate;

			// Omitting square root, it is unnecessary for comparison
			if (mindistance > distance) {
				mindistance = distance;
				ret = i;
				ret++;
				if (ret > 6) {
					ret += 2;
				}
			}	
		}
	}

	return ret;
}

void ConsoleSetColors(Color fg, Color bg) {
	int fgidx = _toNearestConsoleColor(fg);
	int bgidx = _toNearestConsoleColor(bg);

	/*int bright = 0;
	if (fgidx > 7) {
		fgidx %= 8;
		bright = 1;
	}
	bgidx %= 8;*/

	Sys.Console.forecolor = cast(SysColor)fgidx;
	Sys.Console.backcolor = cast(SysColor)bgidx;
}

//will return the next character pressed
static uint _translation[] = [
	SysKey.Null: Key.Invalid,
	SysKey.A: Key.A,
	SysKey.B: Key.B,
	SysKey.C: Key.C,
	SysKey.D: Key.D,
	SysKey.E: Key.E,
	SysKey.F: Key.F,
	SysKey.G: Key.G,
	SysKey.H: Key.H,
	SysKey.I: Key.I,
	SysKey.J: Key.J,
	SysKey.K: Key.K,
	SysKey.L: Key.L,
	SysKey.M: Key.M,
	SysKey.N: Key.N,
	SysKey.O: Key.O,
	SysKey.P: Key.P,
	SysKey.Q: Key.Q,
	SysKey.R: Key.R,
	SysKey.S: Key.S,
	SysKey.T: Key.T,
	SysKey.U: Key.U,
	SysKey.V: Key.V,
	SysKey.W: Key.W,
	SysKey.X: Key.X,
	SysKey.Y: Key.Y,
	SysKey.Z: Key.Z,
	SysKey.Num0: Key.Zero,
	SysKey.Num1: Key.One,
	SysKey.Num2: Key.Two,
	SysKey.Num3: Key.Three,
	SysKey.Num4: Key.Four,
	SysKey.Num5: Key.Five,
	SysKey.Num6: Key.Six,
	SysKey.Num7: Key.Seven,
	SysKey.Num8: Key.Eight,
	SysKey.Num9: Key.Nine,
	SysKey.Quote: Key.Apostrophe,
	SysKey.Minus: Key.Minus,
	SysKey.Equals: Key.Equals,
	SysKey.Slash: Key.Foreslash,
	SysKey.Backspace: Key.Backspace,
	SysKey.Tab: Key.Tab,
	SysKey.Capslock: Key.CapsLock,
	SysKey.LeftShift: Key.LeftShift,
	SysKey.LeftControl: Key.LeftControl,
	SysKey.LeftAlt: Key.LeftAlt,
	SysKey.RightShift: Key.RightShift,
	SysKey.RightControl: Key.RightControl,
	SysKey.RightAlt: Key.RightAlt,
	SysKey.Return: Key.Return,
	SysKey.Escape: Key.Escape,
	SysKey.F1: Key.F1,
	SysKey.F2: Key.F2,
	SysKey.F3: Key.F3,
	SysKey.F4: Key.F4,
	SysKey.F5: Key.F5,
	SysKey.F6: Key.F6,
	SysKey.F7: Key.F7,
	SysKey.F8: Key.F8,
	SysKey.F9: Key.F9,
	SysKey.F10: Key.F10,
	SysKey.F11: Key.F11,
	SysKey.F12: Key.F12,
	SysKey.ScrollLock: Key.ScrollLock,
	SysKey.LeftBracket: Key.LeftBracket,
	SysKey.RightBracket: Key.RightBracket,
	SysKey.NumLock: Key.NumLock,
	SysKey.Apostrophe: Key.SingleQuote,
	SysKey.Comma: Key.Comma,
	SysKey.Period: Key.Period,
	SysKey.Backslash: Key.Backslash,
	SysKey.Down: Key.Down,
	SysKey.Up: Key.Up,
	SysKey.Left: Key.Left,
	SysKey.Right: Key.Right,
	SysKey.Semicolon: Key.Semicolon,
];

static bool lshift=false;
static bool rshift=false;
static bool lctrl=false;
static bool rctrl=false;
static bool lalt=false;
static bool ralt=false;

Key ConsoleGetKey() {
	Key ret;

	bool released=true;
	SysKey key;

	while (released) {
		key = SysK.Keyboard.nextKey(released);

		if (key == SysKey.LeftControl) {
			lctrl = !released;
		}
		else if (key == SysKey.RightControl) {
			rctrl = !released;
		}
		else if (key == SysKey.LeftAlt) {
			lalt = !released;
		}
		else if (key == SysKey.RightAlt) {
			ralt = !released;
		}
		else if (key == SysKey.LeftShift) {
			lshift = !released;
		}
		else if (key == SysKey.RightShift) {
			rshift = !released;
		}
	}

	ret.code = _translation[key];

	ret.shift = lshift | rshift;
	ret.leftControl = lctrl;
	ret.rightControl = rctrl;
	ret.leftAlt = lalt;
	ret.rightAlt = ralt;

	return ret;
}

void ConsoleInit() {
}

void ConsoleUninit() {
}

void ConsoleClear() {
	Sys.Console.clear();
}

void ConsoleSetRelative(int x, int y) {
	uint x_, y_;
	Sys.Console.getPosition(x_, y_);
	int nx, ny;
	nx = cast(int)x_ + x;
	ny = cast(int)y_ + y;
	if (nx < 0) { nx = 0; }
	if (ny < 0) { ny = 0; }
	Sys.Console.setPosition(nx, ny);
}

void ConsoleGetPosition(uint* x, uint* y) {
	uint x_, y_;
	Sys.Console.getPosition(x_,y_);
	*x = x_;
	*y = y_;
}

void ConsoleSetPosition(uint x, uint y) {
	Sys.Console.setPosition(x, y);
}

void ConsoleHideCaret() {
}

void ConsoleShowCaret() {
}

void ConsoleSetHome() {
	uint x, y;
	Sys.Console.getPosition(x, y);
	Sys.Console.setPosition(0, y);
}

void ConsolePutString(char[] chrs) {
	Sys.Console.putString(chrs);
}

void ConsolePutChar(dchar chr) {
	Sys.Console.putString([chr]);
}

void ConsoleGetSize(out uint width, out uint height) {
	width = Sys.Console.width();
	height = Sys.Console.height();
}

void ConsoleGetChar(out dchar chr, out uint code) {
}

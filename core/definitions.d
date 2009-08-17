/*
 * definitions.d
 *
 * This file contains the core definitions, structures, and datatypes
 * taking into account some platform-specific properties.
 *
 * Author: Dave Wilkinson
 *
 */

module core.definitions;

import Platform = platform.definitions;

// String
version(D_Version2) {
	template _D2_Support_string() {
		version(D_Version2) {
			const char[] _D2_Support_string = `alias invariant(char)[] string;`;
		}
		else {
			const char[] _D2_Support_string = `alias char[] string;`;
		}
	}
	template _D2_Support_wstring() {
		version(D_Version2) {
			const char[] _D2_Support_wstring = `alias invariant(wchar)[] wstring;`;
		}
		else {
			const char[] _D2_Support_wstring = `alias wchar[] wstring;`;
		}
	}
	template _D2_Support_dstring() {
		version(D_Version2) {
			const char[] _D2_Support_dstring = `alias invariant(dchar)[] dstring;`;
		}
		else {
			const char[] _D2_Support_dstring = `alias dchar[] dstring;`;
		}
	}

	mixin(_D2_Support_string!());
	mixin(_D2_Support_wstring!());
	mixin(_D2_Support_dstring!());
}
else {
	version(Tango) {
		alias char[] string;
		alias wchar[] wstring;
		alias dchar[] dstring;
	}
}

// Section: Types

// Description: This struct stores an x and y and is used to specify a point.
struct Coord {

	// Description: The x coordinate.
	int x;

	// Description: The y coordinate.
	int y;

}

// Description: This struct stores an x any y, or a width and height, useful for some measurements.
struct Size {

	// Description: The width of the measurement.
	uint x;

	// Description: The height of the measurement.
	uint y;
}


// Description: This struct stores a description of a rectangle.
struct Rect {

	// Description: The x point of the top-left of the rectangle.
	uint left;

	// Description: The y point of the top-left of the rectangle.
	uint top;

	// Description: The y point of the bottom-right of the rectangle.
	uint bottom;

	// Description: The x point of the bottom-right of the rectangle.
	uint right;
}

// Section: Enums

// Window Styles

// Description: This enum gives all possible window styles.  Use the SetStyle() function within the BaseWindow class to set the style of the window to this value.
enum WindowStyle : int {
	// Description: Represents a non-sizable window.
	Fixed = 0,

	// Description: Represents a common sizable window.
	Sizable = 1,

	// Description: Represents a borderless window.
	Popup = 2,
}

// Window States

// Description: This enum gives all possible window states.  Use the SetState() function within the BaseWindow class to set the state of the window to this value.
enum WindowState : int {
	// Description: This would be the normal view of the window.  Sometimes refered to as the restored view.
	Normal = 0,
	// Description: This state will cause the window to be minimized.  Sometimes refered to as shrinking, or even rarely iconizing.
	Minimized = 1,
	// Description: This state will cause the window to be maximized, and this would mean the window would get as big as it can within the constraints of the desktop environment.
	Maximized = 2,
	// Description: This state will cause the window to take up the entire screen, essentially the width and height would be that of the current screen resolution on the current display.
	Fullscreen = 3
}

// System Colors

// Description: This enum gives all possible system colors to query.
enum SystemColor : ubyte {
	// Description: This would be the normal window background style.  Give this to the constructor, and it will produce a normal looking window.
	Window = 0,
}


// Section: Types


// Mouse structure
//   from the Window class

// Description: This struct gives the state of the mouse input for a window.
struct Mouse {
	// Description: The x coordinate in coordination to the client area of the window of the mouse cursor.
	int x;
	// Description: The y coordinate in coordination to the client area of the window of the mouse cursor.
	int y;

	// Description: The number of clicks the user has done in a row.  1 is a single click.  2 is a double click, and so on.  You should use the mod operator to use this property properly.
	int clicks;

	// Description: Whether or not the primary button is down.
	bool leftDown;
	// Description: Whether or not the secondary button is down.
	bool rightDown;
	// Description: Whether or not the tertiary button is down.
	bool middleDown;
}

struct Key {
	uint code;

	bool ctrl;
	bool alt;
	bool shift;

	const uint Backspace = Platform.KeyBackspace;
	const uint Tab = Platform.KeyTab;

	const uint Return = Platform.KeyReturn;
	const uint Pause = Platform.KeyPause;
	const uint Escape = Platform.KeyEscape;
	const uint Space = Platform.KeySpace;

	const uint PageUp = Platform.KeyPageUp;
	const uint PageDown = Platform.KeyPageDown;

	const uint End = Platform.KeyEnd;
	const uint Home = Platform.KeyHome;

	const uint Left = Platform.KeyArrowLeft;
	const uint Right = Platform.KeyArrowRight;
	const uint Up = Platform.KeyArrowUp;
	const uint Down = Platform.KeyArrowDown;

	const uint Insert = Platform.KeyInsert;
	const uint Delete = Platform.KeyDelete;

	const uint NumLock = Platform.KeyNumLock;
	const uint ScrollLock = Platform.KeyScrollLock;

	const uint LeftShift = Platform.KeyLeftShift;
	const uint RightShift = Platform.KeyRightShift;

	const uint LeftControl = Platform.KeyLeftControl;
	const uint RightControl = Platform.KeyRightControl;

	const uint LeftAlt = Platform.KeyLeftAlt;
	const uint RightAlt = Platform.KeyRightAlt;

	const uint Zero = Platform.Key0;
	const uint One = Platform.Key1;
	const uint Two = Platform.Key2;
	const uint Three = Platform.Key3;
	const uint Four = Platform.Key4;
	const uint Five = Platform.Key5;
	const uint Six = Platform.Key6;
	const uint Seven = Platform.Key7;
	const uint Eight = Platform.Key8;
	const uint Nine = Platform.Key9;

	const uint SingleQuote = Platform.KeySingleQuote;
	const uint Quote = Platform.KeyQuote;
	const uint Comma = Platform.KeyComma;
	const uint Period = Platform.KeyPeriod;
	const uint Foreslash = Platform.KeyForeslash;
	const uint Backslash = Platform.KeyBackslash;
	const uint LeftBracket = Platform.KeyLeftBracket;
	const uint RightBracket = Platform.KeyRightBracket;
	const uint Semicolon = Platform.KeySemicolon;
	const uint Minus = Platform.KeyMinus;
	const uint Equals = Platform.KeyEquals;

	const uint A = Platform.KeyA;
	const uint B = Platform.KeyB;
	const uint C = Platform.KeyC;
	const uint D = Platform.KeyD;
	const uint E = Platform.KeyE;
	const uint F = Platform.KeyF;
	const uint G = Platform.KeyG;
	const uint H = Platform.KeyH;
	const uint I = Platform.KeyI;
	const uint J = Platform.KeyJ;
	const uint K = Platform.KeyK;
	const uint L = Platform.KeyL;
	const uint M = Platform.KeyM;
	const uint N = Platform.KeyN;
	const uint O = Platform.KeyO;
	const uint P = Platform.KeyP;
	const uint Q = Platform.KeyQ;
	const uint R = Platform.KeyR;
	const uint S = Platform.KeyS;
	const uint T = Platform.KeyT;
	const uint U = Platform.KeyU;
	const uint V = Platform.KeyV;
	const uint W = Platform.KeyW;
	const uint X = Platform.KeyX;
	const uint Y = Platform.KeyY;
	const uint Z = Platform.KeyZ;

	const uint F1 = Platform.KeyF1;
	const uint F2 = Platform.KeyF2;
	const uint F3 = Platform.KeyF3;
	const uint F4 = Platform.KeyF4;
	const uint F5 = Platform.KeyF5;
	const uint F6 = Platform.KeyF6;
	const uint F7 = Platform.KeyF7;
	const uint F8 = Platform.KeyF8;
	const uint F9 = Platform.KeyF9;
	const uint F10 = Platform.KeyF10;
	const uint F11 = Platform.KeyF11;
	const uint F12 = Platform.KeyF12;
	const uint F13 = Platform.KeyF13;
	const uint F14 = Platform.KeyF14;
	const uint F15 = Platform.KeyF15;
	const uint F16 = Platform.KeyF16;
}

// Redefine Platform Hints
alias Platform.FontSans FontSans;
alias Platform.Char Char;

// Default parameters
const int Default = -1;

// C Types
version(X86) {
	alias uint Culong;
	alias int Clong;
}
else {
	alias ulong Culong;
	alias long Clong;
}

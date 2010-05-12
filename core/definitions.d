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

//import platform.definitions;
public import platform.definitions;

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
	
	// Description: This function will test whether another rectangle intersects (overlaps) this one.
	// test: A rectangle to test.
	// Returns: Will return true when the rectangle given by test overlaps.
	bool intersects(Rect test) {
		return !(left > test.right || right < test.left || top > test.bottom || bottom < test.top);
	}
}

// Section: Enums

// Window Styles

// Description: This enum gives all possible window styles.  Use the SetStyle() function within the BaseWindow class to set the style of the window to this value.
enum WindowStyle : int {
	// Description: Represents a non-sizable window.
	Fixed,

	// Description: Represents a common sizable window.
	Sizable,

	// Description: Represents a borderless window.
	Popup,
}

// Window Positions
enum WindowPosition : int {
	// Description: Will be placed according to the window manager.
	Default,

	// Description: Will be placed in the center of the default monitor.
	Center,

	// Description: Will be placed with the Window's x and y properties.
	User,
}

// Window States

// Description: This enum gives all possible window states.  Use the SetState() function within the BaseWindow class to set the state of the window to this value.
enum WindowState : int {
	// Description: This would be the normal view of the window.  Sometimes refered to as the restored view.
	Normal,
	// Description: This state will cause the window to be minimized.  Sometimes refered to as shrinking, or even rarely iconizing.
	Minimized,
	// Description: This state will cause the window to be maximized, and this would mean the window would get as big as it can within the constraints of the desktop environment.
	Maximized,
	// Description: This state will cause the window to take up the entire screen, essentially the width and height would be that of the current screen resolution on the current display.
	Fullscreen
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

	const uint Backspace = KeyBackspace;
	const uint Tab = KeyTab;

	const uint Return = KeyReturn;
	const uint Pause = KeyPause;
	const uint Escape = KeyEscape;
	const uint Space = KeySpace;

	const uint PageUp = KeyPageUp;
	const uint PageDown = KeyPageDown;

	const uint End = KeyEnd;
	const uint Home = KeyHome;

	const uint Left = KeyArrowLeft;
	const uint Right = KeyArrowRight;
	const uint Up = KeyArrowUp;
	const uint Down = KeyArrowDown;

	const uint Insert = KeyInsert;
	const uint Delete = KeyDelete;

	const uint NumLock = KeyNumLock;
	const uint ScrollLock = KeyScrollLock;

	const uint LeftShift = KeyLeftShift;
	const uint RightShift = KeyRightShift;

	const uint LeftControl = KeyLeftControl;
	const uint RightControl = KeyRightControl;

	const uint LeftAlt = KeyLeftAlt;
	const uint RightAlt = KeyRightAlt;

	const uint Zero = Key0;
	const uint One = Key1;
	const uint Two = Key2;
	const uint Three = Key3;
	const uint Four = Key4;
	const uint Five = Key5;
	const uint Six = Key6;
	const uint Seven = Key7;
	const uint Eight = Key8;
	const uint Nine = Key9;

	const uint SingleQuote = KeySingleQuote;
	const uint Quote = KeyQuote;
	const uint Comma = KeyComma;
	const uint Period = KeyPeriod;
	const uint Foreslash = KeyForeslash;
	const uint Backslash = KeyBackslash;
	const uint LeftBracket = KeyLeftBracket;
	const uint RightBracket = KeyRightBracket;
	const uint Semicolon = KeySemicolon;
	const uint Minus = KeyMinus;
	const uint Equals = KeyEquals;

	const uint A = KeyA;
	const uint B = KeyB;
	const uint C = KeyC;
	const uint D = KeyD;
	const uint E = KeyE;
	const uint F = KeyF;
	const uint G = KeyG;
	const uint H = KeyH;
	const uint I = KeyI;
	const uint J = KeyJ;
	const uint K = KeyK;
	const uint L = KeyL;
	const uint M = KeyM;
	const uint N = KeyN;
	const uint O = KeyO;
	const uint P = KeyP;
	const uint Q = KeyQ;
	const uint R = KeyR;
	const uint S = KeyS;
	const uint T = KeyT;
	const uint U = KeyU;
	const uint V = KeyV;
	const uint W = KeyW;
	const uint X = KeyX;
	const uint Y = KeyY;
	const uint Z = KeyZ;

	const uint F1 = KeyF1;
	const uint F2 = KeyF2;
	const uint F3 = KeyF3;
	const uint F4 = KeyF4;
	const uint F5 = KeyF5;
	const uint F6 = KeyF6;
	const uint F7 = KeyF7;
	const uint F8 = KeyF8;
	const uint F9 = KeyF9;
	const uint F10 = KeyF10;
	const uint F11 = KeyF11;
	const uint F12 = KeyF12;
	const uint F13 = KeyF13;
	const uint F14 = KeyF14;
	const uint F15 = KeyF15;
	const uint F16 = KeyF16;
}

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

union CuiEventInfo {
	Key key;
	Mouse mouse;
	Size size;
}

struct CuiEvent {
	enum Type {
		KeyDown,
		KeyUp,
		MouseDown,
		MouseUp,
		MouseMove,
		MouseWheelX,
		MouseWheelY,
		Size,
		Close,
	}

	Type type;
	CuiEventInfo info;
	uint aux;
}


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

public import platform.definitions;

// Section: Types

// Description: This struct stores an x and y and is used to specify a point.
struct Coord {

	// Description: The x coordinate.
	double x = 0;

	// Description: The y coordinate.
	double y = 0;

}

// Description: This struct stores an x any y, or a width and height, useful for some measurements.
alias Coord Size;


// Description: This struct stores a description of a rectangle.
struct Rect {

	// Description: The x point of the top-left of the rectangle.
	double left = 0;

	// Description: The y point of the top-left of the rectangle.
	double top = 0;

	// Description: The y point of the bottom-right of the rectangle.
	double bottom = 0;

	// Description: The x point of the bottom-right of the rectangle.
	double right = 0;

	// Description: This function will test whether another rectangle intersects (overlaps) this one.
	// test: A rectangle to test.
	// Returns: Will return true when the rectangle given by test overlaps.
	bool intersects(Rect test) {
		return !(left > test.right || right < test.left || top > test.bottom || bottom < test.top);
	}
}

// Description: This enum gives values for orientations.
enum Orientation {
	// Description: This indicates that something should go left to right.
	Horizontal,

	// Description: This indicates that something should go top to bottom.
	Vertical
}

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
	// Description: Will be placed in the center of the default monitor.
	Center,

	User,
}

enum WindowOrder {
	TopMost,
	Top,
	Bottom,
	BottomMost
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
	double x = 0;
	// Description: The y coordinate in coordination to the client area of the window of the mouse cursor.
	double y = 0;

	// Description: The number of clicks the user has done in a row.  1 is a single click.  2 is a double click, and so on.  You should use the mod operator to use this property properly.
	int[5] clicks;
}

struct Key {
	uint code;
	uint scan;

	bool ctrl;
	bool alt;
	bool shift;

	bool leftAlt;
	bool rightAlt;

	dchar printable;

	uint deadCode;

	enum : uint {
		Invalid,

		Backspace,
		Tab,
		Pause,
		Escape,

		PageUp,
		PageDown,

		End,
		Home,

		Left,
		Right,
		Up,
		Down,

		Insert,
		Delete,

		NumLock,
		ScrollLock,
		CapsLock,

		LeftShift,
		RightShift,

		LeftControl,
		RightControl,

		LeftAlt,
		RightAlt,

		LeftGui,
		RightGui,

		Application,

		F1,
		F2,
		F3,
		F4,
		F5,
		F6,
		F7,
		F8,
		F9,
		F10,
		F11,
		F12,
		F13,
		F14,
		F15,
		F16,
		F17,
		F18,
		F19,
		F20,
		F21,
		F22,
		F23,
		F24,

		Return,
		Space,

		Zero,
		One,
		Two,
		Three,
		Four,
		Five,
		Six,
		Seven,
		Eight,
		Nine,

		PrintScreen,
		SysRq,

		SingleQuote,
		Apostrophe,
		Comma,
		Period,
		Foreslash,
		Backslash,

		LeftBracket,
		RightBracket,

		Semicolon,
		Minus,
		Equals,

		A,
		B,
		C,
		D,
		E,
		F,
		G,
		H,
		I,
		J,
		K,
		L,
		M,
		N,
		O,
		P,
		Q,
		R,
		S,
		T,
		U,
		V,
		W,
		X,
		Y,
		Z,

		KeypadZero,
		KeypadOne,
		KeypadTwo,
		KeypadThree,
		KeypadFour,
		KeypadFive,
		KeypadSix,
		KeypadSeven,
		KeypadEight,
		KeypadNine,

		KeypadPlus,
		KeypadMinus,
		KeypadAsterisk,
		KeypadForeslash,
		KeypadReturn,
		KeypadPeriod,

		International,
	}
}

// Default parameters
const int Default = -1;

union EventInfo {
	Key key;
	Mouse mouse;
	Size size;
	uint exitCode;
}

struct Event {
	enum : uint {
		KeyDown,
		KeyUp,
		MouseDown,
		MouseUp,
		MouseMove,
		MouseWheelX,
		MouseWheelY,
		MouseLeave,
		Size,
		Close,
	}

	uint type;
	EventInfo info;
	uint aux;
}

enum Month {
	January,
	February,
	March,
	April,
	May,
	June,
	July,
	August,
	September,
	October,
	November,
	December
}

enum Day {
	Sunday,
	Monday,
	Tuesday,
	Wednesday,
	Thursday,
	Friday,
	Saturday
}

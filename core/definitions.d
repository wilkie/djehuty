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

// String

version(Tango) {
	alias char[] string;
	alias wchar[] wstring;
	alias dchar[] dstring;
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

struct Date {

}


// Section: Enums




// Window Styles

// Description: This enum gives all possible window styles.  Use the SetStyle() function within the BaseWindow class to set the style of the window to this value.
enum WindowStyle : int
{
	// Description: Represents a non-sizable window.
	Fixed = 0,

	// Description: Represents a common sizable window.
	Sizable = 1,

	// Description: Represents a borderless window.
	Popup = 2,
}



// Window States

// Description: This enum gives all possible window states.  Use the SetState() function within the BaseWindow class to set the state of the window to this value.
enum WindowState : int
{
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
enum SystemColor : ubyte
{
	// Description: This would be the normal window background style.  Give this to the constructor, and it will produce a normal looking window.
	Window = 0,
}


// Section: Types


// Mouse structure
//   from the Window class

// Description: This struct gives the state of the mouse input for a window.
struct Mouse
{
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


// Default parameters
const int Default = -1;

// C Types
version(X86)
{
	alias uint Culong;
	alias int Clong;
}
else
{
	alias ulong Culong;
	alias long Clong;
}

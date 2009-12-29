module io.console;

import scaffold.console;

import synch.mutex;

import core.string;
import core.tostring;
import core.format;
import core.unicode;
import core.definitions;
import core.variant;

// Section: Enums

// Description: This enum gives possible events that can be triggered by the Console.
enum ConsoleEvent : uint {
	// Description: Fired when Ctrl+C is signaled.
	CtrlC,

	// Description: Fired when Ctrl+Break is signaled.
	CtrlBreak,
}

// Description: This enum gives all possible foreground colors for the console.
enum fgColor : uint {
	// Description: The color black.
	Black=0,

	// Description: The color red.
	Red,

	// Description: The color green.
	Green,

	// Description: The color yellow.
	Yellow,

	// Description: The color blue.
	Blue,

	// Description: The color magenta.
	Magenta,

	// Description: The color cyan.
	Cyan,

	// Description: The color white.
	White,

	// Description: The color black (emphasized).
	BrightBlack,

	// Description: The color red (emphasized).
	BrightRed,

	// Description: The color green (emphasized).
	BrightGreen,

	// Description: The color yellow (emphasized).
	BrightYellow,

	// Description: The color blue (emphasized).
	BrightBlue,

	// Description: The color magenta (emphasized).
	BrightMagenta,

	// Description: The color cyan (emphasized).
	BrightCyan,

	// Description: The color white (emphasized).
	BrightWhite,
}

// Description: This enum gives all possible background colors for the console.
enum bgColor : uint {
	// Description: The color black.
	Black=0,

	// Description: The color red.
	Red,

	// Description: The color green.
	Green,

	// Description: The color yellow.
	Yellow,

	// Description: The color blue.
	Blue,

	// Description: The color magenta.
	Magenta,

	// Description: The color cyan.
	Cyan,

	// Description: The color white.
	White,
}

// Section: Core

// Description: This class abstracts simple console operations.
class Console {
static:

	//Description: Sets the foreground color for the console.
	//fgclr: The foreground color to set.
	void setColor(fgColor fclr) {
		_lock.lock();
		scope(exit) _lock.unlock();

		int bright = 0;
		if (fclr > fgColor.White)
		{
			bright = 1;
		}

	    cur_fg_color = fclr % 8;
	    cur_bright_color = bright;

	    ConsoleSetColors(cur_fg_color, cur_bg_color, cur_bright_color);
	}

	//Description: Sets the foreground and background colors for the console.
	//fgclr: The foreground color to set.
	//bgclr: The background color to set.
	void setColor(fgColor fclr, bgColor bclr) {
		_lock.lock();
		scope(exit) _lock.unlock();

		int bright = 0;
		if (fclr > fgColor.White)
		{
			bright = 1;
		}

	    cur_fg_color = fclr % 8;
	    cur_bg_color = bclr;
	    cur_bright_color = bright;

	    ConsoleSetColors(cur_fg_color, cur_bg_color, cur_bright_color);
	}

	//Description: Sets the background color for the console.
	//bgclr: The background color to set.
	void setColor(bgColor bclr) {
		_lock.lock();
		scope(exit) _lock.unlock();

	    cur_bg_color = bclr;

	    ConsoleSetColors(cur_fg_color, cur_bg_color, cur_bright_color);
	}

	// Description: Clears the console screen.
	void clear() {
		_lock.lock();
		scope(exit) _lock.unlock();

		ConsoleClear();
	}

	void position(Coord coord) {
		_lock.lock();
		scope(exit) _lock.unlock();

		_position(coord.x, coord.y);
	}

	void position(uint[] coord) {
		_lock.lock();
		scope(exit) _lock.unlock();

		_position(coord[0], coord[1]);
	}

	void position(uint x, uint y) {
		_lock.lock();
		scope(exit) _lock.unlock();

		_position(x,y);
	}

	Coord position() {
		_lock.lock();
		scope(exit) _lock.unlock();

		Coord ret;
		ConsoleGetPosition(cast(uint*)&ret.x,cast(uint*)&ret.y);
		return ret;
	}

	// Description: Moves the position of the caret relative to its current location.
	// x: The number of columns for the caret to move.  Negative values move down.
	// y: The number of rows for the caret.  Negative values move up.
	void setRelative(int x, int y) {
		_lock.lock();
		scope(exit) _lock.unlock();

		ConsoleSetRelative(x,y);
	}

	// Description: Will show the caret.
	void showCaret() {
		_lock.lock();
		scope(exit) _lock.unlock();

		if (!_caretVisible) {
			ConsoleShowCaret();
			_caretVisible = true;
		}
	}

	// Description: Will hide the caret.
	void hideCaret() {
		_lock.lock();
		scope(exit) _lock.unlock();

		if (_caretVisible) {
			ConsoleHideCaret();
			_caretVisible = false;
		}
	}

	bool caretVisible() {
		return _caretVisible;
	}

	// Description: Will return the height
	uint height() {
		uint width;
		uint height;

		ConsoleGetSize(width, height);

		return height;
	}

	// Description: Will return the width
	uint width() {
		uint width;
		uint height;

		ConsoleGetSize(width, height);

		return width;
	}

	// Description: Will wait for input and return the key pressed and also the translated Unicode UTF-32 character that this keypress represents, if applicable.
	// chr: Will be set to the UTF-32 character.
	// code: Will be set to the character code for the key pressed.
	void getChar(out dchar chr, out uint code) {
		ConsoleGetChar(chr, code);
	}

	// Description: This function will save the current clipping context.
	void clipSave() {
		_lock.lock();
		scope(exit) _lock.unlock();

		_clippingStack ~= _clippingRegions;
	}

	// Description: This function will restore a former clipping context.
	void clipRestore() {
		_lock.lock();
		scope(exit) _lock.unlock();

		if (_clippingStack.length > 0) {
			_clippingRegions = _clippingStack[$-1];
			_clippingStack.length = _clippingStack.length - 1;
		}
	}

	// Description: This function will clear the clipping context.
	void clipClear() {
		_lock.lock();
		scope(exit) _lock.unlock();

		_clippingRegions = null;
	}

	// Description: This function will add a rectangular region defined as screen coordinates that will clip the drawing surface. When a clipping context is not clear, only regions within rectangles will be drawn to the screen.
	// region: The rectangular region to add as a clipping region.
	void clipRect(Rect region) {
		_lock.lock();
		scope(exit) _lock.unlock();

		_clippingRegions ~= region;
	}

	// Description: This function will add a rectangular region defined as screen coordinates that will clip the drawing surface. When a clipping context is not clear, only regions within rectangles will be drawn to the screen.
	// left: The left coordinate of the rectangle.
	// top: The top coordinate of the rectangle.
	// right: The right coordinate of the rectangle.
	// bottom: The bottom coordinate of the rectangle.
	void clipRect(uint left, uint top, uint right, uint bottom) {
		Rect rt = {left, top, bottom, right};
		clipRect(rt);
	}

	void putln(...) {
		Variadic vars = new Variadic(_arguments, _argptr);
		putlnv(vars);
	}

	void put(...) {
		Variadic vars = new Variadic(_arguments, _argptr);
		putv(vars);
	}

	void putv(Variadic vars) {
		_lock.lock();
		scope(exit) _lock.unlock();

		_putv(vars);
	}

	void putlnv(Variadic vars) {
		_lock.lock();
		scope(exit) _lock.unlock();

		_putv(vars);
		_putChar('\n');
	}
	
	void putStringAt(uint x, uint y, String str) {
		_lock.lock();
		scope(exit) _lock.unlock();

		_position(x,y);
		_putString(str);
	}

	void putString(String str) {
		_lock.lock();
		scope(exit) _lock.unlock();

		_putString(str);
	}
	
	void putAt(uint x, uint y, ...) {
		Variadic vars = new Variadic(_arguments, _argptr);
		
		putAtv(x, y, vars);
	}

	void putAtv(uint x, uint y, Variadic vars) {
		_lock.lock();
		scope(exit) _lock.unlock();

		_position(x, y);
		_putv(vars);
	}

	// Description: Will print out this character to the screen and the current location.
	// chr: The UTF-32 character to print.
	void putChar(dchar chr) {
		_lock.lock();
		scope(exit) _lock.unlock();

		if (_vt100_inescape2) {
			if (chr >= '0' && chr <= '9') {
				// another number,
				// add to current param
				_vt100_params[_vt100_curparam] *= 10;
				_vt100_params[_vt100_curparam] += chr - cast(ubyte)'0';
				_vt100_paramFilled = 1;
			}
			else if (chr == ';') {
				// goto next param
				if (_vt100_curparam < 4) {
					_vt100_curparam++;
					_vt100_params[_vt100_curparam] = 0;
					_vt100_paramFilled = 0;
				}
			}

			if ((chr >= 'a' && chr <= 'z') ||
				(chr >= 'A' && chr <= 'Z')) {

				if (_vt100_curparam < 4 && _vt100_paramFilled != 0) {
					_vt100_curparam++;
				}
				// found a code
				// interpret this
				if (chr == 'J') {
					if (_vt100_params[0] == 2) {
						ConsoleClear();
						ConsoleSetHome();
					}
					else {
					}
				}
				else if (chr == 's') {
					// save position
					//ConsoleSavePosition();
				}
				else if (chr == 'u') {
					// restore position
					//ConsoleRestorePosition();
				}
				else if (chr == 'A') {
					if (_vt100_params[0] == 0) {
						_vt100_params[0] = 1;
					}
					ConsoleSetRelative(0, -_vt100_params[0]);
				}
				else if (chr == 'B') {
					if (_vt100_params[0] == 0) {
						_vt100_params[0] = 1;
					}
					ConsoleSetRelative(0, _vt100_params[0]);
				}
				else if (chr == 'C') {
					if (_vt100_params[0] == 0)
					{
						_vt100_params[0] = 1;
					}
					ConsoleSetRelative(_vt100_params[0], 0);
				}
				else if (chr == 'D') {
					if (_vt100_params[0] == 0)
					{
						_vt100_params[0] = 1;
					}
					ConsoleSetRelative(-_vt100_params[0], 0);
				}
				else if (chr == 'H' || chr == 'f') {
					// set cursor position
					if (_vt100_params[1] == 0) {
						_vt100_params[1] = 1;
					}
					if (_vt100_params[0] == 0) {
						_vt100_params[0] = 1;
					}

					//ConsoleSetPosition(0,45);
					//writef("H: ", _vt100_params[1]-1, ",", _vt100_params[0]-1);

					ConsoleSetPosition(_vt100_params[1]-1, _vt100_params[0]-1);
				}
				else if (chr == 'm') {
					// color

					int fgclr=-1;
					int bgclr=-1;
					int bright=-1;

					for(uint i=0; i<_vt100_curparam; i++) {
						if (_vt100_params[i] >= 30 && _vt100_params[i] <= 37) {
							fgclr = _vt100_params[i] - 30;
						}
						else if (_vt100_params[i] == 39) {
							fgclr = fgColor.White;
						}
						else if (_vt100_params[i] >= 40 && _vt100_params[i] <= 47) {
							bgclr = _vt100_params[i] - 40;
						}
						else if (_vt100_params[i] == 49) {
							bgclr = bgColor.Black;
						}
						else if (_vt100_params[i] == 0) {
							bright = 0;
							fgclr = fgColor.White;
							bgclr = fgColor.Black;
						}
						else if (_vt100_params[i] < 2) {
							bright = _vt100_params[i];
						}
						else if (_vt100_params[i] == 7) {
							// invert the colors
						}
					}

					if (bright != -1) {
					    cur_bright_color = bright;
					}

					if (fgclr != -1) {
						cur_fg_color = fgclr;
					}

					if (bgclr != -1) {
						cur_bg_color = bgclr;
				    }

				    ConsoleSetColors(cur_fg_color, cur_bg_color, cur_bright_color);
				}
				else {
				}

				_vt100_inescape2 = false;
			}
			return;
		}
		else if (_vt100_inescape) {
			if (chr == '[') {
				_vt100_inescape2 = true;
				_vt100_inescape = false;
				return;
			}
			_vt100_inescape = false;
		}

		if (chr == 13) {
			//ConsoleSetRelative(0,1);
			//ConsoleSetHome();
			_putChar(chr);
		}
		else if (chr == 27 && _vt100_emulation) {
			_vt100_curparam = 0;
			_vt100_inescape = true;
			_vt100_params[0] = 0;
			_vt100_params[1] = 0;
			_vt100_params[2] = 0;
			_vt100_paramFilled = 0;
		}
		else if (chr == 10) {
			//ConsoleSetRelative(0,1);
			//ConsoleSetHome();
			_putChar(chr);
		}
		else {
			_putChar(chr);
		}
	}

	void lock() {
		_lock.lock();
	}

	void unlock() {
		if (_lock is null) {
			_lock = new Mutex(); // _lock is initially unlocked
		}
		else {
			_lock.unlock();
		}
	}

private:

	uint cur_fg_color = fgColor.White;
	uint cur_bg_color = bgColor.Black;
	uint cur_bright_color = 0;

	bool _vt100_emulation = false;
	bool _vt100_inescape = false;
	bool _vt100_inescape2 = false;

	uint _vt100_saved_x = 0;
	uint _vt100_saved_y = 0;

	int _vt100_params[5] = [0];
	int _vt100_curparam = 0;
	int _vt100_paramFilled = 0;

	bool _caretVisible = true;

	Mutex _lock;

	Rect[] _clippingRegions;
	Rect[][] _clippingStack;
	
	void _position(uint x, uint y) {
		ConsoleSetPosition(x,y);
	}

	void _putv(Variadic vars) {
		_putString(new String(toStrv(vars)));
	}

	void _putChar(dchar chr) {
		ConsolePutChar(chr);
	}

	void _putInt(uint value) {
		dstring foo = "";
		do {
			foo = cast(dchar)((value % 10) + '0') ~ foo;
		} while(value /= 10);
		ConsolePutString(foo);
	}

	void _putString(String str) {
		uint x;
		uint y;
		uint r;
		uint b;

		ConsoleGetPosition(&x,&y);

		r = x + str.length;
		b = y + 1;

		// Quick out... no clipping region, just draw the string
		if (_clippingRegions.length == 0) {
			ConsolePutString(str.toUtf32());
			return;
		}

		// This will contain lengths of substrings
		// It will alternate, IN OUT IN OUT IN OUT etc
		// Where OUT means it is not drawn, and IN is

		// We start with everything drawn
		uint[] formatArray = [str.length, 0];

		foreach(region; _clippingRegions) {
			if (x < region.right && r > region.left && y < region.bottom && b > region.top) {
				// This string clips this clipping rectangle
				// Grab the substring within the clipping region

				int str_start = 0;

				if (x < region.left) {
					str_start = region.left - x;
				}

				int str_end;
				str_end = region.right - x;

				if (str_end > str.length) {
					str_end = str.length;
				}

				uint str_length = str_end - str_start;

				if (str_length == 0) {
					continue;
				}

				// We must now go through the format array
				// Remember, the array is like this: [IN, OUT, IN, OUT, ... ]
				// where IN means it will be drawn, and OUT means it will not.

				// So, we merely need to loop through the array and find an IN
				// section that can be updated with respect to this clipped
				// section, which is represented by str_start to str_end.

				// This string (str_start..str_end) represents a section of the
				// output that will be clipped.

				// The loop here will update the format array.

				// It first tries to find the first part of the array to mutate,
				// and then it cascades the effect of the update.

				int pos = 0;

				// Difference is the amount to remove from OUT sections
				int difference = 0;
				int newValue;
				size_t i;

				// Search loop
				for(i = 0; i < formatArray.length; i++) {
					if (pos + formatArray[i] > str_start) {
						if (i % 2 == 0) { // IN
							// Since this is an IN section, and it clips our region
							// it needs to have a lower value.

							// This value should be the difference between the start
							// of the clipped string and the position in the string
							// that this array element reflects.
							newValue = str_start - pos;

							// The newValue is lower, so the difference is the amount
							// to add to the next OUT section to even out the array.
							difference = formatArray[i] - newValue;

							// Look to see if the entire clipped region is within
							// this IN section:
							if (pos + formatArray[i] > str_length) {
								// This means we will have an IN section left over!
								uint in_0 = newValue;
								uint out_0 = str_end - pos;
								uint in_1 = formatArray[i] - in_0 - out_0;
								formatArray = formatArray[0..i] ~ [in_0, out_0, in_1] ~ formatArray[i+1..$];
							}
							else {
								// The IN section can simply spill into an OUT section

								i++;
								if (i < formatArray.length) {
									formatArray[i] += formatArray[i-1] - newValue;
								}
								else {
									formatArray ~= [formatArray[i-1] - newValue];
								}

								formatArray[i-1] = newValue;
							}

							difference = 0;

							// We are done
							break;
						}
						else { // OUT
							// Since this is an OUT section, and it clips our region
							// may need to have a bigger value.

							// The newValue will be the rest of the string.
							newValue = str_end - pos;
							if (newValue > formatArray[i]) {
								// The difference will simply be the amount of characters
								// that will be clipped that were not reflected in this OUT
								// entry. They will have to be removed from other array
								// elements in the update loop.
								difference = newValue - formatArray[i];
								formatArray[i] = newValue;
								i++;
							}
							else {
								difference = 0;
							}
							break;
						}
					}
					pos += formatArray[i];
				}

				// Update loop, will be starting on an IN section
				for (; i < formatArray.length && difference > 0; i++) {
					// Must get difference to zero
					if (formatArray[i] < difference) {
						difference -= formatArray[i];
						formatArray[i] = 0;
					}
					else {
						formatArray[i] -= difference;
						difference = 0;
					}
				}
			}
		}

		bool isOut = true;
		uint pos = 0;

		for (uint i; i < formatArray.length; i++, isOut = !isOut) {
			if (isOut) {
				ConsolePutString(str.subString(pos, formatArray[i]).toUtf32());
			}
			else {
				ConsoleSetRelative(formatArray[i], 0);
			}
			pos += formatArray[i];
		}
	}
}

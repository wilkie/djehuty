module io.console;

import scaffold.console;

import synch.mutex;

import djehuty;

import binding.c;

// Section: Enums

// Description: This enum gives possible events that can be triggered by the Console.
enum ConsoleEvent : uint {
	// Description: Fired when Ctrl+C is signaled.
	CtrlC,

	// Description: Fired when Ctrl+Break is signaled.
	CtrlBreak,
}

// Section: Core

// Description: This class abstracts simple console operations.
class Console {
static:

	//Description: Sets the foreground color for the console.
	//fgclr: The foreground color to set.
	void forecolor(Color clr) {
		lock();
		scope(exit) unlock();

		_fgcolor = clr;
		ConsoleSetColors(_fgcolor, _bgcolor);
	}

	Color forecolor() {
		return _fgcolor;
	}

	void backcolor(Color clr) {
		lock();
		scope(exit) unlock();

		_bgcolor = clr;
	    ConsoleSetColors(_fgcolor, _bgcolor);
	}

	Color backcolor() {
		return _bgcolor;
	}	

	// Description: Clears the console screen.
	void clear() {
		lock();
		scope(exit) unlock();

		ConsoleClear();
	}

	void position(Coord coord) {
		lock();
		scope(exit) unlock();

		_position(coord.x, coord.y);
	}

	void position(uint[] coord) {
		lock();
		scope(exit) unlock();

		_position(coord[0], coord[1]);
	}

	void position(uint x, uint y) {
		lock();
		scope(exit) unlock();

		_position(x,y);
	}

	Coord position() {
		lock();
		scope(exit) unlock();

		Coord ret;
		ConsoleGetPosition(cast(uint*)&ret.x,cast(uint*)&ret.y);
		return ret;
	}

	// Description: Moves the position of the caret relative to its current location.
	// x: The number of columns for the caret to move.  Negative values move down.
	// y: The number of rows for the caret.  Negative values move up.
	void setRelative(int x, int y) {
		lock();
		scope(exit) unlock();

		ConsoleSetRelative(x,y);
	}

	// Description: Will show the caret.
	void showCaret() {
		lock();
		scope(exit) unlock();

		if (!_caretVisible) {
			ConsoleShowCaret();
			_caretVisible = true;
		}
	}

	// Description: Will hide the caret.
	void hideCaret() {
		lock();
		scope(exit) unlock();

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
		lock();
		scope(exit) unlock();

		_clippingStack ~= _clippingRegions;
	}

	// Description: This function will restore a former clipping context.
	void clipRestore() {
		lock();
		scope(exit) unlock();

		if (_clippingStack.length > 0) {
			_clippingRegions = _clippingStack[$-1];
			_clippingStack.length = _clippingStack.length - 1;
		}
	}

	// Description: This function will clear the clipping context.
	void clipClear() {
		lock();
		scope(exit) unlock();

		_clippingRegions = null;
	}

	// Description: This function will add a rectangular region defined as screen coordinates that will clip the drawing surface. When a clipping context is not clear, only regions within rectangles will be drawn to the screen.
	// region: The rectangular region to add as a clipping region.
	void clipRect(Rect region) {
		lock();
		scope(exit) unlock();

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
		lock();
		scope(exit) unlock();

		_putv(vars);
	}

	void putlnv(Variadic vars) {
		lock();
		scope(exit) unlock();

		_putv(vars);
		_putChar('\n');
	}

	void putStringAt(uint x, uint y, string str) {
		lock();
		scope(exit) unlock();

		_position(x,y);
		_putstring(str);
	}

	void putString(string str) {
		lock();
		scope(exit) unlock();

		_putstring(str);
	}

	void putAt(uint x, uint y, ...) {
		Variadic vars = new Variadic(_arguments, _argptr);

		putAtv(x, y, vars);
	}

	void putAtv(uint x, uint y, Variadic vars) {
		lock();
		scope(exit) unlock();

		_position(x, y);
		_putv(vars);
	}

	// Description: Will print out this character to the screen and the current location.
	// chr: The UTF-32 character to print.
	void putChar(dchar chr) {
		lock();
		scope(exit) unlock();

		_putChar(chr);
	}

	void lock() {
		if (_lock is null) {
			_lock = new Mutex();
		}
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

	Color _fgcolor = Color.White;
	Color _bgcolor = Color.Black;

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
		_putstring(toStrv(vars));
	}

	void _putChar(dchar chr) {
		ConsolePutChar(chr);
	}

	void _putInt(uint value) {
		string foo = "";
		do {
			foo = cast(char)((value % 10) + '0') ~ foo;
		} while(value /= 10);
		ConsolePutString(foo);
	}

	void _putstring(string str) {
		uint x;
		uint y;
		uint r;
		uint b;

		ConsoleGetPosition(&x,&y);

		r = x + str.length;
		b = y + 1;

		// Quick out... no clipping region, just draw the string
		if (_clippingRegions.length == 0) {
			ConsolePutString(str);
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
				ConsolePutString(str.substring(pos, formatArray[i]));
			}
			else {
				ConsoleSetRelative(formatArray[i], 0);
			}
			pos += formatArray[i];
		}
	}
}

alias Console.put put;
alias Console.putln putln;

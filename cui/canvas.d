import djehuty;

import scaffold.console;

class CuiCanvas {
private:

	// The clipping region stack
	Rect[] _clippingRegions;
	Rect[][] _clippingStack;

	// The current colors
	Color _fgcolor = Color.Gray;
	Color _bgcolor = Color.Black;

	// The logical top-left coordinate
	Coord _topleft;
	Coord[] _topleftStack;

	// This is a crazy function that will print to the screen but
	// only within the clipping region.
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

	// Just a helper function to set the position of the caret
	void _position(uint x, uint y) {
		ConsoleSetPosition(x,y);
	}

public:

	this() {
	}

	uint width() {
		uint consolewidth, consoleheight;
		ConsoleGetSize(consolewidth, consoleheight);
		return consolewidth - _topleft.x;
	}

	uint height() {
		uint consolewidth, consoleheight;
		ConsoleGetSize(consolewidth, consoleheight);
		return consoleheight - _topleft.y;
	}

	// Context functions

	void contextPush(int x, int y) {
		Coord coord = {x, y};
		contextPush(coord);
	}

	void contextPush(int[] coord) {
		Coord c = {coord[0], coord[1]};
		contextPush(c);
	}

	void contextPush(Coord coord) {
		coord.x += _topleft.x;
		coord.y += _topleft.y;
		_topleftStack ~= coord;
		_topleft = coord;
	}

	void contextPop() {
		_topleftStack = _topleftStack[0..$-1];
		if (_topleftStack.length > 0) {
			_topleft = _topleftStack[$-1];
		}
		else {
			_topleft.x = 0;
			_topleft.y = 0;
		}
	}

	void contextClear() {
		_topleftStack = null;
	}

	// Clipping functions

	// Description: This function will save the current clipping context.
	void clipSave() {
		synchronized(this) {
			_clippingStack ~= _clippingRegions;
		}
	}

	// Description: This function will restore a former clipping context.
	void clipRestore() {
		synchronized(this) {
			if (_clippingStack.length > 0) {
				_clippingRegions = _clippingStack[$-1];
				_clippingStack.length = _clippingStack.length - 1;
			}
		}
	}

	// Description: This function will clear the clipping context.
	void clipClear() {
		synchronized(this) {
			_clippingRegions = null;
		}
	}

	// Description: This function will add a rectangular region defined as screen coordinates that will clip the drawing surface. When a clipping context is not clear, only regions within rectangles will be drawn to the screen.
	// region: The rectangular region to add as a clipping region.
	void clipRect(Rect region) {
		synchronized(this) {
			region.left += _topleft.x;
			region.right += _topleft.x;
			region.top += _topleft.y;
			region.bottom += _topleft.y;
			_clippingRegions ~= region;
		}
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

	// Drawing functions

	void write(...) {
		Variadic vars = new Variadic(_arguments, _argptr);
		writev(vars);
	}

	void writev(Variadic vars) {
		synchronized(this) {
			_putstring(toStrv(vars));
		}
	}

	// Positioning functions

	void position(Coord coord) {
		synchronized(this) {
			_position(coord.x + _topleft.x, coord.y + _topleft.y);
		}
	}

	void position(int[] coord) {
		synchronized(this) {
			_position(coord[0] + _topleft.x, coord[1] + _topleft.y);
		}
	}

	void position(int x, int y) {
		synchronized(this) {
			_position(x + _topleft.x,y + _topleft.y);
		}
	}

	Coord position() {
		synchronized(this) {
			Coord ret;
			ConsoleGetPosition(cast(uint*)&ret.x, cast(uint*)&ret.y);
			ret.x -= _topleft.x;
			ret.y -= _topleft.y;
			return ret;
		}
	}

	// Color functions

	void forecolor(Color clr) {
		synchronized(this) {
			_fgcolor = clr;
			ConsoleSetColors(_fgcolor, _bgcolor);
		}
	}

	Color forecolor() {
		return _fgcolor;
	}

	void backcolor(Color clr) {
		synchronized(this) {
			_bgcolor = clr;
			ConsoleSetColors(_fgcolor, _bgcolor);
		}
	}

	Color backcolor() {
		return _bgcolor;
	}
}

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

	int _xposition;
	int _yposition;

	// This is a crazy function that will print to the screen but
	// only within the clipping region.
	void _putstring(string str) {
		int x;
		int y;
		int r;
		int b;

		uint cw, ch;
		ConsoleGetSize(cw, ch);

		if (_yposition < 0 || _yposition >= ch) {
			return;
		}

		if (_xposition >= cast(int)cw) {
			return;
		}

		if (_xposition + str.utflen() > cast(int)cw) {
			str = str.substring(0, cast(int)cw - _xposition);
		}

		if (_xposition < 0) {
			if (_xposition < -str.utflen()) {
				_xposition += str.utflen();
				return;
			}
			int newpos = -_xposition;
			_xposition = 0;
			ConsoleSetPosition(0, _yposition);
			_putstring(str.substring(newpos));
			return;
		}

		x = _xposition;
		y = _yposition;

		r = x + str.utflen();
		b = y + 1;

		_xposition = r;

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

			int regionleft = cast(int)region.left;
			int regionright = cast(int)region.right;
			int regionbottom = cast(int)region.bottom;
			int regiontop = cast(int)region.top;

			if (x < regionright && r > regionleft && y < regionbottom && b > region.top) {
				// This string clips this clipping rectangle
				// Grab the substring within the clipping region

				int str_start = 0;

				if (x < regionleft) {
					str_start = regionleft - x;
				}

				int str_end;
				str_end = regionright - x;

				if (str_end > str.utflen()) {
					str_end = str.utflen();
				}

				uint str_length = str_end - str_start;

				if (str_length <= 0) {
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

				uint regionSize;
				int pos = 0;

				size_t i;

				// Search loop
				for(i = 0; i < formatArray.length; i++) {
					if (pos + formatArray[i] > str_start) {
						if (i % 2 == 0) { // IN
							// subtract from this IN section
							uint newValue = str_start - pos;

							// A special case... the IN is being subdivided
							if (str_end < pos + formatArray[i]) {
								uint difference = (pos + formatArray[i]) - str_end;
								formatArray = formatArray[0..i] ~ [newValue] ~ [str_length] ~ [difference] ~ formatArray[i+1..$];
							}
							else {
								// Move stuff we took out of this IN to the OUT region next to it
								if ((i + 1) < formatArray.length) {
									formatArray[i+1] += formatArray[i] - newValue;
								}

								// Truncate the IN region
								formatArray[i] = newValue;
							}

							// Move to the OUT region
							i++;

							regionSize = str_length;
						}
						else { // OUT

							// We will try to expand this region to hold str_length... we
							// also need to hold what is already there to the left of the str_start
							regionSize = str_end - pos;
						}

						// We have finished the loop
						break;
					}
					pos += formatArray[i];
				}

				if (i == formatArray.length) {
					formatArray ~= [regionSize];
				}

				// Grow the OUT section at i
				// until it accommodates str_length
				while(formatArray[i] < regionSize) {
					// Take from the IN region next to it
					uint left = regionSize - formatArray[i];

					if (formatArray[i+1] <= left) {
						// OK! This IN section more than makes up for what is left
						// Remove the IN section by adding the next OUT section to this
						if ((i+2) < formatArray.length) {
							formatArray[i] += formatArray[i+1] + formatArray[i+2];
							formatArray = formatArray[0..i+1] ~ formatArray[i+3..$];
						}
						else {
							formatArray[i] += formatArray[i+1];
							formatArray = formatArray[0..i+1];
						}
					}
					else {
						// We need to split up some of the IN section, which can fit
						// the entire region that is left
						formatArray[i+1] -= left;
						formatArray[i] += left;
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
	void _position(int x, int y) {
		_xposition = x;
		_yposition = y;
		if (x >= 0 || y >= 0) {
			ConsoleSetPosition(x, y);
		}
	}

public:

	this() {
		_position(0,0);
	}

	uint width() {
		uint consolewidth, consoleheight;
		ConsoleGetSize(consolewidth, consoleheight);
		return consolewidth - cast(int)_topleft.x;
	}

	uint height() {
		uint consolewidth, consoleheight;
		ConsoleGetSize(consolewidth, consoleheight);
		return consoleheight - cast(int)_topleft.y;
	}

	// Context functions

	void contextPush(int x, int y) {
		Coord coord;
		coord.x = x;
		coord.y = y;
		contextPush(coord);
	}

	void contextPush(int[] coord) {
		Coord c;
		c.x = coord[0];
		c.y = coord[1];
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
				_clippingStack = _clippingStack[0..$-1];
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
			_position(cast(int)(coord.x + _topleft.x), cast(int)(coord.y + _topleft.y));
		}
	}

	void position(int[] coord) {
		synchronized(this) {
			_position(coord[0] + cast(int)_topleft.x, coord[1] + cast(int)_topleft.y);
		}
	}

	void position(int x, int y) {
		synchronized(this) {
			_position(x + cast(int)_topleft.x,y + cast(int)_topleft.y);
		}
	}

	Coord position() {
		synchronized(this) {
			Coord ret;
			//ConsoleGetPosition(cast(uint*)&ret.x, cast(uint*)&ret.y);
			ret.x = _xposition;
			ret.y = _yposition;
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

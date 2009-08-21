module tui.vt100;

import io.console;

import tui.buffer;

// Section: Console

// Description: This console control is a console buffer that emulations VT100 terminal codes.
class TuiVT100 : TuiBuffer {

	// Constructors

	this( uint x, uint y, uint width, uint height) {
		super(x,y,width,height);
	}

	alias TuiBuffer.writeChar writeChar;

	override void writeChar(dchar chr) {
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
						_screenfeed();
					}
					else {
					}
				}
				else if (chr == 's') {
					// save position
					_vt100_saved_x = _curx-this.left;
					_vt100_saved_y = _cury-this.top;
				}
				else if (chr == 'u') {
					// restore position
					position(_vt100_saved_x,_vt100_saved_y);
				}
				else if (chr == 'A') {
					if (_vt100_params[0] == 0) {
						_vt100_params[0] = 1;
					}
					setRelative(0, -_vt100_params[0]);
				}
				else if (chr == 'B') {
					if (_vt100_params[0] == 0) {
						_vt100_params[0] = 1;
					}
					setRelative(0, _vt100_params[0]);
				}
				else if (chr == 'C') {
					if (_vt100_params[0] == 0) {
						_vt100_params[0] = 1;
					}
					setRelative(_vt100_params[0], 0);
				}
				else if (chr == 'D') {
					if (_vt100_params[0] == 0) {
						_vt100_params[0] = 1;
					}
					setRelative(-_vt100_params[0], 0);
				}
				else if (chr == 'H' || chr == 'f') {
					// set cursor position
					if (_vt100_params[1] == 0) {
						_vt100_params[1] = 1;
					}
					if (_vt100_params[0] == 0) {
						_vt100_params[0] = 1;
					}

					position(_vt100_params[1]-1, _vt100_params[0]-1);
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
					    _cur_bright_color = bright;
					}

					if (fgclr != -1) {
						_cur_fg_color = fgclr;
					}

					if (bgclr != -1) {
						_cur_bg_color = bgclr;
				    }

				    _cur_fg_color = _cur_fg_color % 8;
				    _cur_fg_color += (8 * _cur_bright_color);

				    _curfg = cast(fgColor)_cur_fg_color;
				    _curbg = cast(bgColor)_cur_bg_color;

				    setColor(_curfg, _curbg);
				}
				else {
					//Console.putln("!!!!!", chr , "!!!!!");
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

		if (chr == 27) {
			_vt100_curparam = 0;
			_vt100_inescape = true;
			_vt100_params[0] = 0;
			_vt100_params[1] = 0;
			_vt100_params[2] = 0;
			_vt100_paramFilled = 0;
		}
		else {
			//Console.position(0, this.bottom+2);
			//Console.setColor(fgColor.White);
			//Console.put(_curx, ", ", _cury, " : ", _buffer.length());
			super.writeChar(chr);
		}
	}

private:

	static bool _vt100_inescape = false;
	static bool _vt100_inescape2 = false;

	static uint _vt100_saved_x = 0;
	static uint _vt100_saved_y = 0;

	static int _vt100_params[5] = [0];
	static int _vt100_curparam = 0;
	static int _vt100_paramFilled = 0;

	static uint _cur_fg_color = fgColor.White;
	static uint _cur_bg_color = bgColor.Black;
	static uint _cur_bright_color = 0;
}

module io.console;

import scaffold.console;

import core.string;
import core.format;
import core.unicode;

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

	//Description: Sets the foreground color for the console.
	//fgclr: The foreground color to set.
	static void setColor(fgColor fclr) {
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
	static void setColor(fgColor fclr, bgColor bclr) {
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

	//Description: Sets the foreground and background colors for the console.
	//bgclr: The background color to set.
	//fgclr: The foreground color to set.
	static void setColor(bgColor bclr, fgColor fclr) {
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
	static void setColor(bgColor bclr) {
	    cur_bg_color = bclr;

	    ConsoleSetColors(cur_fg_color, cur_bg_color, cur_bright_color);
	}

	// Description: Clears the console screen.
	static void clear() {
		ConsoleClear();
	}

	// Description: Sets the position of the caret to the point (x,y).
	// x: The column for the caret.
	// y: The row for the caret.
	static void setPosition(uint x, uint y) {
		ConsoleSetPosition(x,y);
	}


	// Description: Moves the position of the caret relative to its current location.
	// x: The number of columns for the caret to move.  Negative values move down.
	// y: The number of rows for the caret.  Negative values move up.
	static void setRelative(int x, int y) {
		ConsoleSetRelative(x,y);
	}

	// Description: Will show the caret.
	static void showCaret() {
		ConsoleShowCaret();
	}

	// Description: Will hide the caret.
	static void hideCaret() {
		ConsoleHideCaret();
	}

	// Description: Will return the height
	static uint height() {
		uint width;
		uint height;

		ConsoleGetSize(width, height);

		return height;
	}

	// Description: Will return the width
	static uint width() {
		uint width;
		uint height;

		ConsoleGetSize(width, height);

		return width;
	}

	// Description: Will wait for input and return the key pressed and also the translated Unicode UTF-32 character that this keypress represents, if applicable.
	// chr: Will be set to the UTF-32 character.
	// code: Will be set to the character code for the key pressed.
	static void getChar(out dchar chr, out uint code) {
		ConsoleGetChar(chr, code);
	}

	static void putln(...) {
		synchronized {
			String toParse;

			for(int curArg = 0; curArg < _arguments.length; curArg++) {
				if (_arguments[curArg] is typeid(String)) {
					toParse = va_arg!(String)(_argptr);
				}
				else if (_arguments[curArg] is typeid(long)) {
					ulong argval = cast(ulong)va_arg!(long)(_argptr);
					toParse = new String(argval);
				}
				else if (_arguments[curArg] is typeid(ulong)) {
					ulong argval = va_arg!(ulong)(_argptr);
					toParse = new String(argval);
				}
				else if (_arguments[curArg] is typeid(int)) {
					int argval = cast(int)va_arg!(int)(_argptr);
					toParse = new String(argval);
				}
				else if (_arguments[curArg] is typeid(uint)) {
					uint argval = cast(uint)va_arg!(uint)(_argptr);
					toParse = new String(argval);
				}
				else if (_arguments[curArg] is typeid(short)) {
					short argval = cast(short)va_arg!(short)(_argptr);
					toParse = new String(argval);
				}
				else if (_arguments[curArg] is typeid(ushort)) {
					ushort argval = cast(ushort)va_arg!(ushort)(_argptr);
					toParse = new String(argval);
				}
				else if (_arguments[curArg] is typeid(byte)) {
					byte argval = cast(byte)va_arg!(byte)(_argptr);
					toParse = new String(argval);
				}
				else if (_arguments[curArg] is typeid(ubyte)) {
					ubyte argval = cast(ubyte)va_arg!(ubyte)(_argptr);
					toParse = new String(argval);
				}
				else if (_arguments[curArg] is typeid(char[])) {
					char[] chrs = va_arg!(char[])(_argptr);
					toParse = new String(chrs);
				}
				else if (_arguments[curArg] is typeid(wchar[])) {
					wchar[] chrs = va_arg!(wchar[])(_argptr);
					toParse = new String(Unicode.toUtf8(chrs));
				}
				else if (_arguments[curArg] is typeid(dchar[])) {
					dchar[] chrs = va_arg!(dchar[])(_argptr);
					toParse = new String(Unicode.toUtf8(chrs));
				}
				else if (_arguments[curArg] is typeid(dchar)) {
					dchar chr = va_arg!(dchar)(_argptr);
					toParse = new String("");
					toParse.appendChar(chr);
				}
				else if (_arguments[curArg] is typeid(wchar)) {
					dchar chr = cast(dchar)va_arg!(wchar)(_argptr);
					toParse = new String("");
					toParse.appendChar(chr);
				}
				else if (_arguments[curArg] is typeid(char)) {
					dchar chr = cast(dchar)va_arg!(char)(_argptr);
					toParse = new String("");
					toParse.appendChar(chr);
				}
				else {
					Object obj = va_arg!(Object)(_argptr);
					toParse = new String(obj.toString());
				}

				if (toParse !is null) {
					ConsolePutString(toParse.toUtf32());
				}
			}

			putChar('\n');
		}
	}

	static void put(...) {
        synchronized {
			String toParse;

			for(int curArg = 0; curArg < _arguments.length; curArg++) {
				if (_arguments[curArg] is typeid(String)) {
					toParse = va_arg!(String)(_argptr);
				}
				else if (_arguments[curArg] is typeid(long)) {
					ulong argval = cast(ulong)va_arg!(long)(_argptr);
					toParse = new String(argval);
				}
				else if (_arguments[curArg] is typeid(ulong)) {
					ulong argval = va_arg!(ulong)(_argptr);
					toParse = new String(argval);
				}
				else if (_arguments[curArg] is typeid(int)) {
					int argval = cast(int)va_arg!(int)(_argptr);
					toParse = new String(argval);
				}
				else if (_arguments[curArg] is typeid(uint)) {
					uint argval = cast(uint)va_arg!(uint)(_argptr);
					toParse = new String(argval);
				}
				else if (_arguments[curArg] is typeid(short)) {
					short argval = cast(short)va_arg!(short)(_argptr);
					toParse = new String(argval);
				}
				else if (_arguments[curArg] is typeid(ushort)) {
					ushort argval = cast(ushort)va_arg!(ushort)(_argptr);
					toParse = new String(argval);
				}
				else if (_arguments[curArg] is typeid(byte)) {
					byte argval = cast(byte)va_arg!(byte)(_argptr);
					toParse = new String(argval);
				}
				else if (_arguments[curArg] is typeid(ubyte)) {
					ubyte argval = cast(ubyte)va_arg!(ubyte)(_argptr);
					toParse = new String(argval);
				}
				else if (_arguments[curArg] is typeid(char[])) {
					char[] chrs = va_arg!(char[])(_argptr);
					toParse = new String(chrs);
				}
				else if (_arguments[curArg] is typeid(wchar[])) {
					wchar[] chrs = va_arg!(wchar[])(_argptr);
					toParse = new String(Unicode.toUtf8(chrs));
				}
				else if (_arguments[curArg] is typeid(dchar[])) {
					dchar[] chrs = va_arg!(dchar[])(_argptr);
					toParse = new String(Unicode.toUtf8(chrs));
				}
				else if (_arguments[curArg] is typeid(dchar)) {
					dchar chr = va_arg!(dchar)(_argptr);
					toParse = new String("");
					toParse.appendChar(chr);
				}
				else if (_arguments[curArg] is typeid(wchar)) {
					dchar chr = cast(dchar)va_arg!(wchar)(_argptr);
					toParse = new String("");
					toParse.appendChar(chr);
				}
				else if (_arguments[curArg] is typeid(char)) {
					dchar chr = cast(dchar)va_arg!(char)(_argptr);
					toParse = new String("");
					toParse.appendChar(chr);
				}
				else {
					Object obj = va_arg!(Object)(_argptr);
					toParse = new String(obj.toString());
				}

				if (toParse !is null) {
					ConsolePutString(toParse.toUtf32());
				}
			}
		}
	}

	// Description: Will print out this character to the screen and the current location.
	// chr: The UTF-32 character to print.
	static void putChar(dchar chr) {
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
					ConsoleSavePosition();
				}
				else if (chr == 'u') {
					// restore position
					ConsoleRestorePosition();
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
			ConsoleSetRelative(0,1);
			ConsoleSetHome();
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
			ConsoleSetRelative(0,1);
			ConsoleSetHome();
		}
		else {
			ConsolePutChar(chr);
		}
	}


private:

	static uint cur_fg_color = fgColor.White;
	static uint cur_bg_color = bgColor.Black;
	static uint cur_bright_color = 0;

	static bool _vt100_emulation = false;
	static bool _vt100_inescape = false;
	static bool _vt100_inescape2 = false;

	static uint _vt100_saved_x = 0;
	static uint _vt100_saved_y = 0;

	static int _vt100_params[5] = [0];
	static int _vt100_curparam = 0;
	static int _vt100_paramFilled = 0;
}

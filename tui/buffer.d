module tui.buffer;

import platform.imports;
mixin(PlatformGenericImport!("console"));

import core.string;
import core.main;
import core.definitions;

import synch.semaphore;

import console.main;

import tui.core;

import utils.arraylist;

// Section: Console

// Description: This console control is a line buffer that is similar to having a terminal inside a terminal.  It is basically a terminal window.  Extending this class will allow for other types of terminals and emulations.  For instance, the VT100 control is a buffer control with VT100 ANSI emulation.
class TuiBuffer : TuiWidget
{
	this( uint x, uint y, uint width, uint height)
	{
		_drawLock = new Semaphore(1);

		_x = x;
		_y = y;
		_r = _x + width;
		_b = _y + height;
		_w = width;
		_h = height;

		_buffer = new ArrayList!(BufferLine)();

		for (uint i; i<_h; i++)
		{
			BufferLine bf = new BufferLine;
			bf.line = new emptyChar[width];
			bf.bgclr = new bgColor[width];
			bf.fgclr = new fgColor[width];
			_buffer.addItem(bf);
		}

		setPosition(0,0);
	}

	override void OnKeyChar(dchar chr)
	{
		static char lastchr;

		if (chr == 10)
		{
			if (lastchr != 13)
			{
				chr = 13;
			}
		}

		if (chr == 8)
		{
			if (_curx != _x)
			{
				setPosition((_curx-_x)-1, (_cury-_y));
				writeChar(' ');
				setPosition((_curx-_x)-1, (_cury-_y));
			}
			else
			{
				setPosition(_w-1, (_cury-_y)-1);
				writeChar(' ');
				setPosition(_w-1, (_cury-_y)-1);
			}
		}
		else if (chr == 13)
		{
			if (_cury + 1 == _b)
			{
				_linefeed();
				setPosition(0, (_cury-_y));
			}
			else
			{
				setPosition(0, (_cury-_y)+1);
			}
		}
		else
		{
			writeChar(chr);
		}

		lastchr = chr;
	}

	override void OnAdd()
	{
	}

	override void OnInit()
	{
		redraw();
	}

	override void OnMouseWheelY(int amt)
	{
		// + amt : subtract from _firstVisible
		// - amt : add to _firstVisible

		amt *= 5;

		uint _oldFV = _firstVisible;

		if (amt > 0 && amt > _firstVisible)
		{
			_firstVisible = 0;
		}
		else
		{
			_firstVisible -= amt;
		}

		if (_firstVisible > _buffer.length() - _h)
		{
			_firstVisible = _buffer.length() - _h;
		}

		if (_oldFV != _firstVisible)
		{
			redraw();
		}
	}

	void redraw()
	{
		_drawLock.down();

		Console.setPosition(0,30);
		Console.put("a ", _curx, " ", _cury);

		// Blank out the space of the buffer
		uint curx = 0;
		uint cury = _firstVisible;

		fgColor fgclr;
		bgColor bgclr;

		fgclr = _buffer[cury].fgclr[0];
		bgclr = _buffer[cury].bgclr[0];

		Console.setColor(fgclr, bgclr);

		BufferLine bf;

		for (uint y = _y; y < _b; y++, cury++)
		{

		Console.setPosition(0,30);
		Console.put("y ", _curx, " ", _cury);
			Console.setPosition(_x, y);

			bf = _buffer[cury];

			curx = 0;
			for (curx = 0; curx < _w; curx++)
			{
				if (bf.fgclr[curx] != fgclr || bf.bgclr[curx] != bgclr)
				{
					Console.setColor(bf.fgclr[curx], bf.bgclr[curx]);
					fgclr = bf.fgclr[curx];
					bgclr = bf.bgclr[curx];
				}
				Console.putChar(bf.line[curx]);
			}
		}

		_drawLock.up();
	}

	// Methods

	void setColor(fgColor fgclr, bgColor bgclr)
	{
		_drawLock.down();

		_curfg = fgclr;
		_curbg = bgclr;

		_drawLock.up();
	}

	void writeChar(dchar chr)
	{
		static int a = 0;
		Console.setPosition((a * 10),29);
		Console.put(_curx, " ", _cury);

		if (_cury >= _b)
		{
			_linefeed();

		Console.setPosition((a * 10),29);
			Console.put("lf: ", _curx, " ", _cury);
		}
		a++;
		a %= 3;

		_drawLock.down();

		Console.setPosition(_curx, _cury);
		Console.setColor(_curfg, _curbg);

		Console.putChar(chr);

		uint idx_y = (_cury-_y)+_firstVisible;
		uint idx_x = (_curx-_x);


		_buffer[idx_y].line[idx_x] = cast(emptyChar)chr;
		_buffer[idx_y].bgclr[idx_x] = _curbg;
		_buffer[idx_y].fgclr[idx_x] = _curfg;

		_curx++;

		_drawLock.up();

		if (_curx == _r)
		{

		Console.setPosition((a * 10),29);
			Console.put("lf: ", _curx, " ", _cury);
			_linefeed();

		Console.setPosition((a * 10),29);
			Console.put("af: ", _curx, " ", _cury);
		}
	}

	void writeChar(uint x, uint y, dchar chr)
	{
		_drawLock.down();

		_buffer[y].line[x] = cast(emptyChar)chr;
		_buffer[y].bgclr[x] = _curbg;
		_buffer[y].fgclr[x] = _curfg;

		Console.setPosition(x+_x, y+_y);
		Console.setColor(_curfg, _curbg);

		Console.putChar(chr);

		_drawLock.up();
	}

	void setPosition(uint x, uint y)
	{
		_drawLock.down();

		_curx = x + _x;
		_cury = y + _y;

		if (_curx >= _r)
		{
			_curx = _r-1;
		}

		if (_cury >= _b)
		{
			_cury = _b-1;
		}

		Console.setPosition(_curx, _cury);

		_drawLock.up();
	}

	void setRelative(int x, int y)
	{
		uint new_x = (_curx-_x) + x;
		uint new_y = (_cury-_y) + y;

		setPosition(new_x, new_y);
	}

	void getPosition(out uint x, out uint y)
	{
		x = _curx - _x;
		y = _cury - _y;
	}

protected:

	void _linefeed()
	{

		Console.setPosition((4 * 10),29);
			Console.put("af: ", _curx, " ", _cury);
		_drawLock.down();

		bool needRedraw = false;

		// met right edge; goto next line

		// linefeed
		_cury++;

		while (_cury >= _b)
		{
		Console.setPosition((4 * 10),29);
			Console.put("bf: ", _curx, " ", _cury);
			// we have reached the bottom
			// we have to move the first line
			// to the buffer

			BufferLine bl;

			for(uint i=0; i<_linesToScroll;i++)
			{
				bl = null;
				while (bl is null)
				{
					bl = new BufferLine();
				}
		Console.setPosition((4 * 10),29);
			Console.put("ef: ", _curx, " ", _cury);
				bl.fgclr = new fgColor[_w];
		Console.setPosition((4 * 10),29);
			Console.put("ff: ", _curx, " ", _cury);
				bl.bgclr = new bgColor[_w];
		Console.setPosition((4 * 10),29);
			Console.put("df: ", _curx, " ", _cury);
				bl.line = new emptyChar[_w];
		Console.setPosition((4 * 10),29);
			Console.put("gf: ", _curx, " ", _cury);
				_buffer.addItem(bl);
		Console.setPosition((4 * 10),29);
			Console.put("hf: ", _curx, " ", _cury);
			}
		Console.setPosition((4 * 10),29);
			Console.put("cf: ", _curx, " ", _cury);

			_firstVisible += _linesToScroll;

			// redraw the entire view
			needRedraw = true;

			// position ourselves at the new
			// line, which is just the previous
			// line again
			_cury -= _linesToScroll;
		}

		// carriage return
		_curx=_x;

		_drawLock.up();

		if (needRedraw) { redraw(); }
	}

	void _screenfeed()
	{
		_drawLock.down();

		// we have reached the bottom
		// we have to move the first line
		// to the buffer

		for(uint i=0; i<_h;i++)
		{
			BufferLine bl = new BufferLine();
			bl.line = new emptyChar[_w];
			bl.fgclr = new fgColor[_w];
			bl.bgclr = new bgColor[_w];
			_buffer.addItem(bl);
		}

		_firstVisible += _h;

		// go home
		_cury = _y;
		_curx = _x;

		_drawLock.up();

		redraw();
	}

	uint _x = 0;
	uint _y = 0;

	uint _r = 0;
	uint _b = 0;

	uint _w = 0;
	uint _h = 0;

	typedef dchar emptyChar = ' ';

	// keep a line buffer of previous lines, for scrollback, etc
	class BufferLine {
		emptyChar[] line = null;
		fgColor[] fgclr = null;
		bgColor[] bgclr = null;
	}
	ArrayList!(BufferLine) _buffer;
	uint _firstVisible;	// first line visible

	fgColor _curfg = fgColor.White;
	bgColor _curbg = bgColor.Black;

	uint _curx;
	uint _cury;

	uint _linesToScroll = 7;

	Semaphore _drawLock;
}

module tui.telnet;

import tui.vt100;
import tui.buffer;

import core.string;

import networking.telnet;

// Section: Console

// Description: This console control is a console buffer that will facilitate a connection to a telnet server within a section of your console view.
class TuiTelnet : TuiVT100
{
	this( uint x, uint y, uint width, uint height)
	{
		super(x,y,width,height);

		_telnet = new TelnetClient;
		_telnet.setDelegate(&_recvChar);
		_telnet.connect("ice9-tw.com", 2002);
	}

	override void OnKeyChar(dchar chr)
	{
		if (chr == 10)
		{
			chr = 13;
		}
		_telnet.putChar(chr);
	}

protected:

	TelnetClient _telnet;

	void _recvChar(dchar chr)
	{
			writeChar('a');
		if (true) { return; }
		if (chr == 13 || chr == 10)
		{
			super.OnKeyChar(chr);
		}
		else
		{
			writeChar(chr);
		}
	}
}
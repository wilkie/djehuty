module cui.telnet;

import cui.vt100;
import cui.buffer;

import core.string;

import networking.telnet;

// Section: Console

// Description: This console control is a console buffer that will facilitate a connection to a telnet server within a section of your console view.
class CuiTelnet : CuiVT100 {
	this( uint x, uint y, uint width, uint height) {
		super(x,y,width,height);

		_telnet = new TelnetClient;
		_telnet.setDelegate(&recvChar);
		_telnet.connect("ice9-tw.com", 2002);
	}

	override void onKeyChar(dchar chr) {
		if (chr == 10)
		{
			chr = 13;
		}
		_telnet.putChar(chr);
	}

protected:

	void recvChar(dchar chr) {
		return;
		/*if (chr == 13 || chr == 10) {
			super.onKeyChar(chr);
		}
		else {
			writeChar(chr);
		}*/
	}

private:

	TelnetClient _telnet;
}

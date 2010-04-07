/*
 * telnet.d
 *
 * This file implements the telnet standard.
 *
 * Author: Dave Wilkinson
 *
 */

module networking.telnet;

import core.string;
import core.unicode;
import core.definitions;

import io.socket;
import io.console;

import synch.thread;

private {
	const auto CODE_IAC = 255;		// Interpret as Command
	const auto CODE_SE	= 240;		// End of subnegotiation parameters.
	const auto CODE_NOP = 241;		// No operation.
	const auto CODE_DM  = 242;		// The data stream portion of a Synch.
									// This should always be accompanied
									// by a TCP Urgent notification.
	const auto CODE_BR	= 243;		// NVT character BRK.
	const auto CODE_IP	= 244;		// The function IP (Interrupt Process).
    const auto CODE_AO  = 245;		// The function AO (About Output).
	const auto CODE_AYT = 246;		// The function AYT (Are You There???).
	const auto CODE_EC  = 247;		// The function EC (Erase Character).
	const auto CODE_EL  = 248;		// The function EL (Erase Line).
	const auto CODE_GA  = 249;		// The GA signal (Go Ahead).
	const auto CODE_SB  = 250;		// Indicates that what follows is
									// subnegotiation of the indicated
									// option.


	// Option Code

	const auto CODE_WILL = 251;		// Indicates the desire to begin
									// performing, or confirmation that
									// you are now performing, the
									// indicated option.
	const auto CODE_WONT = 252;		// Indicates the refusal to perform,
									// or continue performing, the
									// indicated option.
    const auto CODE_DO   = 253;		// Indicates the request that the
									// other party perform, or
									// confirmation that you are expecting
									// the other party to perform, the
									// indicated option.
	const auto CODE_DONT = 254;		// Indicates the demand that the
									// other party stop performing,
									// or confirmation that you are no
									// longer expecting the other party
									// to perform, the indicated option.


	// Extended with RFC 857

	const auto CODE_ECHO = 1;				// send as an option code

	// Extended with RFC

	const auto CODE_SUPPRESS_GO_AHEAD = 3;	// send as an option code
}

// Section: Sockpuppets

// Description: This class provides a server interface to the Telnet protocol.
class TelnetServer {
	this() {
	}
}

// Description: This class provides a client interface to the Telnet protocol.
class TelnetClient {
public:

	// Description: This will create an instance of the object.  Use 'connect' to make a connection.
	this() {
		_skt = new Socket();
		_thread = new Thread();

		_thread.callback = &threadProc;
	}

	// Description: Connect to the telnet server at the host given.  The port is optional; by default it is 23.
	// host: The host to connect to.
	// port: The port to use to connect.  Default is 23.
	bool connect(string host, ushort port = 23) {
		_connected = _skt.connect(host,port);

		if (_connected) {
			_thread.start();
		}

		return _connected;
	}

	// Description: This function will send the byte to the server
	void sendByte(ubyte byteout) {
		if (_connected) {
			_skt.write(byteout);
		}
	}

	// Description: This function will send the UTF-32 character as a UTF-8 stream.
	// chr: The UTF-32 character to send.
	void putChar(dchar chr) {
		if (_connected) {
			dstring chrs = [ chr ];
			string chrarray = Unicode.toUtf8(chrs);

			_skt.write(cast(ubyte*)chrarray.ptr, chrarray.length);
		}
	}

	// Description: Will set the delegate for callback events from this sockpuppet.
	// callback: The delegate fitting the description.
	void setDelegate(void delegate(dchar) callback) {
		_charDelegate = callback;
	}

	void close() {
		_skt.close();
	}

protected:

	void sendCommandWord(ubyte optionWord, ubyte commandWord) {
		_skt.write(CODE_IAC);
		_skt.write(optionWord);
		_skt.write(commandWord);
	}

	void threadProc(bool pleaseStop) {
		if (pleaseStop) {
			close();
		}

		ubyte bytein;

		for (;;) {
			_skt.read(bytein);

			if (bytein == CODE_IAC) {
				//writefln("Command Incoming");
				_skt.read(bytein);

				switch (bytein) {
					case CODE_DO:
						//writefln("Option Word");
						_skt.read(bytein);

						switch (bytein) {
							case CODE_ECHO:
								//writefln("Echo");

								sendCommandWord(CODE_WILL, CODE_ECHO);

								break;

							case CODE_SUPPRESS_GO_AHEAD:
								//writefln("Supress Go Ahead");

								sendCommandWord(CODE_WILL, CODE_SUPPRESS_GO_AHEAD);

								break;

							case CODE_AYT:
								//writefln("Are you there?");

								sendCommandWord(CODE_WILL, CODE_AYT);

								break;

							default:
								//writefln(bytein);
								break;
						}
						break;

					case CODE_DONT:
						_skt.read(bytein);
						//writefln("Dont ", bytein);
						break;
					case CODE_WONT:
						_skt.read(bytein);
						//writefln("Wont ", bytein);
						break;
					case CODE_WILL:
						_skt.read(bytein);
						//writefln("Will ", bytein);
						break;

					default:
						//writefln("Command: ", cast(char)bytein);
						break;
				}
			}
			else {
				//
				if (_charDelegate !is null) {
					_charDelegate(Unicode.fromCP866(bytein));
					//_charDelegate(bytein);
				}
			}
		}
	}

	Socket _skt;

	bool _connected;

	Thread _thread;

	void delegate(dchar) _charDelegate;
}

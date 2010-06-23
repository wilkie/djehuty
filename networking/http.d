/*
 * http.d
 *
 * This file implements the HTTP standard.
 *
 * Author: Dave Wilkinson
 *
 */

module networking.http;

import core.string;
import core.definitions;
import synch.thread;
import synch.semaphore;
import core.stream;
import core.unicode;

import io.socket;
import io.console;

class HTTPHeader {
protected:

	string _httpVersion;
}

class HTTPServer {
}

// Section: Sockpuppets

// Description: This class facilitates a client connection to a HTTP Server.
class HTTPClient {
protected:

	const auto downloadBuffer = 1024*128;

	void _recvFunc(bool pleaseStop)
	{
		if (pleaseStop)
		{
			close();
			return;
		}

		// receive the http headers
		// and any data

		ubyte bytein;
		for (;;)
		{
			//Console.put("attempt to download ", downloadBuffer);
			//Console.put(_buffer.length(), _skt.length());
//			uint ret = cast(uint)_skt.readAny(_buffer, 1024);
			uint ret = cast(uint)_buffer.appendAny(_skt, downloadBuffer);
			//Console.put("got ", ret);

			if (ret == 0) { return; }

			//Console.put(ret, " : [[[", cast(char[])_buffer.contents, "]]]");

			// Parse the HTTP Header, if needed

			// Find the "\r\n\r\n" sequence

			if (!_foundHeader)
			{
				for (;_checkPos+1 < _buffer.length; _checkPos++)
				{
					if (_foundSlashR)
					{
						if (_foundSlashN)
						{
							if (_buffer.contents[_checkPos] == '\n')
							{
								// found \r\n\r\n
								_foundHeader = true;

								_header = cast(char[])_buffer.contents[0.._checkPos-3];

								_checkPos++;

								break;
							}
						}

						if (_buffer.contents[_checkPos] == '\n')
						{
							_foundSlashN = true;
							_foundSlashR = false;
						}
						else
						{
							_foundSlashN = false;
							_foundSlashR = false;
						}
					}
					else if (_foundSlashN)
					{
						if (_buffer.contents[_checkPos] == '\r')
						{
							_foundSlashR = true;
						}
						else
						{
							_foundSlashN = false;
						}
					}
					else if (_buffer.contents[_checkPos] == '\r')
					{
						_foundSlashR = true;
						_headerNewlines ~= _checkPos;
					}
				}

				if (_foundHeader)
				{
					Console.put("Header Found:");
					Console.put(" ");

					// _checkPos is the position of the content

					parseHeader();
				}
			}

			if (_foundHeader)
			{
				// how much content do we have?
				uint curContentLength = cast(uint)_buffer.length - _checkPos;

				if (_curPos == 0)
				{
					_buffer.rewind();
					_buffer.skip(_checkPos);
				}

				// read?
			//	Console.put("bleh ", curContentLength);

				if (_callback !is null)
				{
					_callback(_buffer);
				}

				if (curContentLength == _contentLength)
				{
					Console.put("done");
				}


				_curPos = curContentLength;
			}
		}
	}

	void parseHeader()
	{
		uint oldpos = 0;

		char[] HTTPVersion;
		char[] HTTPCode;
		char[] HTTPStatus;

		char[] HTTPAttribute;
		char[] HTTPValue;

		uint event;

		char[] relocationAddress;

		foreach (pos; _headerNewlines)
		{
			char[] line = _header[oldpos..pos];

			//Console.put(" > ", line);

			if (oldpos == 0)
			{
				// This is the first line, the HTTP state and version

				HTTPVersion = line[5..8];

				Console.put("HTTP Version: ", HTTPVersion);

				HTTPCode = line[9..12];

				Console.put("HTTP Code: ", HTTPCode);

				HTTPStatus = line[13..$];

				Console.put("HTTP Status: ", HTTPStatus);

				if (HTTPCode == "302")
				{
					// Relocation Request
					Console.put("-- Relocation Requested --");

					event=1;
				}
			}
			else
			{
				// Getting attributes, file information, and connection information

				// Parse until the ':'

				uint i;

				for(i=0; i<line.length; i++)
				{
					if (line[i] == ':')
					{
						break;
					}
				}

				HTTPAttribute = line[0..i];
				HTTPValue = line[i+2..$];

				Console.put("HTTP Attribute (", HTTPAttribute, "): ", HTTPValue);

				if (event==1)
				{
					if (HTTPAttribute == "Location")
					{
						Console.put("-- Relocate To ", HTTPValue, " --");

						// figure out host and address from url

						relocationAddress = HTTPValue[23..$];
					}
				}

					if (HTTPAttribute == "Content-Length")
					{
						string s = cast(string)HTTPValue;
						s.nextInt(_contentLength);
					}

			}


			oldpos = pos + 2;
		}

		// relocate?

		if (event==1)
		{

			Console.put(" going to : " , relocationAddress);

			_foundHeader=false;
			_foundSlashR = false;
			_foundSlashN = false;
			_headerNewlines = null;
			_checkPos = 0;

			_buffer = new Stream();

			char[] sendstr = "GET " ~ relocationAddress ~ " HTTP/1.1\r\nHost: www.wilkware.com\r\nUser-Agent: DjehutyApp\r\nConnection: Keep-Alive\r\n\r\n";
			_skt.write(cast(ubyte*)sendstr.ptr, sendstr.length);

		}
	}

	bool _foundHeader;
	bool _foundSlashR;
	bool _foundSlashN;
	uint _checkPos;
	uint _curPos;

	char[] _header;
	uint[] _headerNewlines;

	uint _contentLength;

	Socket _skt;
	Thread _thread;

	Stream _buffer;

	bool _connected;

	void delegate(Stream) _callback;

public:
	this() {
		_skt = new Socket;
		_thread = new Thread;
		_buffer = new Stream();

		_thread.callback = &_recvFunc;
	}

	bool connect(string hostname, ushort port = 80) {
		_connected = _skt.connect(hostname, port);

		if (_connected) {
			_thread.start();
		}

		return _connected;
	}

	void get(string path) {
		// send a get request
		string sendstr = "GET " ~ Unicode.toUtf8(path) ~ " HTTP/1.1\r\nHost: www.wilkware.com\r\nUser-Agent: DjehutyApp\r\nConnection: Keep-Alive\r\n\r\n";
//			char[] sendstr = "GET /news/news.php HTTP/1.1\r\nHost: www.wilkware.com\r\nUser-Agent: DjehutyApp\r\nConnection: Keep-Alive\r\n\r\n";
		_skt.write(cast(ubyte*)sendstr.ptr, sendstr.length);
	}

	void setDelegate(void delegate(Stream) callback) {
		_callback = callback;
	}

	void close() {
		_skt.close();
	}
}

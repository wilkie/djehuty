module console.prompt;

import core.string;
import core.unicode;

import io.console;

import core.definitions;

import utils.linkedlist;

// Section: Console

// Description: This class provides a line input field for a console application.  This class can buffer the previous lines much like that of a modern shell.
class Prompt {
	// TODO: Allow ANSI emulated prompt strings
	this() {
		_prompt = "";
	}

	// Description: This will set the prompt string that will precede the input.
	// prompt: A string representing the prompt.
	void prompt(string prompt) {
		_prompt = prompt.dup;
	}

	// Description: This function will return the current prompt.
	// Returns: The current prompt.
	string prompt() {
		return _prompt.dup;
	}

	void promptColor(fgColor fgClr) {
		_promptClr = fgClr;
	}

	void forecolor(fgColor fgClr) {
		_clr = fgClr;
	}

	// Description: This function will set the amount of lines the line buffer stores.  The line buffer will scroll through the most recent lines inputted by the user.  This function will also turn off the line buffer if the size is 0.
	// bufferSize: The number of lines to store.  Setting this to zero will turn off the buffer.  There is a maximum of 5000.
	void bufferSize(uint bufferSize) {
		if (bufferSize > 5000) {
			bufferSize = 5000;
		}

		if (bufferSize != 0) {
			_lineBuffer = new LinkedList!(string)();
		}
		else {
			_lineBuffer = null;
		}

		_bufferSize = bufferSize;
	}

	// Description: This will display the prompt and return the line typed by the user.
	// Returns: The line typed by the user.
	string line() {
		// the current displayed line
		string line;

		// the 'working' line being edited
		string workingLine;

		// Print out the prompt string

		Console.setColor(_promptClr);

		Console.put(_prompt);

		// Go into a key loop, wait for a return
		// On any special key, fire the callback and expect a result (for instance, on TAB)
		// When we are allowed, up and down can signify the use of the line buffer

		dchar chr;

		uint code;

		line = "";

		workingLine = line;
		if (_lineBuffer !is null) {
			_bufferPos = -1;
		}

		Console.setColor(_clr);

		for(;;) {
			Console.getChar(chr, code);

			if (code == Key.Return) {
				// enter

				_pos = 0;

				break;
			}
			else if (code == Key.Backspace) {
				// backspace

				if (line.length > 0 && _pos > 0) {
					Console.put(chr);
					Console.put(' ');
					Console.put(chr);

					if (_pos == line.length) {
						line = line.substring(0, line.length-1);
					}
					else {
						string newLine = line.substring(0, _pos-1);
						string restLine = line.substring(_pos);
						newLine ~= restLine;

						Console.put(restLine);
						Console.put(' ');

						for (uint i=0; i<=restLine.length; i++) {
							Console.put(cast(char)0x8);
						}

						line = newLine;
					}

					if (_lineBuffer !is null) {
						_bufferPos = -1;
					}
					workingLine = line;

					_pos--;
				}
			}
			else if (code == Key.Left) {
				if (_pos > 0) {
					Console.put(cast(char)0x8);

					_pos--;
				}
			}
			else if (code == Key.Right) {
				if (_pos < line.length) {
					Console.setRelative(1,0);

					_pos++;
				}
			}
			else if (code == Key.Up) {
				// The current line is still stored

				// And then the line buffer spits out
				// the previous line submitted
				if (_lineBuffer !is null) {
					if (_bufferPos+1 < cast(int)_lineBuffer.length && _lineBuffer.length > 0) {
						// grab the line from the line buffer

						_bufferPos++;
						line = _lineBuffer.peekAt(_bufferPos);

						uint i;

						if (line.length < _pos) {
							for (i=line.length; i<_pos; i++) {
								Console.put(cast(char)0x8);
								Console.put(' ');
								Console.put(cast(char)0x8);
							}

							_pos = line.length;
						}

						for (i=0; i<_pos; i++) {
							Console.put(cast(char)0x8);
						}

						// print the line
						Console.put(line);

						_pos = line.length;
					}
				}
			}
			else if (code == Key.Down) {
				// The current line is still stored

				// And then the line buffer spits out
				// the next line submitted
				if (_lineBuffer !is null) {
					if (_bufferPos > 0) {
						// grab the line from the line buffer

						_bufferPos--;
						line = _lineBuffer.peekAt(_bufferPos);
					}
					else {
						// redisplay the working line
						_bufferPos = -1;
						if (workingLine !is null) {
							line = workingLine;
						}
					}

					// goto the front of the current line, and erase the current line

					uint i;

					if (line.length < _pos) {
						for (i=line.length; i<_pos; i++) {
							Console.put(cast(char)0x8);
							Console.put(' ');
							Console.put(cast(char)0x8);
						}

						_pos = line.length;
					}

					for (i=0; i<_pos; i++) {
						Console.put(cast(char)0x8);
					}

					// print the line
					Console.put(line);

					// erase the rest of the previous line

					_pos = line.length;
				}
			}
			else if (chr != 0) {
				// written character

				if (_pos == line.length) {
					Console.put(chr);
					line ~= chr;
				}
				else if (_pos == 0) {
					string newLine = "" ~ Unicode.toUtf8([chr]) ~ line;

					Console.put(newLine);

					for (uint i=1; i<newLine.length; i++) {
						Console.put(cast(char)0x8);
					}

					line = newLine;
				}
				else {
					Console.put(chr);
					string leftLine = line.substring(0, _pos);
					leftLine ~= chr;
					string rightLine = line.substring(_pos);
					leftLine ~= rightLine;

					Console.put(rightLine);

					for (uint i=0; i<rightLine.length; i++) {
						Console.put(cast(char)0x8);
					}

					line = leftLine;
				}

				if (_lineBuffer !is null) {
					_bufferPos = -1;
				}
				workingLine = line;

				_pos++;
			}
		}

		Console.putln("");

		// Save line in line buffer
		if (_lineBuffer !is null) {
			if (_lineBuffer.length == _bufferSize) {
				_lineBuffer.remove();
			}
			_lineBuffer.add(line);

			_bufferPos = -1;
		}

		return line;
	}

protected:

	// the prompt string, for instance "# " or "C:\>"
	string _prompt;
	fgColor _promptClr = fgColor.White;
	fgColor _clr = fgColor.White;

	LinkedList!(string) _lineBuffer;
	int _bufferSize;
	int _bufferPos;

	uint _pos;
}

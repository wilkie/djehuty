module console.textfield;

import platform.imports;
mixin(PlatformGenericImport!("console"));

import core.string;
import core.main;
import core.definitions;

import console.main;
import console.window;
import console.control;

// Section: Console

// Description: This console control abstracts a simple one line text field.
class ConsoleTextField : ConsoleControl
{
	this( uint x, uint y, uint width )
	{
		_x = x;
		_y = y;
		_width = width;

		_max = width-2;

		_isTabStop = true;
	}

	override void OnAdd()
	{
	}

	override void OnInit()
	{
		Console.setPosition(_x, _y);
		Console.setColor(fgColor.BrightBlue, bgColor.Black);
		Console.put("[");
		//fflush(stdout);

		Console.setColor(fgColor.BrightWhite);

		for (int i=0; i<_max; i++)
		{
			Console.put(" ");
		//	fflush(stdout);
		}

		Console.setColor(fgColor.BrightBlue);

		Console.put("]");
		//fflush(stdout);
	}

	override void OnKeyDown(uint keyCode)
	{
		if (keyCode == KeyBackspace)
		{
			if (_pos > 0)
			{
				if (_pos == _max)
				{
					Console.put(' ');
				}
				else
				{
					Console.put(cast(char)0x8);
					Console.put(' ');
				}

				Console.put(cast(char)0x8);

				_pos--;
			}
		}
		else if (keyCode == KeyTab || keyCode == KeyReturn || keyCode == 10)
		{
			_window.tabForward();
		}
	}

	override void OnKeyChar(dchar keyChar)
	{
		if (keyChar != 0x8 && keyChar != '\t' && keyChar != '\n' && keyChar != '\r')
		{
			if (_pos <= _max)
			{
				Console.put(keyChar);

				_pos++;

				if (_pos >= _max)
				{
					_pos = _max;
					Console.put(cast(char)(0x8));
				}
			}
		}
	}

	override void OnGotFocus()
	{
		Console.showCaret();

		if (_pos == _max)
		{
			Console.setPosition(_x+1+_max-1, _y);
		}
		else
		{
			Console.setPosition(_x+1+_pos, _y);
		}
		Console.setColor(fgColor.BrightWhite, bgColor.Black);
	}

protected:

	uint _x = 0;
	uint _y = 0;
	uint _width = 0;

	uint _pos = 0;
	uint _max = 0;

}


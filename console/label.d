module console.label;

import platform.imports;
mixin(PlatformGenericImport!("console"));

import core.string;
import core.main;
import core.definitions;

import console.main;
import console.window;
import console.control;

// Section: Console

// Description: This console control abstracts a simple static text field.
class ConsoleLabel : ConsoleControl
{
	this( uint x, uint y, String text )
	{
		_x = x;
		_y = y;

		_value = new String(text);
	}

	this( uint x, uint y, StringLiteral text )
	{
		_x = x;
		_y = y;

		_value = new String(text);
	}

	override void OnAdd()
	{
	}

	override void OnInit()
	{
		Console.setPosition(_x, _y);
		Console.setColor(fgColor.BrightBlue, bgColor.Black);

		Console.put(_value.array);
	}

protected:

	uint _x = 0;
	uint _y = 0;

	String _value;
}

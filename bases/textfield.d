module bases.textfield;

import core.control;
import core.string;

import platform.imports;
mixin(PlatformGenericImport!("definitions"));

enum TextFieldEvent : uint
{
	Selected,
	Unselected,
	Changed,
}

// Section: Bases

// Description: This base provides a shell for a standard one line text field.
abstract class BaseTextField : Control
{
public:

	this(int x, int y, int width, int height, String value)
	{
		_x = x;
		_y = y;

		_r = _x + width;
		_b = _y + height;

		_width = width;
		_height = height;

		_value = new String(value);
	}

	this(int x, int y, int width, int height, StringLiteral value)
	{
		_x = x;
		_y = y;

		_r = _x + width;
		_b = _y + height;

		_width = width;
		_height = height;

		_value = new String(value);
	}

	// support Events
	mixin(ControlAddDelegateSupport!("BaseTextField", "TextFieldEvent"));

	void setText(String newTitle)
	{
		_value = new String(newTitle);
	}

	void setText(StringLiteral newTitle)
	{
		_value = new String(newTitle);
	}

	String getText()
	{
		return _value;
	}

protected:

	String _value;
}

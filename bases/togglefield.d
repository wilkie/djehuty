module bases.togglefield;

import core.control;
import core.string;

import platform.imports;
mixin(PlatformGenericImport!("definitions"));

enum ToggleFieldEvent : uint
{
	Selected,
	Unselected,
}

// Section: Bases

// Description: This base provides a shell for a standard toggle field.
abstract class BaseToggleField : Control
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
	mixin(ControlAddDelegateSupport!("BaseToggleField", "ToggleFieldEvent"));

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

	void SetEnabled(bool bEnable)
	{
		_enabled = bEnable;
	}

	bool GetEnabled()
	{
		return _enabled;
	}

	uint getWidth()
	{
		return _width;
	}

	uint getHeight()
	{
		return _height;
	}

	void Unselect()
	{
	}

	void Select()
	{
	}

protected:
	String _value;

	bool _is_grouped = false;
}

void ToggleFieldSetGrouped(ref BaseToggleField ctrl, bool grouped)
{
	ctrl._is_grouped = grouped;
}

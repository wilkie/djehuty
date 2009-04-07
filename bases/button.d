module bases.button;

import core.control;
import core.string;
import bases.windowedcontrol;

import platform.imports;
mixin(PlatformGenericImport!("definitions"));

// Section: Bases

// Description: This base provides a shell for a standard push button.
abstract class BaseButton : WindowedControl
{
public:

	this(int x, int y, int width, int height, String value)
	{
		super(x,y,width,height);
		_value = new String(value);
	}

	this(int x, int y, int width, int height, StringLiteral value)
	{
		super(x,y,width,height);
	}

	// support Events
	mixin(ControlAddDelegateSupport!("BaseButton", "ButtonEvent"));


}

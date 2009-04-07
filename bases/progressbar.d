module bases.progressbar;

import core.control;
import core.string;
import bases.windowedcontrol;

import platform.imports;
mixin(PlatformGenericImport!("definitions"));

// Section: Bases

// Description: This base provides a shell for a standard progress bar.
abstract class BaseProgressBar : WindowedControl
{
public:

	this(int x, int y, int width, int height)
	{
		super(x,y,width,height);

		_value = 0;
		_min = 0;
		_max = 100;
	}

	void setRange(long min, long max)
	{
		_min = min;
		_max = max;

		if (_min > _max) { _min = _max; }
		if (_value < _min) { _value = _min; }
		if (_value > _max) { _value = _max; }
	}

	void getRange(out long min, out long max)
	{
		min = _min;
		max = _max;
	}

	void setValue(long value)
	{
		_value = value;

		if (_value < _min) { _value = _min; }
		if (_value > _max) { _value = _max; }
	}

	long getValue()
	{
		return _value;
	}

protected:

	long _min;
	long _max;
	long _value;

}

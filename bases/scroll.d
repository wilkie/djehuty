module bases.scroll;

import core.control;
import core.string;

import platform.imports;
mixin(PlatformGenericImport!("definitions"));

enum ScrollEvent : uint
{
	Selected,
	Unselected,
	Scrolled,
}

// Section: Bases

// Description: This base provides a shell for a standard scrollbar.
abstract class BaseScroll : Control
{
public:

	// Constructors
	this()
	{
	}

	this(int x, int y, int width, int height)
	{
		_x = x;
		_y = y;
		_r = x + width;
		_b = y + height;
		_width = width;
		_height = height;
	}

	// support Events
	mixin(ControlAddDelegateSupport!("BaseScroll", "ScrollEvent"));

	// Methods

	uint getWidth()
	{
		return _width;
	}

	uint getHeight()
	{
		return _height;
	}

	void GetRange(out long min, out long max)
	{
	}

	void SetRange(long min, long max)
	{
	}

	void SetValue(long newValue)
	{
	}

	long GetValue()
	{
		return 0;
	}

	void SetScrollPeriods(long smallChange, long largeChange)
	{
	}

	void GetScrollPeriods(out long smallChange, out long largeChange)
	{
	}

	void IncrementSmall()
	{
	}

	void DecrementSmall()
	{
	}

	void IncrementLarge()
	{
	}

	void DecrementLarge()
	{
	}

	void SetEnabled(bool bEnable)
	{
		_enabled = bEnable;
	}

	bool GetEnabled()
	{
		return _enabled;
	}


protected:

	long m_min=0;
	long m_max=30;
	long m_value=0;

	long m_large_change=5;
	long m_small_change=1;

}

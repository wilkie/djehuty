module core.windowedcontrol;

import core.string;
import gui.core;

import platform.imports;
mixin(PlatformGenericImport!("definitions"));

// Section: Bases

// Description: This base provides basic functions for controls meant for UI components on windows.
abstract class WindowedControl : Control
{
	this(int x, int y, int width, int height)
	{
		_subX = x;
		_x = x;

		_subY = y;
		_y = y;

		_r = _x + width;
		_b = _y + height;

		_width = width;
		_height = height;
	}

	void setEnabled(bool bEnable)
	{
		_enabled = bEnable;
	}

	bool getEnabled()
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

	int getX()
	{
		return _subX;
	}

	int getY()
	{
		return _subY;
	}

	void resize(uint width, uint height)
	{
		_width = width;
		_height = height;

		_r = _x + width;
		_b = _y + height;
	}

	void move(int x, int y)
	{
		if (_container !is null)
		{
			_x = x + _container.getBaseX();
			_y = y + _container.getBaseY();
		}
		else
		{
			_x = x;
			_y = y;
		}

		_subX = x;
		_subY = y;

		_r = _x + _width;
		_b = _y + _height;
	}

	override bool isWindowed()
	{
		return true;
	}
}

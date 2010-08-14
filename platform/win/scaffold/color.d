/*
 * color.d
 *
 * This file implements the Scaffold for platform specific Color for Windows.
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.color;

import binding.win32.winuser;

import platform.win.main;

import core.color;
import core.definitions;

void ColorGetSystemColor(ref Color clr, SystemColor sysColorIndex)
{
	switch (sysColorIndex)
	{
		case SystemColor.Window:
			uint clrInt = GetSysColor(15);
			double r, g, b;
			clr.red = r / 255.0;
			clr.blue = b / 255.0;
			clr.green = g / 255.0;
			clr.alpha = 1.0;
			break;
		default: break;
	}
}


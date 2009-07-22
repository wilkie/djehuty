/*
 * color.d
 *
 * This file implements the Scaffold for platform specific Color for Windows.
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.color;

import platform.win.common;
import platform.win.main;

import core.color;
import core.definitions;

void ColorGetSystemColor(ref Color clr, SystemColor sysColorIndex)
{
	switch (sysColorIndex)
	{
		case SystemColor.Window:
			ColorSetValue(clr, (GetSysColor(15)));
			break;
		default: break;
	}
}


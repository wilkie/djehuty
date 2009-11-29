/*
 * pen.d
 *
 * This module has the structure that is kept with a Pen class for Windows.
 *
 * Author: Dave Wilkinson
 * Originated: July 22th, 2009
 *
 */

module platform.vars.pen;

import platform.win.common;

import binding.win32.gdiplusgpstubs;

struct PenPlatformVars {
	HPEN penHandle;
	int clr;
	
	GpPen* handle;
}
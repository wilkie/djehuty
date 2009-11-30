/*
 * font.d
 *
 * This module has the structure that is kept with a Font class for Windows.
 *
 * Author: Dave Wilkinson
 * Originated: July 22th, 2009
 *
 */

module platform.vars.font;

import platform.win.common;

import binding.win32.gdiplusgpstubs;

struct FontPlatformVars {
	HFONT fontHandle;
	
	GpFont* handle;
	GpFontFamily* family;
}
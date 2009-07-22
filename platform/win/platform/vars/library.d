/*
 * library.d
 *
 * This module has the structure that is kept with a Library class for Windows.
 *
 * Author: Dave Wilkinson
 * Originated: July 22th, 2009
 *
 */

module platform.vars.library;

import platform.win.common;

struct LibraryPlatformVars {
	HMODULE hmodule;
}
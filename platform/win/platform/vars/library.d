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

import binding.win32.windef;

struct LibraryPlatformVars {
	HMODULE hmodule;
}
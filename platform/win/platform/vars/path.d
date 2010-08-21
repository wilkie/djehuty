/*
 * path.d
 *
 * This module implements the platform specific data for graphical paths.
 *
 */

module platform.vars.path;

import binding.win32.gdiplus;

struct PathPlatformVars {
	GpPath* path;
}
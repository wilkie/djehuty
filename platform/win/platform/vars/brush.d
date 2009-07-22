/*
 * brush.d
 *
 * This module has the structure that is kept with a Brush class for Windows.
 *
 * Author: Dave Wilkinson
 * Originated: July 22th, 2009
 *
 */

module platform.vars.brush;

import platform.win.common;

struct BrushPlatformVars {
	HBRUSH brushHandle;
}
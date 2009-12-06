/*
 * brush.d
 *
 *
 *
 * Author: Dave Wilkinson
 * Originated: July 25th, 2009
 *
 */

module platform.vars.brush;

import Cairo = binding.cairo.cairo;

struct BrushPlatformVars {
	Cairo.cairo_pattern_t* handle;
}

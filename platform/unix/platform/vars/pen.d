/*
 * pen.d
 *
 * This module implements the platform specifics for the Pen class.
 *
 * Author: Dave Wilkinson
 * Originated: July 25th, 2009
 *
 */

module platform.vars.pen;

import Cairo = binding.cairo.cairo;

struct PenPlatformVars {
	Cairo.cairo_pattern_t* handle;
	double width;
}

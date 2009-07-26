/*
 * font.d
 *
 * This module implements the platform specifics for the Font class.
 *
 * Author: Dave Wilkinson
 * Originated: July 25th, 2009
 *
 */

module platform.vars.font;

import Pango = binding.pango.pango;

struct FontPlatformVars {
	Pango.PangoFontDescription* pangoFont;
}

/*
 * view.d
 *
 * This module implements the platform specifics for the View class.
 *
 * Author: Dave Wilkinson
 * Originated: July 25th, 2009
 *
 */

module platform.vars.view;

import Cairo = binding.cairo.cairo;
import Pango = binding.pango.pango;
import X = binding.x.Xlib;

struct ViewPlatformVars {
	X.Window cur_window;

	X.Pixmap pixmap;
	bool pixmap_loaded;

	X.GC gc;

	uint curpen;
	uint curbrush;

	//text
	Cairo.cairo_t* cr;
	Cairo.cairo_surface_t* surface;

	Pango.PangoLayout* layout;

	Pango.PangoAttrList* attr_list_opaque;
	Pango.PangoAttrList* attr_list_transparent;

	Pango.PangoAttribute* attr_bg;

	char* data;

	double textclr_red;
	double textclr_green;
	double textclr_blue;

	int isOpaqueRendering;

	ulong bits_length;
}

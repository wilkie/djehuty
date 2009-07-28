/*
 * view.d
 *
 * This Scaffold holds the View implementations for the Linux platform
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.view;

import platform.vars.view;
import platform.vars.window;

import platform.unix.common;
import platform.unix.main;

import graphics.view;
import graphics.bitmap;
import graphics.graphics;

import core.string;
import core.main;
import core.definitions;

import io.file;

import gui.window;

//import console.main;

// views
void ViewCreate(ref View view, ViewPlatformVars*viewVars)
{
	// code to create a view

	viewVars.surface = Cairo.cairo_image_surface_create(Cairo.cairo_format_t.CAIRO_FORMAT_ARGB32, view.width(), view.height());
	viewVars.cr = Cairo.cairo_create(viewVars.surface);

	viewVars.attr_list_opaque = Pango.pango_attr_list_new();
	viewVars.attr_list_transparent = Pango.pango_attr_list_new();

	viewVars.attr_bg = Pango.pango_attr_background_new(0xFFFF, 0xFFFF, 0xFFFF);

	viewVars.attr_bg.start_index = 0;
	viewVars.attr_bg.end_index = -1;

	Pango.pango_attr_list_insert(viewVars.attr_list_opaque, viewVars.attr_bg);
}

void ViewDestroy(ref View view, ViewPlatformVars*viewVars)
{
	// code to destroy a view
	Cairo.cairo_destroy(viewVars.cr);
	X.XFreePixmap(_pfvars.display, viewVars.pixmap);

	if (viewVars.gc !is null)
	{
		X.XFreeGC(_pfvars.display, viewVars.gc);
		viewVars.gc = null;
	}
}

void ViewCreateDIB(ref Bitmap view, ViewPlatformVars*viewVars)
{
	// code to create a DIB view
	viewVars.surface = Cairo.cairo_image_surface_create(Cairo.cairo_format_t.CAIRO_FORMAT_ARGB32, view.width(), view.height());
	viewVars.cr = Cairo.cairo_create(viewVars.surface);

	viewVars.attr_list_opaque = Pango.pango_attr_list_new();
	viewVars.attr_list_transparent = Pango.pango_attr_list_new();

	viewVars.attr_bg = Pango.pango_attr_background_new(0xFFFF, 0xFFFF, 0xFFFF);

	viewVars.attr_bg.start_index = 0;
	viewVars.attr_bg.end_index = -1;

	viewVars.bits_length = view.width() * view.height() * 4;
}

void ViewCreateForWindow(ref WindowView view, ViewPlatformVars*viewVars, ref Window window, WindowPlatformVars* windowVars)
{
	// code to create a view for a window

	int screen, depth;

	windowVars.destroy_called = false;

	screen = X.DefaultScreen(_pfvars.display);
	depth = X.DefaultDepth(_pfvars.display, screen);

	int _width = window.width;
	int _height = window.height;

	//create the back buffer
	viewVars.pixmap = X.XCreatePixmap(
		_pfvars.display, windowVars.window,
		_width, _height, depth);

	X.XSetWindowBackgroundPixmap(_pfvars.display, windowVars.window, X.None);

	viewVars.gc = X.XCreateGC(_pfvars.display, viewVars.pixmap, 0, null);

	//Set the buffer's window back reference
	viewVars.cur_window = windowVars.window;

	viewVars.surface = CairoX.cairo_xlib_surface_create(
		_pfvars.display, viewVars.pixmap,
		_pfvars.visual, _width, _height);

	viewVars.cr = Cairo.cairo_create(viewVars.surface);

	viewVars.layout = Pango.pango_cairo_create_layout(viewVars.cr);

	viewVars.attr_list_opaque = Pango.pango_attr_list_new();
	viewVars.attr_list_transparent = Pango.pango_attr_list_new();

	viewVars.attr_bg = Pango.pango_attr_background_new(0xFFFF, 0, 0xFFFF);

	viewVars.attr_bg.start_index = 0;
	viewVars.attr_bg.end_index = -1;

	Pango.pango_attr_list_insert(viewVars.attr_list_opaque, viewVars.attr_bg);

	//Pango.pango_attribute_destroy(viewVars.attr_bg);
}

void ViewResizeForWindow(ref WindowView view, ViewPlatformVars*viewVars, ref Window window, WindowPlatformVars* windowHelper)
{
}

void ViewResize(ref View view, ViewPlatformVars*viewVars)
{
	// code to Size a view, no concern needs to be taken
	// to preserve the view's contents and the image within the view
	// this is because of performance concerns, you don't necessarily care
	// about such things...it is also similar to resizing anything dynamic

	int _width = view.width();
	int _height = view.height();

	//make the buffer
	X.XFreePixmap(_pfvars.display, viewVars.pixmap);

	//create the Pixmap
	viewVars.pixmap = X.XCreatePixmap(
		_pfvars.display, viewVars.cur_window,
		_width,
		_height, X.DefaultDepth(_pfvars.display, X.DefaultScreen(_pfvars.display)));

	//attach to cairo and pango
	Pango.g_object_unref(viewVars.layout);

	Cairo.cairo_surface_destroy(viewVars.surface);
	Cairo.cairo_destroy(viewVars.cr);

	viewVars.surface = CairoX.cairo_xlib_surface_create(
		_pfvars.display, viewVars.pixmap,
		_pfvars.visual, _width, _height);

	viewVars.cr = Cairo.cairo_create(viewVars.surface);

	viewVars.layout = Pango.pango_cairo_create_layout(viewVars.cr);

	X.XFreeGC(_pfvars.display, viewVars.gc);

	viewVars.gc = X.XCreateGC(_pfvars.display,
		viewVars.pixmap, 0, null);
}

void* ViewGetBytes(ViewPlatformVars*viewVars, ref ulong length)
{
	length = viewVars.bits_length;
	return Cairo.cairo_image_surface_get_data(viewVars.surface);
}

void* ViewGetBytes(ViewPlatformVars*viewVars)
{
	return Cairo.cairo_image_surface_get_data(viewVars.surface);
}

uint ViewRGBAToInt32(ref bool _forcenopremultiply, ViewPlatformVars*_pfvars, ref uint r, ref uint g, ref uint b, ref uint a)
{
	if (!_forcenopremultiply)
	{
		float anew = a;
		anew /= cast(float)0xFF;

		r = cast(ubyte)(anew * cast(float)r);
		g = cast(ubyte)(anew * cast(float)g);
		b = cast(ubyte)(anew * cast(float)b);
 }
	return (r << 16) | (g << 8) | (b) | (a << 24);
}

uint ViewRGBAToInt32(ViewPlatformVars*_pfvars, ref uint r, ref uint g, ref uint b)
{
	return (r << 16) | (g << 8) | (b) | 0xFF000000;
}






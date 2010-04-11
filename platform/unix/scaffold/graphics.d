/*
 * graphics.d
 *
 * This Scaffold holds the Graphics implementations for the Linux platform
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.graphics;

import core.string;
import core.color;
import core.main;
import core.definitions;
import core.string;

import graphics.view;
import graphics.graphics;

import platform.unix.common;
import platform.unix.main;

import platform.vars.view;
import platform.vars.region;
import platform.vars.brush;
import platform.vars.pen;
import platform.vars.font;

import graphics.region;

import math.common;

// Shapes

// Draw a line
void drawLine(ViewPlatformVars* viewVars, int x, int y, int x2, int y2) {
	Cairo.cairo_set_source(viewVars.cr, viewVars.curPen.handle);
	Cairo.cairo_set_line_width(viewVars.cr, viewVars.curPen.width);
	Cairo.cairo_move_to(viewVars.cr, x, y);
	Cairo.cairo_line_to(viewVars.cr, x2, y2);
	Cairo.cairo_stroke(viewVars.cr);
}

// Draw a rectangle (filled with the current brush, outlined with current pen)
void drawRect(ViewPlatformVars* viewVars, int x, int y, int width, int height) {
	width--;
	height--;
	Cairo.cairo_set_source(viewVars.cr, viewVars.curBrush.handle);
	Cairo.cairo_rectangle(viewVars.cr, x, y, width, height);
	Cairo.cairo_fill_preserve(viewVars.cr);
	Cairo.cairo_set_source(viewVars.cr, viewVars.curPen.handle);
	Cairo.cairo_set_line_width(viewVars.cr, viewVars.curPen.width);
	Cairo.cairo_stroke(viewVars.cr);
}

void fillRect(ViewPlatformVars* viewVars, int x, int y, int width, int height) {
	x++;
	width--;
	height--;
	Cairo.cairo_set_source(viewVars.cr, viewVars.curBrush.handle);
	Cairo.cairo_rectangle(viewVars.cr, x, y, width, height);
	Cairo.cairo_fill(viewVars.cr);
}

void strokeRect(ViewPlatformVars* viewVars, int x, int y, int width, int height) {
	width--;
	height--;
	Cairo.cairo_set_source(viewVars.cr, viewVars.curPen.handle);
	Cairo.cairo_rectangle(viewVars.cr, x, y, width, height);
	Cairo.cairo_set_line_width(viewVars.cr, viewVars.curPen.width);
	Cairo.cairo_stroke(viewVars.cr);
}

// Draw an ellipse (filled with current brush, outlined with current pen)
void drawOval(ViewPlatformVars* viewVars, int x, int y, int width, int height) {
	width--;
	height--;
	Cairo.cairo_set_source(viewVars.cr, viewVars.curBrush.handle);
	Cairo.cairo_save(viewVars.cr);
	Cairo.cairo_new_path(viewVars.cr);
	double cx, cy;
	cx = cast(double)x + cast(double)(width) / 2.0;
	cy = cast(double)y + cast(double)(height) / 2.0;
	Cairo.cairo_translate(viewVars.cr, cx, cy);
	Cairo.cairo_scale(viewVars.cr, cast(double)(width)/2.0, cast(double)(height)/2.0);
	Cairo.cairo_arc(viewVars.cr, 0, 0, 1.0, 0, 2*3.14159265);
	Cairo.cairo_restore(viewVars.cr);
	Cairo.cairo_fill_preserve(viewVars.cr);
	Cairo.cairo_set_source(viewVars.cr, viewVars.curPen.handle);
	Cairo.cairo_set_line_width(viewVars.cr, viewVars.curPen.width);
	Cairo.cairo_stroke(viewVars.cr);
}

void fillOval(ViewPlatformVars* viewVars, int x, int y, int width, int height) {
	width--;
	height--;
	Cairo.cairo_set_source(viewVars.cr, viewVars.curBrush.handle);
	Cairo.cairo_save(viewVars.cr);
	Cairo.cairo_new_path(viewVars.cr);
	double cx, cy;
	cx = cast(double)x + cast(double)(width) / 2.0;
	cy = cast(double)y + cast(double)(height) / 2.0;
	Cairo.cairo_translate(viewVars.cr, cx, cy);
	Cairo.cairo_scale(viewVars.cr, cast(double)(width)/2.0, cast(double)(height)/2.0);
	Cairo.cairo_arc(viewVars.cr, 0, 0, 1.0, 0, 2*3.14159265);
	Cairo.cairo_restore(viewVars.cr);
	Cairo.cairo_fill(viewVars.cr);
}

void strokeOval(ViewPlatformVars* viewVars, int x, int y, int width, int height) {
	width--;
	height--;
	Cairo.cairo_save(viewVars.cr);
	Cairo.cairo_new_path(viewVars.cr);
	double cx, cy;
	cx = cast(double)x + cast(double)(width) / 2.0;
	cy = cast(double)y + cast(double)(height) / 2.0;
	Cairo.cairo_translate(viewVars.cr, cx, cy);
	Cairo.cairo_scale(viewVars.cr, cast(double)(width)/2.0, cast(double)(height)/2.0);
	Cairo.cairo_arc(viewVars.cr, 0, 0, 1.0, 0, 2*3.14159265);
	Cairo.cairo_restore(viewVars.cr);
	Cairo.cairo_set_source(viewVars.cr, viewVars.curPen.handle);
	Cairo.cairo_set_line_width(viewVars.cr, viewVars.curPen.width);
	Cairo.cairo_stroke(viewVars.cr);
}

void drawPie(ViewPlatformVars* viewVars, int x, int y, int width, int height, double startAngle, double sweepAngle) {
	width--;
	height--;
	Cairo.cairo_set_source(viewVars.cr, viewVars.curBrush.handle);
	Cairo.cairo_save(viewVars.cr);
	Cairo.cairo_new_path(viewVars.cr);
	double cx, cy;
	cx = cast(double)x + cast(double)(width) / 2.0;
	cy = cast(double)y + cast(double)(height) / 2.0;
	Cairo.cairo_translate(viewVars.cr, cx, cy);
	Cairo.cairo_scale(viewVars.cr, cast(double)(width)/2.0, cast(double)(height)/2.0);
	double sA, eA;
	sA = (startAngle*3.14159265)/180.0;
	eA = (sweepAngle*3.14159265)/180.0;
	eA += sA;
	Cairo.cairo_arc(viewVars.cr, 0, 0, 1.0, sA, eA);
	Cairo.cairo_restore(viewVars.cr);
	Cairo.cairo_line_to(viewVars.cr, cx, cy);
	Cairo.cairo_close_path(viewVars.cr);
	Cairo.cairo_fill_preserve(viewVars.cr);
	Cairo.cairo_set_source(viewVars.cr, viewVars.curPen.handle);
	Cairo.cairo_set_line_width(viewVars.cr, viewVars.curPen.width);
	Cairo.cairo_stroke(viewVars.cr);
}

void fillPie(ViewPlatformVars* viewVars, int x, int y, int width, int height, double startAngle, double sweepAngle) {
	width--;
	height--;
	Cairo.cairo_set_source(viewVars.cr, viewVars.curBrush.handle);
	Cairo.cairo_save(viewVars.cr);
	Cairo.cairo_new_path(viewVars.cr);
	double cx, cy;
	cx = cast(double)x + cast(double)(width) / 2.0;
	cy = cast(double)y + cast(double)(height) / 2.0;
	Cairo.cairo_translate(viewVars.cr, cx, cy);
	Cairo.cairo_scale(viewVars.cr, cast(double)(width)/2.0, cast(double)(height)/2.0);
	double sA, eA;
	sA = (startAngle*3.14159265)/180.0;
	eA = (sweepAngle*3.14159265)/180.0;
	eA += sA;
	Cairo.cairo_arc(viewVars.cr, 0, 0, 1.0, sA, eA);
	Cairo.cairo_restore(viewVars.cr);
	Cairo.cairo_line_to(viewVars.cr, cx, cy);
	Cairo.cairo_close_path(viewVars.cr);
	Cairo.cairo_fill(viewVars.cr);
}

void strokePie(ViewPlatformVars* viewVars, int x, int y, int width, int height, double startAngle, double sweepAngle) {
	width--;
	height--;
	Cairo.cairo_set_source(viewVars.cr, viewVars.curPen.handle);
	Cairo.cairo_save(viewVars.cr);
	Cairo.cairo_new_path(viewVars.cr);
	double cx, cy;
	cx = cast(double)x + cast(double)(width) / 2.0;
	cy = cast(double)y + cast(double)(height) / 2.0;
	Cairo.cairo_translate(viewVars.cr, cx, cy);
	Cairo.cairo_scale(viewVars.cr, cast(double)(width)/2.0, cast(double)(height)/2.0);
	double sA, eA;
	sA = (startAngle*3.14159265)/180.0;
	eA = (sweepAngle*3.14159265)/180.0;
	eA += sA;
	Cairo.cairo_arc(viewVars.cr, 0, 0, 1.0, sA, eA);
	Cairo.cairo_restore(viewVars.cr);
	Cairo.cairo_line_to(viewVars.cr, cx, cy);
	Cairo.cairo_close_path(viewVars.cr);
	Cairo.cairo_set_line_width(viewVars.cr, viewVars.curPen.width);
	Cairo.cairo_stroke(viewVars.cr);
}


// Fonts

//void createFont(ViewPlatformVars* viewVars, out Font font, string fontname, int fontsize, int weight, bool italic, bool underline, bool strikethru)
void createFont(FontPlatformVars* font, string fontname, int fontsize, int weight, bool italic, bool underline, bool strikethru) {
	font.pangoFont = Pango.pango_font_description_new();

	fontname = fontname.dup;
	fontname ~= '\0';

	Pango.pango_font_description_set_family(font.pangoFont, fontname.ptr);
	Pango.pango_font_description_set_size(font.pangoFont, fontsize * Pango.PANGO_SCALE);

	if (italic) {
		Pango.pango_font_description_set_style(font.pangoFont, Pango.PangoStyle.PANGO_STYLE_ITALIC);
	}
	else {
		Pango.pango_font_description_set_style(font.pangoFont, Pango.PangoStyle.PANGO_STYLE_NORMAL);
	}

	Pango.pango_font_description_set_weight(font.pangoFont, cast(Pango.PangoWeight)(weight));
}

void setFont(ViewPlatformVars* viewVars, FontPlatformVars* font) {
	Pango.pango_layout_set_font_description(viewVars.layout, font.pangoFont);
}

void destroyFont(FontPlatformVars* font) {
	Pango.pango_font_description_free(font.pangoFont);
}



// Text
void drawText(ViewPlatformVars* viewVars, int x, int y, string str) {
	Pango.pango_layout_set_text(viewVars.layout, str.ptr, str.length);

	Cairo.cairo_set_source_rgb(viewVars.cr, viewVars.textclr_red, viewVars.textclr_green, viewVars.textclr_blue);

	Cairo.cairo_move_to(viewVars.cr, (x), (y));

	Pango.pango_cairo_show_layout(viewVars.cr, viewVars.layout);
}

void drawText(ViewPlatformVars* viewVars, int x, int y, string str, uint length) {
	Pango.pango_layout_set_text(viewVars.layout, str.ptr, length);

	Cairo.cairo_set_source_rgba(viewVars.cr, viewVars.textclr_red, viewVars.textclr_green, viewVars.textclr_blue, viewVars.textclr_alpha);

	Cairo.cairo_move_to(viewVars.cr, (x), (y));

	Pango.pango_cairo_show_layout(viewVars.cr, viewVars.layout);
}

// Clipped Text
void drawClippedText(ViewPlatformVars* viewVars, int x, int y, Rect region, string str) {
	Pango.pango_layout_set_text(viewVars.layout, str.ptr, str.length);

	double xp1,yp1,xp2,yp2;

	xp1 = region.left;
	yp1 = region.top;
	xp2 = region.right;
	yp2 = region.bottom;

	Cairo.cairo_save(viewVars.cr);

	Cairo.cairo_rectangle(viewVars.cr, xp1, yp1, xp2, yp2);
	Cairo.cairo_clip(viewVars.cr);

	Cairo.cairo_set_source_rgba(viewVars.cr, viewVars.textclr_red, viewVars.textclr_green, viewVars.textclr_blue, viewVars.textclr_alpha);

	Cairo.cairo_move_to(viewVars.cr, (x), (y));

	Pango.pango_cairo_show_layout(viewVars.cr, viewVars.layout);

	Cairo.cairo_restore(viewVars.cr);
}

void drawClippedText(ViewPlatformVars* viewVars, int x, int y, Rect region, string str, uint length) {
	Pango.pango_layout_set_text(viewVars.layout, str.ptr, length);

	double xp1,yp1,xp2,yp2;

	xp1 = region.left;
	yp1 = region.top;
	xp2 = region.right;
	yp2 = region.bottom;

	Cairo.cairo_save(viewVars.cr);

	Cairo.cairo_rectangle(viewVars.cr, xp1, yp1, xp2, yp2);
	Cairo.cairo_clip(viewVars.cr);

	Cairo.cairo_set_source_rgba(viewVars.cr, viewVars.textclr_red, viewVars.textclr_green, viewVars.textclr_blue, viewVars.textclr_alpha);

	Cairo.cairo_move_to(viewVars.cr, (x), (y));

	Pango.pango_cairo_show_layout(viewVars.cr, viewVars.layout);

	Cairo.cairo_restore(viewVars.cr);
}

// Text Measurement
void measureText(ViewPlatformVars* viewVars, string str, out Size sz) {
	Pango.pango_layout_set_text(viewVars.layout,
		str.ptr, str.length);

	Pango.pango_layout_get_size(viewVars.layout, cast(int*)&sz.x, cast(int*)&sz.y);

	sz.x /= Pango.PANGO_SCALE;
	sz.y /= Pango.PANGO_SCALE;
}

void measureText(ViewPlatformVars* viewVars, string str, uint length, out Size sz) {
	Pango.pango_layout_set_text(viewVars.layout,
		str.ptr, length);

	Pango.pango_layout_get_size(viewVars.layout, cast(int*)&sz.x, cast(int*)&sz.y);

	sz.x /= Pango.PANGO_SCALE;
	sz.y /= Pango.PANGO_SCALE;
}

// Text Colors
void setTextBackgroundColor(ViewPlatformVars* viewVars, ref Color textColor) {
	// Color is an INT
	// divide

	int r, g, b, a;

	r = cast(int)(textColor.red * 0xffffp0);
	g = cast(int)(textColor.green * 0xffffp0);
	b = cast(int)(textColor.blue * 0xffffp0);
	a = cast(int)(textColor.alpha * 0xffffp0);

	viewVars.attr_bg = Pango.pango_attr_background_new(r, g, b);

	viewVars.attr_bg.start_index = 0;
	viewVars.attr_bg.end_index = -1;

//Pango.pango_attr_list_insert(viewVars.attr_list_opaque, viewVars.attr_bg);
	Pango.pango_attr_list_change(viewVars.attr_list_opaque, viewVars.attr_bg);

//		Pango.pango_attribute_destroy(viewVars.attr_bg);
}

void setTextColor(ViewPlatformVars* viewVars, ref Color textColor) {
	// Color is an INT
	// divide

	double r, g, b, a;

	r = textColor.red;
	g = textColor.green;
	b = textColor.blue;
	a = textColor.alpha;

	viewVars.textclr_red = r;
	viewVars.textclr_green = g;
	viewVars.textclr_blue = b;
	viewVars.textclr_alpha = a;
}

// Text States

void setTextModeTransparent(ViewPlatformVars* viewVars) {
	Pango.pango_layout_set_attributes(viewVars.layout, viewVars.attr_list_transparent);
}

void setTextModeOpaque(ViewPlatformVars* viewVars) {
	Pango.pango_layout_set_attributes(viewVars.layout, viewVars.attr_list_opaque);
}

// Graphics States

void setAntialias(ViewPlatformVars* viewVars, bool value) {
	viewVars.aa = value;
	if (viewVars.aa) {
		Cairo.cairo_set_antialias(viewVars.cr, Cairo.cairo_antialias_t.CAIRO_ANTIALIAS_DEFAULT);
	}
	else {
		Cairo.cairo_set_antialias(viewVars.cr, Cairo.cairo_antialias_t.CAIRO_ANTIALIAS_NONE);
	}
}

// Brushes

void createBrush(BrushPlatformVars* brush, ref Color clr) {
	brush.handle = Cairo.cairo_pattern_create_rgba(clr.red,clr.green,clr.blue,clr.alpha);
}

void setBrush(ViewPlatformVars* viewVars, BrushPlatformVars* brush) {
	viewVars.curBrush = *brush;
}

void destroyBrush(BrushPlatformVars* brush) {
	Cairo.cairo_pattern_destroy(brush.handle);
}

// BitmapBrush

void createBitmapBrush(BrushPlatformVars* brush, ref ViewPlatformVars viewVarsSrc) {
	brush.handle = Cairo.cairo_pattern_create_for_surface(viewVarsSrc.surface);
	Cairo.cairo_pattern_set_extend(brush.handle, Cairo.cairo_extend_t.CAIRO_EXTEND_REPEAT);
}

void createGradientBrush(BrushPlatformVars* brush, double origx, double origy, double[] points, Color[] clrs, double angle, double width) {
	double x0, y0, x1, y1;
	x0 = origx;
	y0 = origy;
	x1 = origx + (cos(angle) * width);
	y1 = origy + (sin(angle) * width);

	brush.handle = Cairo.cairo_pattern_create_linear(x0, y0, x1, y1);
	foreach(size_t i, point; points) {
		Cairo.cairo_pattern_add_color_stop_rgba(brush.handle, point,
				clrs[i].red, clrs[i].green, clrs[i].blue, clrs[i].alpha);
	}
	Cairo.cairo_pattern_set_extend(brush.handle, Cairo.cairo_extend_t.CAIRO_EXTEND_REPEAT);
}

// Pens

void createPen(PenPlatformVars* pen, ref Color clr, double width) {
	pen.handle = Cairo.cairo_pattern_create_rgba(clr.red,clr.green,clr.blue,clr.alpha);
	pen.width = width;
}

void createPenWithBrush(PenPlatformVars* pen, ref BrushPlatformVars brush, double width) {
	pen.handle = Cairo.cairo_pattern_reference(brush.handle);
	pen.width = width;
}

void setPen(ViewPlatformVars* viewVars, PenPlatformVars* pen) {
	viewVars.curPen = *pen;
}

void destroyPen(PenPlatformVars* pen) {
	Cairo.cairo_pattern_destroy(pen.handle);
}

// View Interfacing

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView) {
	Cairo.cairo_set_source_surface(viewVars.cr, viewVarsSrc.surface, x, y);
	Cairo.cairo_paint(viewVars.cr);
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, int viewX, int viewY) {
	Cairo.cairo_save(viewVars.cr);
	Cairo.cairo_set_source_surface(viewVars.cr, viewVarsSrc.surface, x - viewX, y - viewY);
	double x1,y1,x2,y2;
	x1 = x;
	y1 = y;
	x2 = view.width() - viewX;
	y2 = view.height() - viewY;
	Cairo.cairo_rectangle(viewVars.cr, x1, y1, x2, y2);
	Cairo.cairo_restore(viewVars.cr);
	Cairo.cairo_fill(viewVars.cr);
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, int viewX, int viewY, int viewWidth, int viewHeight) {
	Cairo.cairo_save(viewVars.cr);
	Cairo.cairo_set_source_surface(viewVars.cr, viewVarsSrc.surface, x - viewX, y - viewY);
	double x1,y1,x2,y2;
	x1 = x;
	y1 = y;
	x2 = viewWidth;
	y2 = viewHeight;
	Cairo.cairo_rectangle(viewVars.cr, x1, y1, x2, y2);
	Cairo.cairo_restore(viewVars.cr);
	Cairo.cairo_fill(viewVars.cr);
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, double opacity) {
	Cairo.cairo_save(viewVars.cr);
	Cairo.cairo_set_source_surface(viewVars.cr, viewVarsSrc.surface, x, y);
	Cairo.cairo_paint_with_alpha(viewVars.cr, opacity);
	Cairo.cairo_restore(viewVars.cr);
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, int viewX, int viewY, double opacity) {
	Cairo.cairo_set_source_surface(viewVars.cr, viewVarsSrc.surface, x - viewX, y - viewY);
	double x1,y1,x2,y2;
	x1 = x;
	y1 = y;
	x2 = view.width() - viewX;
	y2 = view.height() - viewY;
	Cairo.cairo_save(viewVars.cr);
	Cairo.cairo_rectangle(viewVars.cr, x1, y1, x2, y2);
	Cairo.cairo_clip(viewVars.cr);
	Cairo.cairo_paint_with_alpha(viewVars.cr, opacity);
	Cairo.cairo_restore(viewVars.cr);
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, int viewX, int viewY, int viewWidth, int viewHeight, double opacity) {
	Cairo.cairo_set_source_surface(viewVars.cr, viewVarsSrc.surface, x - viewX, y - viewY);
	double x1,y1,x2,y2;
	x1 = x;
	y1 = y;
	x2 = viewWidth;
	y2 = viewHeight;
	Cairo.cairo_save(viewVars.cr);
	Cairo.cairo_rectangle(viewVars.cr, x1, y1, x2, y2);
	Cairo.cairo_clip(viewVars.cr);
	Cairo.cairo_paint_with_alpha(viewVars.cr, opacity);
	Cairo.cairo_restore(viewVars.cr);
}

void fillRegion(ViewPlatformVars* viewVars, RegionPlatformVars* rgnVars, bool rgnPlatformDirty, Region rgn, int x, int y) {
}

void strokeRegion(ViewPlatformVars* viewVars, RegionPlatformVars* rgnVars, bool rgnPlatformDirty, Region rgn, int x, int y) {
}

void drawRegion(ViewPlatformVars* viewVars, RegionPlatformVars* rgnVars, bool rgnPlatformDirty, Region rgn, int x, int y) {
}

void clipSave(ViewPlatformVars* viewVars)
{
}

void clipRestore(ViewPlatformVars* viewVars)
{
}

void clipRect(ViewPlatformVars* viewVars, int x, int y, int x2, int y2)
{
}

void clipRegion(ViewPlatformVars* viewVars, Region region)
{
}

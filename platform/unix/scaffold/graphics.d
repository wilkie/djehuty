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

// Shapes

// Draw a line
void drawLine(ViewPlatformVars* viewVars, int x, int y, int x2, int y2)
{
	if (x2 > x) { x2--; } else if (x2 < x) { x2++; }
	if (y2 > y) { y2--; } else if (y2 < y) { y2++; }

	X.XDrawLine(_pfvars.display, viewVars.pixmap, viewVars.gc, (x), (y), (x2), (y2));
}

// Draw a rectangle (filled with the current brush, outlined with current pen)
void drawRect(ViewPlatformVars* viewVars, int x, int y, int x2, int y2) {
	Cairo.cairo_set_source_rgba(viewVars.cr,
		viewVars.curBrush.r, viewVars.curBrush.g, viewVars.curBrush.b, viewVars.curBrush.a);
	Cairo.cairo_rectangle(viewVars.cr, x, y, x2-x-1, y2-y-1);
	Cairo.cairo_fill_preserve(viewVars.cr);
	Cairo.cairo_set_source_rgba(viewVars.cr,
		viewVars.curPen.r, viewVars.curPen.g, viewVars.curPen.b, viewVars.curPen.a);
	Cairo.cairo_set_line_width(viewVars.cr, 1);
	Cairo.cairo_set_antialias(viewVars.cr, Cairo.cairo_antialias_t.CAIRO_ANTIALIAS_NONE);
	Cairo.cairo_stroke(viewVars.cr);
}

void fillRect(ViewPlatformVars* viewVars, int x, int y, int x2, int y2) {
	Cairo.cairo_set_source_rgba(viewVars.cr,
		viewVars.curBrush.r, viewVars.curBrush.g, viewVars.curBrush.b, viewVars.curBrush.a);
	Cairo.cairo_rectangle(viewVars.cr, x, y, x2-x-1, y2-y-1);
	Cairo.cairo_fill(viewVars.cr);
}

void strokeRect(ViewPlatformVars* viewVars, int x, int y, int x2, int y2) {
	Cairo.cairo_set_source_rgba(viewVars.cr,
		viewVars.curPen.r, viewVars.curPen.g, viewVars.curPen.b, viewVars.curPen.a);
	Cairo.cairo_rectangle(viewVars.cr, x, y, x2-x-1, y2-y-1);
	Cairo.cairo_set_line_width(viewVars.cr, 1);
	Cairo.cairo_set_antialias(viewVars.cr, Cairo.cairo_antialias_t.CAIRO_ANTIALIAS_NONE);
	Cairo.cairo_stroke(viewVars.cr);
}

// Draw an ellipse (filled with current brush, outlined with current pen)
void drawOval(ViewPlatformVars* viewVars, int x, int y, int x2, int y2) {
	if (x2 > x) { x2--; } else if (x2 < x) { x2++; }
	if (y2 > y) { y2--; } else if (y2 < y) { y2++; }

	Cairo.cairo_set_source_rgba(viewVars.cr,
		viewVars.curBrush.r, viewVars.curBrush.g, viewVars.curBrush.b, viewVars.curBrush.a);
	Cairo.cairo_save(viewVars.cr);
	Cairo.cairo_new_path(viewVars.cr);
	double cx, cy;
	cx = cast(double)x + cast(double)(x2-x) / 2.0;
	cy = cast(double)y + cast(double)(y2-y) / 2.0;
	Cairo.cairo_translate(viewVars.cr, cx, cy);
	Cairo.cairo_scale(viewVars.cr, cast(double)(x2-x)/2.0, cast(double)(y2-y)/2.0);
	Cairo.cairo_arc(viewVars.cr, 0, 0, 1.0, 0, 2*3.14159265);
	Cairo.cairo_fill_preserve(viewVars.cr);
	Cairo.cairo_set_source_rgba(viewVars.cr,
		viewVars.curPen.r, viewVars.curPen.g, viewVars.curPen.b, viewVars.curPen.a);
	Cairo.cairo_set_line_width(viewVars.cr, 1);
	Cairo.cairo_set_antialias(viewVars.cr, Cairo.cairo_antialias_t.CAIRO_ANTIALIAS_NONE);
	Cairo.cairo_stroke(viewVars.cr);
	Cairo.cairo_restore(viewVars.cr);
}

void fillOval(ViewPlatformVars* viewVars, int x, int y, int x2, int y2) {
	Cairo.cairo_set_source_rgba(viewVars.cr,
		viewVars.curBrush.r, viewVars.curBrush.g, viewVars.curBrush.b, viewVars.curBrush.a);
	Cairo.cairo_save(viewVars.cr);
	Cairo.cairo_new_path(viewVars.cr);
	double cx, cy;
	cx = cast(double)x + cast(double)(x2-x) / 2.0;
	cy = cast(double)y + cast(double)(y2-y) / 2.0;
	Cairo.cairo_translate(viewVars.cr, cx, cy);
	Cairo.cairo_scale(viewVars.cr, cast(double)(x2-x)/2.0, cast(double)(y2-y)/2.0);
	Cairo.cairo_arc(viewVars.cr, 0, 0, 1.0, 0, 2*3.14159265);
	Cairo.cairo_fill(viewVars.cr);
	Cairo.cairo_restore(viewVars.cr);
}

void strokeOval(ViewPlatformVars* viewVars, int x, int y, int x2, int y2) {
	Cairo.cairo_set_source_rgba(viewVars.cr,
		viewVars.curPen.r, viewVars.curPen.g, viewVars.curPen.b, viewVars.curPen.a);
	Cairo.cairo_save(viewVars.cr);
	Cairo.cairo_new_path(viewVars.cr);
	double cx, cy;
	cx = cast(double)x + cast(double)(x2-x) / 2.0;
	cy = cast(double)y + cast(double)(y2-y) / 2.0;
	Cairo.cairo_translate(viewVars.cr, cx, cy);
	Cairo.cairo_scale(viewVars.cr, cast(double)(x2-x)/2.0, cast(double)(y2-y)/2.0);
	Cairo.cairo_arc(viewVars.cr, 0, 0, 1.0, 0, 2*3.14159265);
	Cairo.cairo_restore(viewVars.cr);
	Cairo.cairo_set_line_width(viewVars.cr, 1);
	Cairo.cairo_set_antialias(viewVars.cr, Cairo.cairo_antialias_t.CAIRO_ANTIALIAS_NONE);
	Cairo.cairo_stroke(viewVars.cr);
}

void drawPie(ViewPlatformVars* viewVars, int x, int y, int x2, int y2, double startAngle, double sweepAngle) {
	Cairo.cairo_set_source_rgba(viewVars.cr,
		viewVars.curBrush.r, viewVars.curBrush.g, viewVars.curBrush.b, viewVars.curBrush.a);
	Cairo.cairo_save(viewVars.cr);
	Cairo.cairo_new_path(viewVars.cr);
	//Cairo.cairo_translate(viewVars.cr, x + cast(double)(x2-x) / 2.0, y + cast(double)(y2-y) / 2.0);
//	Cairo.cairo_scale(viewVars.cr, cast(double)(x2-x) / 2.0, cast(double)(y2-y) / 2.0);
	double cx, cy;
	cx = cast(double)x + cast(double)(x2-x) / 2.0;
	cy = cast(double)y + cast(double)(y2-y) / 2.0;
	Cairo.cairo_translate(viewVars.cr, cx, cy);
	Cairo.cairo_scale(viewVars.cr, cast(double)(x2-x)/2.0, cast(double)(y2-y)/2.0);
	double sA, eA;
	sA = (startAngle*3.14159265)/180.0;
	eA = (sweepAngle*3.14159265)/180.0;
	eA += sA;
	Cairo.cairo_arc(viewVars.cr, 0, 0, 1.0, sA, eA);
	Cairo.cairo_restore(viewVars.cr);
	Cairo.cairo_line_to(viewVars.cr, cx, cy);
	Cairo.cairo_close_path(viewVars.cr);
	Cairo.cairo_fill_preserve(viewVars.cr);
	Cairo.cairo_set_source_rgba(viewVars.cr,
		viewVars.curPen.r, viewVars.curPen.g, viewVars.curPen.b, viewVars.curPen.a);
	Cairo.cairo_set_line_width(viewVars.cr, 1);
	Cairo.cairo_set_antialias(viewVars.cr, Cairo.cairo_antialias_t.CAIRO_ANTIALIAS_NONE);
	Cairo.cairo_stroke(viewVars.cr);
}

void fillPie(ViewPlatformVars* viewVars, int x, int y, int x2, int y2, double startAngle, double sweepAngle) {
	Cairo.cairo_set_source_rgba(viewVars.cr,
		viewVars.curBrush.r, viewVars.curBrush.g, viewVars.curBrush.b, viewVars.curBrush.a);
	Cairo.cairo_save(viewVars.cr);
	Cairo.cairo_new_path(viewVars.cr);
	//Cairo.cairo_translate(viewVars.cr, x + cast(double)(x2-x) / 2.0, y + cast(double)(y2-y) / 2.0);
//	Cairo.cairo_scale(viewVars.cr, cast(double)(x2-x) / 2.0, cast(double)(y2-y) / 2.0);
	double cx, cy;
	cx = cast(double)x + cast(double)(x2-x) / 2.0;
	cy = cast(double)y + cast(double)(y2-y) / 2.0;
	Cairo.cairo_translate(viewVars.cr, cx, cy);
	Cairo.cairo_scale(viewVars.cr, cast(double)(x2-x)/2.0, cast(double)(y2-y)/2.0);
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

void strokePie(ViewPlatformVars* viewVars, int x, int y, int x2, int y2, double startAngle, double sweepAngle) {
	Cairo.cairo_set_source_rgba(viewVars.cr,
		viewVars.curPen.r, viewVars.curPen.g, viewVars.curPen.b, viewVars.curPen.a);
	Cairo.cairo_save(viewVars.cr);
	Cairo.cairo_new_path(viewVars.cr);
	//Cairo.cairo_translate(viewVars.cr, x + cast(double)(x2-x) / 2.0, y + cast(double)(y2-y) / 2.0);
//	Cairo.cairo_scale(viewVars.cr, cast(double)(x2-x) / 2.0, cast(double)(y2-y) / 2.0);
	double cx, cy;
	cx = cast(double)x + cast(double)(x2-x) / 2.0;
	cy = cast(double)y + cast(double)(y2-y) / 2.0;
	Cairo.cairo_translate(viewVars.cr, cx, cy);
	Cairo.cairo_scale(viewVars.cr, cast(double)(x2-x)/2.0, cast(double)(y2-y)/2.0);
	double sA, eA;
	sA = (startAngle*3.14159265)/180.0;
	eA = (sweepAngle*3.14159265)/180.0;
	eA += sA;
	Cairo.cairo_arc(viewVars.cr, 0, 0, 1.0, sA, eA);
	Cairo.cairo_restore(viewVars.cr);
	Cairo.cairo_line_to(viewVars.cr, cx, cy);
	Cairo.cairo_close_path(viewVars.cr);
	Cairo.cairo_set_line_width(viewVars.cr, 1);
	Cairo.cairo_set_antialias(viewVars.cr, Cairo.cairo_antialias_t.CAIRO_ANTIALIAS_NONE);
	Cairo.cairo_stroke(viewVars.cr);
}


// Fonts

//void createFont(ViewPlatformVars* viewVars, out Font font, string fontname, int fontsize, int weight, bool italic, bool underline, bool strikethru)
void createFont(FontPlatformVars* font, string fontname, int fontsize, int weight, bool italic, bool underline, bool strikethru) {
	font.pangoFont = Pango.pango_font_description_new();

	String fontnamestr = new String(fontname);
	fontnamestr.appendChar('\0');

	Pango.pango_font_description_set_family(font.pangoFont, fontnamestr.ptr);
	Pango.pango_font_description_set_size(font.pangoFont, fontsize * Pango.PANGO_SCALE);

	if (italic) {
		Pango.pango_font_description_set_style(font.pangoFont, Pango.PangoStyle.PANGO_STYLE_ITALIC);
	}
	else {
		Pango.pango_font_description_set_style(font.pangoFont, Pango.PangoStyle.PANGO_STYLE_NORMAL);
	}

	Pango.pango_font_description_set_weight(font.pangoFont, cast(Pango.PangoWeight)(weight));
}

//void createFont(ViewPlatformVars* viewVars, out Font font, String fontname, int fontsize, int weight, bool italic, bool underline, bool strikethru)
void createFont(FontPlatformVars* font, String fontname, int fontsize, int weight, bool italic, bool underline, bool strikethru) {
	font.pangoFont = Pango.pango_font_description_new();

	fontname = new String(fontname);
	fontname.appendChar('\0');

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

void setFont(ViewPlatformVars* viewVars, FontPlatformVars* font)
{
	Pango.pango_layout_set_font_description(viewVars.layout, font.pangoFont);
}

void destroyFont(FontPlatformVars* font)
{
	Pango.pango_font_description_free(font.pangoFont);
}



// Text
void drawText(ViewPlatformVars* viewVars, int x, int y, String str)
{
	Pango.pango_layout_set_text(viewVars.layout, str.ptr, str.length);

	Cairo.cairo_set_source_rgb(viewVars.cr, viewVars.textclr_red, viewVars.textclr_green, viewVars.textclr_blue);

	Cairo.cairo_move_to(viewVars.cr, (x), (y));

	Pango.pango_cairo_show_layout(viewVars.cr, viewVars.layout);
}

void drawText(ViewPlatformVars* viewVars, int x, int y, string str)
{
	Pango.pango_layout_set_text(viewVars.layout, str.ptr, str.length);

	Cairo.cairo_set_source_rgb(viewVars.cr, viewVars.textclr_red, viewVars.textclr_green, viewVars.textclr_blue);

	Cairo.cairo_move_to(viewVars.cr, (x), (y));

	Pango.pango_cairo_show_layout(viewVars.cr, viewVars.layout);
}

void drawText(ViewPlatformVars* viewVars, int x, int y, String str, uint length)
{
	Pango.pango_layout_set_text(viewVars.layout, str.ptr, length);

	Cairo.cairo_set_source_rgb(viewVars.cr, viewVars.textclr_red, viewVars.textclr_green, viewVars.textclr_blue);

	Cairo.cairo_move_to(viewVars.cr, (x), (y));

	Pango.pango_cairo_show_layout(viewVars.cr, viewVars.layout);
}

void drawText(ViewPlatformVars* viewVars, int x, int y, string str, uint length)
{
	Pango.pango_layout_set_text(viewVars.layout, str.ptr, length);

	Cairo.cairo_set_source_rgba(viewVars.cr, viewVars.textclr_red, viewVars.textclr_green, viewVars.textclr_blue, viewVars.textclr_alpha);

	Cairo.cairo_move_to(viewVars.cr, (x), (y));

	Pango.pango_cairo_show_layout(viewVars.cr, viewVars.layout);
}

// Clipped Text
void drawClippedText(ViewPlatformVars* viewVars, int x, int y, Rect region, String str)
{
//		drawText(x,y,str);

	/*
	Pango.pango_layout_set_text(viewVars.layout, str.ptr, str.length);

	double xp1,yp1,xp2,yp2;

	printf("clip draw start\n");

	xp1 = region.left;
	yp1 = region.top;
	xp2 = region.right;
	yp2 = region.bottom;

	Cairo.cairo_save(viewVars.cr);

	printf("clip draw a\n");

	Cairo.cairo_rectangle(viewVars.cr, xp1, yp1, xp2, yp2);
	Cairo.cairo_clip(viewVars.cr);

	printf("clip draw a\n");

	Cairo.cairo_set_source_rgb(viewVars.cr, viewVars.textclr_red, viewVars.textclr_green, viewVars.textclr_blue);

	printf("clip draw a\n");

	Cairo.cairo_move_to(viewVars.cr, (x), (y));

	printf("clip draw a\n");

	Pango.pango_cairo_show_layout(viewVars.cr, viewVars.layout);

	printf("clip draw a\n");

	Cairo.cairo_restore(viewVars.cr);

	printf("clip draw done\n"); */
}

void drawClippedText(ViewPlatformVars* viewVars, int x, int y, Rect region, string str)
{
	Pango.pango_layout_set_text(viewVars.layout, str.ptr, str.length);

	double xp1,yp1,xp2,yp2;

	xp1 = region.left;
	yp1 = region.top;
	xp2 = region.right;
	yp2 = region.bottom;

	Cairo.cairo_save(viewVars.cr);

	Cairo.cairo_rectangle(viewVars.cr, xp1, yp1, xp2, yp2);
	Cairo.cairo_clip(viewVars.cr);

	Cairo.cairo_set_source_rgb(viewVars.cr, viewVars.textclr_red, viewVars.textclr_green, viewVars.textclr_blue);

	Cairo.cairo_move_to(viewVars.cr, (x), (y));

	Pango.pango_cairo_show_layout(viewVars.cr, viewVars.layout);

	Cairo.cairo_restore(viewVars.cr);
}

void drawClippedText(ViewPlatformVars* viewVars, int x, int y, Rect region, String str, uint length)
{
	Pango.pango_layout_set_text(viewVars.layout, str.ptr, length);

	double xp1,yp1,xp2,yp2;

	xp1 = region.left;
	yp1 = region.top;
	xp2 = region.right;
	yp2 = region.bottom;

	Cairo.cairo_save(viewVars.cr);

	Cairo.cairo_rectangle(viewVars.cr, xp1, yp1, xp2, yp2);
	Cairo.cairo_clip(viewVars.cr);

	Cairo.cairo_set_source_rgb(viewVars.cr, viewVars.textclr_red, viewVars.textclr_green, viewVars.textclr_blue);

	Cairo.cairo_move_to(viewVars.cr, (x), (y));

	Pango.pango_cairo_show_layout(viewVars.cr, viewVars.layout);

	Cairo.cairo_restore(viewVars.cr);
}

void drawClippedText(ViewPlatformVars* viewVars, int x, int y, Rect region, string str, uint length)
{
	Pango.pango_layout_set_text(viewVars.layout, str.ptr, length);

	double xp1,yp1,xp2,yp2;

	xp1 = region.left;
	yp1 = region.top;
	xp2 = region.right;
	yp2 = region.bottom;

	Cairo.cairo_save(viewVars.cr);

	Cairo.cairo_rectangle(viewVars.cr, xp1, yp1, xp2, yp2);
	Cairo.cairo_clip(viewVars.cr);

	Cairo.cairo_set_source_rgb(viewVars.cr, viewVars.textclr_red, viewVars.textclr_green, viewVars.textclr_blue);

	Cairo.cairo_move_to(viewVars.cr, (x), (y));

	Pango.pango_cairo_show_layout(viewVars.cr, viewVars.layout);

	Cairo.cairo_restore(viewVars.cr);
}

// Text Measurement
void measureText(ViewPlatformVars* viewVars, String str, out Size sz)
{
	Pango.pango_layout_set_text(viewVars.layout,
		str.ptr, str.length);

	Pango.pango_layout_get_size(viewVars.layout, cast(int*)&sz.x, cast(int*)&sz.y);

	sz.x /= Pango.PANGO_SCALE;
	sz.y /= Pango.PANGO_SCALE;
}

void measureText(ViewPlatformVars* viewVars, String str, uint length, out Size sz)
{
	Pango.pango_layout_set_text(viewVars.layout,
		str.ptr, length);

	Pango.pango_layout_get_size(viewVars.layout, cast(int*)&sz.x, cast(int*)&sz.y);

	sz.x /= Pango.PANGO_SCALE;
	sz.y /= Pango.PANGO_SCALE;
}

void measureText(ViewPlatformVars* viewVars, string str, out Size sz)
{
	Pango.pango_layout_set_text(viewVars.layout,
		str.ptr, str.length);

	Pango.pango_layout_get_size(viewVars.layout, cast(int*)&sz.x, cast(int*)&sz.y);

	sz.x /= Pango.PANGO_SCALE;
	sz.y /= Pango.PANGO_SCALE;
}

void measureText(ViewPlatformVars* viewVars, string str, uint length, out Size sz)
{
	Pango.pango_layout_set_text(viewVars.layout,
		str.ptr, length);

	Pango.pango_layout_get_size(viewVars.layout, cast(int*)&sz.x, cast(int*)&sz.y);

	sz.x /= Pango.PANGO_SCALE;
	sz.y /= Pango.PANGO_SCALE;
}

// Text Colors
void setTextBackgroundColor(ViewPlatformVars* viewVars, ref Color textColor)
{
	// Color is an INT
	// divide

	int r, g, b;

	r = ColorGetR(textColor) * 0x101;
	g = ColorGetG(textColor) * 0x101;
	b = ColorGetB(textColor) * 0x101;

	viewVars.attr_bg = Pango.pango_attr_background_new(r, g, b);

	viewVars.attr_bg.start_index = 0;
	viewVars.attr_bg.end_index = -1;

//Pango.pango_attr_list_insert(viewVars.attr_list_opaque, viewVars.attr_bg);
	Pango.pango_attr_list_change(viewVars.attr_list_opaque, viewVars.attr_bg);

//		Pango.pango_attribute_destroy(viewVars.attr_bg);
}

void setTextColor(ViewPlatformVars* viewVars, ref Color textColor)
{
	// Color is an INT
	// divide

	double r, g, b, a;

	r = textColor.red;
	g = textColor.green;
	b = textColor.blue;
	a = textColor.alpha;

	viewVars.textclr_red = r / 255.0;
	viewVars.textclr_green = g / 255.0;
	viewVars.textclr_blue = b / 255.0;
	viewVars.textclr_alpha = a / 255.0;
}

// Text States

void setTextModeTransparent(ViewPlatformVars* viewVars)
{
	Pango.pango_layout_set_attributes(viewVars.layout, viewVars.attr_list_transparent);
}

void setTextModeOpaque(ViewPlatformVars* viewVars)
{
	Pango.pango_layout_set_attributes(viewVars.layout, viewVars.attr_list_opaque);
}

// Brushes

void createBrush(BrushPlatformVars* brush, ref Color clr) {
	brush.r = cast(double)clr.red / 255.0;
	brush.g = cast(double)clr.green / 255.0;
	brush.b = cast(double)clr.blue / 255.0;
	brush.a = cast(double)clr.alpha / 255.0;
}

void setBrush(ViewPlatformVars* viewVars, BrushPlatformVars* brush) {
	viewVars.curBrush = *brush;
}

void destroyBrush(BrushPlatformVars* brush) {
}

// Pens

void createPen(PenPlatformVars* pen, ref Color clr) {
	pen.r = cast(double)clr.red / 255.0;
	pen.g = cast(double)clr.green / 255.0;
	pen.b = cast(double)clr.blue / 255.0;
	pen.a = cast(double)clr.alpha / 255.0;
}

void setPen(ViewPlatformVars* viewVars, PenPlatformVars* pen) {
	viewVars.curPen = *pen;
}

void destroyPen(PenPlatformVars* pen) {
}

// View Interfacing

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView)
{
	Cairo.cairo_set_source_surface(viewVars.cr, viewVarsSrc.surface, x, y);
	Cairo.cairo_paint(viewVars.cr);
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, int viewX, int viewY)
{
	Cairo.cairo_set_source_surface(viewVars.cr, viewVarsSrc.surface, x - viewX, y - viewY);
	double x1,y1,x2,y2;
	x1 = x;
	y1 = y;
	x2 = view.width() - viewX;
	y2 = view.height() - viewY;
	Cairo.cairo_rectangle(viewVars.cr, x1, y1, x2, y2);
	Cairo.cairo_fill(viewVars.cr);
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, int viewX, int viewY, int viewWidth, int viewHeight)
{
	Cairo.cairo_set_source_surface(viewVars.cr, viewVarsSrc.surface, x - viewX, y - viewY);
	double x1,y1,x2,y2;
	x1 = x;
	y1 = y;
	x2 = viewWidth;
	y2 = viewHeight;
	Cairo.cairo_rectangle(viewVars.cr, x1, y1, x2, y2);
	Cairo.cairo_fill(viewVars.cr);
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, double opacity)
{
	Cairo.cairo_set_source_surface(viewVars.cr, viewVarsSrc.surface, x, y);
	Cairo.cairo_paint_with_alpha(viewVars.cr, opacity);
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, int viewX, int viewY, double opacity)
{
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

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, int viewX, int viewY, int viewWidth, int viewHeight, double opacity)
{
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

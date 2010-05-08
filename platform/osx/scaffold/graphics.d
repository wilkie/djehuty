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

import platform.vars.view;
import platform.vars.region;
import platform.vars.brush;
import platform.vars.pen;
import platform.vars.font;

import graphics.region;

import math.common;

import binding.c;

// Shapes

// Draw a line
extern(C) void _OSXDrawLine(_OSXViewPlatformVars* viewVars, int fromWindow, int x, int y, int x2, int y2);
void drawLine(ViewPlatformVars* viewVars, int x, int y, int x2, int y2) {
	_OSXDrawLine(viewVars.vars, viewVars.fromWindow == 1, x, y, x2, y2);
}

// Draw a rectangle (filled with the current brush, outlined with current pen)
extern(C) void _OSXDrawRect(_OSXViewPlatformVars* viewVars, int fromWindow, int x, int y, int x2, int y2);
void drawRect(ViewPlatformVars* viewVars, int x, int y, int width, int height) {
	_OSXDrawRect(viewVars.vars, viewVars.fromWindow == 1, x, y, width, height);
}

extern(C) void _OSXFillRect(_OSXViewPlatformVars* viewVars, int fromWindow, int x, int y, int x2, int y2);
void fillRect(ViewPlatformVars* viewVars, int x, int y, int width, int height) {
	_OSXFillRect(viewVars.vars, viewVars.fromWindow == 1, x, y, width, height);
}

extern(C) void _OSXStrokeRect(_OSXViewPlatformVars* viewVars, int fromWindow, int x, int y, int x2, int y2);
void strokeRect(ViewPlatformVars* viewVars, int x, int y, int width, int height) {
	_OSXStrokeRect(viewVars.vars, viewVars.fromWindow == 1, x, y, width, height);
}

// Draw an ellipse (filled with current brush, outlined with current pen)
extern(C) void _OSXDrawOval(_OSXViewPlatformVars* viewVars, int fromWindow, int x, int y, int x2, int y2);
void drawOval(ViewPlatformVars* viewVars, int x, int y, int width, int height) {
	_OSXDrawRect(viewVars.vars, viewVars.fromWindow == 1, x, y, width, height);
}

extern(C) void _OSXFillOval(_OSXViewPlatformVars* viewVars, int fromWindow, int x, int y, int x2, int y2);
void fillOval(ViewPlatformVars* viewVars, int x, int y, int width, int height) {
	_OSXFillRect(viewVars.vars, viewVars.fromWindow == 1, x, y, width, height);
}

extern(C) void _OSXStrokeOval(_OSXViewPlatformVars* viewVars, int fromWindow, int x, int y, int x2, int y2);
void strokeOval(ViewPlatformVars* viewVars, int x, int y, int width, int height) {
	_OSXStrokeRect(viewVars.vars, viewVars.fromWindow == 1, x, y, width, height);
}

void drawPie(ViewPlatformVars* viewVars, int x, int y, int width, int height, double startAngle, double sweepAngle) {
}

void fillPie(ViewPlatformVars* viewVars, int x, int y, int width, int height, double startAngle, double sweepAngle) {
}

void strokePie(ViewPlatformVars* viewVars, int x, int y, int width, int height, double startAngle, double sweepAngle) {
}


// Fonts

void createFont(FontPlatformVars* font, string fontname, int fontsize, int weight, bool italic, bool underline, bool strikethru) {
}

void setFont(ViewPlatformVars* viewVars, FontPlatformVars* font)
{
}

void destroyFont(FontPlatformVars* font)
{
}



// Text

extern(C) void _OSXDrawText(_OSXViewPlatformVars* viewVars, int fromWindow, int x, int y, char* str);
void drawText(ViewPlatformVars* viewVars, int x, int y, string str) {
	string tmp = str.dup ~ '\0';
	_OSXDrawText(viewVars.vars, viewVars.fromWindow == 1, x, y, tmp.ptr);
}

void drawText(ViewPlatformVars* viewVars, int x, int y, string str, uint length) {
	string tmp = str[0..length].dup ~ '\0';
	_OSXDrawText(viewVars.vars, viewVars.fromWindow == 1, x, y, tmp.ptr);
}

// Clipped Text
void drawClippedText(ViewPlatformVars* viewVars, int x, int y, Rect region, string str) {
}

void drawClippedText(ViewPlatformVars* viewVars, int x, int y, Rect region, string str, uint length) {
}

// Text Measurement
extern(C) void _OSXMeasureText(_OSXViewPlatformVars* viewVars, int fromWindow, char* str, uint* w, uint* h);
void measureText(ViewPlatformVars* viewVars, string str, out Size sz) {
	string tmp = str.dup ~ '\0';
	_OSXMeasureText(viewVars.vars, viewVars.fromWindow == 1, tmp.ptr, &sz.x, &sz.y);
}

void measureText(ViewPlatformVars* viewVars, string str, uint length, out Size sz) {
	string tmp = str[0..length].dup ~ '\0';
	_OSXMeasureText(viewVars.vars, viewVars.fromWindow == 1, tmp.ptr, &sz.x, &sz.y);
}

// Text Colors
void setTextBackgroundColor(ViewPlatformVars* viewVars, ref Color textColor) {
}

void setTextColor(ViewPlatformVars* viewVars, ref Color textColor)
{
}
// Text States

void setTextModeTransparent(ViewPlatformVars* viewVars)
{
}

void setTextModeOpaque(ViewPlatformVars* viewVars)
{
}

// Graphics States

void setAntialias(ViewPlatformVars* viewVars, bool value) {
}

// Brushes

extern(C) void _OSXCreateBrush(void** brush, double r, double g, double b, double a);
void createBrush(BrushPlatformVars* brush, Color clr) {
	_OSXCreateBrush(&brush.brush, clr.red, clr.green, clr.blue, clr.alpha);
}

extern(C) void _OSXUseBrush(_OSXViewPlatformVars* viewVars, int fromWindow, void* brush);
void setBrush(ViewPlatformVars* viewVars, BrushPlatformVars* brush) {
	_OSXUseBrush(viewVars.vars, viewVars.fromWindow == 1, brush.brush);
}

extern(C) void _OSXDestroyBrush(void* brush);
void destroyBrush(BrushPlatformVars* brush) {
	_OSXDestroyBrush(brush.brush);
}

// BitmapBrush

void createBitmapBrush(BrushPlatformVars* brush, ref ViewPlatformVars viewVarsSrc) {
}

void createGradientBrush(BrushPlatformVars* brush, double origx, double origy, double[] points, Color[] clrs, double angle, double width) {
}

// Pens

extern(C) void _OSXCreatePen(void** pen, double r, double g, double b, double a);
void createPen(PenPlatformVars* pen, ref Color clr, double width) {
	_OSXCreatePen(&pen.pen, clr.red, clr.green, clr.blue, clr.alpha);
}

void createPenWithBrush(PenPlatformVars* pen, ref BrushPlatformVars brush, double width) {
}

extern(C) void _OSXUsePen(_OSXViewPlatformVars* viewVars, int fromWindow, void* pen);
void setPen(ViewPlatformVars* viewVars, PenPlatformVars* pen) {
	_OSXUsePen(viewVars.vars, viewVars.fromWindow == 1, pen.pen);
}

extern(C) void _OSXDestroyPen(void* pen);
void destroyPen(PenPlatformVars* pen) {
	_OSXDestroyPen(pen.pen);
}

// View Interfacing

extern(C) void _OSXDrawViewXY(_OSXViewPlatformVars* viewVars, int fromWindow, _OSXViewPlatformVars* srcViewVars, int srcFromWindow, int x, int y, int srcX, int srcY);

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView) {
	_OSXDrawViewXY(viewVars.vars, viewVars.fromWindow == 1, viewVarsSrc.vars, viewVarsSrc.fromWindow == 1, x, y, 0, 0);
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, int viewX, int viewY) {
	_OSXDrawViewXY(viewVars.vars, viewVars.fromWindow == 1, viewVarsSrc.vars, viewVarsSrc.fromWindow == 1, x, y, viewX, viewY);
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, int viewX, int viewY, int viewWidth, int viewHeight) {
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, double opacity) {
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, int viewX, int viewY, double opacity) {
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, int viewX, int viewY, int viewWidth, int viewHeight, double opacity) {
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

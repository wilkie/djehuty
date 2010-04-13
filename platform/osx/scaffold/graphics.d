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
void drawLine(ViewPlatformVars* viewVars, int x, int y, int x2, int y2) {
}

// Draw a rectangle (filled with the current brush, outlined with current pen)
void drawRect(ViewPlatformVars* viewVars, int x, int y, int width, int height) {
}

void fillRect(ViewPlatformVars* viewVars, int x, int y, int width, int height) {
}

void strokeRect(ViewPlatformVars* viewVars, int x, int y, int width, int height) {
}

// Draw an ellipse (filled with current brush, outlined with current pen)
void drawOval(ViewPlatformVars* viewVars, int x, int y, int width, int height) {
}

void fillOval(ViewPlatformVars* viewVars, int x, int y, int width, int height) {
}

void strokeOval(ViewPlatformVars* viewVars, int x, int y, int width, int height) {
}

void drawPie(ViewPlatformVars* viewVars, int x, int y, int width, int height, double startAngle, double sweepAngle) {
}

void fillPie(ViewPlatformVars* viewVars, int x, int y, int width, int height, double startAngle, double sweepAngle) {
}

void strokePie(ViewPlatformVars* viewVars, int x, int y, int width, int height, double startAngle, double sweepAngle) {
}


// Fonts

//void createFont(ViewPlatformVars* viewVars, out Font font, string fontname, int fontsize, int weight, bool italic, bool underline, bool strikethru)
void createFont(FontPlatformVars* font, string fontname, int fontsize, int weight, bool italic, bool underline, bool strikethru) {
}

void setFont(ViewPlatformVars* viewVars, FontPlatformVars* font)
{
}

void destroyFont(FontPlatformVars* font)
{
}



// Text

void drawText(ViewPlatformVars* viewVars, int x, int y, string str)
{
}

void drawText(ViewPlatformVars* viewVars, int x, int y, string str, uint length)
{
}

// Clipped Text
void drawClippedText(ViewPlatformVars* viewVars, int x, int y, Rect region, string str)
{
}

void drawClippedText(ViewPlatformVars* viewVars, int x, int y, Rect region, string str, uint length)
{
}

// Text Measurement
void measureText(ViewPlatformVars* viewVars, string str, out Size sz)
{
}

void measureText(ViewPlatformVars* viewVars, string str, uint length, out Size sz)
{
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

void createBrush(BrushPlatformVars* brush, ref Color clr) {
}

void setBrush(ViewPlatformVars* viewVars, BrushPlatformVars* brush) {
}

void destroyBrush(BrushPlatformVars* brush) {
}

// BitmapBrush

void createBitmapBrush(BrushPlatformVars* brush, ref ViewPlatformVars viewVarsSrc) {
}

void createGradientBrush(BrushPlatformVars* brush, double origx, double origy, double[] points, Color[] clrs, double angle, double width) {
}

// Pens

void createPen(PenPlatformVars* pen, ref Color clr, double width) {
}

void createPenWithBrush(PenPlatformVars* pen, ref BrushPlatformVars brush, double width) {
}

void setPen(ViewPlatformVars* viewVars, PenPlatformVars* pen) {
}

void destroyPen(PenPlatformVars* pen) {
}

// View Interfacing

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView) {
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, int viewX, int viewY) {
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

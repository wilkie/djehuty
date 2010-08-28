/*
 * graphics.d
 *
 * This file implements the Scaffold for platform specific Graphics
 * operations in Windows.
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.graphics;

pragma(lib, "gdi32.lib");

import graphics.region;
import graphics.view;
import graphics.canvas;
import graphics.brush;
import graphics.pen;

import binding.c;

import platform.vars.view;
import platform.vars.canvas;
import platform.vars.path;
import platform.vars.brush;
import platform.vars.font;
import platform.vars.pen;
import platform.vars.region;

import math.cos;
import math.sin;

import Gdiplus = binding.win32.gdiplus;

import core.string;
import core.color;
import core.main;
import core.definitions;
import core.unicode;

import platform.win.main;

import binding.win32.wingdi;
import binding.win32.winuser;
import binding.win32.windef;
import binding.win32.winbase;

import io.console;

import math.common;
/*
CanvasPlatformVars* canvasPlatformVars(Canvas view, CanvasPlatformVars* vars) {
	static CanvasPlatformVars*[Canvas] _canvasTable;

	if (vars is null) {
		return _canvasTable[view];
	}
	else {
		_canvasTable[view] = vars;
	}
}

BrushPlatformVars* brushPlatformVars(Brush brush, BrushPlatformVars* vars) {
	static BrushPlatformVars*[Brush] _brushTable;

	if (vars is null) {
		return _brushTable[brush];
	}
	else {
		_brushTable[brush] = vars;
	}
}

PenPlatformVars* penPlatformVars(Pen pen, PenPlatformVars* vars) {
	static PenPlatformVars*[Pen] _penTable;

	if (vars is null) {
		return _penTable[pen];
	}
	else {
		_penTable[pen] = vars;
	}
}
*/

// Shapes

// Draw a line
void drawLine(ViewPlatformVars* viewVars, int x, int y, int x2, int y2) {
	//Gdiplus.GdipDrawLineI(viewVars.g, viewVars.curPen, x, y, x2, y2);
}

void fillRect(CanvasPlatformVars* viewVars, double x, double y, double width, double height) {
	//width--;
	//height--;
	Gdiplus.GdipFillRectangle(viewVars.g, viewVars.curBrush, x, y, width, height);
}

void strokeRect(CanvasPlatformVars* viewVars, double x, double y, double width, double height) {
	width--;
	height--;
	Gdiplus.GdipDrawRectangle(viewVars.g, viewVars.curPen, x, y, width, height);
}

// Draw a rectangle (filled with the current brush, outlined with current pen)
void drawRect(CanvasPlatformVars* viewVars, double x, double y, double width, double height) {
	width--;
	height--;
	Gdiplus.GdipFillRectangle(viewVars.g, viewVars.curBrush, x, y, width, height);
	Gdiplus.GdipDrawRectangle(viewVars.g, viewVars.curPen, x, y, width, height);
}

void fillOval(CanvasPlatformVars* viewVars, double x, double y, double width, double height) {
	width--;
	height--;
	Gdiplus.GdipFillEllipse(viewVars.g, viewVars.curBrush, x, y, width, height);
}

void strokeOval(CanvasPlatformVars* viewVars, double x, double y, double width, double height) {
	width--;
	height--;
	Gdiplus.GdipDrawEllipse(viewVars.g, viewVars.curPen, x, y, width, height);
}

// Draw an ellipse (filled with current brush, outlined with current pen)
void drawOval(CanvasPlatformVars* viewVars, double x, double y, double width, double height) {
	width--;
	height--;
	Gdiplus.GdipFillEllipse(viewVars.g, viewVars.curBrush, x, y, width, height);
	Gdiplus.GdipDrawEllipse(viewVars.g, viewVars.curPen, x, y, width, height);
}

void drawPie(ViewPlatformVars* viewVars, int x, int y, int width, int height, double startAngle, double sweepAngle) {
	width--;
	height--;
	Gdiplus.GdipFillPieI(viewVars.g, viewVars.curBrush, x, y, width, height, startAngle, sweepAngle);
	Gdiplus.GdipDrawPieI(viewVars.g, viewVars.curPen, x, y, width, height, startAngle, sweepAngle);
}

void fillPie(ViewPlatformVars* viewVars, int x, int y, int width, int height, double startAngle, double sweepAngle) {
	width--;
	height--;
	Gdiplus.GdipFillPieI(viewVars.g, viewVars.curBrush, x, y, width, height, startAngle, sweepAngle);
}

void strokePie(ViewPlatformVars* viewVars, int x, int y, int width, int height, double startAngle, double sweepAngle) {
	width--;
	height--;
	Gdiplus.GdipDrawPieI(viewVars.g, viewVars.curPen, x, y, width, height, startAngle, sweepAngle);
}

// Text
void drawText(CanvasPlatformVars* viewVars, double x, double y, string str) {
	wstring utf16 = Unicode.toUtf16(str);

	Gdiplus.GpPath* path;
	Gdiplus.GdipCreatePath(Gdiplus.FillMode.FillModeAlternate, &path);

	Gdiplus.RectF rect = Gdiplus.RectF(x, y, 0.0f, 0.0f);

	Gdiplus.GdipAddPathString(path, utf16.ptr, utf16.length, viewVars.curFont.family,
		viewVars.curFont.style, viewVars.curFont.fontsize, &rect,
		null);

	Gdiplus.GdipFillPath(viewVars.g, viewVars.curBrush, path);
	Gdiplus.GdipDrawPath(viewVars.g, viewVars.curPen, path);
	Gdiplus.GdipDeletePath(path);
}

void strokeText(CanvasPlatformVars* viewVars, double x, double y, string str) {
	wstring utf16 = Unicode.toUtf16(str);

	Gdiplus.GpPath* path;
	Gdiplus.GdipCreatePath(Gdiplus.FillMode.FillModeAlternate, &path);

	Gdiplus.RectF rect = Gdiplus.RectF(x, y, 0.0f, 0.0f);

	Gdiplus.GdipAddPathString(path, utf16.ptr, utf16.length, viewVars.curFont.family,
		viewVars.curFont.style, viewVars.curFont.fontsize, &rect,
		null);

	Gdiplus.GdipDrawPath(viewVars.g, viewVars.curPen, path);
	Gdiplus.GdipDeletePath(path);
}

void fillText(CanvasPlatformVars* viewVars, double x, double y, string str) {
	wstring utf16 = Unicode.toUtf16(str);

	Gdiplus.GpPath* path;
	Gdiplus.GdipCreatePath(Gdiplus.FillMode.FillModeAlternate, &path);

	Gdiplus.RectF rect = Gdiplus.RectF(x, y, 0.0f, 0.0f);

	Gdiplus.GdipAddPathString(path, utf16.ptr, utf16.length, viewVars.curFont.family,
		viewVars.curFont.style, viewVars.curFont.fontsize, &rect,
		null);

	Gdiplus.GdipFillPath(viewVars.g, viewVars.curBrush, path);
	Gdiplus.GdipDeletePath(path);
}

// Clipped Text
void drawClippedText(ViewPlatformVars* viewVars, int x, int y, Rect region, string str) {
	wstring utf16 = Unicode.toUtf16(str);
	ExtTextOutW(viewVars.dc, x,y, ETO_CLIPPED, cast(RECT*)&region, utf16.ptr, utf16.length, null);
}

void drawClippedText(ViewPlatformVars* viewVars, int x, int y, Rect region, string str, uint length) {
	wstring utf16 = Unicode.toUtf16(str);
	ExtTextOutW(viewVars.dc, x,y, ETO_CLIPPED, cast(RECT*)&region, utf16.ptr, length, null);
}

// Text Measurement
void measureText(FontPlatformVars* fontVars, string str, out Size sz) {
	wstring utf16 = Unicode.toUtf16(str) ~ cast(wchar)'\0';

	if (fontVars.g is null) {
		HDC dc = GetDC(null);
        Gdiplus.GdipCreateFromHDC(dc, &fontVars.g);
        ReleaseDC(null, dc);
	}

	Gdiplus.RectF rect = Gdiplus.RectF(0.0f, 0.0f, 0.0f, 0.0f);
	Gdiplus.RectF result;
	Gdiplus.GdipMeasureString(fontVars.g, utf16.ptr, utf16.length-1,
		fontVars.handle, &rect, null, &result, null, null);
	sz.x = cast(uint)result.Width;
	sz.y = cast(uint)result.Height;
}

void measureText(CanvasPlatformVars* viewVars, string str, out Size sz) {
	wstring utf16 = Unicode.toUtf16(str) ~ cast(wchar)'\0';
	//GetTextExtentPoint32W(viewVars.dc, utf16.ptr, utf16.length, cast(SIZE*)&sz) ;
	Gdiplus.RectF rect = Gdiplus.RectF(0.0f, 0.0f, 0.0f, 0.0f);
	Gdiplus.RectF result;
	Gdiplus.GdipMeasureString(viewVars.g, utf16.ptr, utf16.length-1,
		viewVars.curFont.handle, &rect, null, &result, null, null);
	sz.x = cast(uint)result.Width;
	sz.y = cast(uint)result.Height;
}

void measureText(ViewPlatformVars* viewVars, string str, uint length, out Size sz) {
/*	wstring utf16 = Unicode.toUtf16(str) ~ cast(wchar)'\0';
	//GetTextExtentPoint32W(viewVars.dc, utf16.ptr, length, cast(SIZE*)&sz);
	Gdiplus.RectF rect = Gdiplus.RectF(0.0f, 0.0f, 0.0f, 0.0f);
	Gdiplus.RectF result;
	Gdiplus.GdipMeasureString(viewVars.g, utf16.ptr, length,
		viewVars.curFont.handle, &rect, null, &result, null, null);
	sz.x = cast(uint)result.Width;
	sz.y = cast(uint)result.Height;*/
}

// Text Colors
void setTextBackgroundColor(ViewPlatformVars* viewVars, in Color textColor) {
	SetBkColor(viewVars.dc, _colorToInt(textColor));
}

void setTextColor(ViewPlatformVars* viewVars, in Color textColor) {
	Gdiplus.GdipCreateSolidFill(_colorToInt(textColor), &viewVars.curTextBrush);
}

// Text States

void setTextModeTransparent(ViewPlatformVars* viewVars) {
	SetBkMode(viewVars.dc, TRANSPARENT);
}

void setTextModeOpaque(ViewPlatformVars* viewVars) {
	SetBkMode(viewVars.dc, OPAQUE);
}

// Graphics States

void setAntialias(CanvasPlatformVars* viewVars, bool value) {
	viewVars.aa = value;
	if (viewVars.aa) {
		Gdiplus.GdipSetSmoothingMode(viewVars.g, Gdiplus.SmoothingMode.SmoothingModeAntiAlias);
	}
	else {
		Gdiplus.GdipSetSmoothingMode(viewVars.g, Gdiplus.SmoothingMode.SmoothingModeDefault);
	}
}


// Fonts
void createFont(FontPlatformVars* font, string fontname, int fontsize, int weight, bool italic, bool underline, bool strikethru) {
	// Create family
	wstring utf16 = Unicode.toUtf16(fontname) ~ cast(wchar)'\0';
	Gdiplus.GdipCreateFontFamilyFromName(utf16.ptr, null, &font.family);

	font.fontsize = fontsize;

	bool bold = false;
	if (weight > 600) {
		bold = true;
	}

	if (bold) {
		font.style |= Gdiplus.FontStyle.FontStyleBold;
	}

	if (italic) {
		font.style |= Gdiplus.FontStyle.FontStyleItalic;
	}

	if (underline) {
		font.style |= Gdiplus.FontStyle.FontStyleUnderline;
	}

	if (strikethru) {
		font.style |= Gdiplus.FontStyle.FontStyleStrikeout;
	}

	// Create font
    Gdiplus.GdipCreateFont(font.family, font.fontsize, font.style, Gdiplus.Unit.UnitPixel, &font.handle);
}

void setFont(CanvasPlatformVars* viewVars, FontPlatformVars* font) {
	viewVars.curFont = *font;
	//SelectObject(viewVars.dc, font.fontHandle);
}

void destroyFont(FontPlatformVars* font) {
	Gdiplus.GdipDeleteFontFamily(font.family);
	Gdiplus.GdipDeleteFont(font.handle);
	Gdiplus.GdipDeleteGraphics(font.g);
	//DeleteObject(font.fontHandle);
}

// Paths
void createPath(PathPlatformVars* path) {
	Gdiplus.GdipCreatePath(Gdiplus.FillMode.FillModeAlternate, &path.path);
}

void pathAddArc(PathPlatformVars* path, double left, double top, double width, double height, double direction, double sweep) {
	width--;
	height--;
	Gdiplus.GdipAddPathArc(path.path, left, top, width, height, direction, sweep);
}

void pathAddRectangle(PathPlatformVars* path, double left, double top, double width, double height) {
	width--;
	height--;
	Gdiplus.GdipAddPathRectangle(path.path, left, top, width, height);
}

void pathAddLine(PathPlatformVars* path, double x1, double y1, double x2, double y2) {
	Gdiplus.GdipAddPathLine(path.path, x1, y2, x2, y2);
}

void pathClose(PathPlatformVars* path) {
	Gdiplus.GdipClosePathFigures(path.path);
}

void destroyPath(PathPlatformVars* path) {
	Gdiplus.GdipDeletePath(path.path);
}

void drawPath(CanvasPlatformVars* viewVars, PathPlatformVars* path) {
	Gdiplus.GdipFillPath(viewVars.g, viewVars.curBrush, path.path);
	Gdiplus.GdipDrawPath(viewVars.g, viewVars.curPen, path.path);
}

void fillPath(CanvasPlatformVars* viewVars, PathPlatformVars* path) {
	Gdiplus.GdipFillPath(viewVars.g, viewVars.curBrush, path.path);
}

void strokePath(CanvasPlatformVars* viewVars, PathPlatformVars* path) {
	Gdiplus.GdipDrawPath(viewVars.g, viewVars.curPen, path.path);
}

// Brushes

void createBrush(BrushPlatformVars* brush, in Color clr) {
	Gdiplus.GdipCreateSolidFill(_colorToInt(clr), &brush.handle);
}

void setBrush(CanvasPlatformVars* viewVars, BrushPlatformVars* brush) {
	viewVars.curBrush = brush.handle;
	//SelectObject(viewVars.dc, brush.brushHandle);
}

void setBrush(ViewPlatformVars* viewVars, BrushPlatformVars* brush) {
	viewVars.curBrush = brush.handle;
	//SelectObject(viewVars.dc, brush.brushHandle);
}

void destroyBrush(BrushPlatformVars* brush) {
	//DeleteObject(brush.brushHandle);
    Gdiplus.GdipDeleteBrush(brush.handle);
}

// BitmapBrush

void createBitmapBrush(BrushPlatformVars* brush, ref ViewPlatformVars viewVarsSrc) {
	Gdiplus.GdipCreateTexture(viewVarsSrc.image, Gdiplus.WrapMode.WrapModeTile, &brush.handle);
}

private int _colorToInt(Color clr) {
	int value;
	int r,g,b,a;
	r = cast(int)(clr.red * 255.0);
	g = cast(int)(clr.green * 255.0);
	b = cast(int)(clr.blue * 255.0);
	a = cast(int)(clr.alpha * 255.0);

	value = (a << 24) | (b << 0) | (g << 8) | (r << 16);
	return value;
}

// PathBrush

void createGradientBrush(BrushPlatformVars* brush, double origx, double origy, double[] points, Color[] clrs, double angle, double width) {
	Gdiplus.PointF pt1 = {origx + 0.0, origy + 0.0};
	Gdiplus.PointF pt2 = {origx + width, origy + 0.0};
	INT clr1 = 0xFF808080;
	INT clr2 = 0xFFFFFFFF;

	if (points.length == 1) {
		clr1 = _colorToInt(clrs[0]);
		clr2 = _colorToInt(clrs[0]);
	}
	else if (points.length > 1) {
		clr1 = _colorToInt(clrs[0]);
		clr2 = _colorToInt(clrs[$-1]);

		//
		// use these 1d points and the angle to
		// get the 2d point...
		//			it is not magic, it is trig.
		//

		pt2.X = origx + (cos(angle) * width);
		pt2.Y = origy + (sin(angle) * width);
	}
	Gdiplus.GdipCreateLineBrush(&pt1, &pt2, clr1, clr2, Gdiplus.WrapMode.WrapModeTile, &brush.handle);
	if (points.length > 2) {
		// Interpolate MORE colors!!!
		Gdiplus.ARGB[] argbs = new Gdiplus.ARGB[points.length];
		Gdiplus.REAL[] blendPositions = new Gdiplus.REAL[points.length];
		INT count = clrs.length;
		for (size_t i = 0; i < count; i++) {
			argbs[i] = _colorToInt(clrs[i]);
			blendPositions[i] = points[i];
		}
		Gdiplus.GdipSetLinePresetBlend(brush.handle, argbs.ptr, blendPositions.ptr, count);
	}
}

// Pens

void createPen(PenPlatformVars* pen, in Color clr, double width) {
    Gdiplus.GdipCreatePen1(_colorToInt(clr), width, Gdiplus.Unit.UnitWorld, &pen.handle);
	//pen.penHandle = platform.win.common.CreatePen(0,1,pen.clr);
}

void createPenWithBrush(PenPlatformVars* pen, ref BrushPlatformVars brushVars, double width) {
	Gdiplus.GdipCreatePen2(brushVars.handle, width, Gdiplus.Unit.UnitWorld, &pen.handle);
}

void setPen(CanvasPlatformVars* viewVars, PenPlatformVars* pen) {
	viewVars.curPen = pen.handle;
	viewVars.penClr = pen.clr;
	//SelectObject(viewVars.dc, pen.penHandle);
}

void setPen(ViewPlatformVars* viewVars, PenPlatformVars* pen) {
	viewVars.curPen = pen.handle;
	viewVars.penClr = pen.clr;
	//SelectObject(viewVars.dc, pen.penHandle);
}

void destroyPen(PenPlatformVars* pen) {
	//DeleteObject(pen.penHandle);
	Gdiplus.GdipDeletePen(pen.handle);
	pen.handle = null;
}

// View Interfacing

void drawCanvas(CanvasPlatformVars* CanvasVars, Canvas canvas, double x, double y, CanvasPlatformVars* CanvasVarsSrc, Canvas srcCanvas) {
	Gdiplus.GdipDrawImage(CanvasVars.g, CanvasVarsSrc.image, x, y);
}

void drawCanvas(CanvasPlatformVars* CanvasVars, Canvas canvas, double x, double y, CanvasPlatformVars* CanvasVarsSrc, Canvas srcCanvas, double CanvasX, double CanvasY) {
	Gdiplus.GdipDrawImagePointRect(CanvasVars.g, CanvasVarsSrc.image, x, y, CanvasX, CanvasY, srcCanvas.width(), srcCanvas.height(), Gdiplus.Unit.UnitPixel);
}

void drawCanvas(CanvasPlatformVars* CanvasVars, Canvas canvas, double x, double y, CanvasPlatformVars* CanvasVarsSrc, Canvas srcCanvas, double CanvasX, double CanvasY, double CanvasWidth, double CanvasHeight) {
	Gdiplus.GdipDrawImagePointRect(CanvasVars.g, CanvasVarsSrc.image, x, y, CanvasX, CanvasY, CanvasWidth, CanvasHeight, Gdiplus.Unit.UnitPixel);
}

void drawCanvas(CanvasPlatformVars* CanvasVars, Canvas canvas, double x, double y, CanvasPlatformVars* CanvasVarsSrc, Canvas srcCanvas, double opacity) {
	static Gdiplus.ColorMatrix cm;
	cm.m[3][3] = cast(Gdiplus.REAL)opacity;

	Gdiplus.GpImageAttributes* ia;
	Gdiplus.GdipCreateImageAttributes(&ia);
	Gdiplus.GdipSetImageAttributesColorMatrix(ia, Gdiplus.ColorAdjustType.ColorAdjustTypeBitmap,
		TRUE, &cm, null, Gdiplus.ColorMatrixFlags.ColorMatrixFlagsDefault);

	Gdiplus.GdipDrawImageRectRect(CanvasVars.g, CanvasVarsSrc.image, x, y, srcCanvas.width, srcCanvas.height,
		0, 0, srcCanvas.width, srcCanvas.height, Gdiplus.Unit.UnitPixel, ia, null, null);

	Gdiplus.GdipDisposeImageAttributes(ia);
}

void drawCanvas(CanvasPlatformVars* CanvasVars, Canvas canvas, double x, double y, CanvasPlatformVars* CanvasVarsSrc, Canvas srcCanvas, double CanvasX, double CanvasY, double opacity) {
	static Gdiplus.ColorMatrix cm;
	cm.m[3][3] = cast(Gdiplus.REAL)opacity;

	Gdiplus.GpImageAttributes* ia;
	Gdiplus.GdipCreateImageAttributes(&ia);
	Gdiplus.GdipSetImageAttributesColorMatrix(ia, Gdiplus.ColorAdjustType.ColorAdjustTypeBitmap,
		TRUE, &cm, null, Gdiplus.ColorMatrixFlags.ColorMatrixFlagsDefault);

	Gdiplus.GdipDrawImageRectRect(CanvasVars.g, CanvasVarsSrc.image, x, y, srcCanvas.width, srcCanvas.height,
		CanvasX, CanvasY, srcCanvas.width, srcCanvas.height, Gdiplus.Unit.UnitPixel, ia, null, null);

	Gdiplus.GdipDisposeImageAttributes(ia);
}

void drawCanvas(CanvasPlatformVars* CanvasVars, Canvas canvas, double x, double y, CanvasPlatformVars* CanvasVarsSrc, Canvas srcCanvas, double CanvasX, double CanvasY, double CanvasWidth, double CanvasHeight, double opacity) {
	static Gdiplus.ColorMatrix cm;
	cm.m[3][3] = cast(Gdiplus.REAL)opacity;

	Gdiplus.GpImageAttributes* ia;
	Gdiplus.GdipCreateImageAttributes(&ia);
	Gdiplus.GdipSetImageAttributesColorMatrix(ia, Gdiplus.ColorAdjustType.ColorAdjustTypeBitmap,
		TRUE, &cm, null, Gdiplus.ColorMatrixFlags.ColorMatrixFlagsDefault);

	Gdiplus.GdipDrawImageRectRect(CanvasVars.g, CanvasVarsSrc.image, x, y, CanvasWidth, CanvasHeight,
		CanvasX, CanvasY, CanvasWidth, CanvasHeight, Gdiplus.Unit.UnitPixel, ia, null, null);

	Gdiplus.GdipDisposeImageAttributes(ia);
}

void _createRegion(RegionPlatformVars* rgnVars, Region rgn, int x, int y) {
	// destroy old region data
	if (rgnVars.regionHandle !is null) {
		DeleteObject(rgnVars.regionHandle);
	}

	// compute a platform graphics api version of the region
	POINT[] pts = new POINT[](rgn.length);

	foreach(i, pt; rgn) {
		pts[i].x = cast(int)pt.x + x;
		pts[i].y = cast(int)pt.y + y;
	}

	// call the platform to create a region object from the points
	rgnVars.regionHandle = CreatePolygonRgn(pts.ptr, rgn.length, ALTERNATE);
}

void fillRegion(ViewPlatformVars* viewVars, RegionPlatformVars* rgnVars, bool rgnPlatformDirty, Region rgn, int x, int y) {
	if (rgnPlatformDirty) {
		_createRegion(rgnVars, rgn, x, y);
	}

	// paint the region
	PaintRgn(viewVars.dc, rgnVars.regionHandle);
}

void strokeRegion(ViewPlatformVars* viewVars, RegionPlatformVars* rgnVars, bool rgnPlatformDirty, Region rgn, int x, int y) {
	if (rgnPlatformDirty) {
		_createRegion(rgnVars, rgn, x, y);
	}

	// frame the region
	HBRUSH brsh = CreateSolidBrush(viewVars.penClr);
	FrameRgn(viewVars.dc, rgnVars.regionHandle, brsh, 1, 1);
	DeleteObject(brsh);
}

void drawRegion(ViewPlatformVars* viewVars, RegionPlatformVars* rgnVars, bool rgnPlatformDirty, Region rgn, int x, int y) {
	if (rgnPlatformDirty) {
		_createRegion(rgnVars, rgn, x, y);
	}

	// paint and frame the region
	PaintRgn(viewVars.dc, rgnVars.regionHandle);
	HBRUSH brsh = CreateSolidBrush(viewVars.penClr);
	FrameRgn(viewVars.dc, rgnVars.regionHandle, brsh, 1, 1);
	DeleteObject(brsh);
}

void save(CanvasPlatformVars* viewVars, long* state) {
	int ret;
	Gdiplus.GdipSaveGraphics(viewVars.g, cast(Gdiplus.GraphicsState*)&ret);
	*state = ret;
}

void restore(CanvasPlatformVars* viewVars, long state) {
	int ret = cast(int)state;
	Gdiplus.GdipRestoreGraphics(viewVars.g, cast(Gdiplus.GraphicsState)ret);
}

void clipSave(CanvasPlatformVars* viewVars) {
	Gdiplus.GpRegion* region;
	Gdiplus.GdipCreateRegion(&region);
	Gdiplus.GdipGetClip(viewVars.g, region);
	viewVars.clipRegions.push(region);
}

void clipRestore(CanvasPlatformVars* viewVars) {
	Gdiplus.GpRegion* region;

	if (!viewVars.clipRegions.empty) {
		region = viewVars.clipRegions.pop();
		Gdiplus.GdipSetClipRegion(viewVars.g, region, Gdiplus.CombineMode.CombineModeReplace);
		Gdiplus.GdipDeleteRegion(region);
	}
}

void clipClear(CanvasPlatformVars* viewVars) {
	Gdiplus.GdipResetClip(viewVars.g);
}

void clipRect(CanvasPlatformVars* viewVars, double x, double y, double width, double height) {
	Gdiplus.GdipSetClipRect(viewVars.g,
		x, y, width, height, Gdiplus.CombineMode.CombineModeIntersect);
}

void clipPath(CanvasPlatformVars* viewVars, PathPlatformVars* path) {
	Gdiplus.GdipSetClipPath(viewVars.g,
		path.path, Gdiplus.CombineMode.CombineModeIntersect);
}

void clipRegion(ViewPlatformVars* viewVars, Region region) {
}

void resetWorld(CanvasPlatformVars* viewVars) {
	Gdiplus.GdipResetWorldTransform(viewVars.g);
}

void translateWorld(CanvasPlatformVars* viewVars, double x, double y) {
	Gdiplus.GdipTranslateWorldTransform(viewVars.g, x, y, Gdiplus.MatrixOrder.MatrixOrderPrepend);
}

void scaleWorld(CanvasPlatformVars* viewVars, double x, double y) {
	Gdiplus.GdipScaleWorldTransform(viewVars.g, x, y, Gdiplus.MatrixOrder.MatrixOrderPrepend);
}

void rotateWorld(CanvasPlatformVars* viewVars, double angle) {
	// needs to be in degrees (for some reason)
	angle = (angle / 3.14159265) * 180.0;
	Gdiplus.GdipRotateWorldTransform(viewVars.g, angle, Gdiplus.MatrixOrder.MatrixOrderPrepend);
}

void saveWorld(CanvasPlatformVars* viewVars) {
	Gdiplus.GpMatrix* matrix;
	Gdiplus.GdipCreateMatrix(&matrix);
	Gdiplus.GdipGetWorldTransform(viewVars.g, matrix);
	viewVars.transformMatrices.push(matrix);
}

void restoreWorld(CanvasPlatformVars* viewVars) {
	Gdiplus.GpMatrix* matrix;

	if (!viewVars.transformMatrices.empty) {
		matrix = viewVars.transformMatrices.pop();
		Gdiplus.GdipSetWorldTransform(viewVars.g, matrix);
		Gdiplus.GdipDeleteMatrix(matrix);
	}
}
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

import graphics.view;

import platform.vars.view;
import platform.vars.brush;
import platform.vars.font;
import platform.vars.pen;
import platform.vars.region;

import Gdiplus = binding.win32.gdiplus;

import core.tostring;
import core.string;
import core.color;
import core.main;
import core.definitions;
import core.unicode;

import graphics.region;

import platform.win.main;
import platform.win.common;

import io.console;

import math.common;

// Shapes

// Draw a line
void drawLine(ViewPlatformVars* viewVars, int x, int y, int x2, int y2) {
	//MoveToEx(viewVars.dc, x, y, null);
	//LineTo(viewVars.dc, x2, y2);

	Gdiplus.GdipDrawLineI(viewVars.g, viewVars.curPen, x, y, x2, y2);
}

void fillRect(ViewPlatformVars* viewVars, int x, int y, int width, int height) {
	//width--;
	//height--;
	Gdiplus.GdipFillRectangleI(viewVars.g, viewVars.curBrush, x, y, width, height);
}

void strokeRect(ViewPlatformVars* viewVars, int x, int y, int width, int height) {
	width--;
	height--;
	Gdiplus.GdipDrawRectangleI(viewVars.g, viewVars.curPen, x, y, width, height);
}

// Draw a rectangle (filled with the current brush, outlined with current pen)
void drawRect(ViewPlatformVars* viewVars, int x, int y, int width, int height) {
	width--;
	height--;
	Gdiplus.GdipFillRectangleI(viewVars.g, viewVars.curBrush, x, y, width, height);
	Gdiplus.GdipDrawRectangleI(viewVars.g, viewVars.curPen, x, y, width, height);
}

void fillOval(ViewPlatformVars* viewVars, int x, int y, int width, int height) {
	width--;
	height--;
	Gdiplus.GdipFillEllipseI(viewVars.g, viewVars.curBrush, x, y, width, height);
}

void strokeOval(ViewPlatformVars* viewVars, int x, int y, int width, int height) {
	width--;
	height--;
	Gdiplus.GdipDrawEllipseI(viewVars.g, viewVars.curPen, x, y, width, height);
}

// Draw an ellipse (filled with current brush, outlined with current pen)
void drawOval(ViewPlatformVars* viewVars, int x, int y, int width, int height) {
	width--;
	height--;
	Gdiplus.GdipFillEllipseI(viewVars.g, viewVars.curBrush, x, y, width, height);
	Gdiplus.GdipDrawEllipseI(viewVars.g, viewVars.curPen, x, y, width, height);
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
void drawText(ViewPlatformVars* viewVars, int x, int y, String str) {
	str = new String(str);
	str.appendChar('\0');

	Gdiplus.RectF rect = Gdiplus.RectF(x, y, 0.0f, 0.0f);
    Gdiplus.GdipDrawString(viewVars.g, str.ptr, str.array.length-1, viewVars.curFont, &rect, null, viewVars.curTextBrush);
	//TextOutW(viewVars.dc, x, y, str.ptr, str.length-1);
}

void drawText(ViewPlatformVars* viewVars, int x, int y, string str) {
	wstring utf16 = Unicode.toUtf16(str ~ '\0');

	Gdiplus.RectF rect = Gdiplus.RectF(x, y, 0.0f, 0.0f);
    Gdiplus.GdipDrawString(viewVars.g, utf16.ptr, utf16.length-1, viewVars.curFont, &rect, null, viewVars.curTextBrush);
	//TextOutW(viewVars.dc, x, y, utf16.ptr, utf16.length-1);
}

void drawText(ViewPlatformVars* viewVars, int x, int y, String str, uint length) {
	str = new String(str);
	str.appendChar('\0');

	Gdiplus.RectF rect = Gdiplus.RectF(x, y, 0.0f, 0.0f);
    Gdiplus.GdipDrawString(viewVars.g, str.ptr, length, viewVars.curFont, &rect, null, viewVars.curTextBrush);
	//TextOutW(viewVars.dc, x, y, str.ptr, length);
}

void drawText(ViewPlatformVars* viewVars, int x, int y, string str, uint length) {
	wstring utf16 = Unicode.toUtf16(str ~ '\0');

	Gdiplus.RectF rect = Gdiplus.RectF(x, y, 0.0f, 0.0f);
    Gdiplus.GdipDrawString(viewVars.g, utf16.ptr, length, viewVars.curFont, &rect, null, viewVars.curTextBrush);
	//TextOutW(viewVars.dc, x, y, utf16.ptr, length);
}

// Clipped Text
void drawClippedText(ViewPlatformVars* viewVars, int x, int y, Rect region, String str) {
	ExtTextOutW(viewVars.dc, x,y, ETO_CLIPPED, cast(RECT*)&region, str.ptr, str.length, null);
}

void drawClippedText(ViewPlatformVars* viewVars, int x, int y, Rect region, string str) {
	wstring utf16 = Unicode.toUtf16(str);
	ExtTextOutW(viewVars.dc, x,y, ETO_CLIPPED, cast(RECT*)&region, utf16.ptr, utf16.length, null);
}

void drawClippedText(ViewPlatformVars* viewVars, int x, int y, Rect region, String str, uint length) {
	ExtTextOutW(viewVars.dc, x,y, ETO_CLIPPED, cast(RECT*)&region, str.ptr, length, null);
}

void drawClippedText(ViewPlatformVars* viewVars, int x, int y, Rect region, string str, uint length) {
	wstring utf16 = Unicode.toUtf16(str);
	ExtTextOutW(viewVars.dc, x,y, ETO_CLIPPED, cast(RECT*)&region, utf16.ptr, length, null);
}

// Text Measurement
void measureText(ViewPlatformVars* viewVars, String str, out Size sz) {
	//GetTextExtentPoint32W(viewVars.dc, str.ptr, str.length, cast(SIZE*)&sz);
	Gdiplus.RectF rect = Gdiplus.RectF(0.0f, 0.0f, 0.0f, 0.0f);
	Gdiplus.RectF result;
	Gdiplus.GdipMeasureString(viewVars.g, str.ptr, str.array.length-1,
		viewVars.curFont, &rect, null, &result, null, null);
	sz.x = cast(uint)result.Width;
	sz.y = cast(uint)result.Height;
}

void measureText(ViewPlatformVars* viewVars, String str, uint length, out Size sz) {
	//GetTextExtentPoint32W(viewVars.dc, str.ptr, length, cast(SIZE*)&sz);
	Gdiplus.RectF rect = Gdiplus.RectF(0.0f, 0.0f, 0.0f, 0.0f);
	Gdiplus.RectF result;
	Gdiplus.GdipMeasureString(viewVars.g, str.ptr, length,
		viewVars.curFont, &rect, null, &result, null, null);
	sz.x = cast(uint)result.Width;
	sz.y = cast(uint)result.Height;
}

void measureText(ViewPlatformVars* viewVars, string str, out Size sz) {
	wstring utf16 = Unicode.toUtf16(str) ~ cast(wchar)'\0';
	//GetTextExtentPoint32W(viewVars.dc, utf16.ptr, utf16.length, cast(SIZE*)&sz) ;
	Gdiplus.RectF rect = Gdiplus.RectF(0.0f, 0.0f, 0.0f, 0.0f);
	Gdiplus.RectF result;
	Gdiplus.GdipMeasureString(viewVars.g, utf16.ptr, utf16.length-1,
		viewVars.curFont, &rect, null, &result, null, null);
	sz.x = cast(uint)result.Width;
	sz.y = cast(uint)result.Height;
}

void measureText(ViewPlatformVars* viewVars, string str, uint length, out Size sz) {
	wstring utf16 = Unicode.toUtf16(str) ~ cast(wchar)'\0';
	//GetTextExtentPoint32W(viewVars.dc, utf16.ptr, length, cast(SIZE*)&sz);
	Gdiplus.RectF rect = Gdiplus.RectF(0.0f, 0.0f, 0.0f, 0.0f);
	Gdiplus.RectF result;
	Gdiplus.GdipMeasureString(viewVars.g, utf16.ptr, length,
		viewVars.curFont, &rect, null, &result, null, null);
	sz.x = cast(uint)result.Width;
	sz.y = cast(uint)result.Height;
}

// Text Colors
void setTextBackgroundColor(ViewPlatformVars* viewVars, ref Color textColor) {
	SetBkColor(viewVars.dc, ColorGetValue(textColor));
}

void setTextColor(ViewPlatformVars* viewVars, ref Color textColor) {
	//platform.win.common.SetTextColor(viewVars.dc, ColorGetValue(textColor));
	Gdiplus.GdipCreateSolidFill(textColor.value, &viewVars.curTextBrush);
}

// Text States

void setTextModeTransparent(ViewPlatformVars* viewVars) {
	SetBkMode(viewVars.dc, TRANSPARENT);
}

void setTextModeOpaque(ViewPlatformVars* viewVars) {
	SetBkMode(viewVars.dc, OPAQUE);
}

// Graphics States

void setAntialias(ViewPlatformVars* viewVars, bool value) {
	viewVars.aa = value;
	if (viewVars.aa) {
		Gdiplus.GdipSetSmoothingMode(viewVars.g, Gdiplus.SmoothingMode.SmoothingModeAntiAlias);
	}
	else {
		Gdiplus.GdipSetSmoothingMode(viewVars.g, Gdiplus.SmoothingMode.SmoothingModeDefault);
	}
}


// Fonts
import std.stdio;
void createFont(FontPlatformVars* font, string fontname, int fontsize, int weight, bool italic, bool underline, bool strikethru) {
	// Create family
	wstring utf16 = Unicode.toUtf16(fontname) ~ cast(wchar)'\0';
	Gdiplus.GdipCreateFontFamilyFromName(utf16.ptr, null, &font.family);

	Gdiplus.FontStyle style;
	bool bold = false;
	if (weight > 600) {
		bold = true;
	}

	if (bold) {
		style |= Gdiplus.FontStyle.FontStyleBold;
	}

	if (italic) {
		style |= Gdiplus.FontStyle.FontStyleItalic;
	}

	if (underline) {
		style |= Gdiplus.FontStyle.FontStyleUnderline;
	}

	if (strikethru) {
		style |= Gdiplus.FontStyle.FontStyleStrikeout;
	}

	// Create font
    Gdiplus.GdipCreateFont(font.family, fontsize, style, Gdiplus.Unit.UnitPoint, &font.handle);

//	HDC dcz = GetDC(cast(HWND)0);
//	font.fontHandle = CreateFontW(-MulDiv(fontsize, GetDeviceCaps(dcz, 90), 72),0,0,0, weight, italic, underline, strikethru, DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, PROOF_QUALITY, DEFAULT_PITCH, utf16.ptr);
//	ReleaseDC(cast(HWND)0, dcz);
}

void createFont(FontPlatformVars* font, String fontname, int fontsize, int weight, bool italic, bool underline, bool strikethru) {
	// Create family
	fontname = new String(fontname);
	fontname.appendChar('\0');
	Gdiplus.GdipCreateFontFamilyFromName(fontname.ptr, null, &font.family);

	Gdiplus.FontStyle style;
	bool bold = false;
	if (weight > 600) {
		bold = true;
	}

	if (bold) {
		style |= Gdiplus.FontStyle.FontStyleBold;
	}

	if (italic) {
		style |= Gdiplus.FontStyle.FontStyleItalic;
	}

	if (underline) {
		style |= Gdiplus.FontStyle.FontStyleUnderline;
	}

	if (strikethru) {
		style |= Gdiplus.FontStyle.FontStyleStrikeout;
	}

	// Create font
    Gdiplus.GdipCreateFont(font.family, fontsize, style, Gdiplus.Unit.UnitPoint, &font.handle);

//	HDC dcz = GetDC(cast(HWND)0);
//	font.fontHandle = CreateFontW(-MulDiv(fontsize, GetDeviceCaps(dcz, 90), 72),0,0,0, weight, italic, underline, strikethru, DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, PROOF_QUALITY, DEFAULT_PITCH, fontname.ptr);
//	ReleaseDC(cast(HWND)0, dcz);
}

void setFont(ViewPlatformVars* viewVars, FontPlatformVars* font) {
	viewVars.curFont = font.handle;
	//SelectObject(viewVars.dc, font.fontHandle);
}

void destroyFont(FontPlatformVars* font) {
	Gdiplus.GdipDeleteFontFamily(font.family);
	Gdiplus.GdipDeleteFont(font.handle);
	//DeleteObject(font.fontHandle);
}


// Brushes

void createBrush(BrushPlatformVars* brush, ref Color clr) {
	//brush.brushHandle = CreateSolidBrush(clr.value);
	Gdiplus.GdipCreateSolidFill(clr.value, &brush.handle);
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

// PathBrush

void createGradientBrush(BrushPlatformVars* brush, double origx, double origy, double[] points, Color[] clrs, double angle, double width) {
	Gdiplus.PointF pt1 = {origx + 0.0, origy + 0.0};
	Gdiplus.PointF pt2 = {origx + width, origy + 0.0};
	INT clr1 = 0xFF808080;
	INT clr2 = 0xFFFFFFFF;

	if (points.length == 1) {
		clr1 = clrs[0].value;
		clr2 = clrs[0].value;
	}
	else if (points.length > 1) {
		clr1 = clrs[0].value;
		clr2 = clrs[$-1].value;

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
			argbs[i] = clrs[i].value;
			blendPositions[i] = points[i];
		}
		Gdiplus.GdipSetLinePresetBlend(brush.handle, argbs.ptr, blendPositions.ptr, count);
	}
}

// Pens

void createPen(PenPlatformVars* pen, ref Color clr, double width) {
    Gdiplus.GdipCreatePen1(clr.value, width, Gdiplus.Unit.UnitWorld, &pen.handle);
	//pen.penHandle = platform.win.common.CreatePen(0,1,pen.clr);
}

void createPenWithBrush(PenPlatformVars* pen, ref BrushPlatformVars brushVars, double width) {
	Gdiplus.GdipCreatePen2(brushVars.handle, width, Gdiplus.Unit.UnitWorld, &pen.handle);
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

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView) {
	Gdiplus.GdipDrawImageI(viewVars.g, viewVarsSrc.image , x, y);
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, int viewX, int viewY) {
	Gdiplus.GdipDrawImagePointRectI(viewVars.g, viewVarsSrc.image, x, y, viewX, viewY, srcView.width(), srcView.height(), Gdiplus.Unit.UnitPixel);
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, int viewX, int viewY, int viewWidth, int viewHeight) {
	Gdiplus.GdipDrawImagePointRectI(viewVars.g, viewVarsSrc.image, x, y, viewX, viewY, viewWidth, viewHeight, Gdiplus.Unit.UnitPixel);
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, double opacity) {
	static Gdiplus.ColorMatrix cm;
	cm.m[3][3] = cast(Gdiplus.REAL)opacity;

	Gdiplus.GpImageAttributes* ia;
	Gdiplus.GdipCreateImageAttributes(&ia);
	Gdiplus.GdipSetImageAttributesColorMatrix(ia, Gdiplus.ColorAdjustType.ColorAdjustTypeBitmap,
		TRUE, &cm, null, Gdiplus.ColorMatrixFlags.ColorMatrixFlagsDefault);

	Gdiplus.GdipDrawImageRectRectI(viewVars.g, viewVarsSrc.image, x, y, srcView.width, srcView.height,
		0, 0, srcView.width, srcView.height, Gdiplus.Unit.UnitPixel, ia, null, null);

	Gdiplus.GdipDisposeImageAttributes(ia);
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, int viewX, int viewY, double opacity) {
	static Gdiplus.ColorMatrix cm;
	cm.m[3][3] = cast(Gdiplus.REAL)opacity;

	Gdiplus.GpImageAttributes* ia;
	Gdiplus.GdipCreateImageAttributes(&ia);
	Gdiplus.GdipSetImageAttributesColorMatrix(ia, Gdiplus.ColorAdjustType.ColorAdjustTypeBitmap,
		TRUE, &cm, null, Gdiplus.ColorMatrixFlags.ColorMatrixFlagsDefault);

	Gdiplus.GdipDrawImageRectRectI(viewVars.g, viewVarsSrc.image, x, y, srcView.width, srcView.height,
		viewX, viewY, srcView.width, srcView.height, Gdiplus.Unit.UnitPixel, ia, null, null);

	Gdiplus.GdipDisposeImageAttributes(ia);
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, int viewX, int viewY, int viewWidth, int viewHeight, double opacity) {
	static Gdiplus.ColorMatrix cm;
	cm.m[3][3] = cast(Gdiplus.REAL)opacity;

	Gdiplus.GpImageAttributes* ia;
	Gdiplus.GdipCreateImageAttributes(&ia);
	Gdiplus.GdipSetImageAttributesColorMatrix(ia, Gdiplus.ColorAdjustType.ColorAdjustTypeBitmap,
		TRUE, &cm, null, Gdiplus.ColorMatrixFlags.ColorMatrixFlagsDefault);

	Gdiplus.GdipDrawImageRectRectI(viewVars.g, viewVarsSrc.image, x, y, viewWidth, viewHeight,
		viewX, viewY, viewWidth, viewHeight, Gdiplus.Unit.UnitPixel, ia, null, null);

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
		pts[i].x = pt.x + x;
		pts[i].y = pt.y + y;
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

void clipSave(ViewPlatformVars* viewVars) {
	if (viewVars.clipRegions.length == 0) {
		viewVars.clipRegions.addItem(null);
	}
	else {
		HRGN rgn = CreateRectRgn(0,0,0,0);

		GetClipRgn(viewVars.dc, rgn);

		viewVars.clipRegions.addItem(rgn);
	}
}

void clipRestore(ViewPlatformVars* viewVars) {
	HRGN rgn;

	if (viewVars.clipRegions.remove(rgn)) {
		SelectClipRgn(viewVars.dc, rgn);

		DeleteObject(rgn);
	}
}

void clipRect(ViewPlatformVars* viewVars, int x, int y, int width, int height) {
	HRGN rgn = CreateRectRgn(x,y,width,height);

	ExtSelectClipRgn(viewVars.dc, rgn, RGN_AND);

	DeleteObject(rgn);
}

void clipRegion(ViewPlatformVars* viewVars, Region region) {
}

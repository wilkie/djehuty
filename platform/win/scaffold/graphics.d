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
pragma(lib, "msimg32.lib");
pragma(lib, "advapi32.lib");

import graphics.view;

import platform.vars.view;
import platform.vars.brush;
import platform.vars.font;
import platform.vars.pen;
import platform.vars.region;

import Gdiplus = binding.win32.gdiplus;

import core.string;
import core.color;
import core.main;
import core.definitions;
import core.unicode;

import graphics.region;

import platform.win.main;
import platform.win.common;

import io.console;

// Shapes

// Draw a line
void drawLine(ViewPlatformVars* viewVars, int x, int y, int x2, int y2) {
	//MoveToEx(viewVars.dc, x, y, null);
	//LineTo(viewVars.dc, x2, y2);

	Gdiplus.GdipDrawLineI(viewVars.g, viewVars.curPen, x, y, x2, y2);
}

void fillRect(ViewPlatformVars* viewVars, int x, int y, int x2, int y2) {
	Gdiplus.GdipFillRectangleI(viewVars.g, viewVars.curBrush, x, y, x2-x-1, y2-y-1);
}

void strokeRect(ViewPlatformVars* viewVars, int x, int y, int x2, int y2) {
	Gdiplus.GdipDrawRectangleI(viewVars.g, viewVars.curPen, x, y, x2-x-1, y2-y-1);
}

// Draw a rectangle (filled with the current brush, outlined with current pen)
void drawRect(ViewPlatformVars* viewVars, int x, int y, int x2, int y2) {
	//Rectangle(viewVars.dc, x, y, x2, y2);
	Gdiplus.GdipFillRectangleI(viewVars.g, viewVars.curBrush, x, y, x2-x-1, y2-y-1);
	Gdiplus.GdipDrawRectangleI(viewVars.g, viewVars.curPen, x, y, x2-x-1, y2-y-1);
}

void fillOval(ViewPlatformVars* viewVars, int x, int y, int x2, int y2) {
	Gdiplus.GdipFillEllipseI(viewVars.g, viewVars.curBrush, x, y, x2-x-1, y2-y-1);
}

void strokeOval(ViewPlatformVars* viewVars, int x, int y, int x2, int y2) {
	Gdiplus.GdipDrawEllipseI(viewVars.g, viewVars.curPen, x, y, x2-x-1, y2-y-1);
}

// Draw an ellipse (filled with current brush, outlined with current pen)
void drawOval(ViewPlatformVars* viewVars, int x, int y, int x2, int y2) {
	Gdiplus.GdipFillEllipseI(viewVars.g, viewVars.curBrush, x, y, x2-x-1, y2-y-1);
	Gdiplus.GdipDrawEllipseI(viewVars.g, viewVars.curPen, x, y, x2-x-1, y2-y-1);
}

void drawPie(ViewPlatformVars* viewVars, int x, int y, int x2, int y2, double startAngle, double sweepAngle) {
	Gdiplus.GdipFillPieI(viewVars.g, viewVars.curBrush, x, y, x2-x-1, y2-y-1, startAngle, sweepAngle);
	Gdiplus.GdipDrawPieI(viewVars.g, viewVars.curPen, x, y, x2-x-1, y2-y-1, startAngle, sweepAngle);
}

void fillPie(ViewPlatformVars* viewVars, int x, int y, int x2, int y2, double startAngle, double sweepAngle) {
	Gdiplus.GdipFillPieI(viewVars.g, viewVars.curBrush, x, y, x2-x-1, y2-y-1, startAngle, sweepAngle);
}

void strokePie(ViewPlatformVars* viewVars, int x, int y, int x2, int y2, double startAngle, double sweepAngle) {
	Gdiplus.GdipDrawPieI(viewVars.g, viewVars.curPen, x, y, x2-x-1, y2-y-1, startAngle, sweepAngle);
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

// Pens

void createPen(PenPlatformVars* pen, ref Color clr) {
    Gdiplus.GdipCreatePen1(clr.value, 1.0, Gdiplus.Unit.UnitWorld, &pen.handle);
	//pen.penHandle = platform.win.common.CreatePen(0,1,pen.clr);
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
	POINT[] pts = new POINT[](rgn.numPoints);

	foreach(i, pt; rgn) {
		pts[i].x = pt.x + x;
		pts[i].y = pt.y + y;
	}

	// call the platform to create a region object from the points
	rgnVars.regionHandle = CreatePolygonRgn(pts.ptr, rgn.numPoints, ALTERNATE);
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

void clipRect(ViewPlatformVars* viewVars, int x, int y, int x2, int y2) {
	HRGN rgn = CreateRectRgn(x,y,x2,y2);

	ExtSelectClipRgn(viewVars.dc, rgn, RGN_AND);

	DeleteObject(rgn);
}

void clipRegion(ViewPlatformVars* viewVars, Region region) {
}

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

import graphics.view;

import core.string;
import core.color;
import core.main;
import core.definitions;
import core.unicode;

import graphics.region;

import platform.win.main;
import platform.win.common;
import platform.win.vars;

// Shapes

// Draw a line
void drawLine(ViewPlatformVars* viewVars, int x, int y, int x2, int y2) {
	MoveToEx(viewVars.dc, x, y, null);

	LineTo(viewVars.dc, x2, y2);
}

// Draw a rectangle (filled with the current brush, outlined with current pen)
void drawRect(ViewPlatformVars* viewVars, int x, int y, int x2, int y2) {
	Rectangle(viewVars.dc, x, y, x2, y2);
}

// Draw an ellipse (filled with current brush, outlined with current pen)
void drawOval(ViewPlatformVars* viewVars, int x, int y, int x2, int y2) {
	Ellipse(viewVars.dc, x, y, x2, y2);
}

// Text
void drawText(ViewPlatformVars* viewVars, int x, int y, String str) {
	TextOutW(viewVars.dc, x, y, str.ptr, str.length);
}

void drawText(ViewPlatformVars* viewVars, int x, int y, string str) {
	wstring utf16 = Unicode.toUtf16(str);
	TextOutW(viewVars.dc, x, y, utf16.ptr, utf16.length);
}

void drawText(ViewPlatformVars* viewVars, int x, int y, String str, uint length) {
	TextOutW(viewVars.dc, x, y, str.ptr, length);
}

void drawText(ViewPlatformVars* viewVars, int x, int y, string str, uint length) {
	wstring utf16 = Unicode.toUtf16(str);
	TextOutW(viewVars.dc, x, y, utf16.ptr, length);
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
	GetTextExtentPoint32W(viewVars.dc, str.ptr, str.length, cast(SIZE*)&sz);
}

void measureText(ViewPlatformVars* viewVars, String str, uint length, out Size sz) {
	GetTextExtentPoint32W(viewVars.dc, str.ptr, length, cast(SIZE*)&sz);
}

void measureText(ViewPlatformVars* viewVars, string str, out Size sz) {
	wstring utf16 = Unicode.toUtf16(str);
	GetTextExtentPoint32W(viewVars.dc, utf16.ptr, utf16.length, cast(SIZE*)&sz);
}

void measureText(ViewPlatformVars* viewVars, string str, uint length, out Size sz) {
	wstring utf16 = Unicode.toUtf16(str);
	GetTextExtentPoint32W(viewVars.dc, utf16.ptr, length, cast(SIZE*)&sz);
}

// Text Colors
void setTextBackgroundColor(ViewPlatformVars* viewVars, ref Color textColor) {
	SetBkColor(viewVars.dc, ColorGetValue(textColor));
}

void setTextColor(ViewPlatformVars* viewVars, ref Color textColor) {
	platform.win.common.SetTextColor(viewVars.dc, ColorGetValue(textColor));
}

// Text States

void setTextModeTransparent(ViewPlatformVars* viewVars) {
	SetBkMode(viewVars.dc, TRANSPARENT);
}

void setTextModeOpaque(ViewPlatformVars* viewVars) {
	SetBkMode(viewVars.dc, OPAQUE);
}




// Fonts

void createFont(FontPlatformVars* font, string fontname, int fontsize, int weight, bool italic, bool underline, bool strikethru) {
	wstring utf16 = Unicode.toUtf16(fontname) ~ cast(wchar)'\0';
	HDC dcz = GetDC(cast(HWND)0);
	font.fontHandle = CreateFontW(-MulDiv(fontsize, GetDeviceCaps(dcz, 90), 72),0,0,0, weight, italic, underline, strikethru, DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, PROOF_QUALITY, DEFAULT_PITCH, utf16.ptr);
	ReleaseDC(cast(HWND)0, dcz);
}

void createFont(FontPlatformVars* font, String fontname, int fontsize, int weight, bool italic, bool underline, bool strikethru) {
	fontname = new String(fontname);
	fontname.appendChar('\0');
	HDC dcz = GetDC(cast(HWND)0);
	font.fontHandle = CreateFontW(-MulDiv(fontsize, GetDeviceCaps(dcz, 90), 72),0,0,0, weight, italic, underline, strikethru, DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, PROOF_QUALITY, DEFAULT_PITCH, fontname.ptr);
	ReleaseDC(cast(HWND)0, dcz);
}

void setFont(ViewPlatformVars* viewVars, FontPlatformVars* font) {
	SelectObject(viewVars.dc, font.fontHandle);
}

void destroyFont(FontPlatformVars* font) {
	DeleteObject(font.fontHandle);
}


// Brushes

void createBrush(BrushPlatformVars* brush, ref Color clr) {
	brush.brushHandle = CreateSolidBrush(ColorGetValue(clr) & 0xFFFFFF);
}

void setBrush(ViewPlatformVars* viewVars, BrushPlatformVars* brush) {
	SelectObject(viewVars.dc, brush.brushHandle);
}

void destroyBrush(BrushPlatformVars* brush) {
	DeleteObject(brush.brushHandle);
}

// Pens

void createPen(PenPlatformVars* pen, ref Color clr) {
	pen.clr = ColorGetValue(clr) & 0xFFFFFF;
	pen.penHandle = platform.win.common.CreatePen(0,1,pen.clr);
}

void setPen(ViewPlatformVars* viewVars, PenPlatformVars* pen) {
	viewVars.penClr = pen.clr;
	SelectObject(viewVars.dc, pen.penHandle);
}

void destroyPen(PenPlatformVars* pen) {
	DeleteObject(pen.penHandle);
}





// View Interfacing

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView) {
	static const BLENDFUNCTION bf = { AC_SRC_OVER, 0, 0xFF, AC_SRC_ALPHA };

	if (srcView.alpha) {
		uint viewWidth = srcView.width();
		uint viewHeight = srcView.height();
		if (x + viewWidth > view.width()) {
			viewWidth = view.width() - x;
		}

		if (y + viewHeight > view.height()) {
			viewHeight = view.height() - y;
		}
		AlphaBlend(viewVars.dc, x, y, viewWidth, viewHeight, viewVarsSrc.dc, 0,0, viewWidth, viewHeight, bf);
	}
	else {
		BitBlt(viewVars.dc, x, y, srcView.width(), srcView.height(), viewVarsSrc.dc, 0,0,SRCCOPY);
	}
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, int viewX, int viewY) {
	static const BLENDFUNCTION bf = { AC_SRC_OVER, 0, 0xFF, AC_SRC_ALPHA };

	if (srcView.alpha) {
		uint viewWidth = srcView.width();
		uint viewHeight = srcView.height();
		if (x + viewWidth > view.width()) {
			viewWidth = view.width() - x;
		}

		if (y + viewHeight > view.height()) {
			viewHeight = view.height() - y;
		}

		if (viewX + viewWidth > srcView.width()) {
			viewWidth = srcView.width() - viewX;
		}

		if (viewY + viewHeight > srcView.height()) {
			viewHeight = srcView.height() - viewY;
		}
		AlphaBlend(viewVars.dc, x, y, viewWidth, viewHeight, viewVarsSrc.dc, viewX,viewY,viewWidth, viewHeight, bf);
	}
	else {
		BitBlt(viewVars.dc, x, y, srcView.width(), srcView.height(), viewVarsSrc.dc, viewX,viewY,SRCCOPY);
	}
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, int viewX, int viewY, int viewWidth, int viewHeight) {
	static const BLENDFUNCTION bf = { AC_SRC_OVER, 0, 0xFF, AC_SRC_ALPHA };

	if (srcView.alpha) {
		if (viewWidth > srcView.width()) {
			viewWidth = srcView.width();
		}

		if (viewHeight > srcView.height()) {
			viewHeight = srcView.height();
		}

		if (x + viewWidth > view.width()) {
			viewWidth = view.width() - x;
		}

		if (y + viewHeight > view.height()) {
			viewHeight = view.height() - y;
		}

		if (viewX + viewWidth > srcView.width()) {
			viewWidth = srcView.width() - viewX;
		}

		if (viewY + viewHeight > srcView.height()) {
			viewHeight = srcView.height() - viewY;
		}
		AlphaBlend(viewVars.dc, x, y, viewWidth, viewHeight, viewVarsSrc.dc, viewX,viewY,viewWidth, viewHeight, bf);
	}
	else {
		BitBlt(viewVars.dc, x, y, viewWidth, viewHeight, viewVarsSrc.dc, viewX,viewY,SRCCOPY);
	}
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, double opacity) {
	static BLENDFUNCTION bf = { AC_SRC_OVER, 0, 0xFF, AC_SRC_ALPHA };

	bf.SourceConstantAlpha = cast(ubyte)(opacity * 255.0);


	uint viewWidth = srcView.width();
	uint viewHeight = srcView.height();
	if (x + viewWidth > view.width()) {
		viewWidth = view.width() - x;
	}

	if (y + viewHeight > view.height()) {
		viewHeight = view.height() - y;
	}
	AlphaBlend(viewVars.dc, x, y, viewWidth, viewHeight, viewVarsSrc.dc, 0,0,viewWidth, viewHeight, bf);
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, int viewX, int viewY, double opacity) {
	static BLENDFUNCTION bf = { AC_SRC_OVER, 0, 0xFF, AC_SRC_ALPHA };

	bf.SourceConstantAlpha = cast(ubyte)(opacity * 255.0);

	uint viewWidth = srcView.width();
	uint viewHeight = srcView.height();
	if (x + viewWidth > view.width()) {
		viewWidth = view.width() - x;
	}

	if (y + viewHeight > view.height()) {
		viewHeight = view.height() - y;
	}

	if (viewX + viewWidth > srcView.width()) {
		viewWidth = srcView.width() - viewX;
	}

	if (viewY + viewHeight > srcView.height()) {
		viewHeight = srcView.height() - viewY;
	}
	AlphaBlend(viewVars.dc, x, y, viewWidth, viewHeight, viewVarsSrc.dc, viewX,viewY,viewWidth, viewHeight, bf);
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, int viewX, int viewY, int viewWidth, int viewHeight, double opacity) {
	static BLENDFUNCTION bf = { AC_SRC_OVER, 0, 0xFF, AC_SRC_ALPHA };

	bf.SourceConstantAlpha = cast(ubyte)(opacity * 255.0);

	if (viewWidth > srcView.width()) {
		viewWidth = srcView.width();
	}

	if (viewHeight > srcView.height()) {
		viewHeight = srcView.height();
	}

	if (x + viewWidth > view.width()) {
		viewWidth = view.width() - x;
	}

	if (y + viewHeight > view.height()) {
		viewHeight = view.height() - y;
	}

	if (viewX + viewWidth > srcView.width()) {
		viewWidth = srcView.width() - viewX;
	}

	if (viewY + viewHeight > srcView.height()) {
		viewHeight = srcView.height() - viewY;
	}

	AlphaBlend(viewVars.dc, x, y, viewWidth, viewHeight, viewVarsSrc.dc, viewX,viewY,viewWidth, viewHeight, bf);
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

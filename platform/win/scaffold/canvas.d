/*
 * canvas.d
 *
 * This file implements the Scaffold for platform specific Canvas
 * operations in Windows.
 *
 */

module scaffold.canvas;

import binding.win32.wingdi;
import binding.win32.winnt;
import binding.win32.windef;
import binding.win32.winuser;

import platform.win.main;

import Gdiplus = binding.win32.gdiplus;

import platform.vars.canvas;
import platform.vars.window;

import gui.window;

import graphics.canvas;
//import graphics.graphics;
//import graphics.bitmap;

import core.string;
import core.main;
import core.definitions;

import data.queue;

import io.console;

// views
void CanvasCreate(Canvas view, CanvasPlatformVars*viewVars) {
	viewVars.clipRegions = new _clipList();

	viewVars.length = (view.width() * view.height()) * 4;

	Gdiplus.GdipCreateBitmapFromScan0(view.width(), view.height(), 
		0, Gdiplus.PixelFormat32bppARGB, null,
		&viewVars.image);

	viewVars.rt = Gdiplus.Rect(0, 0, view.width, view.height);
	Gdiplus.GdipGetImageGraphicsContext(viewVars.image, &viewVars.g);
}

/*void BitmapCreate(Bitmap view, CanvasPlatformVars* viewVars) {
	viewVars.clipRegions = new _clipList();
	
	viewVars.length = (view.width() * view.height()) * 4;

	Gdiplus.GdipCreateBitmapFromScan0(view.width(), view.height(), 0, Gdiplus.PixelFormat32bppARGB, null, &viewVars.image);
	viewVars.rt = Gdiplus.Rect(0, 0, view.width, view.height);
	Gdiplus.GdipGetImageGraphicsContext(viewVars.image, &viewVars.g);
	Gdiplus.GdipGetDC(viewVars.g, &viewVars.dc);
}*/

void CanvasDestroy(Canvas view, CanvasPlatformVars*viewVars) {
	DeleteDC(viewVars.dc);
	Gdiplus.GdipDeleteGraphics(viewVars.g);
}

/*void CanvasCreateDIB(ref Bitmap view, CanvasPlatformVars*viewVars) {
	viewVars.clipRegions = new _clipList();

	viewVars.length = (view.width() * view.height()) * 4;

	Gdiplus.GdipCreateBitmapFromScan0(view.width(), view.height(), 0, Gdiplus.PixelFormat32bppARGB, null, &viewVars.image);
	viewVars.rt = Gdiplus.Rect(0, 0, view.width, view.height);
	Gdiplus.GdipGetImageGraphicsContext(viewVars.image, &viewVars.g);
	Gdiplus.GdipGetDC(viewVars.g, &viewVars.dc);
}*/
/*
void CanvasCreateForWindow(ref View view, ViewPlatformVars*viewVars, ref Window window, WindowPlatformVars* windowVars) {
	//will set _inited to true:
	HDC dc;

	dc = GetDC(null);

	viewVars.clipRegions = new _clipList();

	viewVars.dc = CreateCompatibleDC(dc);

	HBITMAP bmp = null; //CreateCompatibleBitmap(dc, view.width(), view.height());

	ReleaseDC(null, dc);

	SelectObject(viewVars.dc, bmp);

	DeleteObject(bmp);

    Gdiplus.GdipCreateFromHDC(viewVars.dc, &viewVars.g);
} */

//void ViewResizeForWindow(ref View view, ViewPlatformVars*viewVars, ref Window window, WindowPlatformVars* windowVars) {
//}

void CanvasResize(Canvas view, CanvasPlatformVars* viewVars) {
	Console.putln("view resize");
	HDC dc;

	dc = GetDC(null);

	HBITMAP bmp;

/*	if (cast(Bitmap)view !is null) {
		BITMAPINFO bi;

		bi.bmiHeader.biSize = BITMAPINFOHEADER.sizeof;
		bi.bmiHeader.biWidth = view.width();
		bi.bmiHeader.biHeight = -view.height();
		bi.bmiHeader.biPlanes = 1;
		bi.bmiHeader.biBitCount = 32;

		bmp = CreateDIBSection(dc, &bi, DIB_RGB_COLORS, &viewVars.bits, null, 0);
	}
	else*/ {
		bmp = CreateCompatibleBitmap(dc, view.width(), view.height());
	}

	ReleaseDC(null, dc);

	SelectObject(viewVars.dc, bmp);

	DeleteObject(bmp);
	Console.putln("view done");
}

void* CanvasGetBytes(CanvasPlatformVars* viewVars, ref ulong length) {
    Gdiplus.GdipBitmapLockBits(viewVars.image, &viewVars.rt, Gdiplus.ImageLockMode.ImageLockModeReadWrite, Gdiplus.PixelFormat32bppARGB, &viewVars.bdata);

	length = viewVars.length;
	return cast(void*)viewVars.bdata.Scan0;
}

void* CanvasGetBytes(CanvasPlatformVars*viewVars) {
    Gdiplus.GdipBitmapLockBits(viewVars.image, &viewVars.rt, Gdiplus.ImageLockMode.ImageLockModeReadWrite, Gdiplus.PixelFormat32bppARGB, &viewVars.bdata);

	return cast(void*)viewVars.bdata.Scan0;
}

void CanvasUnlockBytes(CanvasPlatformVars* viewVars) {
	Gdiplus.GdipBitmapUnlockBits(viewVars.image, &viewVars.bdata);
}

uint CanvasRGBAToInt32(ref bool _forcenopremultiply, CanvasPlatformVars*_pfvars, ref uint r, ref uint g, ref uint b, ref uint a) {
	if (!_forcenopremultiply) {
		float anew = a;
		anew /= cast(float)0xFF;

		r = cast(ubyte)(anew * cast(float)r);
		g = cast(ubyte)(anew * cast(float)g);
		b = cast(ubyte)(anew * cast(float)b);
	}
	return (r << 16) | (g << 8) | (b) | (a << 24);
}

uint CanvasRGBAToInt32(CanvasPlatformVars*_pfvars, ref uint r, ref uint g, ref uint b) {
	return (r << 16) | (g << 8) | (b) | 0xFF000000;
}
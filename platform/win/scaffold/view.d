/*
 * view.d
 *
 * This file implements the Scaffold for platform specific View
 * operations in Windows.
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.view;

import platform.win.vars;
import platform.win.common;
import platform.win.main;

import gui.window;

import graphics.view;
import graphics.graphics;
import graphics.bitmap;

import core.string;
import core.main;
import core.definitions;

import utils.linkedlist;


// views
void ViewCreate(View view, ref ViewPlatformVars viewVars)
{
	HDC dc;

	dc = GetDC(null);

	viewVars.clipRegions = new _clipList();

	viewVars.dc = CreateCompatibleDC(dc);

	HBITMAP bmp = CreateCompatibleBitmap(dc, view.width(), view.height());

	ReleaseDC(null, dc);

	SelectObject(viewVars.dc, bmp);

	DeleteObject(bmp);
}

void ViewDestroy(ref View view, ref ViewPlatformVars viewVars)
{
	DeleteDC(viewVars.dc);
}

void ViewCreateDIB(ref Bitmap view, ref ViewPlatformVars viewVars)
{
	HDC dc;

	dc = GetDC(null);

	viewVars.clipRegions = new _clipList();

	viewVars.dc = CreateCompatibleDC(dc);

	BITMAPINFO bi = BITMAPINFOHEADER.init;

	bi.bmiHeader.biSize = BITMAPINFOHEADER.sizeof;
	bi.bmiHeader.biWidth = view.width();
	bi.bmiHeader.biHeight = -view.height();
	bi.bmiHeader.biPlanes = 1;
	bi.bmiHeader.biBitCount = 32;

	//HBITMAP bmp = CreateCompatibleBitmap(dc, _width, _height);
	HBITMAP bmp = CreateDIBSection(dc, &bi, DIB_RGB_COLORS, &viewVars.bits, null, 0);

	viewVars.length = (view.width() * view.height()) * 4;

	ReleaseDC(null, dc);

	SelectObject(viewVars.dc, bmp);

	DeleteObject(bmp);
}

void ViewCreateForWindow(ref WindowView view, ref ViewPlatformVars viewVars, ref Window window, WindowPlatformVars* windowVars)
{
	//will set _inited to true:
	ViewCreate(view, viewVars);
}

void ViewResizeForWindow(ref WindowView view, ref ViewPlatformVars viewVars, ref Window window, WindowPlatformVars* windowVars)
{
}

void ViewResize(ref View view, ref ViewPlatformVars viewVars)
{
	HDC dc;

	dc = GetDC(null);

	HBITMAP bmp;

	if (cast(Bitmap)view !is null) {

		BITMAPINFO bi = BITMAPINFO.init;

		bi.bmiHeader.biSize = BITMAPINFOHEADER.sizeof;
		bi.bmiHeader.biWidth = view.width();
		bi.bmiHeader.biHeight = -view.height();
		bi.bmiHeader.biPlanes = 1;
		bi.bmiHeader.biBitCount = 32;

		bmp = CreateDIBSection(dc, &bi, DIB_RGB_COLORS, &viewVars.bits, null, 0);
	}
	else {
		bmp = CreateCompatibleBitmap(dc, view.width(), view.height());
	}

	ReleaseDC(null, dc);

	SelectObject(viewVars.dc, bmp);

	DeleteObject(bmp);
}

void* ViewGetBytes(ref ViewPlatformVars viewVars, ref ulong length)
{
	length = viewVars.length;
	return viewVars.bits;
}

void* ViewGetBytes(ref ViewPlatformVars viewVars)
{
	return viewVars.bits;
}

uint ViewRGBAToInt32(ref bool _forcenopremultiply, ref ViewPlatformVars _pfvars, ref uint r, ref uint g, ref uint b, ref uint a)
{
	//writeln("rgba");
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

uint ViewRGBAToInt32(ref ViewPlatformVars _pfvars, ref uint r, ref uint g, ref uint b)
{
	//writeln("rgb");
	return (r << 16) | (g << 8) | (b) | 0xFF000000;
}

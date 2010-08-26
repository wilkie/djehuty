/*
 * canvas.d
 *
 * This module has the structure that is kept with a Canvas class for Windows.
 *
 */

module platform.vars.canvas;

import platform.vars.font;

import binding.win32.winnt;
import binding.win32.winuser;
import binding.win32.winbase;
import binding.win32.windef;
import binding.win32.wingdi;

import binding.win32.gdiplusgpstubs;
import binding.win32.gdiplustypes;
import binding.win32.gdiplusimaging;

import data.stack;

struct CanvasPlatformVars {
	// antialias
	bool aa;

	RECT bounds;
	HDC dc;
	HDC testDC;

	GpImage* image;
	Rect rt;
	BitmapData bdata;

	void* bits;
	int length;

	int penClr;

	GpBrush* curBrush = null;
	GpPen* curPen = null;
	GpBrush* curTextBrush = null;
	FontPlatformVars curFont;

	GpGraphics* g = null;

	Stack!(GpRegion*) clipRegions;
	Stack!(GpMatrix*) transformMatrices;
}
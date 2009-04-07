module platform.osx.scaffolds.graphics;

import core.view;

import bases.window;
import core.window;
import core.string;
import core.file;
import core.graphics;
import core.color;

import core.main;

import core.definitions;

import core.string;

import platform.osx.common;
import platform.osx.definitions;
import platform.osx.vars;



extern (C) void _OSXDrawLine(_OSXViewPlatformVars* viewVars, int fromWindow, int x, int y, int x2, int y2);
extern (C) void _OSXDrawRect(_OSXViewPlatformVars* viewVars, int fromWindow, int x, int y, int x2, int y2);
extern (C) void _OSXDrawOval(_OSXViewPlatformVars* viewVars, int fromWindow, int x, int y, int x2, int y2);

extern (C) void _OSXDrawText(_OSXViewPlatformVars* viewVars, int fromWindow, int x, int y, char* str);
extern (C) void _OSXMeasureText(_OSXViewPlatformVars* viewVars, int fromWindow, char* str, uint* w, uint* h);

extern (C) void _OSXDrawViewXY(_OSXViewPlatformVars* viewVars, int fromWindow, _OSXViewPlatformVars* srcViewVars, int srcFromWindow, int x, int y);
extern (C) void _OSXDrawViewXYXYWH(_OSXViewPlatformVars* viewVars, int fromWindow, _OSXViewPlatformVars* srcViewVars, int srcFromWindow, int x, int y, int srcX, int srcY, int srcWidth, int srcHeight);

extern (C) void _OSXDrawViewXYA(_OSXViewPlatformVars* viewVars, int fromWindow, _OSXViewPlatformVars* srcViewVars, int srcFromWindow, int x, int y, float opacity);
extern (C) void _OSXDrawViewXYXYWHA(_OSXViewPlatformVars* viewVars, int fromWindow, _OSXViewPlatformVars* srcViewVars, int srcFromWindow, int x, int y, int srcX, int srcY, int srcWidth, int srcHeight, float opacity);

extern (C) void _OSXUsePen(_OSXViewPlatformVars* viewVars, int fromWindow, void* pen);
extern (C) void _OSXCreatePen(_OSXViewPlatformVars* viewVars, int fromWindow, void** pen, int r, int g, int b, int a);
extern (C) void _OSXDestroyPen(_OSXViewPlatformVars* viewVars, int fromWindow, void* pen);

extern (C) void _OSXUseBrush(_OSXViewPlatformVars* viewVars, int fromWindow, void* brush);
extern (C) void _OSXCreateBrush(_OSXViewPlatformVars* viewVars, int fromWindow, void** brush, int r, int g, int b, int a);
extern (C) void _OSXDestroyBrush(_OSXViewPlatformVars* viewVars, int fromWindow, void* brush);

// Shapes

// Draw a line
void drawLine(ViewPlatformVars* viewVars, int x, int y, int x2, int y2)
{
	_OSXDrawLine(viewVars.vars, viewVars.fromWindow, x,y,x2,y2);
}

// Draw a rectangle (filled with the current brush, outlined with current pen)
void drawRect(ViewPlatformVars* viewVars, int x, int y, int x2, int y2)
{
	_OSXDrawRect(viewVars.vars, viewVars.fromWindow, x,y,x2,y2);
}

// Draw an ellipse (filled with current brush, outlined with current pen)
void drawOval(ViewPlatformVars* viewVars, int x, int y, int x2, int y2)
{
	_OSXDrawOval(viewVars.vars, viewVars.fromWindow, x,y,x2,y2);
}





// Text
void drawText(ViewPlatformVars* viewVars, int x, int y, String str)
{
	String s = new String(str);
	s.appendChar('\0');

	_OSXDrawText(viewVars.vars, viewVars.fromWindow, x,y, s.ptr);
}

void drawText(ViewPlatformVars* viewVars, int x, int y, StringLiteral str)
{
	String s = new String(str);
	s.appendChar('\0');

	_OSXDrawText(viewVars.vars, viewVars.fromWindow, x,y, s.ptr);
}

void drawText(ViewPlatformVars* viewVars, int x, int y, String str, uint length)
{
	String s = new String(str);
	s.appendChar('\0');

	char* cstr = s.ptrAt(length);
	cstr[0] = '\0';

	_OSXDrawText(viewVars.vars, viewVars.fromWindow, x,y, s.ptr);
}

void drawText(ViewPlatformVars* viewVars, int x, int y, StringLiteral str, uint length)
{
	String s = new String(str);
	s.appendChar('\0');

	char* cstr = s.ptrAt(length);
	cstr[0] = '\0';

	_OSXDrawText(viewVars.vars, viewVars.fromWindow, x,y, s.ptr);
}

void drawTextPtr(ViewPlatformVars* viewVars, int x, int y, Char* str, uint length)
{
}

// Clipped Text
void drawClippedText(ViewPlatformVars* viewVars, int x, int y, Rect region, String str)
{
}

void drawClippedText(ViewPlatformVars* viewVars, int x, int y, Rect region, StringLiteral str)
{
}

void drawClippedText(ViewPlatformVars* viewVars, int x, int y, Rect region, String str, uint length)
{
}

void drawClippedText(ViewPlatformVars* viewVars, int x, int y, Rect region, StringLiteral str, uint length)
{
}

void drawClippedTextPtr(ViewPlatformVars* viewVars, int x, int y, Rect region, Char* str, uint length)
{
}

// Text Measurement
void measureText(ViewPlatformVars* viewVars, String str, out Size sz)
{
	String s = new String(str);
	s.appendChar('\0');

	_OSXMeasureText(viewVars.vars, viewVars.fromWindow, s.ptr, &sz.x, &sz.y);
}

void measureText(ViewPlatformVars* viewVars, String str, uint length, out Size sz)
{
	String s = new String(str);
	s.appendChar('\0');

	char* cstr = s.ptrAt(length);
	cstr[0] = '\0';

	_OSXMeasureText(viewVars.vars, viewVars.fromWindow, s.ptr, &sz.x, &sz.y);
}

void measureText(ViewPlatformVars* viewVars, StringLiteral str, out Size sz)
{
	String s = new String(str);
	s.appendChar('\0');

	_OSXMeasureText(viewVars.vars, viewVars.fromWindow, s.ptr, &sz.x, &sz.y);
}

void measureText(ViewPlatformVars* viewVars, StringLiteral str, uint length, out Size sz)
{
	String s = new String(str);
	s.appendChar('\0');

	char* cstr = s.ptrAt(length);
	cstr[0] = '\0';

	_OSXMeasureText(viewVars.vars, viewVars.fromWindow, s.ptr, &sz.x, &sz.y);
}

void measureTextPtr(ViewPlatformVars* viewVars, Char* str, uint len, out Size sz)
{
}

// Text Colors
void setTextBackgroundColor(ViewPlatformVars* viewVars, ref Color textColor)
{
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




// Fonts

void createFont(ViewPlatformVars* viewVars, out Font font, StringLiteral fontname, int fontsize, int weight, bool italic, bool underline, bool strikethru)
{
}

void createFont(ViewPlatformVars* viewVars, out Font font, String fontname, int fontsize, int weight, bool italic, bool underline, bool strikethru)
{
}

void setFont(ViewPlatformVars* viewVars, ref Font font)
{
}

void destroyFont(ViewPlatformVars* viewVars, ref Font font)
{
}


// Brushes
void createBrush(ViewPlatformVars* viewVars, out Brush brush, ref Color clr)
{
	_OSXCreateBrush(viewVars.vars, viewVars.fromWindow, &brush, ColorGetR(clr), ColorGetG(clr), ColorGetB(clr), 255);
}

void setBrush(ViewPlatformVars* viewVars, ref Brush brush)
{
	_OSXUseBrush(viewVars.vars, viewVars.fromWindow, brush);
}

void destroyBrush(ViewPlatformVars* viewVars, ref Brush brush)
{
	_OSXDestroyBrush(viewVars.vars, viewVars.fromWindow, brush);
}

// Pens

import std.stdio;
void createPen(ViewPlatformVars* viewVars, out Pen pen, ref Color clr)
{
	_OSXCreatePen(viewVars.vars, viewVars.fromWindow, &pen, ColorGetR(clr), ColorGetG(clr), ColorGetB(clr), 255);
}

void setPen(ViewPlatformVars* viewVars, ref Pen pen)
{
	_OSXUsePen(viewVars.vars, viewVars.fromWindow, pen);
}

void destroyPen(ViewPlatformVars* viewVars, ref Pen pen)
{
	_OSXDestroyPen(viewVars.vars, viewVars.fromWindow, pen);
}





// View Interfacing

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView)
{
	_OSXDrawViewXY(viewVars.vars, viewVars.fromWindow, viewVarsSrc.vars, viewVarsSrc.fromWindow, x, y);
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, int viewX, int viewY)
{
	uint viewWidth = srcView.getWidth;
	uint viewHeight = srcView.getHeight;
	if (x + viewWidth > view.getWidth())
	{
		viewWidth = view.getWidth() - x;
	}

	if (y + viewHeight > view.getHeight())
	{
		viewHeight = view.getHeight() - y;
	}

	if (viewX + viewWidth > srcView.getWidth())
	{
		viewWidth = srcView.getWidth() - viewX;
	}

	if (viewY + viewHeight > srcView.getHeight())
	{
		viewHeight = srcView.getHeight() - viewY;
	}

	_OSXDrawViewXYXYWH(viewVars.vars, viewVars.fromWindow, viewVarsSrc.vars, viewVarsSrc.fromWindow, x, y, viewX, viewY, viewWidth, viewHeight);
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, int viewX, int viewY, int viewWidth, int viewHeight)
{
	if (x + viewWidth > view.getWidth())
	{
		viewWidth = view.getWidth() - x;
	}

	if (y + viewHeight > view.getHeight())
	{
		viewHeight = view.getHeight() - y;
	}

	if (viewX + viewWidth > srcView.getWidth())
	{
		viewWidth = srcView.getWidth() - viewX;
	}

	if (viewY + viewHeight > srcView.getHeight())
	{
		viewHeight = srcView.getHeight() - viewY;
	}

	_OSXDrawViewXYXYWH(viewVars.vars, viewVars.fromWindow, viewVarsSrc.vars, viewVarsSrc.fromWindow, x, y, viewX, viewY, viewWidth, viewHeight);
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, double opacity)
{
	_OSXDrawViewXYA(viewVars.vars, viewVars.fromWindow, viewVarsSrc.vars, viewVarsSrc.fromWindow, x, y, opacity);
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, int viewX, int viewY, double opacity)
{
	uint viewWidth = srcView.getWidth;
	uint viewHeight = srcView.getHeight;
	if (x + viewWidth > view.getWidth())
	{
		viewWidth = view.getWidth() - x;
	}

	if (y + viewHeight > view.getHeight())
	{
		viewHeight = view.getHeight() - y;
	}

	if (viewX + viewWidth > srcView.getWidth())
	{
		viewWidth = srcView.getWidth() - viewX;
	}

	if (viewY + viewHeight > srcView.getHeight())
	{
		viewHeight = srcView.getHeight() - viewY;
	}

	_OSXDrawViewXYXYWHA(viewVars.vars, viewVars.fromWindow, viewVarsSrc.vars, viewVarsSrc.fromWindow, x, y, viewX, viewY, viewWidth, viewHeight, opacity);
}

void drawView(ref ViewPlatformVars* viewVars, ref View view, int x, int y, ref ViewPlatformVars* viewVarsSrc, ref View srcView, int viewX, int viewY, int viewWidth, int viewHeight, double opacity)
{
	if (x + viewWidth > view.getWidth())
	{
		viewWidth = view.getWidth() - x;
	}

	if (y + viewHeight > view.getHeight())
	{
		viewHeight = view.getHeight() - y;
	}

	if (viewX + viewWidth > srcView.getWidth())
	{
		viewWidth = srcView.getWidth() - viewX;
	}

	if (viewY + viewHeight > srcView.getHeight())
	{
		viewHeight = srcView.getHeight() - viewY;
	}

	_OSXDrawViewXYXYWHA(viewVars.vars, viewVars.fromWindow, viewVarsSrc.vars, viewVarsSrc.fromWindow, x, y, viewX, viewY, viewWidth, viewHeight, opacity);
}


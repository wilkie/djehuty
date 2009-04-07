module platform.osx.scaffolds.view;




import platform.osx.vars;
import platform.osx.common;

import core.view;
import core.graphics;

import bases.window;
import core.window;
import platform.osx.main;
import core.string;
import core.file;

import core.main;

import core.definitions;


extern (C) void _OSXViewCreate(_OSXViewPlatformVars** viewVars, int width, int height);
extern (C) void _OSXViewCreateDIB(_OSXViewPlatformVars** viewVars, int width, int height);
extern (C) void _OSXViewDestroy(_OSXViewPlatformVars* viewVars, int isDIB, int isWindow);

extern (C) void* _OSXGetBytes(_OSXViewPlatformVars* viewVars);

// views
void ViewCreate(ref View view, ref ViewPlatformVars viewVars)
{
	_OSXViewCreate(&viewVars.vars, view.getWidth(), view.getHeight());
}

void ViewDestroy(ref View view, ref ViewPlatformVars viewVars)
{
	_OSXViewDestroy(viewVars.vars, ViewIsDIB(view), ViewIsFromWindow(view));
	viewVars.fromWindow = 0;
}

void ViewCreateDIB(ref View view, ref ViewPlatformVars viewVars)
{
	_OSXViewCreateDIB(&viewVars.vars, view.getWidth(), view.getHeight());

	viewVars.dibBytes = view.getWidth() * view.getHeight() * 4;
}

void ViewCreateForWindow(ref View view, ref ViewPlatformVars viewVars, ref Window window)
{
	// is done via WindowCreate
	viewVars.fromWindow = 1;
	BaseWindow bw = window;
	viewVars.vars = WindowGetPlatformVars(bw).viewVars;
}

void ViewResize(ref View view, ref ViewPlatformVars viewVars)
{
}

void* ViewGetBytes(ref ViewPlatformVars viewVars, ref ulong length)
{
	length = viewVars.dibBytes;
	return _OSXGetBytes(viewVars.vars);
}

void* ViewGetBytes(ref ViewPlatformVars viewVars)
{
	return _OSXGetBytes(viewVars.vars);
}

uint ViewRGBAToInt32(ref bool _forcenopremultiply, ref ViewPlatformVars _pfvars, ref uint r, ref uint g, ref uint b, ref uint a)
{
	return (b << 16) | (g << 8) | (r) | (a << 24);
}

uint ViewRGBAToInt32(ref ViewPlatformVars _pfvars, ref uint r, ref uint g, ref uint b)
{
	return (b << 16) | (g << 8) | (r) | 0xFF000000;
}

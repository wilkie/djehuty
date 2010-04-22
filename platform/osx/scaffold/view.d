module scaffold.view;

import platform.vars.view;
import platform.vars.window;
import platform.osx.common;

import graphics.view;
import graphics.graphics;

import gui.window;
import platform.osx.main;
import core.string;
import io.file;
import io.console;

import core.main;

import graphics.bitmap;

import core.definitions;

extern (C) void _OSXViewCreate(_OSXViewPlatformVars** viewVars, int width, int height);
extern (C) void _OSXViewCreateDIB(_OSXViewPlatformVars** viewVars, int width, int height);
extern (C) void _OSXViewDestroy(_OSXViewPlatformVars* viewVars, int isDIB, int isWindow);

extern (C) void* _OSXGetBytes(_OSXViewPlatformVars* viewVars);
// views
void ViewCreate(ref View view, ViewPlatformVars* viewVars) {
	_OSXViewCreate(&viewVars.vars, view.width(), view.height());
}

void ViewDestroy(ref View view, ViewPlatformVars* viewVars) {
	_OSXViewDestroy(viewVars.vars, cast(Bitmap)view !is null, viewVars.fromWindow == 1);
	viewVars.fromWindow = 0;
}

void ViewCreateDIB(ref Bitmap view, ViewPlatformVars* viewVars) {
	_OSXViewCreateDIB(&viewVars.vars, view.width(), view.height());

	viewVars.dibBytes = view.width() * view.height() * 4;
}

void ViewCreateForWindow(ref WindowView view, ViewPlatformVars* viewVars, ref Window window, WindowPlatformVars* windowVars) {
	// is done via WindowCreate
	viewVars.fromWindow = 1;
	viewVars.vars = windowVars.viewVars;
}

void ViewResizeForWindow(ref WindowView view, ViewPlatformVars* viewVars, ref Window window, WindowPlatformVars* windowVars) {
}

void ViewResize(ref View view, ViewPlatformVars* viewVars) {
}

void* ViewGetBytes(ViewPlatformVars* viewVars, ref ulong length) {
	length = viewVars.dibBytes;
	return _OSXGetBytes(viewVars.vars);
}

void* ViewGetBytes(ViewPlatformVars* viewVars) {
	return _OSXGetBytes(viewVars.vars);
}

void ViewUnlockBytes(ViewPlatformVars* viewVars) {
	return _OSXGetBytes(viewVars.vars);
}

uint ViewRGBAToInt32(ref bool _forcenopremultiply, ViewPlatformVars* _pfvars, ref uint r, ref uint g, ref uint b, ref uint a){
	return (b << 16) | (g << 8) | (r) | (a << 24);
}

uint ViewRGBAToInt32(ViewPlatformVars* _pfvars, ref uint r, ref uint g, ref uint b) {
	return (b << 16) | (g << 8) | (r) | 0xFF000000;
}

/*
 * view.d
 *
 * This Scaffold holds the View implementations for the Linux platform
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.view;

import platform.vars.view;
import platform.vars.window;

import graphics.view;
import graphics.bitmap;
import graphics.graphics;

import core.string;
import core.main;
import core.definitions;

import io.file;

import gui.window;

// views
void ViewCreate(ref View view, ViewPlatformVars*viewVars) {
}

void ViewDestroy(ref View view, ViewPlatformVars*viewVars) {
}

void ViewCreateDIB(ref Bitmap view, ViewPlatformVars*viewVars) {
}

void ViewCreateForWindow(ref WindowView view, ViewPlatformVars*viewVars, ref Window window, WindowPlatformVars* windowVars) {
}

void ViewResizeForWindow(ref WindowView view, ViewPlatformVars*viewVars, ref Window window, WindowPlatformVars* windowHelper) {
}

void ViewResize(ref View view, ViewPlatformVars*viewVars) {
}

void* ViewGetBytes(ViewPlatformVars*viewVars, ref ulong length) {
	return null;
}

void* ViewGetBytes(ViewPlatformVars*viewVars) {
	return null;
}

void ViewUnlockBytes(ViewPlatformVars* viewVars) {
}

uint ViewRGBAToInt32(ref bool _forcenopremultiply, ViewPlatformVars*_pfvars, ref uint r, ref uint g, ref uint b, ref uint a) {
	return 0;
}

uint ViewRGBAToInt32(ViewPlatformVars*_pfvars, ref uint r, ref uint g, ref uint b) {
	return 0;
}






/*
 * window.d
 *
 * This Scaffold holds the Window implementations for the Linux platform
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.window;

import platform.vars.window;
import platform.vars.view;
import platform.vars.brush;
import platform.vars.pen;

import scaffold.graphics;

import graphics.view;
import graphics.graphics;

import core.color;
import core.string;
import core.main;
import core.definitions;

import io.file;

import gui.application;
import gui.window;

import io.console;

// all windows
void WindowCreate(ref Window window, WindowPlatformVars* windowVars) {
}

void WindowCreate(ref Window parent, WindowPlatformVars* parentHelper, ref Window window, WindowPlatformVars* windowVars) {
}

void WindowSetStyle(ref Window window, WindowPlatformVars* windowVars) {
}

void WindowReposition(ref Window window, WindowPlatformVars* windowVars) {
}

void WindowSetState(ref Window window, WindowPlatformVars* windowVars) {
}

void WindowRebound(ref Window window, WindowPlatformVars* windowVars) {
}

void WindowDestroy(ref Window window, WindowPlatformVars* windowVars) {
}

void WindowSetVisible(ref Window window, WindowPlatformVars* windowVars, bool bShow) {
}

void WindowSetTitle(ref Window window, WindowPlatformVars* windowVars) {
}

// CLIENT TO SCREEN

// Takes a point on the window's client area and returns the actual screen
// coordinates for that point.

void WindowClientToScreen(ref Window window, WindowPlatformVars* windowVars, ref int x, ref int y) {
}

void WindowClientToScreen(ref Window window, WindowPlatformVars* windowVars, ref Rect rt) {
}


// Viewable windows
void WindowStartDraw(ref Window window, WindowPlatformVars* windowVars, ref WindowView view, ref ViewPlatformVars viewVars) {
}

void WindowEndDraw(ref Window window, WindowPlatformVars* windowVars, ref WindowView view, ref ViewPlatformVars viewVars) {
}

void WindowCaptureMouse(ref Window window, WindowPlatformVars* windowVars) {
}

void WindowReleaseMouse(ref Window window, WindowPlatformVars* windowVars) {
}

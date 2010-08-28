/*
 * window.d
 *
 * This module has the structure that is kept with a Window class.
 *
 */

module platform.vars.window;

import binding.win32.windef;
import binding.win32.winnt;
import binding.win32.winbase;
import binding.win32.wingdi;
import binding.win32.winuser;

import core.definitions;
import core.string;
import core.unicode;

import gui.window;

import binding.opengl.gl;
import binding.opengl.glu;

//import opengl.window;

import synch.thread;

import scaffold.opengl;

struct WindowPlatformVars {
	HWND hWnd;
	HDC hdc;

	Event* event;
	bool haveEvent;

	int hoverTimerSet;

	int lastX;
	int lastY;

	bool supress_WM_SIZE;
	bool supress_WM_MOVE;

	Window window;
}